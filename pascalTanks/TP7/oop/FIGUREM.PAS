{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}
unit figurem;
interface
uses graph,crt,Mousem;
Const Delta=11*Pi/180;
      Max=8;
      cmNothing=0;      {������ �� ���������}
      cmMouse=1;        {������ ����}
      cmKeyBoard=2;     {������ ������}
      cmBroadCast=3;    {����� �������}
      cmPressPoint=100; {������ �����}
      cmPressKrug=101;  {����� ����}
      cmPressKvadr=102; {����� �������}
      cmRed=103;        {������� "����������� � �������"}
      cmGreen=104;      {������� "����������� � �������"}
      cmCollision=105;  {������� "������������"}
type
   pGroup=^tGroup;
   pFigure=^Figure;

   tEvent=record
           case what:word of
             cmMouse: (  {������� �� �����}
                        mx,my:word;
                        Mask:byte
                      );
             cmKeyBoard: ({������� �� ����������}
                          Key,Scan:char;
                         );
             cmBroadCast:(Addr,InfoPtr:pFigure; {����� �������}
                          Code:word)
           end;
   Figure=object
            X,Y:Longint;  {���������� ������ ��������}
            Ugol,RadOrb:real; {���� ��������, ������ ������ ��������}
            Col:Byte;         {���� ������}
            Next:pFigure;{��������� �� ��������� ������ � ������}
            Owner:pGroup;{��������� �� ��������� ������}
            constructor Init(Xn,Yn,Radn:integer);
            destructor Done;virtual;
            procedure Draw;virtual;{������ ������}
            procedure Hide;virtual;{������� ������}
            procedure HandleEvent(var e:tEvent);virtual;{��������� �������}
            procedure PutEvent(var e:tEvent);
            procedure ClearEvent(var e:tEvent);virtual;{������� �������}
            procedure SetColorMy(NewColor:byte);virtual;
                     {������������� ���� ���� ��������}
            procedure move;virtual;  {���������� ������}
            Procedure SetUgol(du:real); virtual;{���������� ���� ��������
                                                 ���� �������}
            procedure Message(Addr:pFigure;Command,Code:word;InfoPtr:pFigure);virtual;
          end;

   tGroup=object(Figure)
            Elem:pFigure;{��������� �� ���������� ������}
            constructor Init(Xn,Yn,Radn:integer);
            destructor Done; virtual;
            procedure Draw;virtual;{��������������� ��������� �������}
            procedure Hide;virtual;{��������������� �������� �������}
            procedure SetUgol(du:real);virtual;{������ ������� ���� ������������}
            procedure HandleEvent(var e:tEvent);virtual;{��������� �������}
            procedure move;virtual;
            procedure SetColorMy(NewColor:byte);virtual;
            procedure Insert(p:pFigure);{��������� ������ � ������}
          end;

   pKrug=^Krug;
   Krug=object(tGroup)
         rad:integer;{������ �����}
         RedGreenState:byte;{������ ������� �� ������� cmRed � cmGreen}
         procedure Draw;virtual;{��������������� ��������� �������}
         procedure Hide;virtual;{��������������� �������� �������}
         procedure HandleEvent(var e:tEvent);virtual;{}
         constructor Init(Xn,Yn,Radn,Rn:integer;Coln:byte;Ug:real);
         procedure SetColorMy(NewColor:byte);virtual;
         procedure move;virtual;
         destructor Done;virtual;
        end;

   pKvadr=^Kvadr;
   Kvadr=object(tGroup)
         SizeX:integer;{������� ��������}
         RedGreenState:byte;
         procedure Draw;virtual;{��������������� ��������� �������}
         procedure Hide;virtual;{��������������� �������� �������}
         procedure HandleEvent(var e:tEvent);virtual;{}
         procedure SetColorMy(NewColor:byte);virtual;
         constructor Init(Xn,Yn,Radn,SizeXn:integer;Ug:real);
         destructor Done;virtual;
         procedure move;virtual;
        end;

   pPoint=^Point;
   Point=object(Figure)
         MyUg:real;{���� �������� ������ ����� � ��������� ������}
         procedure Draw;virtual;
         procedure Hide;virtual;
         procedure move;virtual;
         procedure HandleEvent(var e:tEvent);virtual;{}
         Procedure SetUgol(du:real); virtual;{���������� ���� ��������}
         constructor Init(Xn,Yn,Radn:integer;Ug:real);
         destructor Done;virtual;
        end;

   pDeskTop=^DeskTop;
   DeskTop=object(tGroup)  {������� �������}
            Quit:boolean;{���� ���������� ������}
            Speed:real;{�������� �������� �������}
            SaveEvent:tEvent;
            constructor Init(Xn,Yn,Radn:integer;Coln:byte);
            destructor Done;virtual;
            Procedure Run; {����� �������� ���� �������}
            procedure GetEvent(var e:tEvent);{�������� �������}
            procedure PutEvent(var e:tEvent);
            procedure HandleEvent(var e:tEvent);virtual;{���������� �������}
           end;
   pFreePoint=^FreePoint;
   FreePoint=object(Point)
              dx,dy:integer;{�������� ������� �������� �� ��� ���������}
              Rad:integer;{������ �����}
              procedure Draw;virtual;
              procedure Hide;virtual;
              procedure HandleEvent(var e:tEvent);virtual;{}
              procedure Move;virtual;
              constructor init(ax,ay:integer);
              destructor Done;virtual;
             end;

