Program Running_Man;
  Uses
    Crt,Graph;

  Const
    MaxX        = 640;
    MaxY        = 480;
    Right       = True;
    Left        = False;
    Rad         = Pi/180;
    BodyA       = -70*Rad;
    HeadR       = 5;
    BodyL       = 30;
    HipL        = 15;
    ShinL       = 15;
    ArmL        = 15;
    SholderL    = 15;

  Type
    tHead       = Record
                    x,y,Rad : Integer;
                  end;
    tManPart    = Record
                    x,y   : Integer;
                    Angle : Real
                  end;
    tSide       = Boolean;
    tArms       = Array [tSide] of tManPart;

  Var
    Head     : tHead;
    Body     : tManPart;
    Sholders : tArms;
    Arms     : tArms;
    Hips     : tArms;
    Shins    : tArms;

  Procedure GraphInit;
    Var
      Gd,Gm     : Integer;
      Res       : Word;
  Begin
    Gd:=VGA;
    Gm:=VgaHi;
    InitGraph(Gd,Gm,'');
    Res:=IoResult;
    if Res<>0
      then
        WriteLn('Graphics error : ',GraphErrorMsg(Res))
  End;

  Procedure InitMan(aX,aY : Integer);
  Begin
    With Body do
      begin
        x:=aX;
        y:=aY;
        Angle:=BodyA
      end;
    With Head do
      Begin
        x:=Round(BodyL*Cos(BodyA))+2;
        y:=Round(BodyL*Sin(BodyA))+2
      End;
  End;

  Procedure DrawMan;
    Var
      lx,ly : Integer;
  Begin
    SetColor(White);
    SetFillStyle(SolidFIll,White);
    SetLineStyle(SolidLn,0,ThickWidth);
    With Body do
      begin
        lx:=x;
        ly:=y;
        Line(x,y,x+Round(BodyL*Cos(BodyA)),y+Round(BodyL*Sin(BodyA)));
      end;
    With Head do
      Circle(lx+x,ly+y,Rad);
  End;

Begin
  GraphInit;
  InitMan(320,240);
  DrawMan;
  ReadKey;
  CloseGraph
End.