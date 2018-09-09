uses crt,graph;
var i,r1, gd,gm,x,r,y,xm,ym,xm1,ym1:integer;
        a,s,a1,s1:real;
        f:file;
        p,p1,p2,p3:pointer;
        size:word;
begin
initgraph(gd,gm,'');
  assign(f,'earth.spr');
  reset(f,1);
  blockread(f,x,2);
  blockread(f,y,2);
  blockread(f,size,2);
  getmem(p,size);
  blockread(f,p^,size);
  close(f);
   assign(f,'pol.spr');
  reset(f,1);
  blockread(f,x,2);
  blockread(f,y,2);
  blockread(f,size,2);
  getmem(p1,size);
  blockread(f,p1^,size);
  close(f);
   assign(f,'moon.spr');
  reset(f,1);
  blockread(f,x,2);
  blockread(f,y,2);
  blockread(f,size,2);
  getmem(p2,size);
  blockread(f,p2^,size);
  close(f);

  x:=270;y:=190;
  putimage(x,y,p^,normalput);
   r:=150;
  a:=0;
  s:=2*PI/{19}80;
  r1:=80;
  a1:=0;
  s1:=-2*PI/{19}80;
  repeat
  xm1:=round(270+r1*cos(a1));
  ym1:=round(190+r1*sin(a1));
  xm1:=xm;
  ym1:=ym;
  xm:=round(270+r*cos(a));
  ym:=round(190+r*sin(a));
  a:=a+s;
  if -a>2*PI
  then  a:=0;
  a1:=a1+s1;
  if -a1>2*PI
  then a1:=0;
  putimage(xm1,ym1,p2^,normalput);
   delay(10);
  putimage(xm1,ym1,p2^,xorput);
 
  putimage(xm,ym,p1^,normalput);
  delay(100);
  putimage(xm,ym,p1^,xorput);

  until keypressed;
closegraph;
end.