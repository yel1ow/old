{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
program Ffrgthj;
uses vesa,crt{,objects},keyboard;
Const nothing = 0;
      no = 0;
      mouse = 1;
      all = 10;
      l = 11;
      r = 17;
      t = 12;
      b = 18;
      lt = 13;
      rt = 14;
      rb = 15;
      lb = 16;
type
  ref = ^okno;
  reg = ^elem;

  pDesktop = ^Desktop;
  Event = record
            chto:byte;
            x,y,button:integer;
          end;
  okno = object
           next:ref;
           elem:reg;
           x,y,kx,ky,sizex,sizey:integer;
           func:byte;
           col1,col2:byte;
           moving:integer;
           Procedure Draw;
           Procedure CheckEvent(var e:Event);
         end;
  Elem = object
         end;
  Desktop = object
              okna:ref;
              Quit:boolean;
              Procedure Insert(p:ref);
              Procedure Delete(p:ref);
              Procedure Vnachalo(p:ref);
              Procedure GetEvent(var e:Event);
              Procedure CheckEvent(var e:Event);
              Procedure Run;

            end;

var tz,fz:ref;
    page:byte;
    Desk:pDeskTop;
    gd,gm,dx,dy:integer;
    MemBegin,MemEnd:longint;
    Press:boolean;

Procedure okno.Draw;
var tz:ref;
begin
  tz := @self;
  if tz <> Desk^.okna
  then begin
         tz^.next^.Draw;
         if Desk^.okna^.next = tz then
         setcolor(14)
         else setcolor(4);
         bar(tz^.x,tz^.y,tz^.kx,tz^.ky)
       end;
end;

Procedure okno.CheckEvent(var e:Event);
var tz:ref;
begin
  tz:=@self;
  if e.button = 1
  then begin
         if tz^.moving<>no
         then begin
                case tz^.moving of
                all:begin
                      tz^.x := e.x - dx;
                      tz^.y := e.y - dy;
                      tz^.kx := tz^.x + tz^.sizex;
                      tz^.ky := tz^.y + tz^.sizey;
                    end;
                l:tz^.x := e.x;
                r:tz^.kx := e.x;
                t:tz^.y := e.y;
                b:tz^.ky := e.y;
                lt:begin
                     tz^.x := e.x;
                     tz^.y := e.y;
                   end;
                rt:begin
                     tz^.kx := e.x;
                     tz^.y := e.y;
                   end;
                rb:begin
                     tz^.kx := e.x;
                     tz^.ky := e.y;
                   end;
                lb:begin
                     tz^.x := e.x;
                     tz^.ky := e.y;
                   end;
                end;
                sizex := tz^.kx - tz^.x;
                sizey := tz^.ky - tz^.y;
              end
         else begin
                if (e.x>tz^.x) and (e.x<tz^.x+10) and (e.y>tz^.y) and (e.y<tz^.y+10)
                {lt}
                then begin
                       tz^.moving := lt;
                     end else
                if (e.x>tz^.kx-10) and (e.x<tz^.kx) and (e.y>tz^.y) and (e.y<tz^.y+10)
                {rt}
                then begin
                       tz^.moving := rt;
                     end else
                if (e.x>tz^.kx-10) and (e.x<tz^.kx) and (e.y>tz^.ky-10) and (e.y<tz^.ky)
                {rb}
                then begin
                       tz^.moving := rb;
                     end else
                if (e.x>tz^.x) and (e.x<tz^.x+10) and (e.y>tz^.ky-10) and (e.y<tz^.ky)
                {lb}
                then begin
                       tz^.moving := lb;
                     end else
                if (e.x>tz^.x) and (e.x<tz^.x+10) and (e.y>tz^.y) and (e.y<tz^.ky)
                {l}
                then begin
                     tz^.moving := l;
                     end else
                if (e.x>tz^.x) and (e.x<tz^.kx) and (e.y>tz^.ky-10) and (e.y<tz^.ky)
                {b}
                then begin
                       tz^.moving := b;
                     end else
                if (e.x>tz^.kx-10) and (e.x<tz^.kx) and (e.y>tz^.y) and (e.y<tz^.ky)
                {r}
                then begin
                     tz^.moving := r;
                     end else
                if (e.x>tz^.x) and (e.x<tz^.kx) and (e.y>tz^.y) and (e.y<tz^.y+5)
                {t}
                then begin
                       tz^.moving := t;
                     end else
                if (e.x>tz^.x) and (e.x<tz^.kx) and (e.y>tz^.y) and (e.y<tz^.y+15)
                {all sdvig}
                then begin
                       dx := e.x - tz^.x;
                       dy := e.y - tz^.y;
                       tz^.moving := all;
                     end;
              end;
       end;
  if e.button = 2
  then begin


       end;
end;

Procedure Desktop.Insert(p:ref);
begin
  p^.sizex := p^.kx - p^.x;
  p^.sizey := p^.ky - p^.y;
  p^.next := Okna^.next;
  Okna^.next := p;
end;

Procedure Desktop.Delete(p:ref);
var tz:ref;
begin
  tz := okna;
  while (tz^.next <> p) and (tz^.next <> okna) do
  tz:=tz^.next;
  if tz^.next <> okna
  then begin
         tz^.next := p^.next;
         {Dispose(p);}
         p:=nil;
       end;

end;

Procedure Desktop.Vnachalo(p:ref);
var tz:ref;
begin
  tz := okna;
  while tz^.next <> p do
  tz := tz^.next;
  tz^.next := p^.next;
  p^.next := okna^.next;
  okna^.next := p;
end;

Procedure Desktop.GetEvent(var e:Event);
begin
  e.Chto := Nothing;
  if MouseButton<>0
  then begin
         e.Chto := mouse;
         e.Button := MouseButton;
         e.x := MouseX;
         e.y := MouseY;
       end;
end;

Procedure Desktop.CheckEvent(var e:Event);
var tz:ref;
Procedure ClearMoving;
var tz,fz:ref;
begin
  tz := okna^.next;
  while tz <> okna do
  begin
    tz^.moving:=no;
    tz:=tz^.next;
  end;
end;
begin
  if e.Chto = Nothing
  then begin
         ClearMoving;
         exit;
       end;
  if okna^.next^.moving <> no
  then begin
         okna^.next^.CheckEvent(e);
         exit;
       end;
  tz := okna^.next;
  while tz<>okna do
  begin
    if (e.x>tz^.x) and (e.x<tz^.kx) and (e.y>tz^.y) and (e.y<tz^.ky)
    then begin
           if okna^.next <> tz
           then Vnachalo(tz)
           else begin
                  tz^.CheckEvent(e);
                end;
           e.Chto := Nothing;
           break;
         end;
    tz:=tz^.next;
  end;
  if e.Chto <> Nothing
  then begin
         if e.Chto = 1
         then P
         {vyzov menu}
       end;
end;

Procedure Desktop.Run;
var e:Event;
begin
  Repeat
    Setvisualpage(page);
    page:=1-page;
    waitvbl;
    setactivepage(page);
    GetEvent(e);
    CheckEvent(e);
    setcolor(1);
    Bar(0,0,640,480);
    Okna^.next^.Draw;
    if keys[kesc]
    then Quit := true;
  until Quit;
end;


begin
  MemBegin:=MemAvail;
  InitAll(m640x480);
  KeyBoardinit;
  ShowMouse;
  new(Desk); Desk^.Quit := false;
  new(Desk^.okna);Desk^.okna^.next:=Desk^.okna;
  new(tz);
  tz^.x:=100;
  tz^.kx:=200;
  tz^.y:=100;
  tz^.ky:=200;
  Desk^.insert(tz);
  new(tz);
  tz^.x:=300;
  tz^.kx:=500;
  tz^.y:=300;
  tz^.ky:=500;
  Desk^.insert(tz);
  setcolor(14);
  page := 0;
  Press := false;
  Desk^.Run;
  Dispose(desk);

  DoneAll;
  KeyBoarddone;
  MemEnd:=MemAvail;
  writeln('В начале:',MemBegin,' в конце:', MemEnd)
end.