{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
program gg;
uses vesa,keyboard;
const n=60;m=60;
      nx=430;
      ny=340;
      name:array[1..70] of string[20]=('Танк','','Пехотинец','','','','','','','Рабочий',
      '','','','','','','','','','',
      '','','','','','','','','','',
      'Космический корабль','Батончик','','','','','','','','',
      '','','','','','','','','','',
      'Командный центр','','','','','','','','','',
      '','','','','','','','','','');
      speed:array[1..50] of byte=(5,4,1,1,4,4,4,4,4,2,4,4,4,2,2,2,2,2,
      2,2,2,2,2,2,2,2,2,2,2,2,10,6,5,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2);
      spstr:array[1..60] of byte=(100,50,10,20,50,50,50,50,50,30,
      50,50,50,50,50,50,50,50,50,50,
      50,50,50,50,50,50,50,50,50,50,
      10,50,50,50,50,50,50,50,50,50,
      50,50,50,50,50,50,50,50,50,50,
      50,50,50,50,50,50,50,50,50,50);
      uron:array[1..60] of byte=(69,15,7,15,15,15,15,15,15,10,
      15,15,15,15,15,15,15,15,15,15,
      15,15,15,15,15,15,15,15,15,15,
      25,15,15,15,15,15,15,15,15,15,
      15,15,15,15,15,15,15,15,15,15,
      15,15,15,15,15,15,15,15,15,15);
      bron:array[1..60] of byte=(3,1,0,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,
      4,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,
      8,8,8,6,6,6,6,6,6,6);
      dalnostataki:array[1..40] of byte=(7,4,4,4,4,4,4,4,4,1,
      4,4,4,4,4,4,4,4,4,4,
      4,4,4,4,4,4,4,4,4,4,
      6,4,4,4,4,4,4,4,4,4);
      hitpoints:array[1..70] of integer=(300,100,70,100,100,100,100,100,100,50,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      350,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      500,700,400,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100);
      cost:array[1..70] of word=(250,100,75,100,100,100,100,100,100,60,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      350,150,150,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100);
      timebild:array[1..70] of word=(23*15,100,23*10,100,100,100,100,100,100,23*15,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      340,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      23*35,100,100,23*25,23*25,23*25,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100);
      suply:array[1..50] of byte=(3,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1,
      5,3,3,1,1,1,1,1,1,1,
      1,1,1,1,1,1,1,1,1,1);
      move=1;
      stroit=2;
      moveandfire=3;
type pic=array[0..50,0..7] of pointer;
     build=array[51..100] of pointer;
     tekr=array [1..n,1..m] of byte;
     tOffs=array[0..23] of ShortInt;
     mat=array[1..60,1..60] of byte;
     ykaz=^boolean;
     kordinati=record
                     x,y:shortint;
                     end;
     pObject=^tObject;
     tObject=record
               next,attackobj:pobject;
               vid,moi,dobicha,dob,f10,mb1,fire,havem,cdox,str:boolean;
               tip,delm,dels,action,gabar,chtostroit,n:byte;
               x,y,hp,dx,dy,tx,ty,stx,sty,vect,offs,bild,st,s:integer;
               oldx,oldy:array[0..1] of integer;
               dobivaet,gdestroit:kordinati;
               o4ered:array [1..4] of byte;
            end;
     psnar=^tsnar;
     tsnar=record
                 next:psnar;
                 x,y,tx,ty:integer;
                 dx,dy:integer;
                 offsx,offsy:integer;
                 tank:pobject;
                 tip:byte;
           end;
     rec=record
           st,x,y,tip:integer;
         end;
     vzz=array[1..100] of rec;
     trl=array[1..20] of pobject;
     ctrl12=array[1..9] of trl;
     tmykaz=array[1..60,1..60] of pobject;
     message=record
                   fl:boolean;
                   sm:string;
                   vr:integer;
                   end;
     pmin=^tmin;
     tmin=record
                next:pmin;
                work:word;
                vid:boolean;
                x,y:integer;
                n:integer;
                end;
     enzap=record
                 est:boolean;
                 x,y:integer;
                 end;
     enzda=array[51..60] of enzap;

const dxs:tOffs=(1, 1, 0,-1,-1,-1,0,1,2,2,2,1,0,-1,-2,-2,-2,-2,-2,-1,0,1,2,2);
      dys:tOffs=(0,-1,-1,-1, 0, 1,1,1,0,-1,-2,-2,-2,-2,-2,-1,0,1,2,2,2,2,2,1);

var p:pic;
    b:build;
    ekr:tekr;
    videlx,videly,skx,sky,mx,my,vremya,enemrab,enemrip,rab,
    enemtank,sup,maxsup,ch,i,j:integer;
    mnr,mnrt:longint;
    page,min,sec,toch:byte;
    inz:pobject;
    mm:pmin;
    zzz:psnar;
    klav,ya,ft,videlenie,exite,prod,snarf,krest,mish:boolean;
    sms:array[1..4] of message;
    ctrl1:ctrl12;
    mykaz:tmykaz;
    mybaze,enbaze:pobject;
    enzd:enzda;
    t:mat;
    bb:pobject;
    vz:vzz;
procedure load(var ekr:tekr);
var i,j,tt:integer;
    c:char;
    f:text;
    begin
     assign(f,'matr.txt');
     reset(f);
     for i:=1 to n do
     begin
     for j:=1 to m do
     begin
     read(f,c);
     val(c,ekr[j,i],tt);
     end;
     readln(f);
     end;
end;

procedure sprite;
var i:integer;
    f:file;
begin
  p[0,0]:=loadspr('textura.spr');
  p[1,0]:=loadspr('tank1pr.spr');
  p[1,1]:=loadspr('tank1pt.spr');
  p[1,2]:=loadspr('tank1top.spr');
  p[1,3]:=loadspr('tank1lt.spr');
  p[1,4]:=loadspr('tank1lev.spr');
  p[1,5]:=loadspr('tank1lb.spr');
  p[1,6]:=loadspr('tank1bot.spr');
  p[1,7]:=loadspr('tank1pb.spr');
  p[3,0]:=loadspr('rippr.spr');
  p[3,1]:=loadspr('rippt.spr');
  p[3,2]:=loadspr('riptop.spr');
  p[3,3]:=loadspr('riplt.spr');
  p[3,4]:=loadspr('riplev.spr');
  p[3,5]:=loadspr('riplb.spr');
  p[3,6]:=loadspr('ripbot.spr');
  p[3,7]:=loadspr('rippb.spr');
  p[4,0]:=loadspr('ripmpr.spr');
  p[4,1]:=loadspr('ripmpt.spr');
  p[4,2]:=loadspr('ripmtop.spr');
  p[4,3]:=loadspr('ripmlt.spr');
  p[4,4]:=loadspr('ripmlev.spr');
  p[4,5]:=loadspr('ripmlb.spr');
  p[4,6]:=loadspr('ripmbot.spr');
  p[4,7]:=loadspr('ripmpb.spr');
  assign(f,'mytank1.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[2,i]:=loadspr1(f); close(f);
  assign(f,'mytank2.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[5,i]:=loadspr1(f);close(f);
  p[5,0]:=loadspr('arx0.spr');
  p[5,1]:=loadspr('arx1.spr');
  p[5,2]:=loadspr('arx2.spr');
  p[5,3]:=loadspr('arx3.spr');
  p[5,4]:=loadspr('arx4.spr');
  p[5,5]:=loadspr('arx5.spr');
  p[5,6]:=loadspr('arx6.spr');
  p[5,7]:=loadspr('arx7.spr');
  assign(f,'boom1.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[41,i]:=loadspr1(f);close(f);
  assign(f,'boom2.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[42,i]:=loadspr1(f);close(f);
  assign(f,'boom3.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[43,i]:=loadspr1(f);close(f);
  assign(f,'boom4.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[44,i]:=loadspr1(f);close(f);
  assign(f,'boom5.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[45,i]:=loadspr1(f);close(f);
  assign(f,'boom6.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[46,i]:=loadspr1(f);close(f);
  assign(f,'boom7.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[47,i]:=loadspr1(f);close(f);
  assign(f,'boom8.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[48,i]:=loadspr1(f);close(f);
  assign(f,'mytank3.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[6,i]:=loadspr1(f);
  assign(f,'mytank5.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[7,i]:=loadspr1(f);
  assign(f,'myharv.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[10,i]:=loadspr1(f);
  assign(f,'enemtank.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[8,i]:=loadspr1(f);
  assign(f,'entank.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[9,i]:=loadspr1(f);
  assign(f,'enemair.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[33,i]:=loadspr1(f);
  assign(f,'myair.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[34,i]:=loadspr1(f);
  assign(f,'myair2.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[35,i]:=loadspr1(f);
  assign(f,'myair3.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[32,i]:=loadspr1(f);
  p[10,0]:=loadspr('probe0.spr');
  p[10,1]:=loadspr('probe1.spr');
  p[10,2]:=loadspr('probe2.spr');
  p[10,3]:=loadspr('probe3.spr');
  p[10,4]:=loadspr('probe4.spr');
  p[10,5]:=loadspr('probe5.spr');
  p[10,6]:=loadspr('probe6.spr');
  p[10,7]:=loadspr('probe7.spr');
  p[50,0]:=loadspr('tochka0.spr');
  p[50,1]:=loadspr('tochka1.spr');
  p[50,2]:=loadspr('tochka2.spr');
  p[50,3]:=loadspr('tochka3.spr');
  p[50,4]:=loadspr('tochka4.spr');
  p[50,5]:=loadspr('tochka5.spr');
  p[50,6]:=loadspr('tochka6.spr');
  p[50,7]:=loadspr('tochka7.spr');
  p[31,0]:=loadspr('mships.spr');
  p[31,1]:=loadspr('mships.spr');
  p[31,2]:=loadspr('mships.spr');
  p[31,3]:=loadspr('mships.spr');
  p[31,4]:=loadspr('mships.spr');
  p[31,5]:=loadspr('mships.spr');
  p[31,6]:=loadspr('mships.spr');
  p[31,7]:=loadspr('mships.spr');
  b[51]:=loadspr('cc120.spr');
  b[52]:=loadspr('zd180.spr');
  b[54]:=loadspr('zd280.spr');
  b[55]:=loadspr('zavod80.spr');
  b[56]:=loadspr('kosm80.spr');
  b[60]:=loadspr('up40.spr');
  b[98]:=loadspr('cursor.spr');
  b[99]:=loadspr('minicon.spr');
  b[100]:=loadspr('dryz.spr');
  b[80]:=loadspr('textura1.spr');
  b[81]:=loadspr('text1.spr');
  b[82]:=loadspr('yama.spr');
  b[90]:=loadspr('reka1.spr');
  b[91]:=loadspr('reka2.spr');
  b[92]:=loadspr('reka3.spr');
  b[61]:=loadspr('cc40.spr');
  b[62]:=loadspr('zd140.spr');
  b[64]:=loadspr('zd240.spr');
  b[65]:=loadspr('zavod40.spr');
  b[66]:=loadspr('kosm40.spr');
  b[80]:=loadspr('up40.spr');
  b[71]:=loadspr('cc80.spr');
  b[72]:=loadspr('msip40.spr');
end;

procedure ctttt(h:byte);
var tz:pobject;
    i:integer;
begin
  for i:=1 to 9 do
  ctrl1[h][i]:=nil;
  tz:=inz^.next;
  i:=0;
  while tz<>inz do
    begin
      if tz^.vid
      then begin
             inc(i);
             ctrl1[h][i]:=tz;
           end;
    tz:=tz^.next;
  end;
end;

procedure cttt(h:integer);
var tz:pobject;
    k:integer;
begin
  tz:=inz^.next;
         while tz<>inz do
         begin
         tz^.vid:=false;
         tz:=tz^.next;
         end;
         for k:=1 to 20 do
         ctrl1[h][k]^.vid:=true;
end;

procedure ctrl123;
begin
  if (keys[kctrl]) and (keys[k1])
  then ctttt(1);
  if (keys[kctrl]) and (keys[k2])
  then ctttt(2);
  if (keys[kctrl]) and (keys[k3])
  then ctttt(3);
  if (keys[kctrl]) and (keys[k4])
  then ctttt(4);
  if (keys[kctrl]) and (keys[k5])
  then ctttt(5);
  if (keys[kctrl]) and (keys[k6])
  then ctttt(6);
  if (keys[kctrl]) and (keys[k7])
  then ctttt(7);
  if (keys[kctrl]) and (keys[k8])
  then ctttt(8);
  if (keys[kctrl]) and (keys[k9])
  then ctttt(9);
  if keys[k1]
  then cttt(1);
  if keys[k2]
  then cttt(2);
  if keys[k3]
  then cttt(3);
  if keys[k4]
  then cttt(4);
  if keys[k5]
  then cttt(5);
  if keys[k6]
  then cttt(6);
  if keys[k7]
  then cttt(7);
  if keys[k8]
  then cttt(8);
  if keys[k9]
  then cttt(9);
end;

procedure inzkl(tz:pobject;var ekr:tekr;var mykaz:tmykaz);
var i,j:byte;
begin
  for i:=tz^.x to tz^.x+tz^.gabar-1 do
     for j:=tz^.y to tz^.y+tz^.gabar-1 do
     begin
     ekr[i,j]:=tz^.tip;
     mykaz[i,j]:=tz;
     end;
end;

procedure delkl(tz:pobject;var ekr:tekr;var mykaz:tmykaz);
var i,j:byte;
begin
  for i:=tz^.x to tz^.x+tz^.gabar-1 do
     for j:=tz^.y to tz^.y+tz^.gabar-1 do
     begin
     ekr[i,j]:=0;
     mykaz[i,j]:=nil;
     end;
end;

function rasstoianie(x1,y1,x2,y2:longint):longint;
begin
  rasstoianie:=round(sqrt(sqr(x2-x1)+sqr(y2-y1)));
end;

procedure zapis(s:string);
begin
  sms[4]:=sms[3];sms[3]:=sms[2];sms[2]:=sms[1];
  sms[1].fl:=true;
  sms[1].sm:=s;
  sms[1].vr:=sec;
end;

function newel(typ:byte;x,y:integer;kto:boolean):pobject;
var tz:pobject;  i:integer;
begin
  new(tz);
  tz^.tip:=typ;
  tz^.x:=x;
  tz^.y:=y;
  tz^.tx:=1;
  tz^.ty:=1;
  tz^.action:=0;
  tz^.bild:=0;
  fillchar(tz^.o4ered,sizeof(tz^.o4ered),0);
  if typ in[51..53,31] then tz^.gabar:=3
  else if typ in [54..59,32] then tz^.gabar:=2
  else tz^.gabar:=1;
  tz^.vid:=false;
  if tz^.tip<50 then
  tz^.delm:=0
  else begin
         tz^.gdestroit.x:=tz^.x+tz^.gabar;
         tz^.gdestroit.y:=tz^.y;
       end;
  tz^.offs:=0;
  tz^.dobicha:=false;
  tz^.dob:=false;
  tz^.havem:=false;
  tz^.f10:=false;  tz^.mb1:=false;
  tz^.hp:=hitpoints[tz^.tip];
  tz^.dels:=0;
  tz^.cdox:=false;
  tz^.st:=1;
  tz^.str:=false;
  tz^.s:=1;
  tz^.fire:=false;
  tz^.stx:=0;
  tz^.sty:=0;
  tz^.vect:=0;
  tz^.moi:=kto;
  if tz^.moi then begin
                  tz^.dobivaet.x:=4;
                  tz^.dobivaet.y:=4;
                  end
  else begin
       tz^.dobivaet.x:=56;
       tz^.dobivaet.y:=56;
       end;
  newel:=tz;
end;

procedure delafter(tz:pobject;var ekr:tekr;var mykaz:tmykaz);
var p:pobject;i,j:integer;
begin
  p:=tz^.next;
  delkl(p,ekr,mykaz);
  if p<>nil
  then begin
         tz^.next:=p^.next;
         dispose(p);
       end;
end;

function vector(tz:pobject):integer;
const m:array[-1..1,-1..1] of shortint=((3,2,1),
                                        (4,0,0),
                                        (5,6,7));
begin
  vector:=m[tz^.dy,tz^.dx]
end;

procedure insel(inz,tz:pobject;var ekr:tekr;var mykaz:tmykaz);
var i,j:byte; p:pobject;
begin
     tz^.next:=inz^.next;
     inz^.next:=tz;
     inzkl(tz,ekr,mykaz);
end;

procedure insels(zzz,tz:psnar);
begin
     tz^.next:=zzz^.next;
     zzz^.next:=tz;
end;

procedure inselm(y,x:integer;var ekr:tekr);
var tz:pmin;
begin
  new(tz);
  tz^.x:=x;
  tz^.y:=y;
  tz^.vid:=false;
  tz^.n:=5555;
  tz^.next:=mm^.next;
  mm^.next:=tz;
  ekr[x,y]:=100;
end;

procedure showmin;
var s:pmin;
begin
  s:=mm^.next;
     while s<>mm do
     begin
       putsprite((s^.x-1)*40-skx,(s^.y-1)*40-sky,b[100]);
       setcolor(15);
       if s^.vid then circle((s^.x-1)*40-skx+20,(s^.y-1)*40-sky+20,20);
       s:=s^.next;
     end;
end;

function mousein(x1,y1,x2,y2:integer):boolean;
begin
  mousein:=(mousex>=x1)and(mousex<=x2)and(mousey>=y1)and(mousey<=y2);
end;

procedure kvad(n:integer;var x,y:integer);
begin
  case n of
  1:begin
      x:=520;
      y:=360;
    end;
  2:begin
      x:=560;
      y:=360;
    end;
  3:begin
      x:=600;
      y:=360;
    end;
  4:begin
      x:=520;
      y:=400;
    end;
  5:begin
      x:=560;
      y:=400;
    end;
  6:begin
      x:=600;
      y:=400;
    end;
  end;
end;

function mousen(k:integer):boolean;
begin
  case k of
  1:mousen:=mousein(520,360,560,400);
  2:mousen:=mousein(560,360,600,400);
  3:mousen:=mousein(600,360,640,400);
  4:mousen:=mousein(520,400,560,440);
  5:mousen:=mousein(560,400,600,440);
  6:mousen:=mousein(600,400,640,440);
  0:mousen:=mousein(0,360,120,480);
  7:mousen:=mousein(0,0,640,360);
  end;
end;

Procedure nextstep(tz:pobject);
Const Max=600;
var xs,xf,ys,yf:integer;
Type Node=record
           St:word;
           OlDx,Oldy,x,y,w:byte;
          end;
     QUEUE=array[0..Max-1] of node;
     tOffs=array[0..7] of ShortInt;
     tmin=record
            dal:word;
            vect:byte;
          end;
Var q:QUEUE;
    G,h,l,i,j,lmax:word;
    d:Node;
    x,y,w:byte;
    ox,oy:shortint;
    Work:boolean;
    mat:tekr;
    t:pobject;
    min:tmin;
Const dx:tOffs=(1, 1, 0,-1,-1,-1,0,1);
      dy:tOffs=(0,-1,-1,-1, 0, 1,1,1);
Procedure PutQ(d:node);
begin
  if l>lmax then lMax:=l;
  if l=Max
  then Writeln('╬ўхЁхф№ яхЁхяюыэхэр'#7#7#7)
  else begin
         inc(l);
         h:=(h+1) mod max;
         q[h]:=d;
       end;
end;
Procedure GetQ(var d:node);
var Min,Nm,j,i:word;
begin
  if l=0
  then Writeln('╬ўхЁхф№ яєёЄр '#7#7#7)
  else begin
         dec(l);
         Min:=q[g].st;Nm:=g;j:=g;
         for i:=1 to l do
          begin
          if q[j].St<Min
          then begin
                 Min:=q[j].St;Nm:=j
               end;
          j:=(j+1) mod max;
         end;
        d:=q[nm];q[nm]:=q[g];g:=(g+1) mod max;
       end
end;
Function Calc(x,y:byte):word;
begin
  Calc:=(xf-x)*(xf-x)+(yf-y)*(yf-y)+mat[y,x]*2
end;
begin
  xs:=tz^.x;ys:=tz^.y;
  if tz^.action=move
  then ekr[tz^.tx,tz^.ty]:=tz^.n;
  if tz^.tx<>0 then
  if (ekr[tz^.tx,tz^.ty]<>0) and (ekr[tz^.tx,tz^.ty]<>tz^.n)
         then begin
         i:=0;
         while ekr[tz^.tx+dxs[i],tz^.ty+dys[i]]<>0 do
         inc(i);
         tz^.tx:=tz^.tx+dxs[i];
         tz^.ty:=tz^.ty+dys[i];
         end;
  xf:=tz^.tx;yf:=tz^.ty;
  fillchar(mat,sizeof(mat),0);
  if (tz^.tip>30) OR (TZ^.TIP=10) AND (TZ^.DOBICHA)
  then BEGIN
         for i:=1 to n do
          for j:=1 to m do
           if (ekr[j,i]>50) and (ekr[j,i]<>tz^.n)
             then mat[i,j]:=255
             else mat[i,j]:=0;
       END
       else
         for i:=1 to n do
          for j:=1 to m do
           if (ekr[j,i]<>0) and (ekr[j,i]<>tz^.n) then
             mat[i,j]:=255
             else mat[i,j]:=0;
  g:=1;h:=0;l:=0;
  x:=xs;y:=ys;
  Work:=true;
  mat[y,x]:=1;
  d.x:=x;d.y:=y;
  d.OldX:=x; d.OldY:=y;
  d.St:=Calc(x,y);
  d.w:=1;
  PutQ(d);
  While Work and (l<>0) do
    begin
      GetQ(d);
      w:=d.w;
      x:=d.x;y:=d.y;
      if (x=xf)and(y=yf)
      then Work:=false;
      For i:=0 to 7 do
       begin
         if (y+dy[i]>=1) and (y+dy[i]<=60) and (x+dx[i]>=1) and (x+dx[i]<=60) then
         if (mat[y+dy[i],x+dx[i]]<>255) and (mat[y+dy[i],x+dx[i]]=0)
         then begin
             mat[y+dy[i],x+dx[i]]:=w+1;
             d.x:=x+dx[i];d.y:=y+dy[i];
             d.OldX:=x; d.OldY:=y;
             d.w:=w+1;
             d.St:=Calc(d.x,d.y);
             PutQ(d);
           end;
       end;
    end;
      min.dal:=65000;
      for i:=0 to 7 do
        if (ys+dy[i]>=1) and (ys+dy[i]<=60) and (xs+dx[i]>=1) and (xs+dx[i]<=60) then
        if (mat[ys,xs]<mat[ys+dy[i],xs+dx[i]]) and (mat[ys+dy[i],xs+dx[i]]<>255)
        then if (sqr(xs+dx[i]-xf)+sqr(ys+dy[i]-yf))<min.dal
        then begin
               min.dal:=sqr(xs+dx[i]-xf)+sqr(ys+dy[i]-yf);
               min.vect:=i;
             end;
      xs:=xs+dx[min.vect];
      ys:=ys+dy[min.vect];
      tz^.dx:=xs-tz^.x;
      tz^.dy:=ys-tz^.y;
      tz^.vect:=vector(tz);
      if tz^.tip<>10 then
      ekr[tz^.x+tz^.dx,tz^.y+tz^.dy]:=tz^.n;
end;

procedure dvig(var tz:pobject;x,y:byte);
begin
  tz^.tx:=x;
  tz^.ty:=y;
  nextstep(tz);
  tz^.action:=move;
end;

function zaniat(x,y:integer):boolean;
var k:integer;
tz:pobject;
begin
  tz:=inz^.next;
  k:=0;
  while tz<>inz do
  begin
    if (tz^.dobivaet.x=x) and (tz^.dobivaet.y=y)
    then inc(k);
    tz:=tz^.next;
  end;
  zaniat:=k>rab div 5+1
end;

procedure blizh(tz:pobject);
var t:pobject;
    s:pmin;
begin
  if not tz^.havem then
  if zaniat(tz^.dobivaet.x,tz^.dobivaet.y) or not tz^.dobicha
  then begin
         s:=mm^.next;
         while s<>mm do
         begin
           if (abs(s^.x-tz^.dobivaet.y)<20) and not zaniat(s^.x,s^.y)
           then begin
                  tz^.dobicha:=false;
                  tz^.dob:=true;
                  tz^.dobivaet.x:=s^.x;
                  tz^.dobivaet.y:=s^.y;
                  {tz^.tx:=tz^.dobivaet.x;
                  tz^.ty:=tz^.dobivaet.y;
                  nextstep(tz);
                  tz^.action:=move;}
                  {dvig(tz,tz^.dobivaet.x,tz^.dobivaet.y);}
                end;
           s:=s^.next;
         end;
       {end;}
  dvig(tz,tz^.dobivaet.x,tz^.dobivaet.y);
  end
  else begin
         tz^.tx:=tz^.dobivaet.x;
         tz^.ty:=tz^.dobivaet.y;
         nextstep(tz);
         tz^.action:=move;
       end;
end;

procedure stroika;
var tz:pobject;t:pobject;
    i:integer;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
    if tz^.action=stroit
    then begin
           inc(tz^.bild);
           if tz^.tip=10
           then putimage((tz^.gdestroit.x-1)*40-skx,(tz^.gdestroit.y-1)*40-sky,b[tz^.chtostroit],shadowput);
           setcolor(172);
           if tz^.oldy[page]-sky-7<360
           then begin
                  rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,tz^.oldx[page]+
                  tz^.gabar*40-skx,tz^.oldy[page]-sky-7,172,172);
                  bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,tz^.oldx[page]-skx+
                  round(tz^.bild*(tz^.gabar*40/timebild[tz^.chtostroit])),tz^.oldy[page]-sky-7);
                end;
           if tz^.vid=true
           then begin
                  rectangle(350,420,450,425,2,2);
                  setcolor(2);
                  bar(351,421,349+round(tz^.bild*(100/timebild[tz^.chtostroit])),424);
                  if tz^.chtostroit<51 then
                  begin
                  if tz^.tip=31 then putsprite(310,385,b[72])
                  else putsprite(310,385,p[tz^.chtostroit,0])
                  end
                  else putsprite(310,385,b[tz^.chtostroit+10]);
                  for i:=1 to 4 do
                  if tz^.o4ered[i]<>0
                  then putsprite(310+(i-1)*40,425,p[tz^.o4ered[i],0]);
                end;
           if tz^.bild=timebild[tz^.chtostroit]
           then begin
                  if tz^.tip=10
                  then begin
                         tz^.gdestroit.x:=1;
                         tz^.gdestroit.y:=1;
                       end;
                  i:=0;
                  while ekr[tz^.x+tz^.gabar+i,tz^.y]<>0 do
                  inc(i);
                  insel(inz,newel(tz^.chtostroit,tz^.x+tz^.gabar+i,tz^.y,tz^.moi),ekr,mykaz);
                  t:=mykaz[tz^.x+tz^.gabar+i,tz^.y];
                  if (t^.tip=60) and (maxsup<50) then maxsup:=maxsup+7;
                  if ekr[tz^.gdestroit.x,tz^.gdestroit.y]=100
                  then begin
                         t^.dobicha:=true;
                         t^.dobivaet.x:=tz^.gdestroit.x;
                         t^.dobivaet.y:=tz^.gdestroit.y;
                       end
                  else begin
                         t^.tx:=tz^.gdestroit.x;
                         t^.ty:=tz^.gdestroit.y;
                       end;
                  nextstep(t);
                  if (t^.tip<51) then
                  if (t^.x<>t^.tx) or (t^.y<>t^.ty) then
                  t^.action:=move;
                  tz^.bild:=0;
                  if tz^.o4ered[1]=0
                  then
                  tz^.action:=0
                  else begin
                         tz^.chtostroit:=tz^.o4ered[1];tz^.o4ered[1]:=tz^.o4ered[2];
                         tz^.o4ered[2]:=tz^.o4ered[3];tz^.o4ered[3]:=tz^.o4ered[4];tz^.o4ered[4]:=0;
                       end;
                end;
         end;
    tz:=tz^.next;
  end;
end;

procedure moveobj;
var tz:pobject;            s:string;
    t:pobject;
    j,i,k:integer;
    V,D:boolean;
begin
  for i:=51 to 60 do
  enzd[i].est:=false;
  V:=false;
  D:=false;
  ft:=false;
  tz:=inz^.next;
  k:=100;
  while tz<>inz do
  begin
  inc(k);
  if k=250 then k:=101;
  tz^.n:=k;
  rab:=0;
  if (tz^.tip=10) and tz^.moi then inc(rab);
  if tz^.tip>50
    then begin
           if tz^.moi then V:=true
           else D:=true;
         end;

  if not tz^.moi and (tz^.tip>50)
  then enzd[tz^.tip].est:=true;
  if tz^.action=move
  then begin
         if tz^.delm=0
         then begin
         inc(tz^.offs);
         tz^.delm:=speed[tz^.tip];
         if tz^.offs=8
         then begin
                {if (tz^.tip=31) or (tz^.tip=32) then}
                delkl(tz,ekr,mykaz);
                tz^.x:=tz^.x+tz^.dx;
                tz^.y:=tz^.y+tz^.dy;
                {if (tz^.tip=31) or (tz^.tip=32) then}
                inzkl(tz,ekr,mykaz);
                tz^.offs:=0;
                if ((tz^.x=tz^.tx) or (tz^.x+tz^.gabar-1=tz^.tx))
                and ((tz^.y=tz^.ty) or (tz^.y+tz^.gabar-1=tz^.ty))
                then tz^.action:=0 else
                nextstep(tz);
              end;
              end
         else dec(tz^.delm);
       end;
  if (tz^.vid=true) and (tz^.moi) and ((tz^.action=move) or (tz^.action=moveandfire)) then begin
         if (tz^.dobicha) or (tz^.dob)
         then putsprite((tz^.dobivaet.x-1)*40-skx,(tz^.dobivaet.y-1)*40-sky,p[50,toch])
         else putsprite((tz^.tx-1)*40-skx,(tz^.ty-1)*40-sky,p[50,toch]);
         if ft=false then
         begin
         inc(toch);
         ft:=true;
         end;
         if toch=7 then toch:=0;
         end;
  if (tz^.action=moveandfire) and (tz^.fire=false)
  then begin
         tz^.stx:=tz^.tx;
         tz^.sty:=tz^.ty;
         for i:=tz^.x-dalnostataki[tz^.tip] to tz^.x+dalnostataki[tz^.tip] do
         for j:=tz^.y-dalnostataki[tz^.tip] to tz^.y+dalnostataki[tz^.tip] do
         if (i>1) and (i<60) and (j>1) and (j<60) then
         if ekr[i,j] in [1..60]
                then begin
                       t:=mykaz[i,j];
                       if (tz^.moi<>t^.moi)
                       then begin
                              tz^.fire:=true;
                              tz^.attackobj:=t;
                              str(i,s);
                              zapis(s);
                              str(j,s);
                              zapis(s);
                              {while not keys[kt] do;}
                            end;
                     end;
         if tz^.delm=0
         then begin
         inc(tz^.offs);
         tz^.delm:=speed[tz^.tip];
         if tz^.offs=8
         then begin
                delkl(tz,ekr,mykaz);
                tz^.x:=tz^.x+tz^.dx;
                tz^.y:=tz^.y+tz^.dy;
                inzkl(tz,ekr,mykaz);
                tz^.offs:=0;
                if (tz^.x=tz^.tx) and (tz^.y=tz^.ty)
                then tz^.action:=0 else
                nextstep(tz);
              end;
              end
         else dec(tz^.delm);
       end;
  tz:=tz^.next;
  end;
  if V=false
  then begin
       ya:=false;
       exite:=true;
       end;
  if D=false
  then begin
       ya:=true;
       exite:=true;
       end;
end;

procedure dobi4a;
var tz,t,qq:pobject;s:pmin;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
  if tz^.dob
    then begin
           if tz^.action=0 then blizh(tz);
           if (abs(tz^.x-tz^.dobivaet.x)<=1) and (abs(tz^.y-tz^.dobivaet.y)<=1)
           then begin
                  tz^.dobicha:=true;
                  tz^.dob:=false;
                end;
         end;
  if tz^.dobicha
  then begin
         if not tz^.havem then blizh(tz);
         if tz^.havem
         then begin
                if tz^.moi then t:=mybaze
                else t:=enbaze;
                       if (abs(tz^.x-t^.x)<=1) and (abs(tz^.y-t^.y)<=1)
                       then begin
                              tz^.havem:=false;
                              if tz^.moi then
                              mnr:=mnr+15
                              else mnrt:=mnrt+15;
                              {nextstep(tz);
                              tz^.action:=move;}
                            end
                       else begin
                              {tz^.tx:=t^.x+1;
                              tz^.ty:=t^.y;}
                              dvig(tz,t^.x,t^.y);
                            end;
              end
         else begin
                if (abs(tz^.x-tz^.dobivaet.x)<=1) and (abs(tz^.y-tz^.dobivaet.y)<=1)
                then begin
                       tz^.action:=0;
                       inc(tz^.bild);
                       {rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,
                          tz^.oldx[page]+tz^.gabar*40-skx,
                          tz^.oldy[page]-sky-6,172,172);}
                       setcolor(172);
                       bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,tz^.oldx[page]-skx+(tz^.bild div 2),tz^.oldy[page]-sky-7);
                       if tz^.bild=80
                       then begin
                       s:=mm^.next;
                       while (tz^.dobivaet.x<>s^.x) or (tz^.dobivaet.y<>s^.y)
                       do s:=s^.next;
                       s^.n:=s^.n-15;
                       tz^.havem:=true;tz^.bild:=0;
                    if tz^.moi then t:=mybaze
                    else t:=enbaze;
                    {tz^.tx:=t^.x+1;
                    tz^.ty:=t^.y;
                    nextstep(tz);
                    tz^.action:=move;}
                    dvig(tz,t^.x+1,t^.y);
                    end;
                end;
                if (abs(tz^.x-tz^.dobivaet.x)>1) and (abs(tz^.y-tz^.dobivaet.y)>1)
                   then begin
                          {tz^.tx:=tz^.dobivaet.x;
                          tz^.ty:=tz^.dobivaet.y;
                          nextstep(tz);
                          tz^.action:=move;}
                          dvig(tz,tz^.dobivaet.x,tz^.dobivaet.y);
                        end;
              end;
         end;
    tz:=tz^.next;
  end;
end;

function iamvisual(tz:pobject):boolean;
begin
  if (mx>3) and (my>3) then
  if (tz^.x in [mx-3..mx+20]) and (tz^.y in [my-3..my+12])
  then iamvisual:=true
  else iamvisual:=false;
end;

procedure showobj;
var tz:pobject;s:pmin;
c:integer;
begin
     tz:=inz^.next;
     while tz<>inz do
     begin
     if iamvisual(tz) then {begin}
     {if tz^.moi or not tz^.moi and (t[tz^.y,tz^.x]=2) or (tz^.tip>50)
     then} begin
     tz^.oldx[page]:=(tz^.x-1)*40+tz^.dx*tz^.offs*5;
     tz^.oldy[page]:=(tz^.y-1)*40+tz^.dy*tz^.offs*5;
     if tz^.action=move then if tz^.tip=3 then putsprite(tz^.oldx[page]-skx,tz^.oldy[page]-sky,p[tz^.tip+1,tz^.vect]);
     if tz^.tip<=50 then begin
     if tz^.tip>30 then putimage(tz^.oldx[page]-skx+25,tz^.oldy[page]-sky+25,p[tz^.tip,tz^.vect],ShadowPut)
     else
     putimage(tz^.oldx[page]-skx+5,tz^.oldy[page]-sky+5,p[tz^.tip,tz^.vect],ShadowPut);
     putsprite(tz^.oldx[page]-skx,tz^.oldy[page]-sky,p[tz^.tip,tz^.vect]);
     setcolor(14);
     if tz^.havem then bar(tz^.oldx[page]-skx+19,tz^.oldy[page]-sky+15,tz^.oldx[page]-skx+21,tz^.oldy[page]-sky+20);
     if tz^.moi then begin
     if round(tz^.hp/hitpoints[tz^.tip])*100 in[51..100]
     then c:=2
     else c:=4;
     end
     else begin
     if round(tz^.hp/hitpoints[tz^.tip])*100 in[51..100]
     then c:=8
     else c:=6;
     end;
     rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+tz^.gabar*40,tz^.oldy[page]-sky-3,c,c);
     setcolor(c);
     bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+round(tz^.hp*(tz^.gabar*40/hitpoints[tz^.tip])),
     tz^.oldy[page]-sky-3)
     end
     else begin
     putimage(tz^.oldx[page]-skx+10,tz^.oldy[page]-sky+0,b[tz^.tip],ShadowPut);
     putsprite(tz^.oldx[page]-skx,tz^.oldy[page]-sky,b[tz^.tip]);
     if tz^.moi then begin
     setcolor(2);
     rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+tz^.gabar*40,tz^.oldy[page]-sky-3,2,2);
     end
     else begin
     setcolor(4);
     rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+tz^.gabar*40,tz^.oldy[page]-sky-3,4,4);
     end;
bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+round(tz^.hp*(tz^.gabar*40/hitpoints[tz^.tip])),
tz^.oldy[page]-sky-3);
     if tz^.vid=true
     then if (tz^.moi) and (tz^.tip<60)
     then begin
          setcolor(2);
          line(tz^.oldx[page]-skx+tz^.gabar*20,tz^.oldy[page]-sky+tz^.gabar*20,(tz^.gdestroit.x-1)*40+20-skx,
          (tz^.gdestroit.y-1)*40+20-sky);
          end
     end;
     if tz^.vid=true
     then if tz^.moi
     then begin
            setcolor(2);
            circle(tz^.oldx[page]+tz^.gabar*20-skx,tz^.oldy[page]+tz^.gabar*20-sky,20*tz^.gabar);
          end
     else begin
            setcolor(4);
            circle(tz^.oldx[page]+tz^.gabar*20-skx,tz^.oldy[page]+tz^.gabar*20-sky,20*tz^.gabar);
          end;
     end;
     tz:=tz^.next;
     end;
end;

procedure vidilenie;
var tz:pobject;t:pobject;
    msx,msy,odx,ody,i,j:integer;
    s:pmin;f:boolean;
begin
     if (mousebutton=1) and mousen(0)
     then begin
            msx:=mousex;
            msy:=mousey;
            if msx<16 then msx:=16;
            if msx>103 then msx:=103;
            if msy<372 then msy:=372;
            if msy>459 then msy:=459;
            skx:=msx*20-320;
            sky:=(msy-360)*20-240;
          end else
     if (mousebutton=1) and (mousey<360)
        then begin
              if videlenie=false
              then begin
                   videlx:=mousex;
                   videly:=mousey;
                   videlenie:=true;
                   end;
              rectangle(videlx,videly,mousex,mousey,2,2);
              tz:=inz^.next;
                   while tz<>inz do
                   begin
                     if snarf=false then
                     tz^.vid:=false;
                     tz:=tz^.next;
                   end;
              s:=mm^.next;
              while s<>mm do
              begin
                s^.vid:=false;
                s:=s^.next;
              end;
              if keys[kctrl]
             then begin
                    t:=mykaz[(mousex+skx) div 40+1,(mousey+sky) div 40+1];
                    if (t<>nil) and t^.moi
                    then begin
                           tz:=inz^.next;
                           while tz<>inz do
                           begin
                             if (tz^.tip=t^.tip) and tz^.moi
                             then tz^.vid:=true;
                             tz:=tz^.next;
                           end;
                         end;
                  end;
              if snarf=false then begin
              f:=false;
              tz:=inz^.next;
              while tz<>inz do
              begin
                if (tz^.x>=(videlx+skx) div 40+1) and (tz^.x<=(mousex+skx) div 40+1)
                and (tz^.y>=(videly+sky) div 40+1) and (tz^.y<=(mousey+sky) div 40+1)
                or (tz^.x<=(videlx+skx) div 40+1) and (tz^.x>=(mousex+skx) div 40+1)
                and (tz^.y>=(videly+sky) div 40+1) and (tz^.y<=(mousey+sky) div 40+1)
                or (tz^.x>=(videlx+skx) div 40+1) and (tz^.x<=(mousex+skx) div 40+1)
                and (tz^.y<=(videly+sky) div 40+1) and (tz^.y>=(mousey+sky) div 40+1)
                or (tz^.x<=(videlx+skx) div 40+1) and (tz^.x>=(mousex+skx) div 40+1)
                and (tz^.y<=(videly+sky) div 40+1) and (tz^.y>=(mousey+sky) div 40+1)
                then if tz^.tip<=50
                then begin
                     tz^.vid:=true;
                     f:=true;
                     end;
                tz:=tz^.next;
              end;
              s:=mm^.next;
              while s<>mm do
              begin
               if (s^.x=(videlx+skx) div 40+1) and (s^.x=(mousex+skx) div 40+1)
                and (s^.y=(videly+sky) div 40+1) and (s^.y=(mousey+sky) div 40+1)
                then s^.vid:=true;
                s:=s^.next;
              end;
              {f:=false;
              for i:=(videlx+skx) div 40+1 to (mousex+skx) div 40+1 do
               for j:=(videly+sky) div 40+1 to (mousey+sky) div 40+1 do
               if ekr[j,i]<>0 then
               if mykaz[j,i]^.tip<=50
               then begin
                      mykaz[j,i]^.vid:=true;
                      f:=true;
                    end;
              for i:=(mousex+skx) div 40+1 to (videlx+skx) div 40+1 do
               for j:=(videly+sky) div 40+1 to (mousey+sky) div 40+1 do
               if ekr[j,i]<>0 then
               if mykaz[j,i]^.tip<=50
               then begin
                      mykaz[j,i]^.vid:=true;
                      f:=true;
                    end;
              for i:=(videlx+skx) div 40+1 to (mousex+skx) div 40+1 do
               for j:=(mousey+sky) div 40+1 to (videly+sky) div 40+1 do
               if ekr[j,i]<>0 then
               if mykaz[j,i]^.tip<=50
               then begin
                      mykaz[j,i]^.vid:=true;
                      f:=true;
                    end;
              for i:=(mousex+skx) div 40+1 to (videlx+skx) div 40+1 do
               for j:=(mousey+sky) div 40+1 to (videly+sky) div 40+1 do
               if ekr[j,i]<>0 then
               if mykaz[j,i]^.tip<=50
               then begin
                      mykaz[j,i]^.vid:=true;
                      f:=true;
                    end;}
             end;
             if not f then
             mykaz[(mousex+skx) div 40+1,(mousey+sky) div 40+1]^.vid:=true;
             end;
     if (mousebutton=0) then videlenie:=false;
     if (mousebutton=2) and not mish
     then begin
            tz:=inz^.next;
            while tz<>inz do
            begin
            if (tz^.vid=true) and (tz^.tip<=50) and (tz^.moi)
            then begin
                   if tz^.tip<>10 then begin
                   ekr[tz^.tx,tz^.ty]:=0;
                   if abs(tz^.dx)=1 then
                   ekr[tz^.x+tz^.dx,tz^.y+tz^.dy]:=0;
                   end;
                   tz^.fire:=false;
                   tz^.f10:=false;
                   tz^.gdestroit.x:=1;
                   tz^.gdestroit.y:=1;
                   tz^.bild:=0;
                   if mousen(0)
                   then begin
                          tz^.tx:=mousex div 2+1;
                          tz^.ty:=(mousey-360) div 2+1;
                        end
                   else begin
                   tz^.tx:=(mousex+skx) div 40+1;
                   tz^.ty:=(mousey+sky) div 40+1;
                   end;
                   if tz^.tip<>10
                   then begin
                   if (ekr[tz^.tx,tz^.ty]<>0) and (ekr[tz^.tx,tz^.ty]<>tz^.n)
                   then begin
                          i:=0;
                          while ekr[tz^.tx+dxs[i],tz^.ty+dys[i]]<>0 do
                          inc(i);
                          tz^.tx:=tz^.tx+dxs[i];
                          tz^.ty:=tz^.ty+dys[i];
                        end;
                   ekr[tz^.tx,tz^.ty]:=tz^.n;
                   end;
                   odx:=tz^.dx;
                   ody:=tz^.dy;
                   nextstep(tz);
                   tz^.action:=move;
                   if (tz^.tip=10) and (tz^.vid)
                   then if (ekr[(mousex+skx) div 40+1,(mousey+sky) div 40+1]=100) and (tz^.moi)
                   then begin
                   tz^.dobivaet.x:=(mousex+skx) div 40+1;
                   tz^.dobivaet.y:=(mousey+sky) div 40+1;
                   tz^.dobicha:=true;
                 end
                 else begin
                        tz^.dobivaet.x:=1;
                        tz^.dobivaet.y:=1;
                        tz^.dobicha:=false;
                        tz^.dob:=false;
                      end;
                   if rasstoianie(odx,ody,tz^.dx,tz^.dy)>2
                   then tz^.offs:=-tz^.offs;
                   if abs(odx-tz^.dx)=2 then tz^.offs:=-tz^.offs;
                   if abs(ody-tz^.dy)=2 then tz^.offs:=-tz^.offs;
                   if (tz^.dx=odx) and (tz^.dy<>ody)
                   then begin
                          if tz^.offs<4
                          then tz^.offs:=0
                          else begin
                               tz^.x:=tz^.x;
                               tz^.y:=tz^.y+ody;
                               end;
                        end;
                   if (tz^.dx<>odx) and (tz^.dy=ody)
                   then begin
                          if tz^.offs<4
                          then tz^.offs:=0
                          else begin
                               tz^.x:=tz^.x+odx;
                               tz^.y:=tz^.y;
                               end;
                        end;
                 end;
              if tz^.vid=true then
              if (tz^.tip>50) and (tz^.moi) then begin
                     tz^.gdestroit.x:=(mousex+skx) div 40+1;
                     tz^.gdestroit.y:=(mousey+sky) div 40+1;
                   end;
            tz:=tz^.next;
            end;
          end;
     tz:=inz^.next;
            while tz<>inz do
            begin
            if tz^.f10
              then begin
                   if (tz^.x=tz^.gdestroit.x-1) and (tz^.y=tz^.gdestroit.y)
                            then begin
                                   tz^.action:=stroit;
                                   tz^.f10:=false;
                                 end;
                   if tz^.mb1=false then
                   putimage(mousex,mousey,b[tz^.chtostroit],shadowput)
                   else putimage((tz^.gdestroit.x-1)*40-skx,(tz^.gdestroit.y-1)*40-sky,b[tz^.chtostroit],shadowput);
                   if (mousebutton=1) and (tz^.mb1=false) and mousen(7) or (tz^.moi=false)
                            then begin
                                 tz^.dobicha:=false;
                                 tz^.mb1:=true;
                                 if (tz^.moi)
                                 then begin
                                 tz^.gdestroit.x:=(mousex+skx) div 40+1;
                                 tz^.gdestroit.y:=(mousey+sky) div 40+1;
                                 end;
                                 {tz^.tx:=tz^.gdestroit.x-1;
                                 tz^.ty:=tz^.gdestroit.y;
                                 nextstep(tz);
                                 tz^.action:=move;}
                                 dvig(tz,tz^.gdestroit.x-1,tz^.gdestroit.y);
                                 end;
                                 end;
            tz:=tz^.next;
            end;
end;

procedure vibir;
var i,j,p,k:integer;
    tz,t:pobject;

begin
  if mousein(200,360,520,480)
  then begin
         i:=(mousex-200) div 40+1;
         j:=(mousey-360) div 40+1;
         p:=(j-1)*8+i;
         tz:=inz^.next;
         k:=0;
         while tz<>inz do
         begin
           if tz^.vid then inc(k);
           if k=p
           then begin

                end;
         tz:=tz^.next;
         end;
       end;
  if (mousebutton=1) and mousein(200,360,520,480)
  then begin
         i:=(mousex-200) div 40+1;
         j:=(mousey-360) div 40+1;
         p:=(j-1)*8+i;
         tz:=inz^.next;
         k:=0;
         while tz<>inz do
         begin
           if tz^.vid then inc(k);
           if k=p
           then begin
                  t:=inz^.next;
                  while t<>inz do
                  begin
                    t^.vid:=false;
                    t:=t^.next;
                  end;
                tz^.vid:=true;
                break;
                end;
           tz:=tz^.next;
         end;
       end;
end;

function distpixel(x,y,xx,yy:longint):longint;
begin
  distpixel:=round(sqrt(sqr(xx-x)+sqr(yy-y)));
end;

function createsnar(my,enemy:pobject):psnar;
var p:psnar;
    s:longint;
    z:integer;
begin
  new(p);
  p^.tip:={my^.tip}1;
  p^.x:=my^.x;
  p^.y:=my^.y;
  p^.offsx:=0;
  p^.offsy:=0;
  p^.tx:=enemy^.x;
  p^.ty:=enemy^.y;
  s:=rasstoianie(p^.x,p^.y,p^.tx,p^.ty)*40;
  z:=s div 2;
  p^.dx:=(-p^.x+p^.tx)*40 div z;
  p^.dy:=(-p^.y+p^.ty)*40 div z;
  p^.tank:=my;
end;

procedure snariadi;
var tz,t:pobject;
begin
  if keys[ka] then snarf:=true;
  if snarf
  then begin
       hidemouse;
       line(mousex-5,mousey,mousex+5,mousey);
       line(mousex,mousey-5,mousex,mousey+5);
       end;
  if krest and (mousebutton=0)
  then begin
       krest:=false;
       snarf:=false;
       showmouse;
       end;
  if snarf and (mousebutton=1)
  then begin
         krest:=true;
         t:=mykaz[(mousex+skx) div 40+1,(mousey+sky) div 40+1];
         if t<>nil
         then begin
                tz:=inz^.next;
                while tz<>inz do
                begin
                  if (tz^.vid) and (t<>tz) then
                             begin
                               tz^.fire:=true;
                               tz^.attackobj:=t;
                             end;
                  tz:=tz^.next
                end;
              end
         else begin
                tz:=inz^.next;
                while tz<>inz do
                begin
                  if (tz^.vid) and (tz^.tip<51) and tz^.moi then
                             begin
                               if tz^.tip<>10 then begin
                   ekr[tz^.tx,tz^.ty]:=0;
                   if abs(tz^.dx)=1 then
                   ekr[tz^.x+tz^.dx,tz^.y+tz^.dy]:=0;
                   end;
                               tz^.tx:=(mousex+skx) div 40+1;
                               tz^.ty:=(mousey+sky) div 40+1;
                               tz^.stx:=tz^.tx;
                               tz^.sty:=tz^.ty;
                               if tz^.tip<>10 then begin
                               if (ekr[tz^.tx,tz^.ty]<>0) and (ekr[tz^.tx,tz^.ty]<>tz^.n)
                   then begin
                          i:=0;
                          while ekr[tz^.tx+dxs[i],tz^.ty+dys[i]]<>0 do
                          inc(i);
                          tz^.tx:=tz^.tx+dxs[i];
                          tz^.ty:=tz^.ty+dys[i];
                        end;
                   ekr[tz^.tx,tz^.ty]:=tz^.n;
                   end;
                               nextstep(tz);
                               tz^.action:=moveandfire;

                             end;
                  tz:=tz^.next;
                end;
              end;
       end;
end;

procedure ataka;
var tz:pobject;f:psnar;i,sx,sy:integer;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
    if tz^.str
    then begin
           case tz^.vect of
           0:begin
               sx:=25+5*tz^.offs*tz^.dx;
               sy:=15+5*tz^.offs*tz^.dy;
             end;
           1:begin
               sx:=25+5*tz^.offs*tz^.dx;
               sy:=5+5*tz^.offs*tz^.dy;
             end;
           2:begin
               sx:=15+5*tz^.offs*tz^.dx;
               sy:=5+5*tz^.offs*tz^.dy;
             end;
           3:begin
               sx:=5+5*tz^.offs*tz^.dx;
               sy:=5+5*tz^.offs*tz^.dy;
             end;
           4:begin
               sx:=5+5*tz^.offs*tz^.dx;
               sy:=15+5*tz^.offs*tz^.dy;
             end;
           5:begin
               sx:=5+5*tz^.offs*tz^.dx;
               sy:=25+5*tz^.offs*tz^.dy;
             end;
           6:begin
               sx:=15+5*tz^.offs*tz^.dx;
               sy:=25+5*tz^.offs*tz^.dy;
             end;
           7:begin
               sx:=25+5*tz^.offs*tz^.dx;
               sy:=25+5*tz^.offs*tz^.dy;
             end;
           end;
           putsprite((tz^.x-1)*40-skx+sx,(tz^.y-1)*40-sky+sy,p[46,tz^.s]);
           putsprite((tz^.attackobj^.x-1)*40-skx+15+5*tz^.attackobj^.offs*tz^.attackobj^.dx+(tz^.attackobj^.gabar-1)*20,
           (tz^.attackobj^.y-1)*40-sky+15+5*tz^.attackobj^.offs*tz^.attackobj^.dy+(tz^.attackobj^.gabar-1)*20,p[45,tz^.s]);
           inc(tz^.s);
           if tz^.s>7
           then begin
                  tz^.s:=1;
                  tz^.str:=false;
                end;
         end;
    if tz^.fire
    then begin
           if tz^.action=0 then begin
           if tz^.y>tz^.attackobj^.y
           then if tz^.x>tz^.attackobj^.x
                then tz^.vect:=3
                else tz^.vect:=1;
           if tz^.y<tz^.attackobj^.y
           then if tz^.x>tz^.attackobj^.x
                then tz^.vect:=5
                else tz^.vect:=7;
           if tz^.x=tz^.attackobj^.x
           then if tz^.y>tz^.attackobj^.y
                then tz^.vect:=2
                else tz ^.vect:=6;
           if tz^.y=tz^.attackobj^.y
           then if tz^.x>tz^.attackobj^.x
                then tz^.vect:=4
                else tz^.vect:=0;
           end;
           if tz^.dels=0
           then begin
                  tz^.dels:=spstr[tz^.tip];
                  if tz^.attackobj=nil then
                  if tz^.stx=0 then tz^.action:=0
                  else begin
                         tz^.tx:=tz^.stx;
                         tz^.ty:=tz^.sty;
                         nextstep(tz);
                         tz^.action:=moveandfire;
                         tz^.fire:=false;
                       end
                  else
                  if rasstoianie(tz^.x,tz^.y,tz^.attackobj^.x,tz^.attackobj^.y)<=dalnostataki[tz^.tip]+2
                  then begin
                         tz^.action:=0;
                         {insels(zzz,createsnar(tz,tz^.attackobj));}
                         tz^.str:=true;
                         tz^.attackobj^.hp:=tz^.attackobj^.hp-abs((uron[tz^.tip]-bron[tz^.attackobj^.tip]));
                       end
                  else begin
                         if (rasstoianie(tz^.x,tz^.y,tz^.attackobj^.x,tz^.attackobj^.y)>7) and not tz^.moi
                         then tz^.fire:=false
                         else begin
                         {tz^.tx:=tz^.attackobj^.x;
                         tz^.ty:=tz^.attackobj^.y;
                         nextstep(tz);
                         tz^.action:=move;}
                         dvig(tz,tz^.attackobj^.x,tz^.attackobj^.y);
                         end;
                       end;
                end;
         end;
    if tz^.dels<>0 then
    dec(tz^.dels);
    tz:=tz^.next;
  end;
end;

procedure scan;
var tz:pobject;
    i,j:integer;
begin
  for i:={my}1 to {my+9}60 do
      for j:={mx}1 to {mx+16}60 do
        begin
        if t[j,i]=2
        then t[j,i]:=1;
        end;
  tz:=inz^.next;
  while tz<>inz do
  begin
    if tz^.moi
    then begin
           for i:=tz^.x-6 to tz^.x+6 do
           for j:=tz^.y-6 to tz^.y+6 do
           if (i>0) and (i<61) and (j>0) and (j<61)
           then begin
           t[i,j]:=2;
           end;
         end;
    tz:=tz^.next;
  end;
end;

procedure movesnar;
var tz:psnar;xx,yy:longint;
    t:pobject;
begin
  tz:=zzz^.next;
  while tz<>zzz do
  begin
    tz^.offsx:=tz^.offsx+tz^.dx;
    tz^.offsy:=tz^.offsy+tz^.dy;
    tz^.x:=tz^.x+tz^.offsx div 40;
    tz^.y:=tz^.y+tz^.offsy div 40;
    tz^.offsx:=tz^.offsx mod 40;
    tz^.offsy:=tz^.offsy mod 40;
    setcolor(4);
    bar((tz^.x-1)*40+tz^.offsx,(tz^.y-1)*40+tz^.offsy,(tz^.x-1)*40+tz^.offsx+5,(tz^.y-1)*40+tz^.offsy+5);
    if (tz^.x=tz^.tx) and (tz^.y=tz^.ty)
    then mykaz[tz^.x,tz^.y]^.hp:=mykaz[tz^.x,tz^.y]^.hp-uron[tz^.tank^.tip];
    tz:=tz^.next;
  end;
end;

procedure cdox(tz:pobject);
begin
           if tz^.next^.tip<31
           then putsprite((tz^.next^.x-1)*40-skx+tz^.next^.offs*tz^.next^.dx*5,
           (tz^.next^.y-1)*40-sky+tz^.next^.offs*tz^.next^.dy*5,p[44,tz^.next^.st-1])
           else putsprite((tz^.next^.x-1)*40-skx-20+(tz^.gabar-1)*20,
           (tz^.next^.y-1)*40-sky-20+(tz^.gabar-1)*20,p[42,tz^.next^.st-1]);
           inc(tz^.next^.st);
           if tz^.next^.st>8
           then delafter(tz,ekr,mykaz);
end;

procedure deleteall;
var tz,t:pobject;s:pmin;p:pmin;
begin
  tz:=inz;
  while tz^.next<>inz do
  begin
    if tz^.next^.cdox then cdox(tz);
    if (tz^.next^.hp<=0) and not tz^.next^.cdox
    then begin
           tz^.next^.attackobj:=nil;
           tz^.next^.fire:=false;
           ekr[tz^.next^.tx,tz^.next^.ty]:=0;
           ekr[tz^.next^.x+tz^.next^.dx,tz^.next^.y+tz^.next^.dy]:=0;
           if (not tz^.moi) and (tz^.tip in[51..60])
           then enzd[tz^.tip].est:=false;
           t:=inz^.next;
           while t<>inz do
             begin
             if t^.attackobj=tz^.next
             then begin
                    t^.fire:=false;
                    t^.str:=false;
                    t^.s:=1;
                    if tz^.tip=10
                    then begin
                         blizh(tz);
                         end;
                    if t^.stx<>0
                    then begin
                           t^.tx:=t^.stx;
                           t^.ty:=t^.sty;
                           t^.stx:=0;
                           nextstep(t);
                           t^.action:=moveandfire;
                         end
                    else begin
                         t^.action:=0;
                         t^.tx:=t^.x;
                         t^.ty:=t^.y;
                         end;
                  end;
             t:=t^.next;
             end;
           tz^.next^.cdox:=true;
           {delafter(tz,ekr,mykaz);}
         end;
    tz:=tz^.next
  end;
  s:=mm;
  while s^.next<>mm do
  begin
    if s^.next^.n<=0
    then begin
         tz:=inz^.next;
         while tz<>inz do
         begin
         if (tz^.dobivaet.x=s^.next^.x) and (tz^.dobivaet.y=s^.next^.y)
         then begin
                blizh(tz);
              end;
         tz:=tz^.next;
         end;
         p:=s^.next;
         ekr[p^.next^.x,p^.next^.y]:=0;
         if p<>nil
         then begin
                s^.next:=p^.next;
                dispose(p);
              end;
         end;
  s:=s^.next;
  end;
end;

procedure postroit(tz:pobject;typ:byte);
var i:integer;
    f:boolean;
begin
  f:=true;
  if (tz^.moi)
  then begin if (mnr<cost[typ])
  then begin
         zapis('Недостаточно минералов');
         f:=false;
       end
  else if tz^.moi
  then if sup+suply[typ]>maxsup
  then begin
         zapis('Нужно больше хранилищ');
         f:=false;
       end;
  end;
  if f then if tz^.action=stroit
                     then begin
                            i:=1;
                            while (i<>4) and (tz^.o4ered[i]<>0) do
                            inc(i);
                            if (i=4) and (tz^.o4ered[4]<>0) and (tz^.moi)
                            then zapis('очередь переполнена!')
                            else begin
                                   tz^.o4ered[i]:=typ;
                                   if tz^.moi then begin
                                                     mnr:=mnr-cost[typ];
                                                     sup:=sup+suply[typ];
                                                   end
                                   else mnrt:=mnrt-cost[typ]
                                 end;
                          end
                     else begin
                            tz^.dobicha:=false;
                            tz^.action:=stroit;
                            tz^.chtostroit:=typ;
                            if tz^.moi then begin
                                            mnr:=mnr-cost[typ];
                                            sup:=sup+suply[typ];
                                            end
                                            else mnrt:=mnrt-cost[typ]
                          end;
end;

procedure mish2;
begin
  if mousebutton=2
  then mish:=true
  else mish:=false;
end;

procedure otmena;
var tz:pobject;
    i:integer;
begin
  if keys[kz]
  then begin
       tz:=inz^.next;
       while tz<>inz do
       begin
  if tz^.moi then begin
  if tz^.vid and ((tz^.action=move) or (tz^.action=moveandfire))
  then begin
       tz^.action:=0;
       tz^.fire:=false;
       tz^.attackobj:=nil;
       end;
  if tz^.vid and (tz^.action=stroit)
  then begin
         if tz^.o4ered[1]=0
         then begin
                tz^.action:=0;
                tz^.bild:=0;
                sup:=sup-suply[tz^.chtostroit];
                mnr:=mnr+cost[tz^.chtostroit];
                tz^.chtostroit:=0;
                if tz^.tip=10
                then begin
                       tz^.gdestroit.x:=57;
                       tz^.gdestroit.y:=57;
                     end
                end
         else begin
              for i:=1 to 3 do
              if tz^.o4ered[i+1]=0
              then begin
                     sup:=sup-suply[tz^.o4ered[i]];
                     mnr:=mnr+cost[tz^.o4ered[i]];
                     tz^.o4ered[i]:=0;
                     break;
                   end;
              if tz^.o4ered[4]<>0
              then begin
                     sup:=sup-suply[tz^.o4ered[4]];
                     mnr:=mnr+cost[tz^.o4ered[4]];
                     tz^.o4ered[4]:=0;
                   end;
              end;
              end;
       end;
       tz:=tz^.next;
       end;
       end;
end;

procedure messages;
var i:integer;
begin
  for i:=1 to 4 do
  begin
    if sms[i].fl
    then begin
           setcolor(15);
           outtextxy(25,200+i*20,sms[i].sm);
           if sec-sms[i].vr=3 then sms[i].fl:=false;
         end;
  end;
end;

procedure minikarta;
var r:byte;
    mi,se:string;
    i,j:integer;tz:pobject;
begin
  setcolor(255);
  bar(0,360,640,480);
  for i:=1 to n do
  for j:=1 to m do
 begin
  if t[i,j]=2
  then setcolor(14)
  else if t[i,j]=1
  then setcolor(7)
  else setcolor(255);
  bar((i-1)*2,360+(j-1)*2,(i-1)*2+2*r-(r-1)*2,360+(j-1)*2+2*r-(r-1)*2);
  if ekr[i,j]=100
  then begin setcolor(172);
  bar((i-1)*2,360+(j-1)*2,(i-1)*2+2*r-(r-1)*2,360+(j-1)*2+2*r-(r-1)*2);
  end;
 end;
  tz:=inz^.next;
  while tz<>inz do
  begin
    if tz^.moi then
    setcolor(2)
    else setcolor(4);
    bar((tz^.x-1)*2,360+(++

    tz^.y-1)*2,(tz^.x-1)*2+2*tz^.gabar,360+(tz^.y-1)*2+2*tz^.gabar);
    tz:=tz^.next;
  end;
  setcolor(2);
  line(120,360,120,480);
  line(0,360,640,360);
  rectangle(skx div 20,360+sky div 20,skx div 20+16*2,360+sky div 20+12*2,15,15);
  inc(vremya);
  if vremya=23
  then begin
         vremya:=0;
         inc(sec);
         inc(ch);
         if ch=4 then ch:=1;
         if sec=60
         then begin
                sec:=0;
                inc(min);
              end;
       end;
  str(min,mi);
  str(sec,se);
  if min div 10=0 then mi:='0'+mi;
  if sec div 10=0 then se:='0'+se;
  outtextxy(123,373,mi);
  outtextxy(144,373,se);
  outtextxy(137,373,':');
  putsprite(560,20,b[99]);
  str(mnr,se);
  outtextxy(590,24,se);
  putsprite(560,40,b[99]);
  str(sup,se);
  outtextxy(596-(length(se)-1)*6,44,se);
  outtextxy(604,44,'/');
  str(maxsup,se);
  outtextxy(610,44,se);
  str(mnrt,se);
  outtextxy(590,100,se);
end;

procedure vataky;
var tz:pobject;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
    if not tz^.moi
    then if (tz^.tip<50) and (tz^.tip<>10)
    then begin
         tz^.tx:=4;
         tz^.ty:=4;
         tz^.stx:=4;
         tz^.sty:=4;
         tz^.action:=moveandfire;
         end;
    tz:=tz^.next;
  end;
end;

procedure klavaimish;
var i,k,j,l,h,x,y:integer;mi:string;
    r:real;
    tz,t:pobject;s:pmin;
begin
  j:=0;
  h:=0;
  k:=0;
  t:=inz^.next;
  while t<>inz do
  begin
    if t^.vid=true
    then begin
           if t^.tip<=50 then
           begin
             if tz^.tip=31 then putsprite(200+j*40,360+h*40,b[72])
             else putsprite(200+j*40,360+h*40,p[t^.tip,0])
           end
           else putsprite(200+j*40,360+h*40,b[t^.tip+10]);
           inc(j);
           if j=8 then begin j:=0;inc(h);end;
           tz:=t;
           inc(k);
         end;
    t:=t^.next;
  end;
  s:=mm^.next;
  while s<>mm do
  begin
    if s^.vid
    then begin
         putsprite(200,400,b[100]);
         str(s^.n,mi);
         outtextxy(250,400,mi);
         outtextxy(250,420,'Рабочие:');
         str(s^.work,mi);
         outtextxy(315,420,mi);
         end;
    s:=s^.next;
  end;
  if k=1
  then begin
         if tz^.tip in [1..50]
         then begin
                if tz^.action<>stroit
                then begin
                outtextxy(250,390,'Скорость:');
                if speed[tz^.tip] in[0..2]
                then outtextxy(322,390,'быстрый')
                else if speed[tz^.tip] in[3..5]
                then outtextxy(322,390,'средняя')
                else outtextxy(322,390,'медленный');
                outtextxy(250,405,'Урон:');
                str(uron[tz^.tip],mi);
                outtextxy(300,405,mi);
                outtextxy(250,420,'Скор.атаки:');
                outtextxy(373,420,'ат/с');
                r:=25/spstr[tz^.tip];
                str(r,mi);
                outtextxy(330,420,copy(mi,1,5));
                outtextxy(250,435,'Дальн.атаки:');
                str(dalnostataki[tz^.tip],mi);
                outtextxy(350,435,mi);
                outtextxy(250,450,'Броня:');
                str(bron[tz^.tip],mi);
                outtextxy(300,450,mi);
                outtextxy(250,465,'Жизни:');
                str(tz^.hp,mi);
                outtextxy(300,465,mi);
                outtextxy(325,465,'/');
                str(hitpoints[tz^.tip],mi);
                while length(mi)<3
                do mi:=' '+mi;
                outtextxy(335,465,mi);
                end;
              end;
         if tz^.tip in[51..70]
         then begin
                outtextxy(200,440,'Броня:');
                str(bron[tz^.tip],mi);
                outtextxy(250,440,mi);
                outtextxy(200,455,'Жизни:');
                str(tz^.hp,mi);
                outtextxy(250,455,mi);
                outtextxy(275,455,'/');
                str(hitpoints[tz^.tip],mi);
                while length(mi)<3
                do mi:=' '+mi;
                outtextxy(285,455,mi);
              end;
         outtextxy(340,370,name[tz^.tip]);
         if tz^.tip in[1..9,11..50]
         then begin
                kvad(1,x,y);
                x:=x-60;
                outtextxy(x,y,'Для движения нажмите');
                outtextxy(x,y+15,'правую кнопку мыши;');
                outtextxy(x,y+30,'Для атаки нажмите "А"');
                outtextxy(x,y+45,'и левую кнопку мыши');
              end;
         if tz^.moi then
         case tz^.tip of
         10:begin
              kvad(1,x,y);
              putsprite(x,y,b[61]);
              if mousen(1)
              then outtextxy(nx,ny,'Построить Командный центр');
              if (mousebutton=1) and mousen(1) or keys[kc]
              then begin
                     tz^.chtostroit:=51;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
              kvad(2,x,y);
              putsprite(x,y,b[64]);
              if mousen(2)
              then outtextxy(nx,ny,'Построить барак');
              if (mousebutton=1) and mousen(2) or keys[kb]
              then begin
                     tz^.chtostroit:=54;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
              kvad(3,x,y);
              putsprite(x,y,b[65]);
              if mousen(3)
              then outtextxy(nx,ny,'Построить завод');
              if (mousebutton=1) and mousen(3) or keys[kf]
              then begin
                     tz^.chtostroit:=55;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
              kvad(4,x,y);
              putsprite(x,y,b[66]);
              if mousen(4)
              then outtextxy(nx,ny,'Построить космопорт');
              if (mousebutton=1) and mousen(4) or keys[ks]
              then begin
                     tz^.chtostroit:=56;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
              kvad(5,x,y);
              putsprite(x,y,b[60]);
              if mousen(5)
              then outtextxy(nx,ny,'Построить хранилище припасов');
              if (mousebutton=1) and mousen(5) or keys[kv]
              then begin
                     tz^.chtostroit:=60;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
            end;
         51:begin
              outtextxy(340,370,'Командный центр');
              kvad(1,x,y);
              putsprite(x,y,p[10,0]);
              if mousen(1)
              then outtextxy(nx,ny,'Построить рабочего');
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,10);
            end;
         52:begin
              outtextxy(340,370,'planetary fortress');
              kvad(1,x,y);
            end;
         54:begin
              outtextxy(340,370,'baraks');
              kvad(1,x,y);
              putsprite(x,y,p[3,0]);
              if mousen(1)
              then outtextxy(nx,ny,'Построить пехотинца');
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,3);
            end;
         55:begin
              outtextxy(340,370,'factory');
              kvad(1,x,y);
              putsprite(x,y,p[1,0]);
              if mousen(1)
              then outtextxy(nx,ny,'Построить танк');
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,1);
              kvad(2,x,y);
              putsprite(x,y,p[2,0]);
              if mousen(2)
              then outtextxy(nx,ny,'Построить другой танк');
              if (mousebutton=1) and mousen(2) or keys[kd]
              then postroit(tz,2);
              kvad(3,x,y);
              putsprite(600,360,p[5,0]);
              if mousen(3)
              then outtextxy(nx,ny,'Построить другой танк');
              if (mousebutton=1) and mousen(3) or keys[kf]
              then postroit(tz,5);
            end;
         56:begin
              outtextxy(340,370,'Космопорт');
              kvad(1,x,y);
              putsprite(x,y,b[72]);
              if mousen(1)
              then outtextxy(nx,ny,'Построить космический корабль');
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,31);
              kvad(2,x,y);
              putsprite(560,360,p[32,0]);
              if (mousebutton=1) and mousen(2) or keys[kd]
              then postroit(tz,32);
              kvad(3,x,y);
              putsprite(600,360,p[33,0]);
              if (mousebutton=1) and mousen(3) or keys[kf]
              then postroit(tz,33);
            end;
       end;
       end;
  stroika;
end;

procedure ii;
var tz:pobject;
    s,m:pmin;
    ras:byte;
    i,j,im,jm,sd:integer;
begin
  for i:=54 to 56 do
  if (t[enzd[i].x,enzd[i].y]<>2) and (enzd[i].est=false) and ((min>=1) or (sec>=12*(i-53)))
  then begin
         enzd[i].est:=true;
         insel(inz,newel(i,enzd[i].x,enzd[i].y,false),ekr,mykaz);
       end;
  sd:=0;
  tz:=inz^.next;
  while tz<>inz do
  begin
    if (not tz^.moi)
    then begin
           if (tz^.tip<51) and (tz^.tip<>10)
           then inc(sd);
           case tz^.tip of
           10:begin
                if (tz^.action=0) and (tz^.dobicha=false) and (not tz^.fire)
                then blizh(tz);
                {begin
                ras:=100;
                for i:=tz^.x-10 to tz^.x+20 do
                for j:=tz^.y-6 to tz^.y+20 do
                if (i>0) and (i<61) and (j>0) and (j<61) then
                if (ekr[i,j]=100) and (rasstoianie(tz^.x,tz^.y,i,j)<ras)
                and not zaniat(i,j)
                then begin
                       ras:=rasstoianie(tz^.x,tz^.y,i,j);
                       im:=i;jm:=j;
                     end;
                tz^.dobivaet.x:=im;
                tz^.dobivaet.y:=jm;
                tz^.dobicha:=true;
                {s:=mm^.next;
                ras:=100;
                while s<>mm do
                begin
                  if rasstoianie(tz^.x,tz^.y,s^.x,s^.y)<ras
                  then begin
                         ras:=rasstoianie(tz^.x,tz^.y,s^.x,s^.y);
                         m:=s;
                       end;
                  s:=s^.next;
                end;
                tz^.dobicha:=true;
                tz^.dobivaet.x:=m^.x;
                tz^.dobivaet.y:=m^.y;}
                {tz^.tx:=tz^.dobivaet.x;
                tz^.ty:=tz^.dobivaet.y;
                nextstep(tz);
                tz^.action:=move;}
                {dvig(tz,tz^.dobivaet.x,tz^.dobivaet.y);
                end;}
           end;
           51:if (tz^.action=0) and (mnrt>=100) and (enemrab<10)
           then begin
                postroit(tz,10);
                inc(enemrab);
                end;
           54:if enemrip<5
           then begin
                postroit(tz,3);
                inc(enemrip);
                end;
           55:if enemtank<5
           then begin
                postroit(tz,2);
                inc(enemtank);
                end;
           end;
         end;
    tz:=tz^.next;
  end;
  if sd>=10 then vataky;
end;

procedure avtoataka;
var tz:pobject;
    t:pobject;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
    if (tz^.action=0) and not tz^.fire
    then begin
    t:=inz^.next;
    while t<>inz do
    begin
      if (tz^.moi<>t^.moi) and (tz^.tip<51)
      then begin if (rasstoianie(tz^.x,tz^.y,t^.x,t^.y)<dalnostataki[tz^.tip]-2)
      then begin
             tz^.fire:=true;
             tz^.attackobj:=t;
           end;
      if (tz^.attackobj=t) and (t^.tip<51) and (not t^.fire) and (t^.action=0)
      then begin
             t^.fire:=true;
             t^.attackobj:=tz;
           end;
      end;
      t:=t^.next;
    end;
    end;
    tz:=tz^.next;
  end;
end;

procedure strmenu;
begin
  setactivepage(3);
  setcolor(215);
  bar(0,0,640,480);
  setcolor(14);
  bar(50,50,590,150);
  bar(50,175,590,275);
  bar(50,300,590,400);
  setcolor(12);
  outtextxy(280,95,'prodoljit(Esc)');
  outtextxy(300,220,'settings');
  outtextxy(265,345,'leave this game(GG)');
  setactivepage(4);
  setcolor(215);
  bar(0,0,640,480);
  setcolor(14);
  bar(140,100,300,130);
  bar(140,150,300,180);
  bar(140,200,300,230);
  bar(140,250,300,280);
  setactivepage(15);
  setcolor(15);
  bar(0,0,640,480);
  setcolor(2);
  outtextxy(315,235,'VICTORY');
  setactivepage(14);
  setcolor(4);
  bar(0,0,640,480);
  setcolor(15);
  outtextxy(315,235,'DEFEAT');
end;

procedure skrolling;
begin
  if ((mousex=629) or keys[kright]) and (skx<1753) then skx:=skx+7;
  if ((mousex=0) or keys[kleft]) and (skx>0) then skx:=skx-7;
  if ((mousey=463) or keys[kdown]) and (sky<2034) then sky:=sky+7;
  if ((mousey=0) or keys[kup]) and (sky>0) then sky:=sky-7;
  mx:=skx div 40+1;
  my:=sky div 40+1;
end;

procedure menu;
begin
      setvisualpage(3);
      prod:=false;
      if mousebutton=1 then
      begin
      while mousebutton<>0 do;
      if (mousex>50) and (mousex<590) then
      begin
        if (mousey>50) and (mousey<150) then prod:=true;
        if (mousey>300) and (mousey<400) then exite:=true;
      end;
      end;
      if keys[kesc]
      then begin
           while keys[kesc] do;
           prod:=true
           end
      else
      if keys[kg] or keys[kenter] then exite:=true;
end;

procedure inicializaziya;
var i,j:byte;
begin
  fillchar(t,sizeof(t),0);
  new(inz);
  inz^.next:=inz;
  new(zzz);
  zzz^.next:=zzz;
  new(mm);
  mm^.next:=mm;
  videlenie:=false;
  exite:=false;
  prod:=false;
  setcolor(14);
  showmouse;
  skx:=0;
  sky:=0;
  ya:=false;
  snarf:=false;
  krest:=false;
  enemrab:=0;
  enemrip:=0;
  enemtank:=0;
  for i:=51 to 60 do
  enzd[i].est:=false;
  enzd[54].x:=45;
  enzd[54].y:=45;
  enzd[55].x:=40;
  enzd[55].y:=50;
  enzd[56].x:=49;
  enzd[56].y:=47;
  insel(inz,newel(51,7,7,true),ekr,mykaz);
  mybaze:=inz^.next;
  insel(inz,newel(51,45,51,false),ekr,mykaz);
  enbaze:=inz^.next;
  enzd[51].est:=true;
  insel(inz,newel(55,30,10,true),ekr,mykaz);
  insel(inz,newel(10,6,6,true),ekr,mykaz);
  insel(inz,newel(10,7,6,true),ekr,mykaz);
  insel(inz,newel(10,8,6,true),ekr,mykaz);
  insel(inz,newel(10,9,6,true),ekr,mykaz);
  insel(inz,newel(10,10,6,true),ekr,mykaz);
  insel(inz,newel(10,44,54,false),ekr,mykaz);
  insel(inz,newel(10,45,54,false),ekr,mykaz);
  insel(inz,newel(10,46,54,false),ekr,mykaz);
  insel(inz,newel(10,47,54,false),ekr,mykaz);
  insel(inz,newel(10,48,54,false),ekr,mykaz);
  insel(inz,newel(3,22,16,true),ekr,mykaz);
  insel(inz,newel(5,21,18,true),ekr,mykaz);
  insel(inz,newel(54,8,12,true),ekr,mykaz);
  inselm(4,3,ekr);
  inselm(2,5,ekr);
  inselm(3,7,ekr);
  inselm(3,10,ekr);
  inselm(5,13,ekr);
  inselm(56,51,ekr);
  inselm(58,49,ekr);
  inselm(57,47,ekr);
  inselm(57,44,ekr);
  inselm(55,41,ekr);
  {load(ekr);}
  for i:=1 to 4 do
  sms[i].fl:=false;
  mx:=0;
  my:=0;
  min:=0;
  sec:=0;
  vremya:=0;
  mnr:=10000;
  mnrt:=10000;
  sup:=5;
  maxsup:=10;
  ch:=0;
end;

procedure startrisekr;
var i,j:integer;
begin
for page:=0 to 1 do
    begin
      setvisualpage(1-page);
      setactivepage(page);
      for i:=1 to n do
      for j:=1 to m do
      begin
        putsprite((j-1)*40,(i-1)*40,p[0,0]);
      end;
    end;
end;

procedure risekr;
var i,j:integer;tz:pobject;    s:pmin;
    b,g:integer;
begin
setcolor(255);
bar(0,0,640,480);
for i:=my to my+9 do
      for j:=mx to mx+16 do
        begin
          {if t[j,i]<>0 then}
          putsprite((j-1)*40-skx,(i-1)*40-sky,p[0,0]);
          {if t[j,i]=1
          then putimage((j-1)*40-skx,(i-1)*40-sky,p[0,0],shadowput);
          }setcolor(2);
          if ekr[j,i]<>0 then
          begin
          setcolor(ekr[j,i]);
          bar((j-1)*40-skx+10,(i-1)*40-sky+10,(j-1)*40-skx+30,(i-1)*40-sky+30)
          end;
          if mykaz[j,i]=nil then rectangle((j-1)*40-skx+10,(i-1)*40-sky+10,(j-1)*40-skx+30,(i-1)*40-sky+30,7,7);
          setcolor(255);
          if ekr[j,i]=100
          then bar((j-1)*40-skx+10,(i-1)*40-sky+10,(j-1)*40-skx+30,(i-1)*40-sky+30);
          tz:=inz^.next;
          while tz<>inz do
          begin
            if tz^.fire then bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky,tz^.oldx[page]+20-skx,tz^.oldy[page]+20-sky);
            {if tz^.fire then bar(tz^.attackobj^.oldx[page]-skx,tz^.attackobj^.oldy[page]-sky,
            tz^.attackobj^.oldx[page]+10-skx,tz^.attackobj^.oldy[page]+10-sky);
            }{setcolor(14);
            bar((tz^.tx-1)*40-skx,(tz^.ty-1)*40-sky,(tz^.tx)*40-skx,(tz^.ty)*40-sky);
            setcolor(228);
            bar((tz^.dobivaet.x-1)*40-skx,(tz^.dobivaet.y-1)*40-sky,(tz^.dobivaet.x)*40-skx,
            (tz^.dobivaet.y)*40-sky);}
            tz:=tz^.next;
          end;
          s:=mm^.next;
          while s<>mm do
          begin
            if zaniat(s^.x,s^.y)
            then bar((s^.x-1)*40-skx,(s^.y-1)*40-sky,s^.x*40-skx,s^.y*40-sky);
            s:=s^.next;
          end;
        end;
        {for b:=skx to skx+640 do
        for g:=sky to sky+480 do
        begin
          for i:=mx+((b-1) div 40)-3 to mx+((b-1) div 40)+3 do
          for j:=my+((g-1) div 40)-3 to my+((g-1) div 40)+3 do
          if (j>3) and (j<57) and (i>3) and (i<57) then
          if ekr[j,i]<>0
          then if rasstoianie(b,i*40+20,g,j*40+20)>100
          then putpixel(g,b,255);
        end;}
      {for i:=0 to 3 do
      begin
        putsprite(-skx mod 240,-sky mod 240+240*i,b[81]);
        putsprite(-skx mod 240+240*i,-sky mod 240,b[81]);
      end;}
      {for i:=my to my+9 do
      for j:=mx to mx+16 do
        begin
          if ekr[j,i]=82 then putsprite((j-1)*40-skx,(i-1)*40-sky,b[82]);
          if ekr[j,i]=90 then
          case ch of
          1:putsprite((j-1)*40-skx+1,(i-1)*40-sky,b[90]);
          2:putsprite((j-1)*40-skx+1,(i-1)*40-sky,b[91]);
          3:putsprite((j-1)*40-skx+1,(i-1)*40-sky,b[92]);
          end;
        end;}
end;

procedure loading;
begin
  setcolor(215);
  bar(0,0,640,480);
  setcolor(4);
  outtextxy(300,235,'LOADING');
end;

begin
  initall(m640x480);
  keyboardinit;
  loading;
  inicializaziya;
  sprite;
  strmenu;
  {startrisekr;}
  page:=0;
  repeat
    if keys[kesc] then
    repeat
    while keys[kesc] do;
    menu;
    until prod or exite;
    setvisualpage(page);
    page:=1-page;
    waitVBL;
    setactivepage(page);
    skrolling;
    scan;
    risekr;
    showmin;
    moveobj;
    showobj;
    vidilenie;
    mish2;
    dobi4a;
    minikarta;
    klavaimish;
    ii;
    avtoataka;
    snariadi;
    ataka;
    movesnar;
    deleteall;
    otmena;
    vibir;
    ctrl123;
    messages;
    {inc(j);
    if j>7
    then j:=0;
    for i:=1 to 8 do
    begin
      putsprite(i*70,45,p[40+i,j]);
    end;}
  until exite;
  Repeat
  if ya
  then setvisualpage(15)
  else setvisualpage(14);
  until keys[kesc];
keyboarddone;
doneall;
end.



