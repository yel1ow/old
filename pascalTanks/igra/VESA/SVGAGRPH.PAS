unit SVGAGRPH;

interface

var result:Shortint;

function ismouse:boolean;
function initmouse:boolean;
procedure setsteptopixel(hor,ver:integer);
procedure getsteptopixel(var hor,ver:integer);
procedure setdoblespeed(speed:word);
function getdoblespeed:word;
procedure mousewherexy(var x,y:integer);
function numbutton:byte;
procedure getmousestate(var butt,x,y:integer);
procedure hidemouse;
procedure showmouse;
procedure mousescreen;
procedure mousegraphcur(var scrcur;x,y:byte);
procedure mousebuttpressed(butt:integer;var stat,count,x,y:integer);
procedure mousebuttrelased(butt:integer;var stat,count,x,y:integer);

procedure rectangle(x1,y1,x2,y2:word;fill:boolean);
function readstring(x,y:word):string;
function readint(x,y:word):longint;
function readword(x,y:word):word;
function readreal(x,y:word):real;
procedure Clrscr;
procedure bkcolor(col:longint);
procedure putimage(x1,y1,xsz,ysz:word;bb:byte;var buff;xx,yy:boolean);
function getmaxx:word;
function getmaxy:word;
procedure Vesa;
procedure lineto(x,y:word);
procedure Circle(x,y,r:word);
procedure Done;
procedure GetMaxXY(x,y:word);
procedure Color(col:longint);
procedure TextWrite(x,y:word;txt:string);
procedure SetPixel(x,y:word;col:longint);
procedure OutLine(stx,sty,ex,ey:integer);
procedure mode(m:word);
procedure ellipse(x,y,r:word;mulx,muly:real);
procedure getPix(x,y:word;var col:longint);
procedure MoveTo(x,y:word);
procedure wherexy(x,y:word);
procedure sector(x,y,r,start,finish:word;draw:boolean);
function GetMaxColor:longint;
procedure Init(md:word);
function WhiteColor:longint;

implementation

uses supervga,crt,dos;
type
  pchar=array[0..255] of array[0..15] of byte;
var oldchip:chips;
    colour,bkcol,fill:longint;
    coox,cooy:word;
    info:modetype;
    p:^pchar;
    reg:registers;
const
     mousepresent:boolean=false;
     mousevisible:boolean=false;
     x1m:integer=0;
     y1m:integer=0;
     x2m:integer=639;
     y2m:integer=199;
     speed2:word=128;
     verrat:integer=8;
     horrat:integer=8;
     nbutton:byte=0;

{---------- Mouse Part ----------}

function ismouse:boolean;
var
   p:pointer;
   k,x,y:integer;
   is:boolean;
begin
     if nbutton=0 then
        begin
             getintvec($33,p);
             is:= p<>nil;
             if is then with reg do
                begin
                     ax:=$3;
                     bx:=$ffff;
                     intr($33,reg);
                     is:= bx<>$FFFF;
                end;
             mousepresent:=is;
        end;
     ismouse:=mousepresent;
end;

function initmouse:boolean;
begin
     with reg do
          begin
               ax:=0;
               intr($33,reg);
               mousepresent:= ax=$ffff;
               nbutton:=bx;
          end;
     hidemouse;
     mousescreen;
end;

procedure setsteptopixel(hor,ver:integer);
begin
     if ismouse then with reg do
     begin
          ax:=$0f;
          cx:= hor and $7fff;
          dx:= ver and $7fff;
          horrat:=cx;
          verrat:=dx;
          intr($33,reg);
     end;
end;

procedure Getsteptopixel(var hor,ver:integer);
begin
     if ismouse then
        begin
             hor:=horrat;
             ver:=verrat;
        end;
end;

procedure setdoblespeed(speed:word);
begin
     if ismouse then with reg do
     begin
          ax:=$13;
          dx:=speed;
          speed2:=speed;
          intr($33,reg);
     end;
end;

function getdoblespeed:word;
begin
     getdoblespeed:=speed2;
end;

procedure mousewherexy(var x,y:integer);
begin
     if ismouse then with reg do
     begin
          ax:=$3;
          intr($33,reg);
          x:=cx;
          y:=dx;
     end
     else
     begin
          x:=-1;
          y:=-1;
     end;
