{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
program PUUUUDGE;
uses vesa,keyboard,crt;
type koordinati=record
                  x,y:integer
                end;
     mas=array[1..10000] of koordinati;
var x,y,wx,wy,dwx,dwy,lvl,size1,size2,t,ty,time,tmax,delt,n:longint;
    exite,prod,pr,ya,temn,prost,stoi:boolean;
    page:byte;
    m:mas;
    p:array[1..10] of pointer;
procedure sprite;
begin
  p[1]:=loadspr('textura.spr');
end;

function mousein(x,y,xx,yy:integer):boolean;
begin
  mousein:=(mousex>x)and(mousex<xx)and(mousey>y)and(mousey<yy)
end;

procedure krest(x,y:integer);
begin
  setcolor(2);
  line(x-5,y,x+5,y);
  line(x,y-5,x,y+5);
end;

procedure start;
begin
  setvisualpage(5);
  setactivepage(5);
  rectangle(540,205,560,225,2,2);
  rectangle(540,135,560,155,2,2);
  rectangle(540,65,560,85,2,2);
  rectangle(540,345,560,365,2,2);
  if stoi then krest(550,75);
  if prost then begin
                  setcolor(2);
                  krest(550,145);
                  setcolor(14);
                  bar(541,206,559,224);
                end
  else begin
         setcolor(2);
         krest(550,215);
         setcolor(14);
         bar(541,136,559,154);
       end;
  if temn then krest(550,355);

  if mousein(50,50,590,100) and (mousebutton=1)
  then stoi:=true;
  if mousein(50,120,590,170) and (mousebutton=1)
  then prost:=true;
  if mousein(50,190,590,240) and (mousebutton=1)
  then prost:=false;
  if mousein(50,260,590,310) and (mousebutton=1)
  then begin
         pr:=true;exite:=true;
       end;
  if mousein(50,330,590,380) and (mousebutton=1)
  then temn:=true;
  if keys[kenter] or mousein(50,400,590,450) and (mousebutton=1)
  then pr:=true;
end;

procedure strmenu;
begin
  setactivepage(5);
  setcolor(215);
  bar(0,0,640,480);
  setcolor(14);
  bar(50,50,590,100);
  bar(50,120,590,170);
  bar(50,190,590,240);
  bar(50,260,590,310);
  bar(50,330,590,380);
  bar(50,400,590,450);
  setcolor(12);
  outtextxy(200,70,'Хук в стоячего(Для Никиты азаззаа)');
  outtextxy(309,140,'Легко');
  outtextxy(304,210,'Сложно');
  outtextxy(270,280,'Ливнуть(Для Дюхи)');
  outtextxy(245,350,'Хук в темноту(Для Миши)');
  outtextxy(290,420,'Продолжить');

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

procedure outtext;
var s:string;
begin
  setcolor(2);
  str(lvl,s);
  outtextxy(560,20,'lvl:');
  outtextxy(600,20,s);
  str(time div 23,s);
  outtextxy(560,35,'Time:');
  outtextxy(615,35,s);
end;

procedure inicializaziya;
begin
  randomize;
  pr:=false;
  prost:=true;
  n:=0;
  size1:=3;
  size2:=3;
  lvl:=1;
  t:=0;
  ty:=0;
  exite:=false;
  prod:=false;
  ya:=false;
  showmouse;
  x:=100;
  y:=60;
  wx:=500;
  wy:=200;
  tmax:=12;
  delt:=3;
  time:=23*(tmax+lvl*delt);
end;

procedure hook(x,y,size:integer);
begin
  setcolor(215);
  bar(x-31*size,y-1*size,x-11*size,y+1*size);
  line(x-11*size,y+1*size,x-5*size,y+15*size);
  line(x-5*size,y+15*size,x+5*size,y+15*size);
  line(x+5*size,y+15*size,x+12*size,y+7*size);
  line(x+12*size,y+7*size,x+12*size,y-5*size);
  line(x+12*size,y-5*size,x+2*size,y-15*size);
end;

procedure wisp(x,y,size:integer);
begin
  setcolor(105);
  circle(x,y,15*size);
end;

procedure risekr;
var i,j,c:integer;
begin
  for i:=1 to 12 do
  for j:=1 to 16 do
  putsprite((j-1)*40,(i-1)*40,p[1]);
  setcolor(115);
  for j:=1 to n do
  circle(m[j].x-31*size1,m[j].y,10);
end;

procedure movehook;
var rx,ry,dx,dy:integer;
    g:real;
begin
  size1:=lvl mod 3+1;
  rx:=abs(mousex-x);
  ry:=abs(mousey-y);
  if rx<>0 then
  g:=ry/rx
  else g:=1;
  if mousex>x then
  dx:=round(0.6*(10-lvl))
  else dx:=-round(0.6*(10-lvl));
  if mousey>y then
  dy:=round(g)
  else dy:=-round(g);
  if abs(dy)>abs(dx)
  then if mousey>y then dy:=abs(dx) else dy:=-abs(dx);
  if abs(x-mousex)<5 then dx:=0;
  if y=mousey then dy:=0;
  x:=x+dx;
  y:=y+dy;
  hook(x,y,size1);
end;

procedure movewisp;
begin
  size2:=(10-lvl) div 3+1;
  if ty=0
  then begin
         if temn then ty:=random((12-lvl)*20)+50
         else ty:=random((11-lvl)*15)+10;
         dwy:=-1+random(3);
       end
  else dec(ty);
  if t=0
  then begin
         t:=random((10-lvl)*20)+10;
         dwx:=-1+random(3);
         if lvl=10 then
         if wx>200 then
         dwx:=-1+random(2);
         if temn and (lvl<>10)
         then if wx<330 then dwx:=1;
       end
  else dec(t);
  if wx<30
  then dwx:=1;
  if wx>610
  then dwx:=-1;
  if wy<30
  then dwy:=1;
  if wy>450
  then dwy:=-1;
  if not stoi
  then begin
         wx:=wx+round(dwx*(lvl*0.5));
         wy:=wy+round(dwy*(lvl*0.5));
       end;
  wisp(wx,wy,size2);
end;

function sr(x,y:integer):integer;
begin
  sr:=round((x+y)/2);
end;

procedure sdvig;
var i,g,j:integer;
begin
  setvisualpage(page);
  setactivepage(page);
  for i:=n downto 1 do
  begin
    for g:=1 to 12 do
    for j:=1 to 16 do
    putsprite((j-1)*40,(g-1)*40,p[1]);
    setcolor(115);
    for j:=1 to n do
    circle(m[j].x-31*size1,m[j].y,10);
    hook(m[i].x,m[i].y,size1);
    wisp(m[i].x+10,m[i].y+10,size2);
    delay(1000);
    setcolor(255);
    bar(0,0,640,480);
  end;
  n:=0;
end;

procedure gg;
var c:integer;
begin
  if not prost and (lvl<>10) then
  if sqrt(sqr(x-wx)+sqr(y-wy))<10*size2+7*size1+10
  then begin
         if wx>x then dwx:=1
         else dwx:=-1;
       end;
  if sqrt(sqr(x-wx)+sqr(y-wy))<10*size2+7*size1
  then begin
         sdvig;
         inc(lvl);
         x:=100;
         y:=60;
         wx:=500;
         wy:=200;
         time:=23*(tmax+lvl*delt);
       end;
  if lvl>10
  then begin
         exite:=true;
         ya:=true;
       end;
  dec(time);
  if time mod lvl=0
  then begin
         inc(n);
         m[n].x:=x;
         m[n].y:=y;
       end;
  if time=0
  then begin
         exite:=true;
         ya:=false;
       end;
end;

begin
  initall(m640x480);
  keyboardinit;
  inicializaziya;
  sprite;
  strmenu;
  page:=0;
  repeat
    if not pr then start
    else begin
    if keys[kesc] then
    repeat
    while keys[kesc] do;
    menu;
    until prod or exite;
    setvisualpage(page);
    page:=1-page;
    waitVBL;
    setactivepage(page);
    risekr;
    movehook;
    movewisp;
    gg;
    if temn
    then begin
           setcolor(7);
           bar(320,0,640,480);
         end;
    end;
    outtext;
  until exite;
  Repeat
  if ya
  then setvisualpage(15)
  else setvisualpage(14);
  until keys[kesc];
  keyboarddone;
  doneall;
end.