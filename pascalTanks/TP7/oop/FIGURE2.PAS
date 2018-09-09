uses graph,crt,Mousem,figurem;

const maxs = 500;
Type pMyDesk=^tMyDesk;
     tMyDesk=object(DeskTop)
         constructor Init(Xn,Yn,Radn:integer;Coln:byte);
(*         procedure HandleEvent(var e:tEvent);virtual;{Обработать событие}*)
     end;
     ab = array[1..maxs] of byte;
     ai = array[1..maxs] of integer;
     al = array[1..maxs] of longint;
Var
   MemBegin,MemEnd,CurMem:longint;
   gd,gm:integer;
   Desk:pMyDesk;
   i:^integer;
   a:^ab;
   s:^ai;
   l:^al;


   Constructor tMyDesk.Init(Xn,Yn,Radn:integer;Coln:byte);
   var i:integer;
       ug2,ug1:real;
       rr,j:integer;
       pp:pGroup;
   begin
     inherited Init(Xn,Yn,Radn,Coln);
     for i:=1 to 3+random(5) do
       insert(new(pFreePoint,Init(random(640),random(480))));

      Ug1:=0;RR:=150;
      for i:=1 to Max do
       begin
         {Создать подэлементы круг или квадрат}
         if odd(i)
         then pp:=New(pKrug,Init(x+Round(rr*cos(Ug1)),
                 y+Round(rr*sin(Ug1)),rr-25,50,8+i,Ug1))
         else pp:=New(pKvadr,Init(x+Round(rr*cos(Ug1)),
                 y+Round(rr*sin(Ug1)),rr-20,80,Ug1));
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
         Insert(pp);

         Ug1:=Ug1+(2*Pi/Max)
       end;
   end;

procedure CheckMem;
begin
  if CurMem<>MemAvail
  then begin
         writeln('ChangeMem!');
         CurMem:=MemAvail;
       end;

end;
    begin
      gd:=VGA;gm:=VGAHi;
      MemBegin:=MemAvail;
      CurMem:=MemBegin;
      InitGraph(gd,gm,'c:\tools\tp7');
      ShowMouse;

      {Создать объект "Рабочая область"}
      {New(Desk,Init(GetMaxX div 2,GetMaxY div 2,300,0));
      Desk^.Run;
      Dispose(Desk,Done);}
      CloseGraph;
      {new(i);}
      new(a);
      writeln('byte ',MemBegin-MemAvail);
      dispose(a);
      new(s);
      writeln('int ',MemBegin-MemAvail);
      dispose(s);
      new(l);
      writeln('long ',MemBegin-MemAvail);
      dispose(l);
      {//}
      MemEnd:=MemAvail;
      writeln('В начале:',MemBegin,#13#10'В конце: ', MemEnd);
      {writeln('max ', MaxAvail);}
      readln;
    end.
