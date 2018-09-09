{VESA.PAS - version 4.0 (beta)}
{XMS}
{$A+,B-,D+,E+,F+,G-,I+,L+,N-,O-,P+,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}
Unit VESA;
Interface
  Const
    {Графические режимы}
    M640x400=$100;
    M640x480=$101;
    M800x600=$103;
    M1024x768=$105;
    M1280x1024=$107;
    {Режимы вывода изображения}
    NormalPut=0;
    AndPut=2;
    XorPut=4;
    OrPut=6;
    ShadowPut=8;
    {Режимы вывода тени}
    LightShadow=3;
    MediumShadow=4;
    DarkShadow=5;
    {Mouse buttons}
    NoButton=0;
    LeftButton=1;
    RightButton=2;
    BothButtons=3;
    {Active font}
    afRaster = true;
    afStroked = false;

  {структура, содержащая информацию о графическом режиме}
  type
    TModeInfoRec = record
                     Mode: word;
                     SizeX, SizeY: word;
                     BitsPerPixel: byte;
                   end;

  function  SupportedModesCount: word;
  procedure GetSupportedModesInfo(var Buf);

  Procedure InitAll(Mode: word);
  Procedure DoneAll;

  Function  LoadSpr(FileName:string):pointer;
  Function  LoadSpr1(Var f:file):pointer;
  Procedure GetSpriteParameters(Var x,y,Size:word);
  procedure PictureToFile(x1, y1, x2, y2: integer; FileName: string);
  procedure PictureFromFile(x, y: integer; FileName: string);
  Procedure InitHiMem;
  Procedure DoneHiMem;
  Procedure FreeHiMem(Var _pp:pointer);
  Procedure GetHiMem(Var _pp:pointer;Size:longint);
  procedure WriteToHiMem(p: pointer; var Buf; Size: longint);
  procedure ReadFromHiMem(p: pointer; var Buf; Size: longint);

  Procedure VESADone;
  Procedure VESAInit(Mode:word);

  Procedure PutPixel(x,y:integer;Color:byte);Far;
  Procedure PutSprite(x,y:integer;p:pointer);
  Procedure PutImage(x,y:integer;p:pointer;Reg:integer);
  Procedure SetVisualPage(Page:word);Far;
  Procedure SetActivePage(Page:word);Far;
  Procedure SetWSize(x1,y1,x2,y2:integer);Far;
  procedure GetWSize(var x1, y1, x2, y2: integer); far;
  Procedure Line(x1,y1,x2,y2:integer);
  Procedure Circle(x,y,Radius:integer);
  procedure Ellipse(x, y, RadiusX, RadiusY: integer);
  Procedure SetColor(NewColor:byte);Far;
  Function  GetColor:byte;Far;
  Procedure Bar(x1,y1,x2,y2:integer);Far;
  Procedure SetPalette(Var Palette);Far;
  procedure GetPalette(Var Palette);
  Procedure SetStandartPalette;Far;
  Procedure WaitVBL;Far;
  Function  GetMaxX:integer;Far;
  Function  GetMaxY:integer;Far;
  Function  ImageSize(x1,y1,x2,y2:integer):longint;
  Procedure Rectangle(x1,y1,x2,y2:integer;Color1,Color2:byte);
  Procedure GetImage(x1,y1,x2,y2:integer;p:pointer);
  Function  GetPixel(x,y:integer):byte;Far;
  Procedure OutTextXY(x,y:integer;Message:string);Far;
  function  TextWidth(s:string): integer;
  function  TextHeight(s:string): integer;
  Procedure SetUserCursor(p:pointer);Far;
  Procedure SetStandartCursor;Far;
  Procedure SetShadowMode(SM:byte);Far;
  procedure FloodFill(x, y: integer; BorderColor: byte); far;
  function  Inside(x, y, x1, y1, x2, y2: integer): boolean; far;
  procedure LoadStrokedFont(FontFile: string);
  function  StrokedFontName: string;
  function  StrokedFontInfo: string;
  procedure SetActiveFont(AFont: boolean);  {afRaster or afStroked}
  procedure SetStrokedFontScale(ScaleX, ScaleY: real);

  procedure SetUserRasterFont(var Font); far;
  procedure SetStandartRasterFont; far;

  Procedure ShowMouse;Far;
  Procedure HideMouse;Far;
  Procedure InitMouse;Far;
  Procedure DoneMouse;Far;
  Function  MouseX:integer;Far;
  Function  MouseY:integer;Far;
  Function  MouseButton:integer;Far;
  procedure SetMousePosition(x, y: word); far;
  procedure SetMouseArea(x1, y1, x2, y2: word); far;