implementation


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

    procedure Figure.Draw;{���������� ������}
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
      e.what:=cmNothing{������ �� ���������}
    end;

    procedure Figure.Hide;
    begin
    end;

    procedure Figure.PutEvent(var e:tEvent);
    begin
      if owner<>nil
      then Owner^.PutEvent(e)
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

procedure Figure.Message(Addr:pFigure;Command,Code:word;InfoPtr:pFigure);
var e:tEvent;   {  ����,        ���,    ��� �������, �� ����}
begin         {�������� ���������. ���� Addr=nil, �� ������� ���������� ����}
  e.what:=Command;
  e.infoPtr:=InfoPtr;
  e.Code:=Code;
  e.Addr:=Addr;
  if Addr<> nil {���� ��������� �� ����: �� ������� ����������.}
  then Addr^.HandleEvent(e)
  else PutEvent(e) {����� ������� ����.}
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
      while t<>nil do{������������� ��� ���� �����������}
        begin
          p:=t; t:=t^.Next;
          dispose(p,Done);
        end;
    end;

procedure tGroup.Draw;
   procedure DrawRec(t:pFigure);
   begin
     if t<>nil
     then begin
           DrawRec(t^.Next);{}
           t^.Draw
          end
   end;
    begin
      DrawRec(Elem)
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
      then while t<>nil do {������� ����������� ������� � ���� ������������}
             begin
               t^.HandleEvent(e);
               t:=t^.Next
             end;
    end;

   procedure tGroup.Hide;
   var t:pFigure;
     procedure HideAll(t:pFigure);
     begin
       if t<>nil
       then begin
              HideAll(t^.Next);
              t^.Hide;
            end
     end;
    begin
      HideAll(Elem) {������� ������ ���������� � �������� �������}
    end;

    procedure tGroup.Insert(p:pFigure);
    var t:pFigure;
    begin
      t:=Elem;p^.Owner:=@Self;{��������� ������� � ��������� � ������ Elem_}
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
     Rad:=Rn;Ugol:=Ug;RedGreenState:=0;
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
       if RedGreenState=0
       then begin
              SetColor(Col);             {���������� ����}
              Circle(x,y,Rad);
            end
       else begin
              SetFillStyle(1,RedGreenState);
              FillEllipse(x,y,Rad,Rad);
            end;
       Inherited Draw;{���������� ���� ����������� tGroup.Draw}
    end;

    procedure Krug.Hide;
    Var x1,y1:integer;
        uu:real;
    begin
       InHerited Hide; {������ ���� �����������}
       if RedGreenState=0
       then begin
              SetColor(0);
              Circle(x,y,Rad);
            end
       else begin
              SetFillStyle(1,0);
              FillEllipse(x,y,Rad,Rad);
              RedGreenState:=0
            end;
    end;

   procedure Krug.HandleEvent(var e:tEvent);
   var t:pFigure;
       r1,r2:real;
       AddrEv:pFigure;
       i:integer;
    function Dist(x1,y1,x2,y2:real):real;{����� ���������� ����� ����� �������}
     begin
       Dist:=Sqrt(Sqr(x2-x1)+Sqr(y2-y1))
     end;

    begin
       inherited HandleEvent(e);{�������� ������� ������������}
       case e.what of          {���� ��� ��� �� ����������, ��}
         cmMouse: begin{���� ������ ������� �� �����}
                   if Dist(x,y,e.mx,e.my)<Rad {���� ���� "������" ����, ��}
                   then begin {������� ������� ������ ���������, ��� ����� ����}
                         Message(Owner,cmBroadCast,cmPressKrug,@Self);
                         clearEvent(e);{�������� �������}
                        end;
                  end;
         cmBroadCast: begin
                       if e.Code=cmCollision {�������� �� ������������ �� }
                       then begin            {���������� �������}
                             if Dist(x,y,e.InfoPtr^.x+pFreePoint(e.InfoPtr)^.dx,
                             e.InfoPtr^.y+pFreePoint(e.InfoPtr)^.dy)<(Rad+5)
                             then begin
                                   Owner^.Hide;{���� ��������}
                                   RedGreenState:=Red;{������� ���� � ����}
                                   Message(e.InfoPtr,cmBroadCast,cmRed,@Self);
                            {������� �������� � ������������ ��������� �����}
                                   Owner^.Draw;
                                   sound(800);
                                   delay(100);
                                   nosound;
                                   Owner^.Hide;
                                  end;
                            end;
                       if e.Addr=@Self{���� ������� ��� ����}
                       then case e.Code of
                            cmRed: RedGreenState:=12;
                            CmGreen:RedGreenState:=10;
                            cmPressPoint: begin{���� ������� "������ �����"}
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
     SizeX:=SizeXn;Ugol:=Ug;RedGreenState:=0;
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
       if RedGreenState=0
       then begin
              SetColor(Col);
              Rectangle(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
            end
       else begin
              SetFillStyle(1,RedGreenState);
              Bar(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
            end;
       SetColor(Col);
       Rectangle(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
       Inherited Draw;{���������� ���� �����������}
    end;

    procedure Kvadr.Hide;
    begin
       Inherited Hide;{������� ���� �����������}
       if RedGreenState=0
       then begin
             SetColor(0);
             Rectangle(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
            end
       else begin
              SetFillStyle(1,0);
              Bar(x-SizeX div 2,y-SizeX div 2,x+SizeX div 2,y+SizeX div 2);
              RedGreenState:=0
            end;
    end;

   procedure Kvadr.HandleEvent(var e:tEvent);
   var t:pFigure;
       r1,r2:integer;
       AddrEv:pFigure;
       i:integer;
    begin
       inherited HandleEvent(e);
       case e.what of
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
                            cmRed: RedGreenState:=12;
                            CmGreen:RedGreenState:=10;
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
       case e.what of
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


{**************** DeskTop *************}

   Constructor DeskTop.Init(Xn,Yn,Radn:integer;Coln:byte);
   begin
     inherited Init(Xn,Yn,Radn);
     Speed:=0.01;Quit:=false;
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
       case e.what of
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

    procedure DeskTop.PutEvent(var e:tEvent);
    begin
       SaveEvent:=e
    end;


   procedure DeskTop.GetEvent(var e:tEvent);
   begin
      if SaveEvent.what<>cmNothing{���� ���� ���������� �������, ��}
      then begin                  {������� ��� ������������}
             e:=SaveEvent;SaveEvent.what:=cmNothing
           end
      else
      if keypressed {���� ���� ������ �������}
      then begin
            e.what:=cmKeyboard;
            e.Key:=readkey;
            if e.Key=#0
            then e.Scan:=readkey
           end
      else begin
            ReadMouse;
            if Mask<>0 {���� ���� ������ ����}
            then begin
                  e.what:=cmMouse;
                  e.mx:=mx; e.MY:=my;
                  e.mask:=Mask;
                 end
            else e.what:=cmNothing
           end
   end;


   Procedure DeSkTop.Run;
   var Ug:real;
       Page:byte;
       e:tEvent;
    begin
       Ug:=0;Page:=0;SetColor(15);
       HideMouse;
       OutTextXY(10,10,'"+" - ��������� ��������, "-" - ��������� ��������.');
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

   case e.what of
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
end;


procedure FreePoint.Draw;
begin
   SetColor(Col);
   SetFillStyle(1,Col);FillEllipse(x,y,Rad,Rad);
end;

procedure FreePoint.Hide;
begin
   SetColor(0);
   SetFillStyle(1,0);FillEllipse(x,y,Rad,Rad);
end;

destructor FreePoint.Done;
begin
end;

begin
end.
