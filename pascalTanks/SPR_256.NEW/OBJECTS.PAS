{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,10360}
Unit Objects;
Interface

  Procedure InitAll(Mode: word);
  Procedure DoneAll;

  Function  LoadSpr(FileName:string):pointer;
  Function  LoadSpr1(Var f:file):pointer;
  Procedure GetSpriteParameters(Var x,y,Size:word);

  Procedure SetButtonTexture(FileName:string);
  Procedure SetWindowTexture(FileName:string);
  Procedure SetLabelTexture(FileName:string);
  Procedure SetEditTexture(FileName:string);
  function  GetButtonTexture: string;
  function  GetWindowTexture: string;
  function  GetLabelTexture: string;
  function  GetEditTexture: string;

  Procedure DrawButton(x1,y1,x2,y2:word;s:string;Press,Focus:boolean);
  procedure DrawPicButton(x1,y1,x2,y2:word;s:string;Press,Focus:boolean; Pic: pointer; sx, sy: integer);
  Procedure DrawWindow(x1,y1,x2,y2:integer);
  Procedure ShowWindow(x1,y1,x2,y2:integer);
  Procedure Ramka(x1,y1,x2,y2:integer);
  Procedure DrawLabel(x1,y1,x2,y2:word;s:string);
  Procedure DrawEdit(x1,y1,x2,y2:word;s:string);
  Procedure DrawScreen(X1,Y1,X2,Y2: integer;const Name: string);

  procedure PictureToFile(x1, y1, x2, y2: integer; FileName: string);
  procedure PictureFromFile(x, y: integer; FileName: string);

Implementation
  Uses
    VESA;

  type
    TTextureColorCorrect = array [0 .. 255, -5 .. 5] of byte;

  Var
    ButtonTexture, WindowTexture, LabelTexture, EditTexture: string;
    SpriteX,SpriteY,SpriteSize:word;
    TCC: TTextureColorCorrect;

Procedure InitAll(Mode: word);
Begin
  VESAInit(Mode);
  InitHiMem;
  InitMouse
End;

Procedure DoneAll;
Begin
  DoneMouse;
  DoneHiMem;
  VESADone
End;

Procedure SetButtonTexture(FileName:string);
Begin
  ButtonTexture:=FileName
End;

Procedure SetWindowTexture(FileName:string);
Begin
  WindowTexture:=FileName
End;

Procedure SetLabelTexture(FileName:string);
Begin
  LabelTexture:=FileName
End;

Procedure SetEditTexture(FileName:string);
Begin
  EditTexture:=FileName
End;

function GetButtonTexture: string;
begin
  GetButtonTexture := ButtonTexture
end;

function GetWindowTexture: string;
begin
  GetWindowTexture := WindowTexture
end;

function GetLabelTexture: string;
begin
  GetLabelTexture := LabelTexture
end;

function GetEditTexture: string;
begin
  GetEditTexture := EditTexture
end;

Function LoadSpr(FileName:string):pointer;
  Var
    f:file;
Begin
  Assign(f,FileName);
  {$I-}
  Reset(f,1);
  If IOResult=0
  Then
    Begin
      BlockRead(f,SpriteX,2);
      BlockRead(f,SpriteY,2);
      BlockRead(f,SpriteSize,2);
      Close(f)
    End;
  {$I+}
  LoadSpr:=LoadSprite(FileName)
End;

Function LoadSpr1(Var f:file):pointer;
  Var
    p,p1:pointer;
Begin
  BlockRead(f,SpriteX,2);
  BlockRead(f,SpriteY,2);
  BlockRead(f,SpriteSize,2);
  If SpriteSize<=PageSize-4
  Then
    Begin
      VESAError:=0;
      GetHiMem(p,SpriteSize);
      If VESAError=0
      Then
        Begin
          LoadSpr1:=p;
          SwapPage(0,GetPageNumber(p));
          p1:=ptr(Base,Word(p));
          BlockRead(f,p1^,SpriteSize);
          SwapPage(0,FizPages[0])
        End
      Else
        LoadSpr1:=nil
    End
  Else
    Begin
      VESAError:=$FF;
      LoadSpr1:=nil
    End;