Implementation
uses
  XMS;
Type
  pSpriteHeader=^SpriteHeader;
  SpriteHeader=Record
                 Size: longint;
                 Free: boolean;
               End;
  TFontCharacter = record
                     Width: byte;
                     Offs: word
                   end;
  TCharacters = array [char] of TFontCharacter;
  TFontData = array [0 .. 60000] of shortint;
  PFontData = ^TFontData;
  TStrokedFont = record
                   Height, Upper: byte;
                   Count: word;
                   First: byte;
                   Name: string[4];
                   Info: string;
                   Characters: TCharacters;
                   Data: PFontData
                 end;
var
  Mem, VESAFlag, MouseFlag: boolean;
  HeaderSize: word;
  GraphMode: word;
  OldMode: byte;
  ModeAttrs: array [0..255] of byte;
  MyName, TempName: string[8];
  CurSFont: TStrokedFont;
  ActiveFont, StrokedFontLoaded: boolean;
  FontScaleX, FontScaleY: real;
  SpriteX, SpriteY, SpriteSize: word;
  OldExitProc: pointer;

  {XMS variables}
  XMSBuffer: pointer;
  XMSBufferOffs, XMSBufferSize: word;
  Base: word;
  XMSSize, XMSOffset: longint;
  Header: SpriteHeader; { не }
  Reserve: byte;        { разделять }

{$L VESA.OBJ}
Procedure PutPixel(x,y:integer;Color:byte);External;
Procedure PutImage_(x,y:integer;p:pointer;Reg:integer);far;External;
Procedure PutImage__(x,y:integer;p:pointer;Reg:integer; Offset: longint; BufSize, BufOffs: word);far;External;
procedure PutSprite_(x, y: integer; p: pointer); far; external;
procedure PutSprite__(x, y: integer; p: pointer; Offset: longint; BufSize, BufOffs: word); far; external;
Procedure SetVisualPage(Page:word);External;
Procedure SetActivePage(Page:word);External;
Procedure VESAInit_;External;
Procedure Line(x1,y1,x2,y2:integer);External;
Procedure SetWSize(x1,y1,x2,y2:integer);External;
procedure GetWSize(var x1, y1, x2, y2: integer); external;
Procedure SetColor(NewColor:byte);External;
Function  GetColor:byte;External;
Procedure Bar(x1,y1,x2,y2:integer);External;
Procedure SetPalette(Var Palette);External;
procedure GetPalette(var Palette); external;
Procedure SetStandartPalette;External;
Procedure GetImage_(x1,y1,x2,y2:integer;p:pointer); far; External;
Procedure GetImage__(x1,y1,x2,y2:integer;p:pointer; Offset: longint; BufSize, BufOffs: word); far; External;
Function  GetPixel(x,y:integer):byte;External;
Procedure OutText(x,y:integer;Message:string);Far;External;
Procedure InitMouse;External;
Procedure DoneMouse;External;
Procedure ShowMouse;External;
Procedure HideMouse;External;
Function  MouseX:integer;External;
Function  MouseY:integer;External;
Function  MouseButton:integer;External;
procedure SetMousePosition(x, y: word); external;
procedure SetMouseArea(x1, y1, x2, y2: word); external;
Procedure WaitVBL;External;
Function  GetMaxX:integer;External;
Function  GetMaxY:integer;External;
Procedure SetUserCursor(p:pointer);External;
Procedure SetStandartCursor;External;
Procedure SetShadowMode(SM:byte);External;
procedure SetUserRasterFont(var Font); external;
procedure SetStandartRasterFont; external;

