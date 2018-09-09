{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
program starcraft;
uses vesa,keyboard;
const n=60;m=60;
      speed:array[1..50] of byte=(3,2,0,0,2,4,3,1,2,2,2,2,2,2,2,2,2,2,
      2,2,2,2,2,2,2,2,2,2,2,2,10,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2);
      spstr:array[1..60] of byte=(50,50,20,20,50,50,50,50,50,30,
      50,50,50,50,50,50,50,50,50,50,
      50,50,50,50,50,50,50,50,50,50,
      10,50,50,50,50,50,50,50,50,50,
      50,50,50,50,50,50,50,50,50,50,
      50,50,50,50,50,50,50,50,50,50);
      uron:array[1..40] of byte=(15,15,15,15,15,15,15,15,15,10,
      15,15,15,15,15,15,15,15,15,15,
      15,15,15,15,15,15,15,15,15,15,
      5,15,15,15,15,15,15,15,15,15);
      dalnostataki:array[1..40] of byte=(4,4,4,4,4,4,4,4,4,1,
      4,4,4,4,4,4,4,4,4,4,
      4,4,4,4,4,4,4,4,4,4,
      4,4,4,4,4,4,4,4,4,4);
      timebild:array[1..70] of word=(200,200,200,200,200,200,200,200,200,200,
      200,200,200,200,200,200,200,200,200,200,
      200,200,200,200,200,200,200,200,200,200,
      200,200,200,200,200,200,200,200,200,200,
      200,200,200,200,200,200,200,200,200,200,
      200,200,200,200,200,200,200,200,200,200,
      200,200,200,200,200,200,200,200,200,200);
      hitpoints:array[1..70] of byte=(100,100,100,100,100,100,100,100,100,70,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100);
      cost:array[1..70] of word=(150,70,60,100,100,100,100,100,100,50,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100);
      vremstr:array[1..70] of word=(100,100,100,100,100,100,100,100,100,23*10,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100,
      100,100,100,100,100,100,100,100,100,100);
      move=1;
      stroit=2;
      moveandfire=3;
type pic=array[0..50,0..7] of pointer;
     build=array[51..200] of pointer;
     tekr=array [1..n,1..m] of byte;
     tOffs=array[0..23] of ShortInt;
     kordinati=record
                     x,y:shortint;
                     end;
     pObject=^tObject;
     tObject=record
               next:pObject;
               vid:boolean;
               tip:byte;
               moi:boolean;
               x,y:integer;
               oldx,oldy:array[0..1] of integer;
               hp:integer;
               dx,dy,tx,ty,stx,sty:integer;
               vect:integer;
               offs,bild:integer;
               action:word;
               delm,dels:byte;
               sost:byte;
               gabar:byte;
               chtostroit:byte;
               dobivaet:kordinati;
               dobicha,f10,mb1,fire:boolean;
               havem:boolean;
               kydastroit:byte;
               o4ered:array [1..4] of byte;
               o4eredm:array[1..4] of byte;
               gdestroit:kordinati;
               attackobj:pobject;
            end;
     psnar=^tsnar;
     tsnar=record
                 next:psnar;
                 x,y:longint;
                 tx,ty:byte;
                 dx,dy:integer;
                 tank:pobject;
                 tip:byte;
           end;
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
    i,j,w,videlx,videly,skx,sky,mx,my,enemrab:integer;
    c:char;
    page,min,sec,toch:byte;
    inz:pobject;
    mm:pmin;
    zzz:psnar;klav,ya:boolean;
    videlenie,exit,prod,snarf,krest:boolean;
    vremya,mnr,mnrt:integer;
    minerals:array[1..20] of kordinati;
    sms:array[1..4] of message;
    ctrl1:ctrl12;
    mykaz:tmykaz;
    mybaze,enbaze:pobject;
    enzd:enzda;

{procedure load(var ekr:tekr);
var i,j:integer;
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
     if c='1' then ekr[i,j]:=101;
     end;
     readln(f);
     end;
end;}

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
  {p[3,8]:=loadspr('rip8.spr');}
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
  p[2,i]:=loadspr1(f);
  assign(f,'mytank2.dat');
  reset(f,1);
  for i:=0 to 7 do
  p[5,i]:=loadspr1(f);
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
  b[51]:=loadspr('baza.spr');
  b[52]:=loadspr('planet.spr');
  b[54]:=loadspr('barak.spr');
  b[55]:=loadspr('factory.spr');
  b[56]:=loadspr('star.spr');
  b[98]:=loadspr('cursor.spr');
  b[99]:=loadspr('minicon.spr');
  b[100]:=loadspr('dryz.spr');
  b[150]:=loadspr('elka12x2.spr');
  b[151]:=loadspr('elka22x2.spr');
  b[152]:=loadspr('elka21x1.spr');
end;

procedure ctttt(h:byte);
var tz:pobject;
begin
  i:=0;
  tz:=inz^.next;
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
     ekr[j,i]:=tz^.tip;
     mykaz[j,i]:=tz;
     end;
end;

procedure delkl(tz:pobject;var ekr:tekr;var mykaz:tmykaz);
var i,j:byte;
begin
  for i:=tz^.x to tz^.x+tz^.gabar-1 do
     for j:=tz^.y to tz^.y+tz^.gabar-1 do
     begin
     ekr[j,i]:=0;
     mykaz[j,i]:=nil;
     end;
end;

function rasstoianie(x1,y1,x2,y2:longint):longint;
begin
  rasstoianie:=round(sqrt(sqr(x2-x1)+sqr(y2-y1)));
end;

function newel(typ:byte;x,y:integer;kto:boolean):pobject;
var tz:pobject;  i:integer;
begin
  new(tz);
  tz^.tip:=typ;
  tz^.x:=x;
  tz^.y:=y;
  tz^.action:=0;
  tz^.bild:=0;
  fillchar(tz^.o4ered,sizeof(tz^.o4ered),0);
  if typ in[51..53,31] then tz^.gabar:=3
  else if typ in [54..57,32] then tz^.gabar:=2
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
  tz^.havem:=false;
  tz^.f10:=false;  tz^.mb1:=false;
  tz^.hp:=hitpoints[tz^.tip];
  tz^.dels:=0;
  tz^.fire:=false;
  tz^.stx:=0;
  tz^.sty:=0;
  tz^.vect:=0;
  tz^.moi:=kto;
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

procedure inselm(x,y:integer;var ekr:tekr);
var tz:pmin;
begin
  new(tz);
  tz^.x:=x;
  tz^.y:=y;
  tz^.vid:=false;
  tz^.n:=5666;
  tz^.next:=mm^.next;
  mm^.next:=tz;
  ekr[x,y]:=100;
end;

function mousein(x1,y1,x2,y2:integer):boolean;
begin
  mousein:=(mousex>=x1)and(mousex<=x2)and(mousey>=y1)and(mousey<=y2);
end;

function mousen(k:integer):boolean;
begin
  case k of
  1:if mousein(520,340,560,380)
  then mousen:=true
  else mousen:=false;
  2:if mousein(560,340,600,380)
  then mousen:=true
  else mousen:=false;
  3:if mousein(600,340,640,380)
  then mousen:=true
  else mousen:=false;
  4:if mousein(520,380,560,420)
  then mousen:=true
  else mousen:=false;
  5:if mousein(560,380,600,420)
  then mousen:=true
  else mousen:=false;
  6:if mousein(600,380,640,420)
  then mousen:=true
  else mousen:=false;
  0:if mousein(0,360,120,480)
  then mousen:=true
  else mousen:=false;
  end;
end;

Procedure nextstep(tz:pobject);
Const Max=500;
var xs,xf,ys,yf:shortint;
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
  then Writeln('Œ˜ÂÂ‰¸ ÔÂÂÔÓÎÌÂÌ‡'#7#7#7)
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
  then Writeln('Œ˜ÂÂ‰¸ ÔÛÒÚ‡ '#7#7#7)
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
  if tz^.tx<>0 then
  if ekr[tz^.ty,tz^.tx]<>0
         then begin
         i:=0;
         while ekr[tz^.ty+dys[i],tz^.tx+dxs[i]]<>0 do
         inc(i);
         tz^.tx:=tz^.tx+dxs[i];
         tz^.ty:=tz^.ty+dys[i];
         end;
  IF TZ^.tip<>10 THEN BEGIN
         t:=inz^.next;
         while t<>inz do
         begin
         if (tz^.tx=t^.tx) and (tz^.ty=t^.ty) and (tz<>t)
         then begin
         i:=0;
         while ekr[tz^.ty+dys[i],tz^.tx+dxs[i]]<>0 do
         inc(i);
         tz^.tx:=tz^.tx+dxs[i];
         tz^.ty:=tz^.ty+dys[i];
         end;
         t:=t^.next;
         end;
         END;
  if (tz^.tip=10) and (tz^.dobicha) and (tz^.havem=false)
  then begin
         i:=0;
         while (ekr[tz^.dobivaet.y+dy[i],tz^.dobivaet.x+dx[i]]<>0) and (i<8) do
         inc(i);
         tz^.tx:=tz^.dobivaet.x+dx[i];
         tz^.ty:=tz^.dobivaet.y+dy[i];
       end;
  xf:=tz^.tx;yf:=tz^.ty;
  if (tz^.tip>30) OR (TZ^.TIP=10) AND (TZ^.DOBICHA)
  then BEGIN
       fillchar(mat,sizeof(mat),0);
       for i:=1 to n do
  for j:=1 to m do
  if (ekr[i,j]>50) then
  mat[i,j]:=ekr[i,j]
       END
  else
  for i:=1 to n do
  for j:=1 to m do
  if ekr[i,j]<>0 then
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
end;

procedure exat(var tz:pobject;tx,ty:integer);
begin
  tz^.tx:=tx;
  tz^.ty:=ty;
  nextstep(tz);
  tz^.action:=move;
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
           rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,tz^.oldx[page]+tz^.gabar*40-skx,tz^.oldy[page]-sky-7,172,172);
           bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,tz^.oldx[page]-skx+
           round(tz^.bild*(tz^.gabar*40/timebild[tz^.chtostroit])),tz^.oldy[page]-sky-7);
           if tz^.vid=true
           then begin
                  rectangle(350,420,450,425,2,2);
                  setcolor(2);
                  bar(351,421,349+round(tz^.bild*(100/timebild[tz^.chtostroit])),424);
                  if tz^.chtostroit<51 then
                  putsprite(310,385,p[tz^.chtostroit,0])
                  else putsprite(310,385,b[tz^.chtostroit]);
                  for i:=1 to 4 do
                  if tz^.o4ered[i]<>0
                  then putsprite(310+(i-1)*40,425,p[tz^.o4ered[i],0]);
                end;
           if tz^.bild=timebild[tz^.chtostroit]
           then begin
                  i:=0;
                  while ekr[tz^.y,tz^.x+tz^.gabar+i]<>0 do
                  inc(i);
                  insel(inz,newel(tz^.chtostroit,tz^.x+tz^.gabar+i,tz^.y,tz^.moi),ekr,mykaz);
                  t:=mykaz[tz^.y,tz^.x+tz^.gabar+i];
                  if ekr[tz^.gdestroit.y,tz^.gdestroit.x]=100
                  then begin
                         t^.dobicha:=true;
                         t^.dobivaet.x:=tz^.gdestroit.x;
                         t^.dobivaet.y:=tz^.gdestroit.y;
                       end;
                  t^.tx:=tz^.gdestroit.x;
                  t^.ty:=tz^.gdestroit.y;
                  nextstep(t);
                  if (t^.tip<51) then
                  if (t^.x<>t^.tx) and (t^.y<>t^.ty) then
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
var tz:pobject;  t:pobject;
    f:boolean;j,i:integer;
begin
  f:=false;
  tz:=inz^.next;
  while tz<>inz do
  begin
  if tz^.action=move
  then begin
         {IF TZ^.tip<>10 THEN BEGIN
         t:=inz^.next;
         while t<>inz do
         begin
         if (tz^.tx=t^.tx) and (tz^.ty=t^.ty) and (tz<>t)
         then tz^.tx:=tz^.tx+1;
         t:=t^.next;
         end;
         END;}
         if tz^.vid=true then begin
         putsprite((tz^.tx-1)*40-skx,(tz^.ty-1)*40-sky,p[50,toch]);
         if f=false then
         inc(toch);
         f:=true;
         if toch=7 then toch:=0;
         end;
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
                if (tz^.x=tz^.tx) and (tz^.y=tz^.ty)
                then tz^.action:=0 else
                nextstep(tz);
              end;
              end
         else dec(tz^.delm);
       end;
  if (tz^.action=moveandfire) and (tz^.fire=false)
  then begin
         tz^.stx:=tz^.tx;
         tz^.sty:=tz^.ty;
         for i:=tz^.x-dalnostataki[tz^.tip] to tz^.x+dalnostataki[tz^.tip] do
         for j:=tz^.y-dalnostataki[tz^.tip] to tz^.y+dalnostataki[tz^.tip] do
         if (i>1) and (i<60) and (j>1) and (j<60) then
         if ekr[j,i]<>0
         then begin
                t:=mykaz[j,i];
                if (tz^.moi<>t^.moi) then begin
                           tz^.fire:=true;
                           tz^.attackobj:=t;
                         end;
              end;
         {if tz^.vid=true then begin
         putsprite((tz^.tx-1)*40-skx,(tz^.ty-1)*40-sky,p[50,toch]);
         if f=false then
         inc(toch);
         f:=true;
         if toch=7 then toch:=0;
         end;}
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
end;

procedure dobi4a;
var tz,t,qq:pobject;s,m:pmin;ras:integer;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
  if tz^.dobicha
  then begin
         if ekr[tz^.dobivaet.y,tz^.dobivaet.x]=0
         then begin
                s:=mm^.next;
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
                tz^.dobivaet.x:=m^.y;
                tz^.dobivaet.y:=m^.x;
                exat(tz,tz^.dobivaet.x,tz^.dobivaet.y);
              end;
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
                       nextstep(tz);
                       tz^.action:=move;
                     end
                else begin
                     tz^.tx:=t^.x;
                     tz^.ty:=t^.y;
                     end;
              end
         else begin
                if (abs(tz^.x-tz^.dobivaet.x)<=1) and (abs(tz^.y-tz^.dobivaet.y)<=1)
                then begin
                       tz^.action:=0;
                       inc(tz^.bild);
                       rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,
                          tz^.oldx[page]+tz^.gabar*40-skx,
                          tz^.oldy[page]-sky-6,172,172);
                       setcolor(172);
                       bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-10,tz^.oldx[page]-skx+(tz^.bild div 2),tz^.oldy[page]-sky-7);
                       if tz^.bild=80
                       then begin
                       s:=mm^.next;
                       while (tz^.dobivaet.y<>s^.x) and (tz^.dobivaet.x<>s^.y)
                       do s:=s^.next;
                       if s<>nil
                       then
                       s^.n:=s^.n-15;
                       tz^.havem:=true;tz^.bild:=0;
                    if tz^.moi then t:=mybaze
                    else t:=enbaze;
                    tz^.tx:=t^.x;
                    tz^.ty:=t^.y;
                    nextstep(tz);
                    tz^.action:=move;
                    end;
                end;
                if (abs(tz^.x-tz^.dobivaet.x)>1) and (abs(tz^.y-tz^.dobivaet.y)>1)
                   then begin
                          tz^.tx:=tz^.dobivaet.x;
                          tz^.ty:=tz^.dobivaet.y;
                          nextstep(tz);
                        end;
              end;
              end;
  tz:=tz^.next;
  end;