End;

Procedure GetSpriteParameters(Var x,y,Size:word);
Begin
  x:=SpriteX;
  y:=SpriteY;
  Size:=SpriteSize
End;

procedure DrawButton(x1,y1,x2,y2:word;s:string;Press,Focus:boolean);
type
  TSpriteHeader = record
    X,Y: word;
  end;
  TPixels = array [0..1023] of byte;

var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;
  Len: integer;
  X3,Y3: integer;

  function GetLinePos(X,Y: longint): Longint;
  begin
    X:=X mod SHead.X;
    Y:=Y mod SHead.Y;
    GetLinePos:=10+X+Y*SHead.X;
  end;

begin
{  if Focus
  then Rectangle(X1+2,Y1+2,X2-2,Y2-2,120,120)
  else} Rectangle(X1+2,Y1+2,X2-2,Y2-2,36,36);
  {}
  X1:=X1+3;
  X2:=X2-3;
  Y1:=Y1+3;
  Y2:=Y2-3;
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  Assign(Source,ButtonTexture);
  {Insert a check}
  Reset(Source,1);
  {Read sprite header}
  BlockRead(Source,SHead,SizeOf(SHead));
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(longint(SprBufer),4);
  {Vertical part}
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to YSize-1 do begin
    Seek(Source,GetLinePos(X1,Y1+Index));
    BlockRead(Source,SprBufer^,XSize);
{    if not Focus
    then} for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +5];
    if Index=0+Byte(press)
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -3];
    if Index=YSize-1
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +5];
    if Index=1+Byte(press)
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -1];
    if Index=YSize-2
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +3];
    If Index<YSize-1
    Then
      Begin
        TPixels(SprBufer^)[0+Byte(press)]:=TCC[TPixels(SprBufer^)[0+Byte(press)], -3];
        TPixels(SprBufer^)[XSize-1]:=TCC[TPixels(SprBufer^)[XSize-1], +5];
        TPixels(SprBufer^)[1+Byte(press)]:=TCC[TPixels(SprBufer^)[1+Byte(press)], -1];
        TPixels(SprBufer^)[XSize-2]:=TCC[TPixels(SprBufer^)[XSize-2], +3]
      End;
    if Press
    then begin
      for SubIndex:=0 to XSize-1 do
        TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +5];
      If Index<YSize-1
      Then
        TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], +5];
    end;
    PutSprite(X1,Y1+Index,MemLine);
  end;
  Close(Source);
  FreeMem(MemLine,1024);
  Len:=Length(s);
  X3:=(x1+x2-Len*8) div 2;
  Y3:=(y1+y2-16) div 2;
  SetColor(8);
  OutTextXY(x3+Byte(press),y3+1+Byte(press),s);
  OutTextXY(x3+1+Byte(press),y3+Byte(press),s);
  OutTextXY(x3+1+Byte(press),y3+1+Byte(press),s);
  if Not (Press) and not Focus
  then SetColor(15)
  else SetColor(119);
  OutTextXY((x3)+Byte(press),Y3+Byte(press),s);
end;

procedure DrawPicButton(x1,y1,x2,y2:word;s:string;Press,Focus:boolean; Pic: pointer; sx, sy: integer);
begin
  DrawButton(x1,y1,x2,y2,s,Press,Focus);
  PutSprite(x1 + sx + byte(Press), y1 + sy + byte(Press), Pic)
end;

procedure Ramka(x1,y1,x2,y2:integer);
type
  TSpriteHeader = record
    X,Y: word;
  end;
  TPixels = array [0..1023] of byte;

var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;

  function GetLinePos(X,Y: longint): Longint;
  begin
    X:=X mod SHead.X;
    Y:=Y mod SHead.Y;
    GetLinePos:=10+X+Y*SHead.X;
  end;