Procedure DoneHiMem;
Begin
  FreeMem(XMSBuffer, $8001);
  DoneXMS;
  Mem := false
End;

Procedure Error(Message:string);
Begin
  WriteLn('Ошибка: ',Message);
  If Mem Then DoneHiMem;
  Halt(1)
End;

function GetXMSOffset(p: pointer): longint;
begin
  asm
    and         word ptr p+2,0FFFh
  end;
  GetXMSOffset := longint(p);
end;

procedure FreeHiMem(var _pp: pointer);
  var
    p: pointer;
    Offset: longint;
    Offs: longint;
    Size, NewSize: longint;
begin
  CopyEMBRev(XMSOffset);
  p := _pp;
  asm
    and         word ptr p+2,0FFFh
  end;
  Offset := longint(p);
  Offset := Offset - HeaderSize;
  CopyHeader(Offset);
  NewSize := Header.Size;
  if Offset > 0
  then
    begin
      Offs := 0;
      while (Offs <> Offset) and (Offs <> XMSSize) do
      begin
        CopyHeader(Offs);
        Offs := Offs + Header.Size;
      end;
      if Offs <> Offset
      then
        Error('VESA.FreeHiMem');
      CopyHeader(Offs);
      if Header.Free
      then
        begin
          Offset := Offs;
          NewSize := NewSize + Header.Size;
        end;
    end;
  if Offset + NewSize < XMSSize
  then
    begin
      CopyHeader(Offset + NewSize);
      if Header.Free
      then
        NewSize := NewSize + Header.Size;
    end;
  Header.Size := NewSize;
  Header.Free := true;
  CopyHeaderRev(Offset);
  _pp := nil;
  CopyEMB(XMSOffset);
end;

procedure GetHiMem(var _pp:pointer; Size: longint);
  var
    Offset, Ost: longint;
    f: boolean;
    p: pointer;
begin
  CopyEMBRev(XMSOffset);
  Offset := 0;
  f := false;
  repeat
    CopyHeader(Offset);
    if (Header.Size - HeaderSize >= Size) and Header.Free
    then
      f := true
    else
      Offset := Offset + Header.Size;
  until (Offset = XMSSize) or f;
  if not f
  then
    _pp := nil
  else
    begin
      p := pointer(Offset);
      asm
        or      word ptr p+2,0F000h
        mov     ax,HeaderSize
        add     word ptr p,ax
        adc     word ptr p+2,0
      end;
      _pp := p;
      if Header.Size - HeaderSize - Size <= HeaderSize
      then
        begin
          Header.Free := false;
          CopyHeaderRev(Offset);
        end
      else
        begin
          Ost := Header.Size - Size - HeaderSize;
          Header.Size := Size + HeaderSize;
          Header.Free := false;
          CopyHeaderRev(Offset);
          Offset := Offset + Size + HeaderSize;
          Header.Size := Ost;
          Header.Free := true;
          CopyHeaderRev(Offset);
        end;
    end;
  CopyEMB(XMSOffset);
end;

procedure GetArea(Offset, Size: longint; var p: pointer; var RealSize: longint);
begin
  if (Offset >= XMSOffset) and (Offset < XMSOffset + XMSBufferSize)
  then
    begin
      p := Ptr(Base, XMSBufferOffs + (Offset - XMSOffset));
      RealSize := XMSOffset + XMSBufferSize - Offset;
    end
  else
    begin
      CopyEMBRev(XMSOffset);
      XMSOffset := Offset;
      CopyEMB(XMSOffset);
      p := Ptr(Base, XMSBufferOffs);
      RealSize := XMSBufferSize;
    end;
  if Size < RealSize
  then
    RealSize := Size;
end;

function LoadSprite(var f: file; RealSize: longint): pointer;
  var
    p1, p: pointer;
    Offset, Size: longint;
    x, s: word;
