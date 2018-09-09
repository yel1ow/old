unit option;
interface
uses polsk;
const MaxSprite=8;
type tpic=array [1..8] of pointer;
     tpole=array [1..10,1..10] of byte;

     tbeg=^node;
     node=record
            next,prev:tbeg;
            strok:string[33];
          end;

     pLoad=^tLoad;
     tLoad=record
             name:str_15;
             next,prev:pLoad;
           end;

var f_exit:boolean;
    f_save:boolean;
    refresh:boolean;
    sLoad,NowLoad,NachLoad:pLoad;
    n_save:string[8];
    pic:tpic;
    Xchud,Ychud:integer;
    pole:tpole;
    beg:tbeg;

procedure exit_prog;
procedure save_prog;
function MouseIn(x1,y1,x2,y2:integer):boolean;
procedure _refresh_;
procedure DrawButtonWithIkons;
procedure PutXYPole;
procedure WriteObjectsPole;
procedure WriteFileProg(name:string);
procedure WriteFilePole(name:string);
procedure LoadAllSprite;

implementation

uses vesa,objects,crt;

const xp=10;
      yp=10;

var save_pic:pointer;
    ix,iy:integer;

procedure LoadAllSprite;
var i:integer;
    f:file;
begin
  assign(f,'robot.dat');
  reset(f,1);
  for i:=1 to MaxSprite do
    pic[i]:=loadspr1(f);
  close(f);
end;

procedure draw_win;
begin
{  GetImage(200,170,470,310,save_pic);}
  drawwindow(180,170,490,310);
  rectangle(190,180,480,300,15,0);
  drawwindow(210,250,310,290);
  rectangle(220,260,300,280,15,0);
  drawwindow(360,250,460,290);
  rectangle(370,260,450,280,15,0);
end;

procedure WriteFileProg(name:string);
var
  tz:tbeg;
  f:text;
begin
  assign(f,name);
  rewrite(f);
  tz:=beg^.next;
  while tz<>nil do
    begin
      writeln(f,tz^.strok);
      tz:=tz^.next;
    end;
  close(f);
end;

procedure WriteFilePole(name:string);
var f:file of byte;
    i,j:integer;
begin
  assign(f,name);
  rewrite(f);
  for i:=1 to 10 do
    for j:=1 to 10 do
      write(f,pole[i,j]);
end;

function analiz_mouse_keyboard(f_put:byte):boolean;
var f:boolean;
    c:char;
begin
  f:=false;
  case f_put of
  0:rectangle(220,260,300,280,14,0);
  1:rectangle(370,260,450,280,14,0);
  end;
  repeat
    if MouseButton=LeftButton
    then begin
           if MouseIn(220,260,300,280)
           then begin
                  hidemouse;
                  rectangle(370,260,450,280,15,0);
                  rectangle(220,260,300,280,0,14);
                  showmouse;
                  repeat
                  until MouseButton<>LeftButton;
                  f:=true;
                end
           else begin
                  if MouseIn(370,260,450,280)
                  then begin
                         hidemouse;
                         rectangle(220,260,300,280,15,0);
                         rectangle(370,260,450,280,0,14);
                         repeat
                         until MouseButton<>LeftButton;
                         refresh:=true;
                         _refresh_;
                       end;
                end;
         end;
    if keypressed
    then begin
           c:=readkey;
           case c of
           #9,#75,#77:begin
                        case f_put of
                        0:rectangle(220,260,300,280,15,0);
                        1:rectangle(370,260,450,280,15,0);
                        end;
                        f_put:=abs(f_put mod 2 - 1);
                        case f_put of
                        0:rectangle(220,260,300,280,14,0);
                        1:rectangle(370,260,450,280,14,0);
                        end;
                      end;
           #13: case f_put of
                0:begin
                    hidemouse;
                    rectangle(220,260,300,280,0,14);
                    f:=true;
                  end;
                1:begin
                    hidemouse;
                    rectangle(370,260,450,280,0,14);
                    refresh:=true;
                    _refresh_;
                  end;
                end;
           end;
         end;
  until (f)or(refresh);
  if not refresh
  then analiz_mouse_keyboard:=true
  else analiz_mouse_keyboard:=false;
end;

procedure LoadName;
var code:char;
    x_save:integer;