begin
  {}
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  Assign(Source,WindowTexture);
  {Insert a check}
  Reset(Source,1);
  {Read sprite header}
  BlockRead(Source,SHead,SizeOf(SHead));
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(Longint(SprBufer),4);
  {Vertical part}
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to 9 do begin
    Seek(Source,GetLinePos(X1,Y1+Index));
    BlockRead(Source,SprBufer^,XSize);
    if Index=0
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -4];
    if Index=9
    then for SubIndex:=9 to XSize-10 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +4];
    TPixels(SprBufer^)[0]:= TCC[TPixels(SprBufer^)[0], -4];
    TPixels(SprBufer^)[XSize-1]:=TCC[TPixels(SprBufer^)[XSize-1], +4];
    PutSprite(X1,Y1+Index,MemLine);
  end;
  for Index:=0 to 9 do begin
    Seek(Source,GetLinePos(X1,Y2-9+Index));
    BlockRead(Source,SprBufer^,XSize);
    if Index=0
    then for SubIndex:=9 to XSize-10 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -4];
    if Index=9
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +4];
    TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], -4];
    TPixels(SprBufer^)[XSize-1]:=TCC[TPixels(SprBufer^)[XSize-1], +4];
    PutSprite(X1,Y2-9+Index,MemLine);
  end;
  TSpriteHeader(MemLine^).X:=10;
  for Index:=Y1+10 to Y2-10 do begin
    {Left}
    Seek(Source,GetLinePos(X1,Index));
    BlockRead(Source,SprBufer^,10);
    TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], -4];
    TPixels(SprBufer^)[9]:=TCC[TPixels(SprBufer^)[9], +4];
    PutSprite(X1,Index,MemLine);
    {Right}
    Seek(Source,GetLinePos(X2-9,Index));
    BlockRead(Source,SprBufer^,10);
    TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], -4];
    TPixels(SprBufer^)[9]:=TCC[TPixels(SprBufer^)[9], +4];
    PutSprite(X2-9,Index,MemLine);
  end;
  Close(Source);
  FreeMem(MemLine,1024);
end;

Procedure DrawWindow(x1,y1,x2,y2:integer);
type
  TSpriteHeader = record
    X,Y: word;
  end;
  TPixels = array [0..1023] of byte;

var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;

  function GetLinePos(X,Y: longint): Longint;
  begin
    X:=X mod SHead.X;
    Y:=Y mod SHead.Y;
    GetLinePos:=10+X+Y*SHead.X;
  end;

begin
  Ramka(X1,Y1,X2,Y2);
  {}
  X1:=X1+10;
  X2:=X2-10;
  Y1:=Y1+10;
  Y2:=Y2-10;
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  Assign(Source,WindowTexture);
  {Insert a check}
  Reset(Source,1);
  {Read sprite header}
  BlockRead(Source,SHead,SizeOf(SHead));
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(Longint(SprBufer),4);
  {Vertical part}
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to YSize-1 do begin
    Seek(Source,GetLinePos(X1,Y1+Index));
    BlockRead(Source,SprBufer^,XSize);
    if Index<2
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -4];
    if Index>YSize-3
    then for SubIndex:=0 to XSize-3 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +5];
    TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], -4];
    TPixels(SprBufer^)[XSize-1]:=TCC[TPixels(SprBufer^)[XSize-1], +5];
    TPixels(SprBufer^)[1]:= TCC[TPixels(SprBufer^)[1], -4];
    TPixels(SprBufer^)[XSize-2]:=TCC[TPixels(SprBufer^)[XSize-2], +5];
    PutSprite(X1,Y1+Index,MemLine);
  end;
  Close(Source);
  FreeMem(MemLine,1024);
end;

Procedure ShowWindow(x1,y1,x2,y2:integer);
type
  TSpriteHeader = record
    X,Y: word;
  end;
  TPixels = array [0..1023] of byte;

var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;

begin
  Ramka(x1,y1,x2,y2);
  {}
  X1:=X1+10;
  X2:=X2-10;
  Y1:=Y1+10;
  Y2:=Y2-10;
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(Longint(SprBufer),4);
  {Vertical part}
  FillChar(MemLine^,1024,1);
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to YSize-1 do begin
    PutImage(X1,Y1+Index,MemLine,ShadowPut);
  end;
  FreeMem(MemLine,1024)
end;