begin
  GetHiMem(p, RealSize);
  if p = nil
  then
    LoadSprite := nil
  else
    begin
      LoadSprite := p;
      Offset := GetXMSOffset(p);
      while RealSize > 0 do
      begin
        GetArea(Offset, RealSize, p1, Size);
        BlockRead(f, p1^, Size);
        RealSize := RealSize - Size;
        Offset := Offset + Size;
      end;
    end;
end;

Procedure InitHiMem;
  var
    x: word;
    Offs: word;
    p: pointer;
Begin
  InitXMS;
  GetMem(XMSBuffer, $8001);
  Mem := true;
  asm
    mov         ax,word ptr XMSBuffer
    mov         Offs,ax
    mov         ax,word ptr XMSBuffer+2
    mov         Base,ax
  end;
  Base := Base + Offs div 16;
  XMSBufferOffs := Offs mod 16;
  x := $8000 - XMSBufferOffs;
  XMSBufferSize := $8000 - XMSBufferOffs;
  if x mod 2 = 1
  then
    Inc(x);
  SetCopyParams(XMSBuffer, x);
  XMSSize := EMBSize;
  XMSSize := XMSSize * 1024;
  XMSOffset := 0;
  if HeaderSize mod 2 = 1
  then
    SetHeaderParams(Addr(Header), HeaderSize + 1)
  else
    SetHeaderParams(Addr(Header), HeaderSize);
  CopyHeader(0);
  Header.Size := XMSSize;
  Header.Free := true;
  CopyHeaderRev(0);
  CopyEMB(XMSOffset);
End;

Procedure VESAInit(Mode:word);
Begin
  New(CurSFont.Data);
  GraphMode:=Mode;
  Asm
    mov     ah,0Fh
    int     10h
    mov     byte ptr OldMode,al
    mov     ax,ds
    mov     es,ax
    mov     di,offset ModeAttrs
    mov     ax,4F01h
    mov     cx,word ptr GraphMode
    int     10h
    mov     ax,4F02h
    mov     bx,word ptr GraphMode
    int     10h
    call    far ptr VESAInit_
  End;
  VESAFlag := true
End;

Procedure VESADone;
Begin
  Asm
    mov     ah,00h
    mov     al,byte ptr OldMode
    int     10h
  End;
  Dispose(CurSFont.Data);
  VESAFlag := false
End;

Function ImageSize(x1,y1,x2,y2:integer): longint;
Begin
  ImageSize:=Abs(longint(x2-x1+1)*longint(y2-y1+1))+4
End;

Procedure Rectangle(x1,y1,x2,y2:integer;Color1,Color2:byte);
  Var
    c:byte;
Begin
  c:=GetColor;
  SetColor(Color2);
  Line(x1,y2,x2,y2);
  Line(x2,y1,x2,y2);
  SetColor(Color1);
  Line(x1,y1,x1,y2);
  Line(x1,y1,x2,y1);
  SetColor(c)
End;

Procedure Circle(x,y,Radius:integer);
  Var
    CurX,CurY,Delta,q:integer;
    Color:byte;
Begin
  Color:=GetColor;
  CurX:=0;
  CurY:=Radius;
  Delta:=1+Sqr(CurY-1)-Sqr(Radius);
  Repeat
    PutPixel(X-CurX,Y-CurY,Color);
    PutPixel(X+CurX,Y-CurY,Color);
    PutPixel(X-CurX,Y+CurY,Color);
    PutPixel(X+CurX,Y+CurY,Color);
    If Delta<0
    Then
      Begin
        q:=((Delta+CurY) shl 1)-1;
        If q<=0
        Then
          Begin
            Inc(CurX);
            Delta:=Delta+(CurX shl 1)+1
          End
        Else
          Begin
            Inc(CurX);
            Dec(CurY);
            Delta:=Delta+(CurX shl 1)-(CurY shl 1)+2
          End
      End
    Else
      If Delta>0
      Then
        Begin
          q:=((Delta-CurX) shl 1)-1;
          If q<=0
          Then
            Begin
              Inc(CurX);
              Dec(CurY);
              Delta:=Delta+(CurX shl 1)-(CurY shl 1)+2
            End
          Else
            Begin
              Dec(CurY);
              Delta:=Delta-(CurY shl 1)+1
            End
        End
      Else
        If Delta=0
        Then
          Begin
            Inc(CurX);
            Dec(CurY);
            Delta:=Delta+(CurX shl 1)-(CurY shl 1)+2
          End
  Until CurY<0