end;

procedure showobj(inz:pobject);
var tz:pobject;t:psnar;s:pmin;
begin
     tz:=inz^.next;
     while tz<>inz do
     begin
     tz^.oldx[page]:=(tz^.x-1)*40+tz^.dx*tz^.offs*5;
     tz^.oldy[page]:=(tz^.y-1)*40+tz^.dy*tz^.offs*5;
     if tz^.action=move then if tz^.tip=3 then putsprite(tz^.oldx[page]-skx,tz^.oldy[page]-sky,p[tz^.tip+1,tz^.vect]);
     if tz^.tip<=50 then begin
     if tz^.tip>30 then putimage(tz^.oldx[page]-skx+25,tz^.oldy[page]-sky+25,p[tz^.tip,tz^.vect],ShadowPut)
     else
     putimage(tz^.oldx[page]-skx+5,tz^.oldy[page]-sky+5,p[tz^.tip,tz^.vect],ShadowPut);
     putsprite(tz^.oldx[page]-skx,tz^.oldy[page]-sky,p[tz^.tip,tz^.vect]);
     if tz^.moi then begin
     setcolor(2);
     rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+tz^.gabar*40,tz^.oldy[page]-sky-3,2,2);
     end
     else begin
     setcolor(4);
     rectangle(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+tz^.gabar*40,tz^.oldy[page]-sky-3,4,4);
     end;
     bar(tz^.oldx[page]-skx,tz^.oldy[page]-sky-6,tz^.oldx[page]-skx+round(tz^.hp*(tz^.gabar*40/hitpoints[tz^.tip])),
     tz^.oldy[page]-sky-3)
     end
     else begin
     putimage(tz^.oldx[page]-skx+5,tz^.oldy[page]-sky+5,b[tz^.tip],ShadowPut);
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
     then if tz^.moi
     then begin
          setcolor(2);
          line(tz^.oldx[page]-skx+40,tz^.oldy[page]-sky+40,(tz^.gdestroit.x-1)*40+20-skx,(tz^.gdestroit.y-1)*40+20-sky);
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
     tz:=tz^.next;
     end;
     s:=mm^.next;
     while s<>mm do
     begin
       putsprite((s^.y-1)*40-skx,(s^.x-1)*40-sky,b[100]);
       setcolor(15);
       if s^.vid then circle((s^.y-1)*40-skx+20,(s^.x-1)*40-sky+20,20);
       s:=s^.next;
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
              if snarf=false then begin
              {tz:=inz^.next;
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
                then tz^.vid:=true;
                if (tz^.x=(videlx+skx) div 40+1) and (tz^.x=(mousex+skx) div 40+1)
                and (tz^.y=(videly+sky) div 40+1) and (tz^.y=(mousey+sky) div 40+1)
                then if tz^.tip>50
                then tz^.vid:=true;
                tz:=tz^.next;
              end;}
              s:=mm^.next;
              while s<>mm do
              begin
               if (s^.y=(videlx+skx) div 40+1) and (s^.y=(mousex+skx) div 40+1)
                and (s^.x=(videly+sky) div 40+1) and (s^.x=(mousey+sky) div 40+1)
                then s^.vid:=true;
                s:=s^.next;
              end;
              f:=false;
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
                    end;
             end;
             if not f then
             mykaz[(mousey+sky) div 40+1,(mousex+skx) div 40+1]^.vid:=true;
             end;
     if (mousebutton=0) then videlenie:=false;
     if mousebutton=2
     then begin
            tz:=inz^.next;
            while tz<>inz do
            begin
            if (tz^.vid=true) and (tz^.tip<=50) and (tz^.moi)
            then begin
                   tz^.fire:=false;
                   tz^.action:=move;
                   if mousen(0)
                   then begin
                          tz^.tx:=mousex div 2+1;
                          tz^.ty:=(mousey-360) div 2+1;
                        end
                   else begin
                   tz^.tx:=(mousex+skx) div 40+1;
                   tz^.ty:=(mousey+sky) div 40+1;
                   end;
                   odx:=tz^.dx;
                   ody:=tz^.dy;
                   nextstep(tz);
                   if (tz^.tip=10) and (tz^.vid)
                   then if (ekr[(mousey+sky) div 40+1,(mousex+skx) div 40+1]=100) and (tz^.moi)
                   then begin
                   tz^.dobivaet.x:=(mousex+skx) div 40+1;
                   tz^.dobivaet.y:=(mousey+sky) div 40+1;
                   tz^.DOBICHA:=true;
                 end
                 else tz^.dobicha:=false;
                   if abs(odx-tz^.dx)=2 then tz^.offs:=-tz^.offs;
                   if abs(ody-tz^.dy)=2 then tz^.offs:=-tz^.offs;
                 end;
              if tz^.vid=true then
              if (tz^.tip>50) and (tz^.moi) then begin
                     tz^.gdestroit.x:=(mousex+skx) div 40+1;
                     tz^.gdestroit.y:=(mousey+sky) div 40+1;
                   end;
            tz:=tz^.next;
            end;
          end;
     moveobj;
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
                   if tz^.mb1=false         then
                   putimage(mousex,mousey,b[tz^.chtostroit],shadowput)
                   else putimage((tz^.gdestroit.x-1)*40-skx,(tz^.gdestroit.y-1)*40-sky,b[tz^.chtostroit],shadowput);
                   if (mousebutton=1) and (tz^.mb1=false) or (tz^.moi=false)
                            then begin
                                 tz^.mb1:=true;
                                 if (tz^.moi)
                                 then begin
                                 tz^.gdestroit.x:=(mousex+skx) div 40+1;
                                 tz^.gdestroit.y:=(mousey+sky) div 40+1;
                                 end;
                                 tz^.tx:=tz^.gdestroit.x-1;
                                 tz^.ty:=tz^.gdestroit.y;
                                 nextstep(tz);
                                 tz^.action:=move;
                                 end;
                                 end;
            tz:=tz^.next;
            end;
