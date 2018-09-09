{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
program Example;
uses graph,crt,Mousem;
Const Delta=11*Pi/180;
      Max=8;
      cmNothing=0;      {ничего не произошло}
      cmMouse=1;        {нажата мышь}
      cmKeyBoard=2;     {нажата кнопка}
      cmBroadCast=3;    {общее событие}
      cmPressPoint=100; {нажата точка}
      cmPressKrug=101;  {нажат круг}
      cmPressKvadr=102; {нажат квадрат}
      cmRed=103;        {событие "перекрасься в красный"}
      cmGreen=104;      {событие "перекрасься в зеленый"}
      cmCollision=105;  {событие "столкновение"}
type
   pGroup=^tGroup;
   pFigure=^Figure;

   tEvent=record
           case Watch:word of
             cmMouse: (  {Событие от мышки}
                        mx,my:word;
                        Mask:byte
                      );
             cmKeyBoard: ({Событие от клавиатуры}
                          Key,Scan:char;
                         );
             cmBroadCast:(Addr,InfoPtr:pFigure; {Общее событие}
                          Code:word)
           end;
   Figure=object
            X,Y:Longint;  {координаты центра вращения}
            Ugol,RadOrb:real; {Угол поворота, радиус орбиты вращения}
            Col:Byte;         {Цвет фигуры}
            Next:pFigure;{Указатель на следующий объект в списке}
            Owner:pGroup;{Указатель на владельца фигуры}
            constructor Init(Xn,Yn,Radn:integer);
            destructor Done;virtual;
            procedure Draw;virtual;{Рисует объект}
            procedure Hide;virtual;{Стирает объект}
            procedure HandleEvent(var e:tEvent);virtual;{Обработка событий}
            procedure ClearEvent(var e:tEvent);virtual;{Очистка события}
            procedure SetColorMy(NewColor:byte);virtual;
                     {Устанавливает цвет всех объектов}
            procedure move;virtual;  {Перемещает объект}
            Procedure SetUgol(du:real); virtual;{Установить угол поворота
                                                 всей системы}
          end;

   tGroup=object(Figure)
            Elem:pFigure;{Указатель на подэлемент фигуры}
            constructor Init(Xn,Yn,Radn:integer);
            destructor Done; virtual;
            procedure Draw;virtual;{Переопределение рисования объекта}
            procedure Hide;virtual;{Переопределение стирания объекта}
            procedure SetUgol(du:real);virtual;{задает поворот всех подэлементов}
            procedure HandleEvent(var e:tEvent);virtual;{Обработка событий}
            procedure move;virtual;
            procedure SetColorMy(NewColor:byte);virtual;
            procedure Insert(p:pFigure);{Поместить объект в группу}
          end;

   pKrug=^Krug;
   Krug=object(tGroup)
         rad:integer;{Радиус круга}
         RedGrenState:byte;{Задает реакцию на событие cmRed и cmGreen}
         procedure Draw;virtual;{Переопределение рисования объекта}
         procedure Hide;virtual;{Переопределение стирания объекта}
         procedure HandleEvent(var e:tEvent);virtual;{}
         constructor Init(Xn,Yn,Radn,Rn:integer;Coln:byte;Ug:real);
         procedure SetColorMy(NewColor:byte);virtual;
         procedure move;virtual;
         destructor Done;virtual;
        end;

   pKvadr=^Kvadr;
   Kvadr=object(tGroup)
         SizeX:integer;{Сторона квадрата}
         RedGrenState:byte;
         procedure Draw;virtual;{Переопределение рисования объекта}
         procedure Hide;virtual;{Переопределение стирания объекта}
         procedure HandleEvent(var e:tEvent);virtual;{}
         procedure SetColorMy(NewColor:byte);virtual;
         constructor Init(Xn,Yn,Radn,SizeXn:integer;Ug:real);
         destructor Done;virtual;
         procedure move;virtual;
        end;

   pPoint=^Point;
   Point=object(Figure)
         MyUg:real;{Угол поворота данной точки в начальный момент}
         procedure Draw;virtual;
         procedure Hide;virtual;
         procedure move;virtual;
         procedure HandleEvent(var e:tEvent);virtual;{}
         Procedure SetUgol(du:real); virtual;{Установить угол поворота}
         constructor Init(Xn,Yn,Radn:integer;Ug:real);
         destructor Done;virtual;
        end;

   pDeskTop=^DeskTop;
   DeskTop=object(tGroup)  {Рабочая область}
            Quit:boolean;{Флаг завершения работы}
            Speed:real;{Скорость вращения системы}
            constructor Init(Xn,Yn,Radn:integer;Coln:byte);
            destructor Done;virtual;
            Procedure Run; {Метод вращения всей системы}
            procedure GetEvent(var e:tEvent);{Получить событие}
            procedure HandleEvent(var e:tEvent);virtual;{Обработать событие}
           end;
   pFreePoint=^FreePoint;
   FreePoint=object(Point)
              dx,dy:integer;{проекции вектора скорости на оси координат}
              Rad:integer;{Размер точки}
              procedure Draw;virtual;
              procedure Hide;virtual;
              procedure HandleEvent(var e:tEvent);virtual;{}
              procedure Move;virtual;
              constructor init(ax,ay:integer);
              destructor Done;virtual;
             end;
   pMasterFreePoint=^MasterFreePoint;
   MasterFreePoint=object(tGroup)
              constructor Init;
            { destructor Done; virtual;}
             end;

Var Desk:PDeskTop;

procedure Message(Addr:pFigure;Command,Code:word;InfoPtr:pFigure);
var e:tEvent;   { кому, что, код события, от кого}
begin         {Посылает сообщение. Если Addr=nil, то событие адресовано всем}
  e.Watch:=Command;
  e.infoPtr:=InfoPtr;
  e.Code:=Code;
  e.Addr:=Addr;
  if Addr<> nil {Если сообщение не всем: то послать избранному.}
  then Addr^.HandleEvent(e)
  else Desk^.HandleEvent(e) {Иначе послать всем.}
end;

  {************Figure************}

  Constructor Figure.Init(Xn,Yn,Radn:integer);
    begin
      x:=Xn;Y:=Yn;Col:=0;RadOrb:=Radn;Ugol:=0;
      Next:=nil;OWner:=nil;
    end;

   destructor Figure.Done;
    begin
      Hide;
    end;

    procedure Figure.Draw;{Отложенные методы}
    begin
    end;

    procedure Figure.Move;
    begin
    end;

    procedure Figure.HandleEvent(var e:tEvent);
    begin
    end;

    procedure Figure.ClearEvent(var e:tEvent);
    begin
      e.Watch:=cmNothing{Ничего ни произошло}
    end;

    procedure Figure.Hide;
    begin
    end;


    procedure Figure.SetColorMy(NewColor:byte);
    begin
      Col:=NewColor;
    end;

    Procedure Figure.SetUgol(du:real);
    begin
      Ugol:=Ugol+du;
      if ugol>2*PI
      then ugol:=0
    end;

 {************** tGroup ****************}

   Constructor tGroup.Init(Xn,Yn,Radn:integer);
   begin
     inherited Init(Xn,Yn,Radn);
     Elem:=nil;
   end;

   destructor tGroup.Done;
   var t,p:pFigure;
    begin
      t:=Elem;
      while t<>nil do{Ликвидировать все свои подэлементы}
        begin
          p:=t; t:=t^.Next;
          dispose(p,Done);
        end;
    end;

   procedure tGroup.Draw;
   var t:pFigure;
    begin
      t:=Elem;
      if t<> nil
      then while t<>nil do
             begin
               t^.Draw;
               t:=t^.Next
             end;
    end;

   procedure tGroup.Move;
   var t:pFigure;
    begin
      t:=Elem;
      if t<> nil
      then while t<>nil do
             begin
               t^.Move;
               t:=t^.Next
             end;
    end;

   procedure tGroup.SetColorMy(NewColor:byte);
   var t:pFigure;
       i:integer;
    begin
      t:=Elem;   i:=0;
      if t<> nil
      then while t<>nil do
             begin
               inc(i);
               t^.SetColorMy((NewColor+i)mod 15+1);
               t:=t^.Next
             end;
    end;

   procedure tGroup.HandleEvent(var e:tEvent);
   var t:pFigure;
    begin
      t:=Elem;
      if t<> nil
      then while t<>nil do {Вызвать обработчики событий у всех подэлементов}
             begin
               t^.HandleEvent(e);
               t:=t^.Next
             end;
    end;

   procedure tGroup.Hide;
   var t:pFigure;
     procedure HideAll(t:pFigure);
     begin
       if t^.Next<>nil
       then HideAll(t^.Next);
       t^.Hide;
     end;
    begin
      if Elem<> nil
      then HideAll(Elem) {Объекты должны скрываться в обратном порядке}
    end;

    procedure tGroup.Insert(p:pFigure);
    var t:pFigure;
    begin
      t:=Elem;p^.Owner:=@Self;{Вставляет элемент р последним в список Elem_}
      if t=nil
      then Elem:=p
      else begin
             while t^.next<>nil do
              t:=t^.next;
              t^.Next:=p;
           end;
    end;

    procedure tGroup.SetUgol(du:real);
    var t:pFigure;
    begin
       inherited SetUgol(du);
       if Elem<> nil
       then begin
             t:=Elem;
             while t<> nil do
              begin
                t^.SetUgol(du);
                t:=t^.Next
              end;
            end;
    end;


 {************** Krug ****************}

   Constructor Krug.Init(Xn,Yn,Radn,Rn:integer;Coln:byte;Ug:real);
   begin
     inherited Init(Xn,Yn,Radn);
     Rad:=Rn;Ugol:=Ug;RedGrenState:=0;
   end;

   destructor Krug.Done;
    begin
      Inherited Done;
      Hide;
    end;

   procedure Krug.SetColorMy(NewColor:byte);
   begin
     col:=NewColor;
     inherited SetColorMy(random(15));
   end;

    procedure Krug.Move;
    begin
       x:=Owner^.x+round(RadOrb*cos(Ugol));
       y:=Owner^.y+round(RadOrb*sin(Ugol));
       inherited move;
    end;

    procedure Krug.Draw;
    Var x1,y1:Longint;
    begin
       if RedGrenState=0
       then begin
              SetColor(Col);             {Нарисовать себя}
              Circle(x,y,Rad);
            end
       else begin
              SetFillStyle(1,RedGrenState);
              FillEllipse(x,y,Rad,Rad);
            end;
       Inherited Draw;{Нарисовать свои подэлементы tGroup.Draw}
    end;

    procedure Krug.Hide;
    Var x1,y1:integer;
        uu:real;
    begin
       InHerited Hide; {Скрыть свои подэлементы}
       if RedGrenState=0
       then begin
              SetColor(0);
              Circle(x,y,Rad);
            end
       else begin
              SetFillStyle(1,0);
              FillEllipse(x,y,Rad,Rad);
              RedGrenState:=0
            end;
    end;

   procedure Krug.HandleEvent(var e:tEvent);
   var t:pFigure;
       r1,r2:real;
       AddrEv:pFigure;
       i:integer;
    function Dist(x1,y1,x2,y2:real):real;{Найти растояние между двумя точками}
     begin
       Dist:=Sqrt(Sqr(x2-x1)+Sqr(y2-y1))
     end;

    begin
       inherited HandleEvent(e);{Передать событие подэлементам}
       case e.Watch of          {Если оно еще не обработано, то}
         cmMouse: begin{Если пришло событие от мышки}
                   if Dist(x,y,e.mx,e.my)<Rad {Если Мышь "внутри" меня, то}
                   then begin {послать событие своему владельцу, что нажат круг}
                         Message(Owner,cmBroadCast,cmPressKrug,@Self);
                         clearEvent(e);{Очистить событие}
                        end;
                  end;
         cmBroadCast: begin
                       if e.Code=cmCollision {Проверка на столкновение со }
                       then begin            {свободными точками}
                             if Dist(x,y,e.InfoPtr^.x+pFreePoint(e.InfoPtr)^.dx,
                             e.InfoPtr^.y+pFreePoint(e.InfoPtr)^.dy)<(Rad+5)
                             then begin
                                   Owner^.Hide;{Всем скрыться}
                                   RedGrenState:=Red;{Взвести флаг у себя}
                                   Message(e.InfoPtr,cmBroadCast,cmRed,@Self);
                            {послать сообщени о столкновении свободной точке}
                                   Owner^.Draw;
                                   sound(800);
                                   delay(100);
                                   nosound;
                                   Owner^.Hide;
                                  end;
                            end;
                       if e.Addr=@Self{Если событие для меня}
                       then case e.Code of
                            cmRed: RedGrenState:=12;
                            CmGreen:RedGrenState:=10;
                            cmPressPoint: begin{если событие "нажата точка"}
                               AddrEv:=e.InfoPtr;HideMouse;
                               for i:=1 to 5 do
                               begin
                                Hide;
                                if odd(i)
                                then Message(AddrEv,cmBroadCast,cmRed,@Self)
                                else Message(AddrEv,cmBroadCast,cmGreen,@Self);
                                Draw;
                                sound(1000);
                                delay(100);
                                nosound;
                               end;
                               ShowMouse;
                             end;
                            end;
                           end;
       end;
    end;

  {************** Kvadr ****************}

   Constructor Kvadr.Init(Xn,Yn,Radn,SizeXn:integer;Ug:real);
   begin
     inherited Init(Xn,Yn,Radn);
     SizeX:=SizeXn;Ugol:=Ug;RedGrenState:=0;
   end;

   destructor Kvadr.Done;
    begin
      inherited Done;
      Hide;
    end;

   procedure Kvadr.SetColorMy(NewColor:byte);
   begin
     col:=NewColor;
     inherited SetColorMy(random(15));
   end;

    procedure Kvadr.Move;
    begin
       x:=Owner^.x+round(RadOrb*cos(Ugol));
       y:=Owner^.y+round(RadOrb*sin(Ugol));
       inherited Move;
    end;

    procedure Kvadr.Draw;
    Var x1,y1:Longint;
    begin
       if RedGrenState=0
       then begin
              SetColor(Col);
              Rectangle(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
            end
       else begin
              SetFillStyle(1,RedGrenState);
              Bar(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
            end;
       SetColor(Col);
       Rectangle(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
       Inherited Draw;{Нарисовать свои подэлементы}
    end;

    procedure Kvadr.Hide;
    begin
       Inherited Hide;{Стереть свои подэлементы}
       if RedGrenState=0
       then begin
             SetColor(0);
             Rectangle(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
            end
       else begin
              SetFillStyle(1,0);
              Bar(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
              RedGrenState:=0
            end;
    end;

   procedure Kvadr.HandleEvent(var e:tEvent);
   var t:pFigure;
       r1,r2:integer;
       AddrEv:pFigure;
       i:integer;
    begin
       inherited HandleEvent(e);
       case e.Watch of
         cmMouse: begin
                   r1:=abs(x-e.mx);r2:=abs(y-e.my);
                   if (r1<(SizeX div 2))and(r2<(SizeX div 2))
                   then begin
                         Message(Owner,cmBroadCast,cmPressKvadr,@Self);
                         ClearEvent(e)
                        end;
                  end;
         cmBroadCast: if e.Addr=@Self
                      then case e.Code of
                            cmRed: RedGrenState:=12;
                            CmGreen:RedGrenState:=10;
                            cmPressPoint: begin
                               AddrEv:=e.InfoPtr;HideMouse;
                               for i:=1 to 5 do
                               begin
                                Hide;
                                if odd(i)
                                then Message(AddrEv,cmBroadCast,cmRed,@Self)
                                else Message(AddrEv,cmBroadCast,cmGreen,@Self);
                                Draw;
                                sound(1000);
                                delay(100);
                                nosound;
                               end;
                               ShowMouse;
                             end;

                           end;
       end;
    end;



{***************** Point ****************}

   Constructor Point.Init(Xn,Yn,Radn:integer;Ug:real);
   begin
     inherited Init(Xn,Yn,Radn);
     MyUg:=Ug;
   end;

   destructor Point.Done;
    begin
      Hide;
    end;

    procedure Point.Hide;
    begin
       SetColor(0);
       SetFillStyle(1,0);FillEllipse(x,y,2,2);
    end;

    procedure Point.Move;
    var uu:real;
    begin
       uu:=-2*Ugol+myUg;
       x:=Owner^.x+round(RadOrb*cos(Uu));
       y:=Owner^.y+round(RadOrb*sin(Uu));
    end;


    procedure Point.Draw;
    begin
       SetColor(Col);
       SetFillStyle(1,Col);FillEllipse(x,y,2,2);
    end;

    Procedure Point.SetUgol(du:real);
    begin
      Ugol:=Ugol-2*du;
      if ugol<0
      then ugol:=2*Pi
    end;


   procedure Point.HandleEvent(var e:tEvent);
   var t:pFigure;
       r1,r2:real;
    begin
       case e.Watch of
         cmMouse: begin
                   r1:=x-e.mx;r2:=y-e.my;
                   r1:=sqrt(sqr(r1)+sqr(r2));
                   if r1<5
                   then begin
                         Message(Owner,cmBroadCast,cmPressPoint,@Self);
                         ClearEvent(e)
                        end;
                  end;
         cmBroadCast: if e.Addr=@Self
                      then begin
                            case e.Code of
                            cmRed: Col:=12;
                            CmGreen:col:=10;
                            end;
                            ClearEvent(e);
                           end;
       end;
    end;

{**************** MasterFreePoint *************}

  Constructor MasterFreePoint.Init;
    begin
       inherited Init(0,0,0)
    end;

{   destructor MasterFreePoint.Done;
    begin
       inherited Done
    end;}


{**************** DeskTop *************}

   Constructor DeskTop.Init(Xn,Yn,Radn:integer;Coln:byte);
   var i:integer;
       p:pMasterFreePoint;
   begin
     inherited Init(Xn,Yn,Radn);
     Speed:=0.01;Quit:=false;
     New(p,Init);
     for i:=1 to 3+random(5) do
       p^.insert(new(pFreePoint,Init(random(640),random(480))));
     Insert(p);
   end;

   destructor DeskTop.Done;
   var p,t:pFigure;
    begin
      Inherited Done;
    end;

   procedure DeskTop.HandleEvent(var e:tEvent);
   var i:integer;
       AddrEv:pFigure;
    begin
       inherited HandleEvent(e);
       case e.Watch of
         cmKeyBoard: case e.key of
                     #27:Quit:=true;
                     '+':if Speed=0
                          then Speed:=0.01
                          else Speed:=Speed*2;
                     '-':speed:=Speed/2;
                    end;
         cmBroadCast: if e.Addr=@Self
                      then case e.Code of
                            cmPressKrug,cmPressKvadr:
                              begin
                               AddrEv:=e.InfoPtr;HideMouse;
                               for i:=1 to 5 do
                               begin
                                Hide;
                                if odd(i)
                                then Message(AddrEv,cmBroadCast,cmRed,@Self)
                                else Message(AddrEv,cmBroadCast,cmGreen,@Self);
                                Draw;
                                sound(1000);
                                delay(100);
                                nosound;
                               end;
                               ShowMouse;
                              end
                           end;
       end;
    end;



   procedure DeskTop.GetEvent(var e:tEvent);
   begin
      if keypressed {Если была нажата клавиша}
      then begin
            e.Watch:=cmKeyboard;
            e.Key:=readkey;
            if e.Key=#0
            then e.Scan:=readkey
           end
      else begin
            ReadMouse;
            if Mask<>0 {если была нажата мышь}
            then begin
                  e.Watch:=cmMouse;
                  e.mx:=mx; e.MY:=my;
                  e.mask:=Mask;
                 end
            else e.Watch:=cmNothing
           end
   end;


   Procedure DeskTop.Run;
   var Ug:real;
       Page:byte;
       e:tEvent;
    begin
       Ug:=0;Page:=0;SetColor(15);
       HideMouse;
       OutTextXY(10,10,'"+" - увеличить скорость, "-" - уменьшить скорость.');
       showmouse;
       repeat
         HideMouse;
         Hide;
         ShowMouse;
         SetUgol(Speed);
         Move;
         SetColorMy(random(15));
         HideMouse;
         Draw;
         ShowMouse;
         GetEvent(e);
         HandleEvent(e);
         Delay(50);
       until quit;
    end;

Constructor FreePoint.Init(ax,ay:integer);
begin
   x:=ax;y:=ay;
   dx:=4-random(8);   dy:=4-random(8);
   Col:=Random(15)+1;Rad:=5;
   Next:=nil;Owner:=nil;
end;

procedure FreePoint.Move;
begin
  if ((x+dx)>GetMaxX-Rad) or (((x+dx-Rad)<0))
  then dx:=-dx
  else x:=x+dx;
  if ((y+dy)>GetMaxy-Rad) or (((y+dy-Rad)<0))
  then dy:=-dy
  else y:=y+dy;
  Col:=Random(15)+1;
  message(nil,cmBroadCast,cmCollision,@Self);
end;

procedure FreePoint.HandleEvent(var e:tEvent);
begin

   case e.Watch of
     cmBroadCast: case e.Code of
                   cmRed:begin
                          if e.Addr=@Self
                          then begin
                                 dx:=-dx;dy:=-dy;
                                 x:=x+5*dx;y:=y+5*dy
                               end
                         end;
                  end;
   end;
{   inherited HandleEvent(e);}
end;


procedure FreePoint.Draw;
begin
   SetColor(Col);
   SetFillStyle(1,Col);FillEllipse(x,y,Rad,Rad);
   if Next<> nil
   then Next^.Draw
end;

procedure FreePoint.Hide;
begin
  if Next<>nil
  then Next^.Hide;
   SetColor(0);
   SetFillStyle(1,0);FillEllipse(x,y,Rad,Rad);
end;

destructor FreePoint.Done;
begin
end;


Var ug2,ug1:real;
    rr,i,gd,gm,j:integer;
    pp:pGroup;
    MemBegin,MemEnd:longint;

    begin
      gd:=VGA;gm:=VGAHi;
      MemBegin:=MemAvail;
      InitGraph(gd,gm,'c:\tools\tp7\bgi');
      ShowMouse;

      {Создать объект "Рабочая область"}
      New(Desk,Init(GetMaxX div 2,GetMaxY div 2,300,0));

      Ug1:=0;RR:=150;
      for i:=1 to Max do
       begin
         {Создать подэлементы круг или квадрат}
         if odd(i)
         then pp:=New(pKrug,Init(Desk^.x+Round(rr*cos(Ug1)),
                 Desk^.y+Round(rr*sin(Ug1)),rr-25,50,8+i,Ug1))
         else pp:=New(pKvadr,Init(Desk^.x+Round(rr*cos(Ug1)),
                 Desk^.y+Round(rr*sin(Ug1)),rr-20,80,Ug1));
         Ug2:=0;
         {Создать подэлементы точки для объекта круг или квадрат}
         for j:=1 to max do
          begin
            pp^.Insert(New(pPoint,Init(pp^.x+Round(20*cos(Ug2)),
                 pp^.y+Round(20*sin(Ug2)),20,Ug2)));
            Ug2:=Ug2+(2*Pi/Max)
          end;
         {Разместить круг или квадрат в подэлементах  рабочей
         области.}
         Desk^.Insert(pp);

         Ug1:=Ug1+(2*Pi/Max)
       end;
      Desk^.Run;
      Dispose(Desk,Done);
      CloseGraph;
      MemEnd:=MemAvail;
      writeln('В начале:',MemBegin,' в конце:', MemEnd)
    end.