end;

function numbutton:byte;
begin
     numbutton:=nbutton;
end;

procedure getmousestate(var butt,x,y:integer);
begin
     if ismouse then with reg do
     begin
          ax:=$3;
          intr($33,reg);
          x:=cx;
          y:=dx;
          butt:=bx;
     end
     else
     begin
          x:=0;
          y:=0;
          butt:=0;
     end;
end;

procedure mousebuttpressed(butt:integer;var stat,count,x,y:integer);
begin
     if ismouse then with reg do
     begin
          ax:=$05;
          bx:=butt;
          intr($33,reg);
          count:=bx;
          x:=cx;
          y:=dx;
          stat:=bx;
     end;
end;

procedure mousebuttrelased(butt:integer;var stat,count,x,y:integer);
begin
     if ismouse then with reg do
     begin
          ax:=$06;
          bx:=butt;
          intr($33,reg);
          count:=bx;
          x:=cx;
          y:=dx;
          stat:=bx;
     end;
end;

procedure mousewindow(x1,y1,x2,y2:integer);
begin
     if ismouse then
     begin
          x1m:=x1;
          y1m:=y1;
          x2m:=x2;
          y2m:=y2;
          with reg do
          begin
               ax:=$7;
               cx:=x1;
               dx:=x2;
               intr($33,reg);
               ax:=$8;
               cx:=y1;
               dx:=y2;
               intr($33,reg);
          end;
     end;
end;

procedure mousescreen;
begin
     mousewindow(0,0,getmaxx,getmaxy);
end;

procedure showmouse;
begin
     if ismouse and not mousevisible then
     with reg do begin
          ax:=$1;
          intr($33,reg);
          mousevisible:=true;
     end;
end;

procedure hidemouse;
begin
     if ismouse and mousevisible then
     with reg do begin
          ax:=$2;
          intr($33,reg);
          mousevisible:=true;
     end;
end;

procedure mousegraphcur(var scrcur;x,y:byte);
begin
     if ismouse then with reg do
     begin
          ax:=$9;
          bx:=x;
          cx:=y;
          es:=seg(scrcur);
          dx:=ofs(scrcur);
          intr($33,reg);
     end;
end;

{---------- Graphic Part ----------}

procedure rectangle(x1,y1,x2,y2:word;fill:boolean);
var i,j:word;
begin
     outline(x1,y1,x1,y2);outline(x1,y1,x2,y1);outline(x2,y2,x1,y2);outline(x2,y2,x2,y1);
     if fill then for i:=x1 to x2 do outline(i,y1,i,y2);
end;

procedure PrintChar(ch:char;x,y:word);
var
  v:longint;
  i,j,z,b:integer;
begin
    for j:=0 to 15 do
    begin
      b:=p^[ord(ch)][j];
      for i:=0 to 7 do
      begin
        if (b and 128)<>0 then v:=colour else v:=bkcol;
        setpixel(x+i,y+j,v);
        b:=b shl 1;
      end;
    end;
end;

function readstr(x,y:word):string;
var len,cur:word;
    insflag:boolean;
    chr:char;
    col:longint;

const s:string='';

procedure setcur;
begin
     outline(x+(cur-1)*8,y+15,x+cur*8,y+15);
     if insflag then outline(x+(cur-1)*8,y+14,x+cur*8,y+14);
end;

procedure delcur;
begin
     col:=colour;
     colour:=bkcol;
     outline(x+(cur-1)*8,y+15,x+cur*8,y+15);
     if insflag then outline(x+(cur-1)*8,y+14,x+cur*8,y+14);
     colour:=col;
end;

procedure Cursor;
var i:integer;
begin
   while not keypressed do
    begin
     setcur;
     for i:=1 to 10 do if not keypressed then delay(10);
     delcur;
     for i:=1 to 10 do if not keypressed then delay(10);
    end;
end;

procedure prints;
var i:integer;
begin
     for i:=1 to length(s) do
         printchar(s[i],x+(i-1)*8,y);
     printchar(' ',x+length(s)*8,y)
end;


procedure Home;
begin
     cur:=1;
end;