end;

procedure vibir;
var i,j,h:integer;
    tz,p:pobject;
begin
  if (mousebutton=1) and (mousein(400,360,640,480))
  then begin
        i:=(mousex-400) div 40+1;
        h:=(mousey-360) div 40+1;
        i:=i+h*8;
        j:=0;
        tz:=inz^.next;
        while tz<>inz do
        begin
          if tz^.vid then
          inc(j);
          if i=j
          then p:=tz;
          tz:=tz^.next;
        end;
       tz:=inz^.next;
        while tz<>inz do
        begin
          tz^.vid:=false;
          tz:=tz^.next;
        end;
       p^.vid:=true;
       end;
end;

function distpixel(x,y,xx,yy:integer):longint;
begin
  distpixel:=round(sqrt(sqr(xx-x)+sqr(yy-y)));
end;

function createsnar(my,enemy:pobject):psnar;
var p:psnar;
    s:longint;
begin
  new(p);
  p^.tip:=my^.tip;
  p^.x:=my^.oldx[page]+20;
  p^.y:=my^.oldy[page]+20;
  p^.tx:=enemy^.x;
  p^.ty:=enemy^.y;
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
         t:=mykaz[(mousey+sky) div 40+1,(mousex+skx) div 40+1];
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
                  if (tz^.vid) and (tz^.tip<51) then
                             begin
                               tz^.tx:=(mousex+skx) div 40+1;
                               tz^.ty:=(mousey+sky) div 40+1;
                               nextstep(tz);
                               tz^.action:=moveandfire;
                             end;
                  tz:=tz^.next;
                end;
              end;
       end;