Procedure DrawLabel(x1,y1,x2,y2:word;s:string);
type
  TSpriteHeader = record
    X,Y: word;
  end;
  TPixels = array [0..1023] of byte;

var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;
  Len: integer;
  X3,Y3: integer;

  function GetLinePos(X,Y: longint): Longint;
  begin
    X:=X mod SHead.X;
    Y:=Y mod SHead.Y;
    GetLinePos:=10+X+Y*SHead.X;
  end;

begin
  X1:=X1+2;
  X2:=X2-2;
  Y1:=Y1+2;
  Y2:=Y2-2;
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  Assign(Source,LabelTexture);
  {Insert a check}
  Reset(Source,1);
  {Read sprite header}
  BlockRead(Source,SHead,SizeOf(SHead));
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(Longint(SprBufer),4);
  {Vertical part}
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to YSize-1 do begin
    Seek(Source,GetLinePos(X1,Y1+Index));
    BlockRead(Source,SprBufer^,XSize);
{    for SubIndex:=0 to XSize-1 do
        TPixels(SprBufer^)[SubIndex]:=TPixels(SprBufer^)[SubIndex]+60;}
    if Index=0
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -3];
    if Index=YSize-1
    then for SubIndex:=0 to XSize-2 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +5];
    if Index=1
    then for SubIndex:=0 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -1];
    if Index=YSize-2
    then for SubIndex:=0 to XSize-2 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +3];
    TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], -3];
    TPixels(SprBufer^)[XSize-1]:=TCC[TPixels(SprBufer^)[XSize-1], +5];
    TPixels(SprBufer^)[1]:=TCC[TPixels(SprBufer^)[1], -1];
    TPixels(SprBufer^)[XSize-2]:=TCC[TPixels(SprBufer^)[XSize-2], +3];
    PutSprite(X1,Y1+Index,MemLine);
  end;
  Close(Source);
  FreeMem(MemLine,1024);
  SetColor(8);
  Len:=Length(s);
  X3:=(x1+x2-Len*8) div 2;
  Y3:=(y1+y2-16) div 2;
  OutTextXY(x3,y3+1,s);
  OutTextXY(x3+1,y3,s);
  OutTextXY(x3+1,y3+1,s);
  SetColor(114);
  OutTextXY((x3),Y3,s)
end;

Procedure DrawScreen(X1,Y1,X2,Y2: integer;const Name: string);
type
  TSpriteHeader = record
    X,Y: word;
  end;
  TPixels = array [0..1023] of byte;

var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;

  function GetLinePos(X,Y: longint): Longint;
  begin
    X:=X mod SHead.X;
    Y:=Y mod SHead.Y;
    GetLinePos:=10+X+Y*SHead.X;
  end;

begin
  {}
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  Assign(Source,Name);
  {Insert a check}
  Reset(Source,1);
  {Read sprite header}
  BlockRead(Source,SHead,SizeOf(SHead));
  if SHead.X<XSize
  then XSize:=SHead.X;
  if SHead.Y<YSize
  then YSize:=SHead.Y;
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(Longint(SprBufer),4);
  {Vertical part}
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to YSize-1 do begin
    Seek(Source,GetLinePos(0,Index));
    BlockRead(Source,SprBufer^,XSize);
    PutSprite(X1,Y1+Index,MemLine);
  end;
  Close(Source);
  FreeMem(MemLine,1024);
end;

procedure DrawEdit(x1,y1,x2,y2:word;s:string);
type
  TPixels = array [0..1023] of byte;
  tSpriteHeader=record
                  x,y:word;
                end;
var
  Source: File;
  MemLine: pointer;
  SprBufer: pointer;
  SHead: TSpriteHeader;
  XSize, YSize: integer;
  Index: integer;
  SubIndex: integer;
  Len: integer;
  X3,Y3: integer;
  TextPart: integer;

  function GetLinePos(X,Y: longint): Longint;
  begin
    X:=X mod SHead.X;
    Y:=Y mod SHead.Y;
    GetLinePos:=X+Y*SHead.X;
  end;