begin
  x_save:=338;
  n_save:='';
  repeat
    if keypressed
    then begin
           code:=readkey;
           case code of
           'A'..'z':begin
                      if x_save>386
                      then begin
                             setcolor(0);
                             bar(x_save-8,199,x_save,216);
                             setcolor(14);
                             outtextxy(x_save-8,199,code);
                             n_save:=n_save+code;
                           end
                      else begin
                             setcolor(14);
                             outtextxy(x_save-8,199,code);
                             x_save:=x_save+8;
                             n_save:=n_save+code;
                           end;
                    end;
           #8:begin
                if x_save>330
                then begin
                       setcolor(0);
                       bar(x_save-16,199,x_save-8,216);
                       delete(n_save,length(n_save),1);
                       x_save:=x_save-8;
                     end;
              end;
           end;
         end;
  until code=#13;
end;

function MouseIn;
begin
  if (MouseX>=x1)and(MouseX<=x2)
  then if (MouseY>=y1)and(MouseY<=y2)
       then MouseIn:=true
       else MouseIn:=false
  else MouseIn:=false;
end;

procedure exit_prog;
begin
  draw_win;
  setcolor(14);
  outtextxy(220,200,'Вы хотите покинуть программу?');
  outtextxy(253,262,'Да');
  outtextxy(400,262,'Нет');
  showmouse;
  refresh:=false;
  f_exit:=analiz_mouse_keyboard(1);
end;

procedure save_prog;
begin
  draw_win;
  setcolor(14);
  outtextxy(200,200,'   Сохранить ...');
  outtextxy(225,262,'Сохранить');
  outtextxy(390,262,'Отмена');
  setcolor(0);
  bar(330,199,470,216);
  LoadName;
  showmouse;
  refresh:=false;
  f_save:=analiz_mouse_keyboard(0);
  if f_save
  then begin
         _refresh_;
         n_save:=n_save+'.prg';
         WriteFileProg(n_save);
         delete(n_save,length(n_save)-3,4);
         n_save:=n_save+'.foc';
         WriteFilePole(n_save);
       end;
end;

procedure PutXYPole;
var x,i:integer;
begin
  setcolor(100);
  drawwindow(0,0,330+xp,330+yp);
  bar(xp,yp,xp+320,yp+320);
  x:=xp;
  setcolor(0);
  repeat
       x:=x+32;
       line(x,yp,x,yp+320);
  until x>=288+xp;
  x:=yp;
  repeat
       x:=x+32;
       line(xp,x,xp+320,x);
  until x>=279+yp;
  rectangle(10,10,320+xp,320+yp,15,15);
{  PutImage(Xchud*32+11,Ychud*32+11,pic[2],NormalPut);}
  pole[1,1]:=2;
end;

procedure DrawButtonWithIkons;
var i:integer;
begin
  ix:=64;iy:=343;
  for i:=1 to 4 do
    begin
      drawwindow(ix,iy,ix+53,iy+53);
      PutImage(ix+11,iy+11,pic[i],NormalPut);
      ix:=ix+53;
    end;
end;

procedure Letter(x,y:integer;c:char);
begin
  LoadStrokedFont('goth.chr');
  SetStrokedFontScale(1,1);
  SetActiveFont(afStroked);
  Bar(10+32*x-31,10+32*y-31,10+32*x-1,10+32*y-1);
  rectangle(10+32*x-30,10+32*y-30,10+32*x-2,10+32*y-2,0,0);
  rectangle(10+32*x-31,10+32*y-31,10+32*x-1,10+32*y-1,100,100);
  PutImage(10+32*x-30,10+32*y-30,pic[8],NormalPut);
  Setcolor(0);
  OutTextXY(10+32*x-26,10+32*y-28,c);
  Setcolor(12);
  OutTextXY(8+32*x-26,8+32*y-28,c);
  setcolor(100);
  SetActiveFont(afRaster);
end;

procedure WriteObjectsPole;
var i,j:integer;
begin
  for i:=1 to 10 do
    for j:=1 to 10 do
      case pole[i,j] of
      1,2,3,4,5,6,7:PutImage(11+(i-1)*32,11+(j-1)*32,pic[pole[i,j]],NormalPut);
      160..175,224..239:Letter(i,j,chr(pole[i,j]));
      end;
end;

procedure _refresh_;
begin
  setcolor(0);
  bar(0,0,640,480);
  drawwindow(348,0,640,441);
  setcolor(80);
  bar(357,10,630,431);
  DrawLabel(0,445,640,480,'F5-Поле  F6-редактор  F7-Сохранить  F8-Загрузить  F9-Запустить  Esc-Выход');
  rectangle(0,445,639,479,15,15);
  rectangle(357,9,630,431,15,15);
  DrawButtonWithIkons;
  PutXYPole;
  WriteObjectsPole;
end;

end.