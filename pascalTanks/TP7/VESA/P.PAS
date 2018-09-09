uses vesa256,crt;
var i,j:integer;
begin
 if not startvesa256(vesa640x480,0)
 then begin
       write('Не могу инициализировать графику');
       halt
      end;
 if not mousedriverinstalled
 then begin
       write('Не могу инициализировать мышь');
       halt
      end;
{ for i:=0 to 479 do
 for j:=0 to 639 do
  putpixel(j,i,lo(j));}
 setmousexy(200,200);
 showmouse;
 setmousebox(0,0,640,480);
 readkey;
 loadmousestate;
 repeat
 setmousexy(0,0);
 until keypressed or isleftmousebuttondown;
 finishvesa256
end.