End;

procedure Ellipse(x, y, RadiusX, RadiusY: integer);
  var
    i, j, r1, r2, t, Step:real;
    x1, x2, y1, y2: integer;
    c: byte;
begin
  c := GetColor;
  x1 := x;
  x2 := x + RadiusX;
  y1 := y;
  y2 := y + RadiusY;
  if (x1 <> x2) and (y1 <> y2)
  then
    begin
      i := x2;
      j := y2;
      r1 := Abs(x1 - i); r2 := Abs(y1 - j);
      t := 0.0;
      if RadiusX > RadiusY
      then
        Step := 1 / RadiusX
      else
        Step := 1 / RadiusY;
      while t <= 2 * Pi do
      begin
        i := r1 * Cos(t) + x1;
        j := r2 * Sin(t) + y1;
        PutPixel(Round(i), Round(j), c);
        t := t + Step;
      end
    end
  else
    Line(x2, y2, x2 + 2 * (x1 - x2), y2 + 2 * (y1 - y2));
end;

procedure StrokedOutText(x, y: integer; s: string);
  var
    CurX, CurY, OldX, OldY, i, xx, a, b: integer;
    Sm: word;
    cx, cy: shortint;
begin
  OldX := x; OldY := y + Round(CurSFont.Upper * FontScaleY);
  CurX := OldX; CurY := OldY;
  for i := 1 to Length(s) do
  begin
    xx := Ord(s[i]);
    if (xx >= CurSFont.First) and (xx <= CurSFont.First + CurSFont.Count - 1)
    then
      begin
        Sm := CurSFont.Characters[s[i]].Offs;
        cx := CurSFont.Data^[Sm];
        Inc(Sm);
        while cx and $80 <> 0 do
        begin
          cy := CurSFont.Data^[Sm];
          Inc(Sm);
          if cy and $80 <> 0
          then
            begin
              cx := cx and $7F;
              cy := cy and $7F;
              if cx and $40 <> 0
              then
                cx := cx or $80;
              if cy and $40 <> 0
              then
                cy := cy or $80;
              a := Round(cx * FontScaleX);
              b := Round(cy * FontScaleY);
              Line(OldX, OldY, CurX + a, CurY - b);
            end
          else
            begin
              cx := cx and $7F;
              cy := cy and $7F;
              if cx and $40 <> 0
              then
                cx := cx or $80;
              if cy and $40 <> 0
              then
                cy := cy or $80;
              a := Round(cx * FontScaleX);
              b := Round(cy * FontScaleY);
            end;
          OldX := CurX + a;
          OldY := CurY - b;
          cx := CurSFont.Data^[Sm];
          Inc(Sm);
        end;
        CurX := OldX; CurY := OldY
      end
  end
end;

Procedure OutTextXY(x,y:integer;Message:string);
Begin
  If Message<>''
  Then
    begin
      if ActiveFont = afRaster
      then
        OutText(x,y,Message)
      else
        StrokedOutText(x, y, Message)
    end
End;

Function TextHeight(s: string): integer;
begin
  if ActiveFont = afRaster
  then
    TextHeight := 16
  else
    TextHeight := Round(CurSFont.Height * FontScaleY)
end;

function TextWidth(s: string): integer;
  var
    i: integer;
    Width: integer;
begin
  if ActiveFont = afRaster
  then
    TextWidth := Length(s) * 8
  else
    begin
      Width := 0;
      for i := 1 to Length(s) do
        if (Ord(s[i]) >= CurSFont.First) and (Ord(s[i]) <= CurSFont.First + CurSFont.Count - 1)
        then
          Width := Width + Round(CurSFont.Characters[s[i]].Width * FontScaleX);
      TextWidth := Width
    end
