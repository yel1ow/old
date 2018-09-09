uses svgagrph;
var i:longint;
    j,f:string;
begin
     init(19);
     vesa;
     mode($105);
     for i:=0 to 255 do
         setpixel(i,400,i);
     color(whitecolor);
     j:=readstring(100,100);
     outline(0,0,50,50);
     sector(500,500,50,20,60,true);
     ellipse(600,600,50,1,1.5);
     Textwrite(60,60,'Hallow world');
     getpix(136,400,i);str(i,j);textwrite(500,500,'At 136,400 point has color '+j+' ');
     setpixel(200,100,15);
     setpixel(200,101,15);
     readln;
     done;
     write(result);
     readln;
end.
