program rt;
uses graph,crt;
type koord=array[1..10] of integer;
     ugol=array[1..10] of real;
var a1,b,c1,d1,gd,gm,i,x1,y1,c,o,p:integer;
    x,y,k,cx,cy,z:koord;
    a,r,s:ugol;
begin
      gd:=vga;
      gm:=vgahi;
      initgraph(gd,gm,'');
     for i:=1 to 1000 do
 begin
  x1:= random(640);
  y1:=random(480);
  c:=random(15)+1;
   putpixel(x1,y1,15);

 end;
          r[1]:=160;
      a[1]:=0;
      s[1]:=-2*PI/180;
      k[1]:=5;
      r[2]:=30;  a[2]:=0;   s[2]:=-2*PI/40;    k[2]:=1;
      r[3]:=140;  a[3]:=0;   s[3]:=2*PI/132;    k[3]:=2;
       r[4]:=190;  a[4]:=0;   s[4]:=-2*PI/160;    k[4]:=3;
      r[5]:=100;  a[5]:=0;   s[5]:=2*PI/270;    k[5]:=4;
       r[6]:=130;  a[6]:=0;   s[6]:=2*PI/70;    k[6]:=4;
        r[7]:=100;  a[7]:=0;   s[7]:=2*PI/70;    k[7]:=4;
       r[8]:=120;  a[8]:=0;   s[8]:=2*PI/70;    k[8]:=4;
        r[9]:=180;  a[9]:=0;   s[9]:=2*PI/70;    k[9]:=4;
       r[10]:=190;  a[10]:=0;   s[10]:=2*PI/70;    k[10]:=4;


      cx[1]:=320; cy[1]:=240;
            cx[2]:=320; cy[2]:=240;
          cx[3]:=320; cy[3]:=240;
            cx[4]:=320; cy[4]:=240;
             cx[5]:=320; cy[5]:=240;
        z[1]:=7;  z[2]:=4; z[3]:=9; z[4]:=16; z[5]:=7;
           cx[6]:=320; cy[6]:=240;
                cx[7]:=320; cy[7]:=240;
                cx[8]:=320; cy[8]:=240;
                cx[9]:=320; cy[9]:=240;
                cx[10]:=320; cy[10]:=240;
                z[6]:=7;  z[7]:=4; z[8]:=9; z[9]:=16; z[10]:=7;



  setcolor(0);
      repeat
       for o:=1 to 10 do
         begin
           x[o]:=round(cx[o]+r[o]*cos(a[o]));
           y[o]:=round(cy[o]+r[o]*sin(a[o]));
           cx[2]:=x[4];
           cy[2]:=y[4] ;
             cx[8]:=x[3];
           cy[8]:=y[3] ;
            cx[6]:=x[5];
           cy[6]:=y[5] ;
           cx[7]:=x[2];
           cy[7]:=y[2] ;
             cx[9]:=x[1];
           cy[9]:=y[1] ;
           setfillstyle(1,k[o]);
           fillellipse(x[o],y[o],z[o],z[o]);


         end;

       for o:=1 to 10 do
         begin
           setcolor(0);
           setfillstyle(1,0);
           fillellipse(round(x[o]),round(y[o]),z[o],z[o]);
         end;


   for  o:=1 to 10 do
     begin
      a[o]:=a[o]+s[o];
      if a[o]>2*PI
      then a[o]:=0;
  end;

       for i:=1 to 20 do
 begin
  x1:= random(640);
  y1:=random(480);
  c:=random(15)+1;
   putpixel(x1,y1,15);

 end;
   setcolor(0);
      setfillstyle(1,14);
      fillellipse(320,240,30,30);
             setcolor(1);
      settextstyle(1,0,3);
      outtextxy(266,225,'Солнце');
      until keypressed;
end.