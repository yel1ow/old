program my1;
uses vesa,keyboard;
Type TSvertWind=array[1..3]of string[12];Wind=array[1..3]of string[12];
Var Point,Point1:Pointer;sch1,{C1,}Perem1,schet_okon:integer;{sch1-schetchik svernutih okon}
    SvertWind:TSvertWind;



Procedure OnFileKey;
begin
  HideMouse;
  SetColor(25);
  Bar(20,27,120,112);{107}
  Rectangle(20,27,120,112,105,105);
  Rectangle(23,29,117,54,15,105);
  Setcolor(105);
  OutTextXY(53,35,'Open');
  Rectangle(23,57,117,82,15,105);
  Setcolor(105);
  OutTextXY(53,62,'Save');
  Rectangle(23,85,117,110,15,105);
  Setcolor(105);
  OutTextXY(57,90,'New');
  ShowMouse;
end;



Procedure OnEditKey;
begin
  HideMouse;
  SetColor(25);
  Bar(130,27,230,112);{107}
  Rectangle(130,27,230,112,105,105);
  Rectangle(133,29,227,54,15,105);
  Setcolor(105);
  OutTextXY(162,35,'Copy');
  Rectangle(133,57,227,82,15,105);
  Setcolor(105);
  OutTextXY(167,62,'Cut');
  Rectangle(133,85,227,110,15,105);
  Setcolor(105);
  OutTextXY(159,90,'Paste');
  ShowMouse;
end;






Procedure Destcop;
Var l,i,Ex1,Ex2,ExDST,Run1,Run2,RunDST,Opt1,Opt2,OptDST,Cmp1,Cmp2,CmpDST,Srch1,Srch2,SrchDST,Edt1,Edt2,EdtDST:Integer;
    MB,MX,MY:Word;Fl1,Fl2,FlDST:Integer;SvertWind:TSvertWind;
begin
  SetColor(93);
  Bar(0,0,799,599);
  SetColor(91);
  Bar(0,0,799,24);
  l:=0;
  For I:=1 to 80 do
  Begin
    Line(l,0,l,599);
    l:=l+10;
  end;
  SetColor(91);
  Bar(0,569,799,599);
  Rectangle(50,570,250,598,15,255);
  Rectangle(300,570,500,598,15,255);
  Rectangle(550,570,750,598,15,255);
  SetColor(170);
  Fl1:=20;
  Fl2:=120;
  FlDST:=50;
  Rectangle(Fl1,3,Fl2,23,15,255);
  OutTextXY(FlDST,5,'File');
  Edt1:=130;
  Edt2:=230;
  EdtDST:=165;
  Rectangle(Edt1,3,Edt2,23,15,255);
  OutTextXY(EdtDST,5,'Edit');
  Srch1:=240;
  Srch2:=340;
  SrchDST:=265;
  Rectangle(Srch1,3,Srch2,23,15,255);
  OutTextXY(SrchDST,5,'Search');
  Cmp1:=350;
  Cmp2:=450;
  CmpDST:=370;
  Rectangle(Cmp1,3,Cmp2,23,15,255);
  OutTextXY(CmpDST,5,'Compile');
  Opt1:=460;
  Opt2:=560;
  OptDST:=480;
  Rectangle(Opt1,3,Opt2,23,15,255);
  OutTextXY(OptDST,5,'Options');
  SetColor(1);
  Run1:=570;
  Run2:=670;
  RunDST:=605;
  Rectangle(Run1,3,Run2,23,15,255);
  OutTextXY(RunDST,5,'Run');
  SetColor(4);
  Ex1:=680;
  Ex2:=780;
  ExDST:=715;
  Rectangle(Ex1,3,Ex2,23,15,255);
  OutTextXY(ExDST,5,'Exit');
  SetColor(5);
  OutTextXY(55,575,SvertWind[1]);
  OutTextXY(55,575,SvertWind[2]);
  OutTextXY(55,575,SvertWind[3]);

 { If (sch1-1)=1
  Then Begin
         SetColor(255);
         OutTextXY(60,573,SvertWind[sch1]);
       end;                                  }
  SetMousePosition(400,300);
  ShowMouse;
 Repeat
    MX:=MouseX;
    MY:=MouseY;
    MB:=MouseButton;
    if ((MX>Fl1)and(MX<Fl2))and((MY>3)and(MY<25))and(MB=1)
     then begin
            OnFileKey;
          end;
    if ((MX>Edt1)and(MX<Edt2))and((MY>3)and(MY<25))and(MB=1)
    then begin
           OnEditKey;
         end;
  until ((MX>Ex1)and(MX<Ex2))and((MY>3)and(MY<25))and(MB=1);
  HideMouse;
end;






Procedure Window(x,y,q,z:integer;Name:string);
Var sc,xa,ya,qa,I:integer;MX,MY,MB:Word;SvertWind:TSvertWind;
Begin
  SvertWind[schet_okon]:=Name;
  schet_okon:=schet_okon+1;
  SetColor(163);
  Bar(x,y,q,z);
  sc:=113;
  xa:=x+1;
  ya:=y;
  qa:=q-1;
  For I:=1 to 22 do
  Begin
    sc:=sc-1;
    SetColor(sc);
    ya:=ya+1;
    Line(xa,ya,qa,ya);
  end;
  SetColor(15);
  Line(x,y,x,z);
  Line(x+1,y,x+1,z);
  SetColor(1);
  Line(q-1,y,q-1,z);
  Line(q,y,q,z);
  Line(x,z-1,q,z-1);
  Line(x,z,q,z);
  PutSprite(x+778,y+1,point);
  PutSprite(x+755,y+1,point1);
  Rectangle(x+349,y+1,x+449,y+21,15,15);
  SetColor(15);
  OutTextXY(x+359,y+3,name);
  SetColor(163);
  Line(xa,ya,qa,ya);
  SetMousePosition(400,300);
  ShowMouse;
  Repeat
    MX:=MouseX;
    MY:=MouseY;
    MB:=MouseButton;
    If (MX>(x+778))and(MX<(X+798))and(MY>(y+1))and(MY<(Y+21))and(MB=1)
    Then Begin
           HideMouse;
           Destcop;
         end;
    If (MX>(x+753))and(MX<(X+773))and(MY>(y+1))and(MY<(Y+21))and(MB=1)
    Then Begin
       {    SvertWind[sch1]:=SvertWind[sch1]+name
           sch1:=sch1+1;                        }
          { SvertWind[schet_okon]:='';     }
           SvertWind[schet_okon]:=SvertWind[schet_okon]+Name;
           HideMouse;
           Destcop;
         end;
  until MB=1;
  HideMouse;
end;





begin
  InitAll(m800x600);
  KeyboardInit;
  sch1:=1;
  Schet_okon:=1;
  For Perem1:=1 to 3 do
    SvertWind[Perem1]:='';
  Point:=Loadspr('close.spr');
  Point1:=Loadspr('svern.spr');
    Destcop;
 {   Window(0,25,799,569,'noname.***');    }
  KeyboardDone;
  DoneAll;
end.