end;

function PointerToXMS(p: pointer): boolean;
  var
    HighByte: byte;
    pp: pointer;
begin
  pp := p;
  asm
    mov         ax,word ptr pp+2
    mov         cl,4
    shr         ah,cl
    mov         HighByte,ah
  end;
  PointerToXMS := HighByte = $0F;
end;

procedure PutSprite(x, y: integer; p: pointer);
  var
    pp: pointer;
    Offset, s: longint;
begin
  if PointerToXMS(p)
  then
    begin
      Offset := GetXMSOffset(p);
      GetArea(Offset, XMSBufferSize, pp, s);
      PutSprite__(x, y, pp, Offset, XMSBufferSize, XMSBufferOffs);
    end
  else
    PutSprite_(x, y, p);
end;

procedure WriteToHiMem(p: pointer; var Buf; Size: longint);
  var
    pp, b: pointer;
    s, Offset: longint;
    SaveSI: word;
begin
  b := Addr(Buf);
  Offset := GetXMSOffset(p);
  SaveSI := word(b);
  while Size > 0 do
  begin
    GetArea(Offset, Size, pp, s);
    Size := Size - s;
    Offset := Offset + s;
    asm
      push        cx
      push        si
      push        di
      push        ds
      push        es
      mov         cx,word ptr s
      les         di,pp
      lds         si,b
      mov         si,SaveSI
      cld
      rep movsb
      mov         SaveSI,si
      pop         es
      pop         ds
      pop         di
      pop         si
      pop         cx
    end;
  end;
end;

procedure ReadFromHiMem(p: pointer; var Buf; Size: longint);
  var
    pp, b: pointer;
    s, Offset: longint;
    SaveDI: word;
begin
  b := Addr(Buf);
  Offset := GetXMSOffset(p);
  SaveDI := word(b);
  while Size > 0 do
  begin
    GetArea(Offset, Size, pp, s);
    Size := Size - s;
    Offset := Offset + s;
    asm
      push        cx
      push        si
      push        di
      push        ds
      push        es
      mov         cx,word ptr s
      les         di,b
      mov         di,SaveDI
      lds         si,pp
      cld
      rep movsb
      mov         SaveDI,di
      pop         es
      pop         ds
      pop         di
      pop         si
      pop         cx
    end;
  end;
end;

Procedure PutImage(x,y:integer;p:pointer;Reg:integer);
  var
    Offset, s: longint;
    pp: pointer;
Begin
  if PointerToXMS(p)
  then
    begin
      Offset := GetXMSOffset(p);
      GetArea(Offset, XMSBufferSize, pp, s);
      PutImage__(x, y, pp, Reg, Offset, XMSBufferSize, XMSBufferOffs);
    end
  else
    PutImage_(x, y, p, Reg);
End;

Procedure GetImage(x1,y1,x2,y2:integer;p:pointer);
  Var
    Offset, s: longint;
    pp: pointer;
Begin
  if PointerToXMS(p)
  then
    begin
      Offset := GetXMSOffset(p);
      GetArea(Offset, XMSBufferSize, pp, s);
      GetImage__(x1, y1, x2, y2, pp, Offset, XMSBufferSize, XMSBufferOffs);
    end
  else
    GetImage_(x1, y1, x2, y2, p);
End;

{Borland stroked fonts}
procedure LoadStrokedFont(FontFile: string);
  var
    f: file;
    c: char;
    x: byte;
    y, Table, CWidth, CPointer, i, Result: word;
    z: shortint;
