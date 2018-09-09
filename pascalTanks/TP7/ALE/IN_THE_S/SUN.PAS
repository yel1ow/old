program rt;
uses graph,crt;
type koord=array[1..15] of integer;
     ugol=array[1..15] of real;
var gd,gm,i,x1,y1,q,w,z,c,o,p:integer;
    x,y,k,v,cc1,b,cc2,cx,cy:koord;
    a,r,s:ugol;
begin
      gd:=vga;
      gm:=vgahi;
      initgraph(gd,gm,'d:\tools\tp_7');
      for i:=1 to 1000 do
 begin
  x1:= random(640);
  y1:=random(480);
  c:=random(15)+1;
   putpixel(x1,y1,c);

 end;
          r[1]:=20;
      a[1]:=0;      a[8]:=0;    s[8]:=2*pi/80;
      s[1]:=2*PI/30;     k[8]:=10; r[8]:=100; v[8]:=20;
      k[1]:=5;
      r[2]:=35;  a[2]:=30;   s[2]:=2*PI/60;    k[2]:=10;
      r[3]:=80;  a[3]:=0;   s[3]:=2*PI/80;    k[3]:=12;
       r[4]:=60;  a[4]:=0;   s[4]:=2*PI/20;    k[4]:=3;
      r[5]:=30;  a[5]:=0;   s[5]:=2*PI/10;    k[5]:=4;
      v[1]:=10;   v[2]:=12;   v[3]:=7;          v[4]:=14; v[5]:=18;
      cx[1]:=200;cy[1]:=160; cx[2]:=200;cy[2]:=160;cx[5]:=360;cy[5]:=200;
       cx[4]:=360;cy[4]:=200;cx[3]:=200;cy[3]:=160;
       b[1]:=4; b[2]:=5; b[3]:=7; b[4]:=8;  b[5]:=6;
      r[6]:=160;  a[6]:=30;   s[6]:=2*PI/100;    k[6]:=14;
      r[7]:=90;  a[7]:=30;   s[7]:=2*PI/60;    k[7]:=13;
      cx[6]:=360;cy[6]:=200; cx[7]:=360;cy[7]:=200;   cx[8]:=360;cy[8]:=200;
      b[6]:=8;b[7]:=7;b[8]:=20;

   for i:=4 to 8 do
      begin
        cc1[i]:=360; cc2[i]:=200;
      end;
           w:=49;
           q:=50;
            z:=1;
  setcolor(0);
      repeat

                  setcolor(Z);
      settextstyle(7,0,7);
      outtextxy(q+2,300,'ëéãçñÖ');
        setcolor(1);
        z:=z+1;
        delay(100);
        setcolor(0);
        settextstyle(7,0,7);
      outtextxy(q,300,'ëéãçñÖ');
       q:=q+1;
       delay(1);
          {   setcolor(1);
      settextstyle(3,0,1);
      outtextxy(q+1,200,'ëéãçñÖ');}


        for i:=1to 8do
        begin
          x[i]:=round(r[i]*cos(a[i])+cx[i]);
          y[i]:=round(r[i]*sin(a[i])+cy[i]);
          cx[1]:=x[3];
          cy[1]:=y[3];
          cx[5]:=x[6];
          cy[5]:=y[6];
          cx[3]:=x[8];
          cy[3]:=y[8];
          cx[2]:=x[8];
          cy[2]:=y[8];

           setfillstyle(1,k[i]);
           fillellipse(x[i],y[i],b[i],b[i]);
           setcolor(3);
         end;
           for i:=1 to 3 do
      begin
        cc1[i]:=x[8]; cc2[i]:=y[8];
      end;
       delay(150);
       for o:=1 to 8 do

         begin
           setcolor(0);
           setfillstyle(1,0);
           fillellipse(round(x[o]),round(y[o]),b[o],b[o]);
         end;

             setcolor(0);
           setfillstyle(1,0);
           fillellipse(round(x[8]),round(y[8]),b[8],b[8]);


   for  o:=1 to 8 do
     begin
      a[o]:=a[o]-s[o];
      if a[o]>2*PI
      then a[o]:=0;
  end;


        for i:=1 to 20 do
 begin
  x1:= random(640);
  y1:=random(480);
  c:=random(15)+1;
   putpixel(x1,y1,c);

 end;
   setcolor(0);
       setfillstyle(1,0);
      fillellipse(x[8],y[8],b[8],b[8]);
       setfillstyle(1,14);
      fillellipse(360,200,40,40);

{      fillellipse(sat)}
      setcolor(5);
      settextstyle(7,0,3);
      outtextxy(412,235,'åÄêë');

      until keypressed;


      readln;
end.