end;

procedure creatsnar;
var tz:pobject;f:psnar;i:integer;
begin
  tz:=inz^.next;
  while tz<>inz do
  begin
    if tz^.fire
    then begin
           if tz^.action=0 then begin
           if tz^.x=tz^.attackobj^.x
           then if tz^.y>tz^.attackobj^.y
                then tz^.vect:=2
                else tz^.vect:=6;
           if tz^.y=tz^.attackobj^.y
           then if tz^.x>tz^.attackobj^.x
                then tz^.vect:=4
                else tz^.vect:=0;
           if tz^.y>tz^.attackobj^.y
           then if tz^.x>tz^.attackobj^.x
                then tz^.vect:=3
                else tz^.vect:=1;
           if tz^.y<tz^.attackobj^.y
           then if tz^.x>tz^.attackobj^.x
                then tz^.vect:=5
                else tz^.vect:=7;
           end;
           if tz^.dels=0
           then begin
                  tz^.dels:=spstr[tz^.tip];
                  if tz^.attackobj=nil then tz^.action:=0
                  else
                  if rasstoianie(tz^.x,tz^.y,tz^.attackobj^.x,tz^.attackobj^.y)<=dalnostataki[tz^.tip] then
                  begin
                  tz^.action:=0;
                  {insels(zzz,createsnar(tz,tz^.attackobj));}
                  tz^.attackobj^.hp:=tz^.attackobj^.hp-uron[tz^.tip];
                  end
                  else begin
                         tz^.tx:=tz^.attackobj^.x;
                         tz^.ty:=tz^.attackobj^.y;
                         nextstep(tz);
                         tz^.action:=move;
                       end;
                end;
         end;
    if tz^.dels<>0 then
    dec(tz^.dels);
    tz:=tz^.next;
  end;
  {f:=zzz^.next;
  i:=0;
  while f<>zzz do
  begin
    if i<10 then
    putsprite(50+i*40,50,b[98]);
    inc(i);
    f:=f^.next;
  end; }
