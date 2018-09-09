{$A+,B-,D+,E-,F-,G+,I+,L+,N+,O-,P-,Q+,R-,S+,T-,V+,X+}
{$M 65520,0,655360}
program Gonochki;
uses vesa,keyboard;
type tRasCar=array[0..25] of pointer;
     tMes=array[0..4] of pointer;
     stringmatr=array[1..500] of byte;
     tMatrGameField=array[1..500]of ^stringmatr;
          tCar=record
           name:string;
           x,y:integer; {---Coordinates of the car-}
           v:integer; {-----Vector of turn-}
           qp:tRasCar; {----File of the images-}
           speed:integer; {-Speed-}
          end;

var page:shortint; {------------Number of page-}
    MatrField:tMatrGameField;
    Mes:tMes;
    pin:char;
    n,rtek,per,qwe:integer; {-------The counter-}
    s,s1,s2,s3,s4,s5,s6,s7,s8,s9:string; {--------Line of statistics-}
    car:tCar; {-----------------Record-}
    f,y,t:boolean; {------------Flag-}
    xi,yi:integer; {--}
    kx,ky:integer; {--}
    fil:file of char;

{----}
Procedure ZapMatr;
var i,y:integer;
Begin
 {for i:=1 to 500 do
  Begin
   New(MatrField[i]);
   for y:=1 to 500 do
     MatrField[i]^[y]:=random(3);
  End;}
{ Assign(fil,'.\maps\sigma.dat');
 Reset(fil);
 For i:=1 to 500 do
  Begin
   New(MatrField[i]);
   For y:=1 to 500 do
    Begin
     read(fil,pin);
     MatrField[i]^[y]:=Ord(pin);
    End;
  End;}
End;


{--Procedure of chenge of page--}
Procedure ChangePage;
 Begin
  setvisualpage(page);
  page:=1-page;
  waitvbl;
  setactivepage(page);
 End;

{----}
Procedure IzRtek;
Begin
 if (keys[kLeft]) then Inc(rtek);
 if (keys[kRight]) then Inc(rtek);
 if (keys[kRight]=false)and(keys[kLeft]=false) then rtek:=0;
 if rtek>5 then rtek:=5;
End;

{--Procedure of chenge of a vector--}
Function IzVector(predznach:integer;izmenenie:integer):integer;
var d:boolean;
Begin
 d:=false;
 if car.speed=0 then d:=false;
 if (((car.speed=1)and(rtek=5))or((car.speed=2)and(rtek=5))or
    ((car.speed=3)and(rtek=4))or((car.speed=4)and(rtek=3))or
    ((car.speed=5)and(rtek=2))or((car.speed=6)and(rtek=1))) then d:=true;
 if d then
  begin
   if (izmenenie>0)and(predznach=23) then
    IzVector:=0
    else
     if (izmenenie<0)and(predznach=0) then
      IzVector:=23
      else IzVector:=predznach+izmenenie;
   rtek:=0
  end
 else if ((keys[kDown])and(rtek=5))
       then
        if (izmenenie>0)and(predznach=23) then IzVector:=0
         else if (izmenenie<0)and(predznach=0) then IzVector:=23
              else IzVector:=predznach+izmenenie
      else IzVector:=predznach;
End;