begin
  Assign(f, FontFile);
  Reset(f, 1);
  Seek(f, $04);
  x := 0;
  repeat
    BlockRead(f, c, 1);
    if c <> #26
    then
      begin
        Inc(x);
        CurSFont.Info[x] := c
      end;
  until c = #26;
  CurSFont.Info[0] := Chr(x);
  BlockRead(f, y, 2);
  CurSFont.Name[0] := #04;
  BlockRead(f, CurSFont.Name[1], 4);
  Seek(f, $81);
  CurSFont.Count := 0;
  BlockRead(f, CurSFont.Count, 1);
  if CurSFont.Count = 0
  then
    CurSFont.Count := 256;
  Seek(f, $84);
  BlockRead(f, CurSFont.First, 1);
  BlockRead(f, Table, 2);
  Table := Table + $80;
  Seek(f, $88);
  BlockRead(f, CurSFont.Upper, 1);
  Seek(f, $8A);
  BlockRead(f, z, 1);
  CurSFont.Height := CurSFont.Upper - z;
  CPointer := $90;
  CWidth := CPointer + CurSFont.Count * 2;
  c := Chr(CurSFont.First);
  for i := 1 to CurSFont.Count do
  begin
    Seek(f, CWidth);
    BlockRead(f, CurSFont.Characters[c].Width, 1);
    Seek(f, CPointer);
    BlockRead(f, CurSFont.Characters[c].Offs, 2);
    Inc(CWidth);
    CPointer := CPointer + 2;
    if c <> #255
    then
      c := Succ(c)
  end;
  Seek(f, Table);
  BlockRead(f, CurSFont.Data^, 60000, Result);
  Close(f);
  StrokedFontLoaded := true
end;

function StrokedFontName: string;
begin
  if StrokedFontLoaded
  then
    StrokedFontName := CurSFont.Name
end;

function StrokedFontInfo: string;
begin
  if StrokedFontLoaded
  then
    StrokedFontInfo := CurSFont.Info
end;

procedure SetActiveFont(AFont: boolean);
begin
  if not ((AFont = afStroked) and not StrokedFontLoaded)
  then
    ActiveFont := AFont
end;

procedure SetStrokedFontScale(ScaleX, ScaleY: real);
begin
  FontScaleX := ScaleX;
  FontScaleY := ScaleY
end;

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

Function LoadSpr(FileName:string):pointer;
  Var
    f:file;
    RealSize: longint;
Begin
  Assign(f,FileName);
  {$I-}
  Reset(f,1);
  If IOResult=0
  Then
    Begin
      LoadSpr := LoadSpr1(f);
      Close(f)
    End;
  {$I+}
End;

Function LoadSpr1(Var f:file):pointer;
  Var
    RealSize: longint;
Begin
  BlockRead(f,SpriteX,2);
  BlockRead(f,SpriteY,2);
  BlockRead(f,SpriteSize,2);
  RealSize := SpriteX;
  RealSize := RealSize * SpriteY + 4;
  LoadSpr1 := LoadSprite(f, RealSize);
End;

Procedure GetSpriteParameters(Var x,y,Size:word);
Begin
  x:=SpriteX;
  y:=SpriteY;
  Size:=SpriteSize
End;

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

procedure Exchange(var x, y: integer);
  var
    z: integer;
begin
  if x > y
  then
    begin
      z := x;
      x := y;
      y := z;
    end;
end;

function  Inside(x, y, x1, y1, x2, y2: integer): boolean;
begin
  Exchange(x1, x2);
  Exchange(y1, y2);
  Inside := (x >= x1) and (x <= x2) and (y >= y1) and (y <= y2);
end;

procedure FloodFill(x, y: integer; BorderColor: byte);
  type
    TStack = array [1 .. 1000] of integer;
  var
    Top: integer;
    StackX, StackY: TStack;
    xx, yy, xm, xr, xl, j: integer;
    c, cc: byte;
    f: boolean;