end;

procedure deleteall;
var tz,t:pobject;s:pmin;p:pmin;
begin
  tz:=inz;
  while tz^.next<>inz do
  begin
    if tz^.next^.hp<=0
    then begin
           if (tz^.tip>50) and (not tz^.moi)
           then enzd[tz^.tip].est:=false;
           t:=inz^.next;
           while t<>inz do
             begin
             if t^.attackobj=tz^.next
             then begin
                    t^.fire:=false;
                    if t^.stx<>0
                    then begin
                           t^.tx:=t^.stx;
                           t^.ty:=t^.sty;
                           t^.stx:=0;
                           nextstep(t);
                           t^.action:=moveandfire;
                         end
                    else
                    t^.action:=0;
                  end;
             t:=t^.next;
             end;
           delafter(tz,ekr,mykaz);
         end;
    tz:=tz^.next
  end;
  s:=mm;
  while s^.next<>mm do
  begin
    if s^.next^.n<=0
    then begin
         p:=s^.next;
         ekr[p^.next^.y,p^.next^.x]:=0;
  if p<>nil
  then begin
         s^.next:=p^.next;
         dispose(p);
       end;
         end;
  s:=s^.next;
  end;
end;

procedure movesnar;
var tz:psnar;xx,yy:longint;
begin
  tz:=zzz^.next;
  while tz<>zzz do
  begin
    putsprite(20,20,b[98]);
    tz^.x:=tz^.x+1;tz^.y:=tz^.y+1;
    xx:=tz^.x div 40+1;yy:=tz^.y div 40+1;
    if (tz^.tx=xx) and (tz^.ty=yy)
    then begin
         end;
    tz:=tz^.next;
  end;