{--Procedure initization the images--}
Procedure InitPic;
var i:integer; s:string[2];
Begin
 for i:=0 to 23 do
  Begin str(i,s); car.qp[i]:=LoadSpr('c:\pic\'+s+'.spr'); End;
 Mes[0]:=LoadSpr('c:\pic\00.spr');
 Mes[1]:=LoadSpr('c:\pic\01.spr');
 Mes[2]:=LoadSpr('c:\pic\02.spr');
 Mes[3]:=LoadSpr('c:\pic\03.spr');
 Mes[4]:=LoadSpr('c:\pic\04.spr');
End;

{--Procedure of chenge screens--}
Procedure ShowAll;
var i,j:integer;
Begin
 ChangePage;
 Setcolor(0);
 Bar(0,0,640,480);
 for i:=0 to 63 do
  for j:=0 to 47 do
 PutSprite(i*10,j*10,Mes[MatrField[i+kx]^[j+ky]]);
 PutSprite(car.x,car.y,car.qp[car.v]);

End;

{----}
Function IzMatr(tx,ty:integer): boolean;
Begin
 if ((ky+ty)<437)and((ky+ty)>0)and((kx+tx)<443)and((kx+tx)>0)
  then IzMatr:=true
  else IzMatr:=false;
End;

{--Procedure movement on a vector--}
Procedure Movement(vector:integer;f:boolean);
var x0,x1,x2,x3,x4,x5:integer;
Begin
 x0:=(2*car.speed) div 2; x1:=(4*car.speed) div 2; x2:=(6*car.speed) div 2;
 x3:=(8*car.speed) div 2; x4:=(10*car.speed) div 2; x5:=(12*car.speed) div 2;
 case vector of
   0: if IzMatr(0,-x5) then ky:=ky-x5;
   1: if IzMatr(-x0,-x4) then begin kx:=kx-x0; ky:=ky-x4; end;
   2: if IzMatr(-x1,-x3) then begin kx:=kx-x1; ky:=ky-x3; end;
   3: if IzMatr(-x2,-x2) then begin kx:=kx-x2; ky:=ky-x2; end;
   4: if IzMatr(-x3,-x1) then begin kx:=kx-x3; ky:=ky-x1; end;
   5: if IzMatr(-x4,-x0) then begin kx:=kx-x4; ky:=ky-x0; end;
   6: if IzMatr(-x5,0) then  kx:=kx-x5;
   7: if IzMatr(-x4,x0) then begin kx:=kx-x4; ky:=ky+x0; end;
   8: if IzMatr(-x3,x1) then begin kx:=kx-x3; ky:=ky+x1; end;
   9: if IzMatr(-x2,x2) then begin kx:=kx-x2; ky:=ky+x2; end;
   10: if IzMatr(-x1,x3) then begin kx:=kx-x1; ky:=ky+x3; end;
   11: if IzMatr(-x0,x4) then begin kx:=kx-x0; ky:=ky+x4; end;
   12: if IzMatr(0,x5) then  ky:=ky+x5;
   13: if IzMatr(x0,x4) then begin kx:=kx+x0; ky:=ky+x4; end;
   14: if IzMatr(x1,x3) then begin kx:=kx+x1; ky:=ky+x3; end;
   15: if IzMatr(x2,x2) then begin kx:=kx+x2; ky:=ky+x2; end;
   16: if IzMatr(x3,x1) then begin kx:=kx+x3; ky:=ky+x1; end;
   17: if IzMatr(x4,x0) then begin kx:=kx+x4; ky:=ky+x0; end;
   18: if IzMatr(x5,0) then  kx:=kx+x5;
   19: if IzMatr(x4,-x0) then begin kx:=kx+x4; ky:=ky-x0; end;
   20: if IzMatr(x3,-x1) then begin kx:=kx+x3; ky:=ky-x1; end;
   21: if IzMatr(x2,-x2) then begin kx:=kx+x2; ky:=ky-x2; end;
   22: if IzMatr(x1,-x3) then begin kx:=kx+x1; ky:=ky-x3; end;
   23: if IzMatr(x0,-x4) then begin kx:=kx+x0; ky:=ky-x4; end;
  end;
 if f=false then if (keys[kDown])and(car.speed=0) then
  case vector of
   0: if IzMatr(0,6) then ky:=ky+1;
   1: if IzMatr(1,5) then begin kx:=kx+1; ky:=ky+1; end;
   2: if IzMatr(2,4) then begin kx:=kx+1; ky:=ky+1; end;
   3: if IzMatr(3,3) then begin kx:=kx+1; ky:=ky+1; end;
   4: if IzMatr(4,2) then begin kx:=kx+1; ky:=ky+1; end;
   5: if IzMatr(5,1) then begin kx:=kx+1; ky:=ky+1; end;
   6: if IzMatr(6,0) then  kx:=kx+1;
   7: if IzMatr(5,-1) then begin kx:=kx+1; ky:=ky-1; end;
   8: if IzMatr(4,-2) then begin kx:=kx+1; ky:=ky-1; end;
   9: if IzMatr(3,-3) then begin kx:=kx+1; ky:=ky-1; end;
   10: if IzMatr(2,-4) then begin kx:=kx+1; ky:=ky-1; end;
   11: if IzMatr(1,-5) then begin kx:=kx+1; ky:=ky-1; end;
   12: if IzMatr(0,-6) then  ky:=ky-1;
   13: if IzMatr(-1,-5) then begin kx:=kx-1; ky:=ky-1; end;
   14: if IzMatr(-2,-4) then begin kx:=kx-1; ky:=ky-1; end;
   15: if IzMatr(-3,-3) then begin kx:=kx-1; ky:=ky-1; end;
   16: if IzMatr(-4,-2) then begin kx:=kx-1; ky:=ky-1; end;
   17: if IzMatr(-5,-1) then begin kx:=kx-1; ky:=ky-1; end;
   18: if IzMatr(-6,0) then kx:=kx-1;
   19: if IzMatr(-5,1) then begin kx:=kx-1; ky:=ky+1; end;
   20: if IzMatr(-4,2) then begin kx:=kx-1; ky:=ky+1; end;
   21: if IzMatr(-3,3) then begin kx:=kx-1; ky:=ky+1; end;
   22: if IzMatr(-2,4) then begin kx:=kx-1; ky:=ky+1; end;
   23: if IzMatr(-1,5) then begin kx:=kx-1; ky:=ky+1; end;
  end
End;

{----}
Procedure IzSpeed(per:integer);
Begin
 case per of
  0: car.speed:=0;
  20: car.speed:=1;
  50: car.speed:=2;
  90: car.speed:=3;
  130: car.speed:=4;
  190: car.speed:=5;
  260: car.speed:=6;
 end;
End;

{--Procedure tracking of speed--}
Procedure TrackingSpeed(var per:integer);
Begin
 if keys[kUp]
  then  Inc(per)
  else  if (keys[kUp]=false)and(per>=5)
         then begin
               per:=per-25;
               if (keys[kDown])and(per>=3)
                then per:=per-20;
               if (per<0)or(per<25) then  per:=0;
              end;
 if per>260
  then per:=260;

End;

{--Procedure of initialization meanings--}
Procedure InitMeanings;
Begin
 car.x:=220; car.y:=150; car.v:=0; per:=0; car.speed:=0;
 rtek:=0; xi:=1; yi:=1; kx:=1; ky:=1;
End;

{--Procedure conclusion of statistics--}
Procedure WriteStat;
Begin
 setcolor(2);
 str(car.speed,s);
 str(per,s1);
 str(car.x,s2);
 str(car.y,s3);
 str(rtek,s4);
 str(car.v,s5);
 outtextXY(10,30,s);
 outtextXY(10,10,s1);
 outtextXY(50,10,s2);
 outtextXY(130,10,s3);
 outtextXY(200,10,s4);
 outtextXY(270,10,s5);

End;

{--Procedure of analysis the keyboard--}
Procedure AnalysKeyboard;
 Begin
  if (keys[kUp]) then y:=true; {-----------------------Up-}
  if (keys[kDown]) then y:=false; {--------------------Down-}
  if (keys[kLeft]) then car.v:=IzVector(car.v,1); {----Left-}
  if (keys[kRight]) then car.v:=IzVector(car.v,-1); {--Right-}
  if (keys[kR]) then begin car.x:=220; car.y:=150 end; {-Restart-}
  if (per>1) and (keys[kf]) then
   per:=per+50;
 if per >310 then
  per:=310
 End;

Begin
 Randomize;
 InitMeanings; {----------Initialization meanings-}
 Initall(m640x480); {-----Initialization expansion-}
 KeyboardInit;  {---------Initialization modules keyboard-}
 InitPic; {---------------Initialization images-}
 ZapMatr;
 repeat
  WriteStat; {------------Conclusion of statistics-}
  Movement(car.v,y); {----Movement on a vector-}
  AnalysKeyboard;  {------Analysis the keyboard-}
  IzRtek;
  ShowAll; {--------------Chenge screens-}
  IzSpeed(per); {-------------kpokikjuij-}
  TrackingSpeed(per); {---Trecing of speed-}
 until keys[kEsc];
 KeyboardDone;
 Doneall; {-Close modules-}
End.