begin
  X1:=X1+2;
  X2:=X2-2;
  Y1:=Y1+2;
  Y2:=Y2-2;
  XSize:=X2-X1+1;
  YSize:=Y2-Y1+1;
  Assign(Source,EditTexture);
  {Insert a check}
  Reset(Source,1);
  {Read sprite header}
  BlockRead(Source,SHead,SizeOf(SHead));
  {Get memory}
  GetMem(MemLine,1024);
  SprBufer:=MemLine;
  Inc(Longint(SprBufer),4);
  {Vertical part}
  TSpriteHeader(MemLine^).X:=XSize;
  TSpriteHeader(MemLine^).Y:=1;
  for Index:=0 to YSize-1 do begin
    Seek(Source,GetLinePos(X1,Y1+Index));
    BlockRead(Source,SprBufer^,XSize);
{    for SubIndex:=0 to XSize-1 do
        TPixels(SprBufer^)[SubIndex]:=TPixels(SprBufer^)[SubIndex]+60;}
    if Index=0
    then for SubIndex:=1 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +5];
    if Index=YSize-1
    then for SubIndex:=1 to XSize-2 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -3];
    if Index=1
    then for SubIndex:=1 to XSize-1 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], +3];
    if Index=YSize-2
    then for SubIndex:=1 to XSize-2 do
           TPixels(SprBufer^)[SubIndex]:=TCC[TPixels(SprBufer^)[SubIndex], -1];
    TPixels(SprBufer^)[0]:=TCC[TPixels(SprBufer^)[0], +5];
    TPixels(SprBufer^)[XSize-1]:=TCC[TPixels(SprBufer^)[XSize-1], -3];
    TPixels(SprBufer^)[1]:=TCC[TPixels(SprBufer^)[1], +3];
    TPixels(SprBufer^)[XSize-2]:=TCC[TPixels(SprBufer^)[XSize-2], -1];
    PutSprite(X1,Y1+Index,MemLine);
  end;
  FreeMem(MemLine,1024);
  TextPart:=(Abs(X2-X1)-10) div 8;
  Len:=Length(s);
  X3:=X1+5;
  Y3:=y1+2;
  SetColor(114);
  while S<>'' do begin
    OutTextXY(x3,Y3,Copy(s,1,TextPart));
    Delete(S,1,TextPart);
    Y3:=Y3+16;
  end;
  Close(Source)
end;

procedure ReadTCC;
  var
    f: file;
begin
  Assign(f, 'vesa.tcc');
  Reset(f, 1);
  BlockRead(f, TCC, SizeOf(TCC));
  Close(f)
end;

procedure PictureToFile(x1, y1, x2, y2: integer; FileName: string);
  var
    f: file;
    p: pointer;
    x: word;
    i: integer;
begin
  Assign(f, FileName);
  Rewrite(f, 1);
  x := x2 - x1 + 1;
  BlockWrite(f, x, 2);
  x := y2 - y1 + 1;
  BlockWrite(f, x, 2);
  GetMem(p, ImageSize(x1, 0, x2, 0));
  for i := y1 to y2 do
  begin
    GetImage(x1, i, x2, i, p);
    BlockWrite(f, p^, ImageSize(x1, 0, x2, 0))
  end;
  FreeMem(p, ImageSize(x1, 0, x2, 0));
  Close(f)
end;

procedure PictureFromFile(x, y: integer; FileName: string);
  var
    p: pointer;
    f: file;
    i: integer;
    sx, sy: word;
begin
  Assign(f, FileName);
  Reset(f, 1);
  BlockRead(f, sx, 2);
  BlockRead(f, sy, 2);
  GetMem(p, ImageSize(1, 0, sx, 0));
  for i := y to y + sy - 1 do
  begin
    BlockRead(f, p^, ImageSize(1, 0, sx, 0));
    PutSprite(x, i, p)
  end;
  FreeMem(p, ImageSize(1, 0, sx, 0));
  Close(f)
end;

Begin
  ButtonTexture := 'buttons.dat';
  WindowTexture := 'texture.dat';
  EditTexture := 'labels.dat';
  LabelTexture := 'labels.dat';
  ReadTCC
End.