end;

procedure zapis(s:string);
begin
  sms[4]:=sms[3];sms[3]:=sms[2];sms[2]:=sms[1];
  sms[1].fl:=true;
  sms[1].sm:=s;
  sms[1].vr:=sec;
end;

procedure postroit(tz:pobject;typ:byte);
begin
  if mnr<cost[typ]
  then zapis('nedostato4no mineralov')
  else
  if tz^.action=stroit
                     then begin
                            i:=1;
                            while (i<>4) and (tz^.o4ered[i]<>0) do
                            inc(i);
                            if (i=4) and (tz^.o4ered[4]<>0)
                            then zapis('ÆÁ•‡•§Ï Ø•‡•ØÆ´≠•≠†!')
                            else begin
                                   tz^.o4ered[i]:=typ;
                                   if tz^.moi then
                                   mnr:=mnr-cost[typ]
                                   else mnrt:=mnrt-cost[typ]
                                 end;
                          end
                     else begin
                            tz^.action:=stroit;
                            tz^.chtostroit:=typ;
                            if tz^.moi then
                                   mnr:=mnr-cost[typ]
                                   else mnrt:=mnrt-cost[typ]
                          end;
end;

procedure otmena(tz:pobject);
begin
  if tz^.action=stroit
  then begin
         tz^.action:=0;
         tz^.chtostroit:=0;
       end
  else begin

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
    i:integer;tz:pobject;
begin
  setcolor(255);
  bar(0,360,640,480);
  setcolor(2);
  line(120,360,120,480);
  for i:=1 to n do
  for j:=1 to m do
  if ekr[i,j]=100
  then begin setcolor(172);
  bar((j-1)*2,360+(i-1)*2,(j-1)*2+2*r-(r-1)*2,360+(i-1)*2+2*r-(r-1)*2);
  end;
  {begin
         case ekr[i,j] of
         1..30:r:=1;
         31,51..53:r:=3;
         32,54..70:r:=2;
         end;
         bar((j-1)*2,360+(i-1)*2,(j-1)*2+2*r-(r-1)*2,360+(i-1)*2+2*r-(r-1)*2);
       end;}
  tz:=inz^.next;
  while tz<>inz do
  begin
    if tz^.moi then
    setcolor(2)
    else setcolor(4);
    bar((tz^.x-1)*2,360+(tz^.y-1)*2,(tz^.x-1)*2+2*tz^.gabar,360+(tz^.y-1)*2+2*tz^.gabar);
    tz:=tz^.next;
  end;
  rectangle(skx div 20,360+sky div 20,skx div 20+16*2,360+sky div 20+12*2,15,15);
  inc(vremya);
  if vremya=23
  then begin
         vremya:=0;
         inc(sec);
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
end;