begin
  c := GetColor;
  Top := 1; StackX[Top] := x; StackY[Top] := y;
  while Top <> 0 do
  begin
    xx := StackX[Top]; yy := StackY[Top]; Dec(Top);
    PutPixel(xx, yy, c); xm := xx;
    while (GetPixel(xx, yy) <> BorderColor) and (xx <= GetMaxX) do
    begin
      PutPixel(xx, yy, c); Inc(xx);
    end;
    xr := xx - 1; xx := xm;
    while (GetPixel(xx, yy) <> BorderColor) and (xx >= 0) do
    begin
      PutPixel(xx, yy, c); Dec(xx);
    end;
    xl := xx + 1; j := 1;
    repeat
      yy := yy + j;
      if (yy >= 0) and (yy <= GetMaxY)
      then
        begin
          xx := xl;
          while xx <= xr do
          begin
            f := false;
            cc := GetPixel(xx, yy);
            while (cc <> BorderColor) and (cc <> c) and (xx < xr) do
            begin
              f := true; Inc(xx);
              cc := GetPixel(xx, yy);
            end;
            if f
            then
              begin
                Inc(Top); StackX[Top] := xx - 1; StackY[Top] := yy;
              end;
            repeat
              Inc(xx);
              cc := GetPixel(xx, yy);
            until not ((cc = BorderColor) or (cc = c) and (xx < xr));
          end;
        end;
      j := j - 3;
    until not (j >= -2);
  end;
end;

procedure ExitProcedure; far;
begin
  ExitProc := OldExitProc;
  if MouseFlag
  then
    DoneMouse;
  if Mem
  then
    DoneHiMem;
  if VESAFlag
  then
    VESADone
end;

function SupportedModesCount: word;
  var
    p, p1: pointer;
    Count: word;
begin
  GetMem(p, 1024);
  GetMem(p1, 512);
  Count := 0;
  asm
    les         di,dword ptr p
    mov         ax,4F00h
    int         10h
    les         di,dword ptr es:[di+0Eh]
  @NextMode:
    cmp         word ptr es:[di],0FFFFh
    jz          @EndOfList
    push        es
    push        di
    mov         ax,4F01h
    mov         cx,es:[di]
    les         di,dword ptr p1
    int         10h
    cmp         ax,004Fh
    jnz         @NotSupported
    mov         al,es:[di]
    test        al,01h
    jz          @NotSupported
    test        al,10h
    jz          @NotSupported
    cmp         byte ptr es:[di+19h],8
    jnz         @NotSupported
    inc         word ptr Count
  @NotSupported:
    pop         di
    pop         es
    add         di,2
    jmp         @NextMode
  @EndOfList:
  end;
  FreeMem(p, 1024);
  FreeMem(p1, 512);
  SupportedModesCount := Count;
end;

procedure GetSupportedModesInfo(var Buf);
  var
    p, p1, _p: pointer;
begin
  GetMem(p, 1024);
  GetMem(p1, 512);
  _p := Addr(Buf);
  asm
    les         di,dword ptr p
    mov         ax,4F00h
    int         10h
    les         di,dword ptr es:[di+0Eh]
  @NextMode:
    cmp         word ptr es:[di],0FFFFh
    jz          @EndOfList
    push        es
    push        di
    mov         ax,4F01h
    mov         cx,es:[di]
    les         di,dword ptr p1
    int         10h
    cmp         ax,004Fh
    jnz         @NotSupported
    mov         al,es:[di]
    test        al,01h
    jz          @NotSupported
    test        al,10h
    jz          @NotSupported
    cmp         byte ptr es:[di+19h],8
    jnz         @NotSupported
    push        ds
    lds         si,dword ptr _p
    mov         [si],cx
    mov         ax,es:[di+12h]
    mov         [si+2],ax
    mov         ax,es:[di+14h]
    mov         [si+4],ax
    mov         al,es:[di+19h]
    mov         [si+6],al
    pop         ds
    add         word ptr _p,7
  @NotSupported:
    pop         di
    pop         es
    add         di,2
    jmp         @NextMode
  @EndOfList:
  end;
  FreeMem(p, 1024);
  FreeMem(p1, 512);
end;

Begin
  OldExitProc := ExitProc;
  ExitProc := Addr(ExitProcedure);
  HeaderSize:=SizeOf(SpriteHeader);
  Mem:=False; VESAFlag := false; MouseFlag := false;
  MyName:='VESAMode';
  TempName:='        ';
  ActiveFont := afRaster;
  StrokedFontLoaded := false;
  FontScaleX := 1;
  FontScaleY := 1;
End.