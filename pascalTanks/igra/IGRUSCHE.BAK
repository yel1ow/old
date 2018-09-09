program starcraft;
uses vesa,keyboard;
const n=12;m=16;
type pic=array[1..100] of pointer;
     tekr=array [1..n,1..m] of byte;
     pObject=^tObject;
     tpoint=record
                  case target:boolean of
                  true:(tp:pObject);
                  false:(tx,ty:integer);
            end;
     tObject=record
               next:pObject;

               tip:byte;
               x,y:integer;
               oldx,oldy:array[0..1] of integer;
               hp:integer;
               dx,dy:integer;
               vect:integer;
               offs:integer;
               action:word;
               delm,dels:byte;
               sost:byte;
               attackobj:pobject;

               maintarget:tpoint;
            end;
var p:pic;
    ekr:tekr;
    i,j,w:integer;
    c:char;
    page:byte;
    inz:pobject;

procedure load(var ekr:tekr);
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
     if c='2' then ekr[i,j]:=2;
     end;
     readln(f);
     end
end;

procedure sprite;
begin
p[1]:=loadspr('textura.spr');
p[2]:=loadspr('tank1lev.spr');
end;

function newel(typ:byte;x,y:integer):pobject;
var tz:pobject;
begin
new(tz);
tz^.tip:=typ;
tz^.x:=x;
tz^.y:=y;
newel:=tz;
end;

procedure insel(inz,tz:pobject);
begin
     tz^.next:=inz;
     inz^.next:=tz;
end;

procedure showobj(inz:pobject);
var tz:pobject;
begin
     tz:=inz^.next;
     while tz<>inz do
     begin
     tz^.oldx[page]:=(tz^.x-1)*40;
     tz^.oldy[page]:=(tz^.y-1)*40;
     putsprite(tz^.oldx[page],tz^.oldy[page],p[2]);
     tz:=tz^.next;
     end;
end;

begin
  initall(m640x480);
  keyboardinit;
  load(ekr);
  sprite;
  new(inz);
  showmouse;
  for page:=0 to 1 do
    begin
      setvisualpage(1-page);
      setactivepage(page);
      for i:=1 to n do
      for j:=1 to m do
      begin
        putsprite((j-1)*40,(i-1)*40,p[1]);
        {if ekr[i,j]=2 then putsprite((j-1)*40,(i-1)*40,p[2]);}
      end;
    end;
  page:=0;
  repeat
    setvisualpage(page);
    page:=1-page;
    waitVBL;
    setactivepage(page);

    w:=readkeyboard(c);
    insel(inz,newel(2,4,5));
    showobj(inz);

  until w=kesc;
keyboarddone;
end.