procedure klavaimish;
var i,k,j,l,h:integer;mi:string;
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
           putsprite(200+j*40,360+h*40,p[t^.tip,0])
           else putsprite(200+j*40,360+h*40,b[t^.tip]);
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
         end;
    s:=s^.next;
  end;
  if k=1
  then begin case tz^.tip of
         1:outtextxy(340,370,'siege tank');
         2:outtextxy(340,370,'mini TANK');
         3:outtextxy(340,370,'reaper');
         {4:
         5:
         6:
         7:
         8:
         9:}
         10:begin
              outtextxy(340,370,'ê†°ÆÁ®©');
              putsprite(520,360,p[10,0]);
              if (mousebutton=1) and mousen(1) or keys[kc]
              then begin
                     tz^.chtostroit:=51;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
              if (mousebutton=1) and mousen(2) or keys[kb]
              then begin
                     tz^.chtostroit:=54;
                     tz^.f10:=true;
                   end;
              if (mousebutton=1) and mousen(3) or keys[kf]
              then begin
                     tz^.chtostroit:=55;
                     tz^.f10:=true;
                   end;
              if (mousebutton=1) and mousen(4) or keys[ks]
              then begin
                     tz^.chtostroit:=56;
                     tz^.f10:=true;
                     tz^.mb1:=false;
                   end;
            end;
         51:begin
              outtextxy(340,370,'äÆ¨†≠§≠Î© Ê•≠‚‡');
              putsprite(520,360,p[10,0]);
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,10);
            end;
         52:outtextxy(340,370,'planetary fortress');
         54:begin
              outtextxy(340,370,'baraks');
              putsprite(520,360,p[3,0]);
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,3);
            end;
         55:begin
              outtextxy(340,370,'factory');
              putsprite(520,360,p[1,0]);
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,1);
              putsprite(560,360,p[2,0]);
              if (mousebutton=1) and mousen(2) or keys[kd]
              then postroit(tz,2);
              putsprite(600,360,p[5,0]);
              if (mousebutton=1) and mousen(3) or keys[kf]
              then postroit(tz,5);
            end;
         56:begin
              outtextxy(340,370,'äÆ·¨ÆØÆ‡‚');
              if (mousebutton=1) and mousen(1) or keys[ks]
              then postroit(tz,32);
              if (mousebutton=1) and mousen(2) or keys[km]
              then postroit(tz,31);
              if (mousebutton=1) and mousen(3) or keys[kg]
              then postroit(tz,33);
            end;
       end;
       str(tz^.hp,mi);
       outtextxy(212,450,mi);
       outtextxy(237,450,'/');
       str(hitpoints[tz^.tip],mi);
       outtextxy(245,450,mi);
       end;
  stroika;
end;

procedure stran;
begin
  setactivepage(15);
  setcolor(15);
  bar(0,0,640,480);
  setcolor(2);
  outtextxy(315,235,'èéÅÖÑÄ!');
  setactivepage(14);
  setcolor(4);
  bar(0,0,640,480);
  setcolor(15);
  outtextxy(315,235,'èéêÄÜÖçàÖ!');
end;

{procedure ktovigral;
var i:integer;f:boolean;
begin
  f:=true;
  for i:=51 to 60 do
  if enzd[i].est
  then f:=false;
  if f
  then begin
       exit:=true;
       ya:=true;
       end;
end;}

procedure ii;
var tz:pobject;s,m:pmin;ras:byte;i:integer;f,f1:boolean;
begin
  tz:=inz^.next;
  f:=false;
  f1:=false;
  while tz<>inz do
  begin
    if not tz^.moi
    then begin
           if tz^.tip>50 then f:=true;
           case tz^.tip of
           10:begin
           if enzd[54].est=false
           then begin
                tz^.gdestroit.x:=enzd[54].x;
                tz^.gdestroit.y:=enzd[54].y;
                tz^.dobicha:=false;
                tz^.f10:=true;
                tz^.chtostroit:=54;
                if (tz^.x=tz^.gdestroit.x-1) and
                (tz^.y=tz^.gdestroit.y)
                then begin
                     tz^.f10:=false;
                     tz^.action:=stroit;
                     enzd[54].est:=true;
                     end
                else begin
                tz^.tx:=tz^.gdestroit.x-1;
                tz^.ty:=tz^.gdestroit.y;
                nextstep(tz);
                tz^.action:=move;
                end;
                end;
                if (tz^.action=0) and (tz^.dobicha=false)
                then begin
                s:=mm^.next;
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
                tz^.dobivaet.x:=m^.y;
                tz^.dobivaet.y:=m^.x;
                tz^.tx:=tz^.dobivaet.x;
                tz^.ty:=tz^.dobivaet.y;
                nextstep(tz);
                tz^.action:=move;
                end;
           end;
           51:if (tz^.action=0) and (mnrt>=100) and (enemrab<12)
           then begin
                postroit(tz,10);
                inc(enemrab);
                end;
           end;
         end;
    if (tz^.moi) and (tz^.tip>50)
    then f1:=true;
    tz:=tz^.next;
  end;
  if not f1
  then begin
         exit:=true;
         ya:=false;
       end;
  if not f
  then begin
         exit:=true;
         ya:=true;
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
end;