procedure EndKey;
begin
     cur:=len;
end;

procedure left;
begin
     if cur<>1 then cur:=cur-1;
end;

procedure Right;
begin
     if cur<>(len+1) then cur:=cur+1;
end;

procedure Inse;
begin
     insflag:=not(insflag);
end;

procedure bs;
begin
     if cur<>1 then begin
                         cur:=cur-1;
                         delete(s,cur,1);
                         len:=len-1;
                    end;
end;

procedure del;
begin
     if cur<>(len+1) then begin
                               delete(s,cur,1);
                               len:=len-1;
                          end;
end;

procedure esc;
begin
     s:='';
     len:=0;
end;

procedure anychar;
begin
     if cur=(len+1) then begin
                         s:=s+chr;
                         len:=len+1;
                         cur:=cur+1;
                         end
                    else if insflag then begin
                                         insert(chr,s,cur);
                                         len:=len+1;
                                         cur:=cur+1;
                                         end
                                    else begin
                                         s[cur]:=chr;
                                         len:=len+1;
                                         cur:=cur+1;
                                         end;
end;

begin
     cur:=1;
     len:=0;
     insflag:=true;
     repeat
           cursor;
           prints;
           chr:=readkey;
           case chr of
                #8:bs;
                #27:esc;
                #0:case ord(readkey) of
                                     71:home;
                                     75:left;
                                     77:right;
                                     79:endkey;
                                     82:inse;
                                     83:del;
                                     else chr:=#0;
                   end;
                else anychar;
           end;
           if ord(chr)>31 then prints;
     until (chr=#13) or (chr=#27);
     readstr:=s;
end;

function readint(x,y:word):longint;
var r:integer;
    num:longint;
begin
     val(readstr(x,y),num,r);
     readint:=num;
end;

function readword(x,y:word):word;
var r:integer;
    num:word;
begin
     val(readstr(x,y),num,r);
     readword:=num;
end;

function readreal(x,y:word):real;
var r:integer;
    num:real;
begin
     val(readstr(x,y),num,r);
     readreal:=num;
end;

function readstring(x,y:word):string;
begin
     readstring:=readstr(x,y);
end;


procedure putimage;
var image:array[1..MaxInt] of byte absolute buff;
    i,f,x,y:word;
    adr,color:longint;
begin
     for i:=1 to xsz do
      for f:=1 to ysz do
       begin
        x:=i;y:=f;
        if xx then x:=xsz+1-i;
        if yy then y:=ysz+1-f;
        adr:=(x-1)*bb+1+y*bb*xsz;
        color:=image[adr];
        case bb of
             2:color:=color+image[adr+1]*256;
             3:begin
                   color:=color+image[adr+1]*256;
                   color:=color+image[adr+2]*65536;
               end;
        end;
        setpixel(x1+i-1,y1+f-1,color);
       end;
end;

procedure sector(x,y,r,start,finish:word;draw:boolean);
var xx,yy:integer;
    i:real;
begin
     if finish<start then start:=360-start;
     i:=start;
     repeat
          xx:=round(r*cos(i))+x;
          yy:=round(r*sin(i))+y;
          if I=start then if draw then outline (x,y,xx,yy);
          if xx>=0 then if xx<=pixels then if yy>=0 then if yy<=lins then setpixel(xx,yy,colour);
          i:=i+0.05;
     until i<finish;
     if draw then outline (x,y,xx,yy);
     moveto(xx,yy);
end;

function getmaxx:word;
begin
     getmaxx:=pixels;
end;

function getmaxy:word;
begin
     getmaxy:=lins;
end;

procedure vesa;
begin
     if chip=__vesa then chip:=oldchip else chip:=__vesa;
end;

function modeinfo(m:word):boolean;
var i:word;
begin
     for i:=1 to nomodes do
       if modetbl[i].md=m then begin
                                    pixels:=modetbl[i].xres;
                                    lins:=modetbl[i].yres;
                                    bytes:=modetbl[i].bytes;
                                    memmode:=modetbl[i].memmode;
                                    curmode:=m;
                                    exit;
                               end;
     for i:=1 to novgamodes do
             if stdmodetbl[i].md=m then begin
                                    pixels:=stdmodetbl[i].xres;
                                    lins:=stdmodetbl[i].yres;
                                    bytes:=stdmodetbl[i].bytes;
                                    memmode:=stdmodetbl[i].memmode;
                                    curmode:=m;
                                    exit;
                               end;
     vesamodeinfo(m);
end;

procedure loadmodes;              {Load extended modes for this chip}
var
  t:text;
  s,pat:string;
  md,x,xres,yres,err,mreq,byt:word;

function unhex(s:string):word;
var x:word;
begin
  for x:=1 to 4 do
    if s[x]>'9' then
      s[x]:=chr(ord(s[x]) and $5f-7);
  unhex:=(((word(ord(s[1])-48) shl 4
         +  word(ord(s[2])-48)) shl 4
         +  word(ord(s[3])-48)) shl 4
         +  word(ord(s[4])-48));
end;

function mmode(s:string):mmods;
var x:mmods;
begin
  for x:=_text to _p16m do
    if s=mmodenames[x] then mmode:=x;

end;

begin
  nomodes:=0;
  pat:='['+header[chip]+']';
  assign(t,'whatvga.lst');
  reset(t);
  s:=' ';
  while (not eof(t)) and (s<>pat) do readln(t,s);
  s:=' ';
  readln(t,s);
  while (s[1]<>'[') and (s<>'') do
  begin
    md:=unhex(copy(s,1,4));
    memmode:=mmode(copy(s,6,4));
    val(copy(s,11,5),xres,err);
    val(copy(s,17,4),yres,err);
    case memmode of
      _text,_text4:bytes:=xres*2;
 _pl2e, _herc,_cga2,_pl2:bytes:=xres shr 3;
    _pk4,_pl4,_cga4:bytes:=xres shr 4;
       _pl16,_pk16:bytes:=xres shr 1;
             _p256:bytes:=xres;
       _p32k,_p64k:bytes:=xres*2;
             _p16m:bytes:=xres*3;
    else
    end;
    case dactype of
        _dac8:if memmode>_p256 then memmode:=_text;
       _dac15:if memmode>_p32k then memmode:=_text;
       _dac16:if memmode=_p16m then memmode:=_text;
     _dacss24:if memmode=_p64k then memmode:=_text;
    end;
    val(copy(s,22,5),byt,err);
    if (err=0) and (byt>0) then bytes:=byt;
    if err<>0 then mreq:=(longint(bytes)*yres+1023) div 1024;
    case memmode of
      _pl16:bytes:=xres shr 3;
    end;
    if (memmode>_text4) and (mm>=mreq) then
    begin
      inc(nomodes);
      modetbl[nomodes].xres:=xres;
      modetbl[nomodes].yres:=yres;
      modetbl[nomodes].md:=md;
      modetbl[nomodes].bytes:=bytes;
      modetbl[nomodes].memmode:=memmode;
    end;
    readln(t,s);
  end;
  close(t);
end;

procedure color(col:longint);
begin
     colour:=col;
end;

procedure Bkcolor(col:longint);
begin
     bkcol:=col;
end;

procedure Circle(x,y,r:word);
var y1,i1:integer;
    i,max:real;
begin
     i:=0;
     max:=0.75*r;
     repeat
     y1:=trunc(sqrt(sqr(r)-sqr(i)));
     i1:=trunc(i);
     setpixel(x+i1,y1+y,colour);
     setpixel(x-i1,y1+y,colour);
     setpixel(x-i1,y-y1,colour);
     setpixel(x+i1,y-y1,colour);
     setpixel(x+y1,i1+y,colour);
     setpixel(x-y1,i1+y,colour);
     setpixel(x-y1,y-i1,colour);
     setpixel(x+y1,y-i1,colour);
     i:=i+0.25;
     until I>max;
end;

procedure ellipse;
var y1,i1:integer;
    i,max:real;
begin
     i:=0;
     max:=0.75*r;
     repeat
     y1:=trunc(sqrt(sqr(r)-sqr(i)));
     i1:=trunc(i);
     setpixel(round(x+i1*mulx),round(y+y1*muly),colour);
     setpixel(round(x-i1*mulx),round(y+y1*muly),colour);
     setpixel(round(x-i1*mulx),round(y-y1*muly),colour);
     setpixel(round(x+i1*mulx),round(y-y1*muly),colour);
     setpixel(round(x+y1*mulx),round(y+i1*muly),colour);
     setpixel(round(x-y1*mulx),round(y+i1*muly),colour);
     setpixel(round(x-y1*mulx),round(y-i1*muly),colour);
     setpixel(round(x+y1*mulx),round(y-i1*muly),colour);
     i:=i+0.25;
     until I>max;
end;

procedure Done;
begin
  rp.al:=7;
  vio(0);
end;

procedure GetMaxXY(x,y:word);
begin
     x:=pixels;
     y:=lins;
end;

procedure Init(md:word);
begin
     findvideo;
     if CHIP=__none then begin
                   Result:=-3;
                   exit;
                   end;
     oldchip:=chip;
     loadmodes;
     mode(md);
     colour:=whitecolor;
     bkcol:=0;
     rp.bh:=6;
     vio($1130);
     p:=ptr(rp.es,rp.bp);
end;

function GetMaxColor:longint;
begin
     GetMaxColor:=modecols[memmode]-1;
     case memmode of
          _text:GetMaxColor:=15;
          _text2:getmaxcolor:=1;
          _text4:getmaxcolor:=3;
     end;
end;

procedure WhereXY(x,y:word);
begin
     x:=coox;y:=cooy;
end;

procedure lineto;
begin
     outline(coox,cooy,x,y);
end;

procedure moveto;
begin
     coox:=x;
     cooy:=y;
end;

procedure mode(m:word);
begin
  modeinfo(m);
  if setmode(m) then result:=0
                else result:=-1;
end;

procedure outLine(stx,sty,ex,ey:integer);
var x,y,d,mx,my:integer;
begin
    coox:=ex;cooy:=ey;
    if sty>ey then
    begin
      x:=stx;stx:=ex;ex:=x;
      x:=sty;sty:=ey;ey:=x;
    end;
    y:=0;
    mx:=abs(ex-stx);
    my:=ey-sty;
    d:=0;
    repeat
      y:=(y+1) and 255;
      setpixel(stx,sty,colour);
      if abs(d+mx)<abs(d-my) then
      begin
        inc(sty);
        d:=d+mx;
      end
      else begin
        d:=d-my;
        if ex>stx then inc(stx)
                  else dec(stx);
           end;
    until (stx=ex) and (sty=ey);

end;

procedure ClrScr;
var i,f:word;
begin
 for i:=0 to getmaxx do
    for f:=0 to getmaxy do
       setpixel(f,i,colour);
end;

procedure TextWrite(x,y:word;txt:string);
var
  z:integer;
begin
  for z:=1 to length(txt) do if x+(z-1)*8<=getmaxx then printchar(txt[z],x+(z-1)*8,y);
end;

function WhiteColor:longint;
var col:longint;
begin
  case memmode of
    _cga2,_pl2e,
     _pl2:col:=1;
    _cga4,_pk4
    ,_pl4:col:=3;
    _pk16,_pl16,
    _p256:col:=15;
    _p32k:col:=$7fff;
    _p64k:col:=$ffff;
    _p16m:col:=$ffffff;
  else
  end;
  whitecolor:=col;
end;

function loword(a:longint):word;
begin
     loword:=a mod 65536;
end;

procedure GetPix(x,y:word;var col:longint);
var l:longint;
    m,z:word;
    b:byte;
begin
  case memmode of
   _cga2:begin
           b:=mem[$b800:((y div 2)*80+ord(odd(y))*$2000+x div 8)];
           col:=0;
           if b<>0 then col:=1;
         end;
   _p256:begin
           l:=y*bytes+x;
           setbank(l shr 16);
           col:=mem[vseg:loword(l)];
         end;
   _p32k,_p64k:
         begin
           l:=y*bytes+(x shl 1);
           setbank(l shr 16);
           col:=memw[vseg:loword(l)];
         end;
   _p16m:begin
           l:=y*bytes+(x*3);
           z:=word(l);
           m:=l shr 16;
           setbank(m);
           if z<$fffe then move(mem[vseg:z],col,3)
           else begin
             col:=mem[vseg:z];
             if z=$ffff then setbank(m+1);
             col:=col+mem[vseg:z+1] shr 8;
             if z=$fffe then setbank(m+1);
             col:=col+mem[vseg:z+2] shr 16;
           end;
         end;
    else ;
  end;
end;


procedure SetPixel(x,y:word;col:longint);
const
  msk:array[0..7] of byte=(128,64,32,16,8,4,2,1);
  plane :array[0..1] of byte=(5,10);
  plane4:array[0..3] of byte=(1,2,4,8);
  mscga4:array[0..3] of byte=($3f,$cf,$f3,$fc);
  shcga4:array[0..3] of byte=(6,4,2,0);
var l:longint;
    m,z:word;
begin
  case memmode of
   _cga2:begin
           z:=(y shr 1)*bytes+(x shr 3);
           if odd(y) then inc(z,8192);
           mem[$b800:z]:=(mem[$b800:z] and (255 xor msk[x and 7]))
                         or ((col and 1) shl (7-(x and 7)));
         end;
   _cga4:begin
           z:=(y shr 1)*bytes+(x shr 2);
           if odd(y) then inc(z,8192);
           mem[$b800:z]:=(mem[$b800:z] and mscga4[x and 3])
                         or (col and 3) shl shcga4[x and 3];
         end;
    _pl2:begin
           l:=y*bytes+(x shr 3);
           wrinx($3ce,3,0);
           wrinx($3ce,5,2);
           wrinx($3c4,2,1);
           wrinx($3ce,8,msk[x and 7]);
           setbank(l shr 16);
           z:=mem[vseg:word(l)];
           mem[vseg:word(l)]:=col;
         end;
   _pl2e:begin
           l:=y*128+(x shr 3);
           modinx($3ce,5,3,0);
           wrinx($3c4,2,15);
           wrinx($3ce,0,col*3);
           wrinx($3ce,1,3);
           wrinx($3ce,8,msk[x and 7]);
           z:=mem[vseg:word(l)];
           mem[vseg:word(l)]:=0;
         end;
    _pl4:begin
           l:=y*bytes+(x shr 4);
           wrinx($3ce,3,0);
           wrinx($3ce,5,2);
           wrinx($3c4,2,plane[(x shr 3) and 1]);
           wrinx($3ce,8,msk[x and 7]);
           setbank(l shr 16);
           z:=mem[vseg:word(l)];
           mem[vseg:word(l)]:=col;
         end;
    _pk4:begin
           l:=y*bytes+(x shr 2);
           setbank(l shr 16);
           z:=mem[vseg:word(l)] and mscga4[x and 3];
           mem[vseg:word(l)]:=z or (col shl shcga4[x and 3]);
         end;
   _pl16:begin
           l:=y*bytes+(x shr 3);
           wrinx($3ce,3,0);
           wrinx($3ce,5,2);
           wrinx($3ce,8,msk[x and 7]);
           setbank(l shr 16);
           z:=mem[vseg:word(l)];
           mem[vseg:word(l)]:=col;
         end;
   _pk16:begin
           l:=y*bytes+(x shr 1);
           setbank(l shr 16);
           z:=mem[vseg:word(l)];
           if odd(x) then z:=z and $f+(col shl 4)
                     else z:=z and $f0+col;
           mem[vseg:word(l)]:=z;
         end;
   _p256:begin
           l:=y*bytes+x;
           setbank(l shr 16);
           mem[vseg:word(l)]:=col;
         end;
   _p32k,_p64k:
         begin
           l:=y*bytes+(x shl 1);
           setbank(l shr 16);
           memw[vseg:word(l)]:=col;
         end;
   _p16m:begin
           l:=y*bytes+(x*3);
           z:=word(l);
           m:=l shr 16;
           setbank(m);
           if z<$fffe then move(col,mem[vseg:z],3)
           else begin
             mem[vseg:z]:=lo(col);
             if z=$ffff then setbank(m+1);
             mem[vseg:z+1]:=lo(col shr 8);
             if z=$fffe then setbank(m+1);
             mem[vseg:z+2]:=col shr 16;
           end;
         end;
    else ;
  end;
end;
end.