procedure skrolling;
begin
  if ((mousex=629) or keys[kright]) and (skx<1753) then skx:=skx+7;
  if ((mousex=0) or keys[kleft]) and (skx>0) then skx:=skx-7;
  if ((mousey=463) or keys[kdown]) and (sky<1914) then sky:=sky+7;
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
        if (mousey>300) and (mousey<400) then exit:=true;
      end;
      end;
      {w:=readkeyboard(c);}
      if keys[kesc]
      then begin
           while keys[kesc] do;
           prod:=true
           end
      else
      if keys[kg] or keys[kenter] then exit:=true;
end;

procedure inicializaziya;
var i,j,D:byte;
begin
  new(inz);
  inz^.next:=inz;
  new(zzz);
  zzz^.next:=zzz;
  new(mm);
  mm^.next:=mm;
  videlenie:=false;
  exit:=false;
  prod:=false;
  setcolor(14);
  setusercursor(b[98]);
  showmouse;
  skx:=0;
  sky:=0;
  snarf:=false;
  krest:=false;
  enemrab:=0;
  for i:=51 to 60 do
  enzd[i].est:=false;
  enzd[54].x:=45;
  enzd[54].y:=45;
  insel(inz,newel(51,7,7,true),ekr,mykaz);
  mybaze:=inz^.next;
  insel(inz,newel(51,45,51,false),ekr,mykaz);
  enbaze:=inz^.next;
  enzd[51].est:=true;
  insel(inz,newel(10,6,6,true),ekr,mykaz);
  {insel(inz,newel(10,7,6));
  insel(inz,newel(10,8,6));
  insel(inz,newel(10,9,6));
  insel(inz,newel(10,10,6));}
  insel(inz,newel(2,21,15,true),ekr,mykaz);
  insel(inz,newel(3,22,16,true),ekr,mykaz);
  insel(inz,newel(5,21,18,true),ekr,mykaz);
  insel(inz,newel(6,24,14,true),ekr,mykaz);
  insel(inz,newel(7,42,17,true),ekr,mykaz);
  insel(inz,newel(54,8,12,true),ekr,mykaz);
  {insel(inz,newel(55,20,20,false),ekr,mykaz);
  insel(inz,newel(32,10,8));
  insel(inz,newel(10,6,6));
  insel(inz,newel(10,6,7));
  insel(inz,newel(10,6,8));
  insel(inz,newel(10,6,9));
  insel(inz,newel(10,6,10));
  insel(inz,newel(8,6,2));
  insel(inz,newel(9,7,2));
  insel(inz,newel(33,8,2));
  insel(inz,newel(34,9,2));
  insel(inz,newel(35,10,2));
  insel(inz,newel(32,11,2));}
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
  for i:=1 to 4 do
  sms[i].fl:=false;
  mx:=0;
  my:=0;
  min:=0;
  sec:=0;
  vremya:=0;
  mnr:=5000;
  mnrt:=5000;
  {for D:=1 to 100 do
  begin
  i:=1+random(60);
  j:=1+random(60);
  if (i<=59) and (j<=59)
  then begin
  ekr[j,i]:=150;
  ekr[j+1,i]:=255;
  ekr[j,i+1]:=255;
  ekr[j+1,i+1]:=255;
  end;
  end;}
end;

begin
  initall(m640x480);
  keyboardinit;
  inicializaziya;
  sprite;
  stran;
  strmenu;
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
  page:=0;
  repeat
    if keys[kesc] then
    repeat
    while keys[kesc] do;
    menu;
    until prod or exit;
    setvisualpage(page);
    page:=1-page;
    waitVBL;
    setactivepage(page);
    skrolling;
    for i:=my to my+9 do
      for j:=mx to mx+16 do
        begin
          putsprite((j-1)*40-skx,(i-1)*40-sky,p[0,0]);
        end;
        {w:=readkeyboard(c);}
    vidilenie;
    showobj(inz);
    minikarta;
    klavaimish;
    ii;
    snariadi;
    creatsnar;
    {movesnar;}
    deleteall;
    {vibir;}
    {if keys[kesc]
    then begin
         tz:=inz^.next;
         while tz<>inz do
           begin
             otmena(tz);
             tz:=tz^.next;
           end;
         end;}
    dobi4a;
    ctrl123;
    messages;
  until exit;
  if ya
  then repeat
  setvisualpage(15)
  until keys[kesc]
  else repeat
  setvisualpage(14);
  until keys[kesc];
keyboarddone;
doneall;
end.



