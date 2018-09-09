{VESA.PAS - version 3.0 (-)}
{GetHiMem, FreeHiMem, LoadSprite,
 PutSprite (Size <= 65532),
 GetImage  (Size <= 65532),
 PutImage  (Size <= 65532)}
{$A+,B-,D+,E+,F+,G-,I+,L+,N-,O-,P+,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
Unit VESA;
Interface
  Const
    {Графические режимы}
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
    {Размер страницы верхней памяти}
    PageSize=16384;

    {Mouse buttons}
    NoButton=0;
    LeftButton=1;
    RightButton=2;
    BothButtons=3;

    {Active font}
    afRaster = true;
    afStroked = false;

  Var
    VESAError:byte;
    Base:word;        {Сегмент окна}
    FreePages: word;
    FizPages:Array [0..3] of word;
                      {Номера страниц в окне}

  Procedure InitHiMem;     {инит. верхней памяти}
  Procedure DoneHiMem;

  Procedure FreeHiMem(Var _pp:pointer);
  Procedure GetHiMem(Var _pp:pointer;Size:longint);
  Procedure VESADone;
  Procedure VESAInit(Mode:word);
  Function  LoadSprite(Name:string):pointer;
  procedure WriteToHiMem(p: pointer; var Buf; Size: word);
  procedure ReadFromHiMem(p: pointer; var Buf; Size: word);

  Procedure PutPixel(x,y:integer;Color:byte);Far;
  Procedure PutSprite_(x,y:integer;p:pointer);Far;
  Procedure PutSprite(x,y:integer;p:pointer);
  Procedure PutImage_(x,y:integer;p:pointer;Reg:integer);Far;
  Procedure PutImage(x,y:integer;p:pointer;Reg:integer);
  Procedure SetVisualPage(Page:word);Far;
  Procedure SetActivePage(Page:word);Far;
  Procedure SetWSize(x1,y1,x2,y2:integer);Far;
  procedure GetWSize(var x1, y1, x2, y2: integer); far;
  Procedure Line(x1,y1,x2,y2:integer);
  Procedure Circle(x,y,Radius:integer);
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
  Procedure GetImage_(x1,y1,x2,y2:integer;p:pointer);Far;
  Procedure GetImage(x1,y1,x2,y2:integer;p:pointer);
  Function  GetPixel(x,y:integer):byte;Far;
  Procedure OutTextXY(x,y:integer;Message:string);Far;
  function TextWidth(s:string): integer;
  function TextHeight(s:string): integer;
  Procedure SetUserCursor(p:pointer);Far;
  Procedure SetStandartCursor;Far;
  Procedure SetShadowMode(SM:byte);Far;

  Procedure ShowMouse;Far;
  Procedure HideMouse;Far;
  Procedure InitMouse;Far;
  Procedure DoneMouse;Far;
  Function  MouseX:integer;Far;
  Function  MouseY:integer;Far;
  Function  MouseButton:integer;Far;
  procedure SetMousePosition(x, y: word); far;

  Procedure SwapPage(FizNum:byte;LogNum:word);
  Function  LoadPage(Page:word):word;
  Function  GetPageNumber(_p:pointer):word;

  {version 2.0}
  procedure LoadStrokedFont(FontFile: string);  {chr}
  function  StrokedFontName: string;
  function  StrokedFontInfo: string;
  procedure SetActiveFont(AFont: boolean);  {afRaster or afStroked}
  procedure SetStrokedFontScale(ScaleX, ScaleY: real);

Implementation
Const
  FreeBlock = 65535;
  BlockPart = 65534;
Type
  pSpriteHeader=^SpriteHeader;
  SpriteHeader=Record
                 Size:word;
                 NextSpriteOffset:word;
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
Var
  t:word;
  Handle:word;
  OldPages:Array [0..3] of byte;
  Mem:boolean;
  HeaderSize:byte;
  s:string;
  GraphMode:word;
  OldMode:byte;
  ModeAttrs:Array [0..255] of byte;
  W1,ScanLine,UWinPos:word;
  SizeX,SizeY:word;
  UlOffset:longint;
  temp:integer;
  KolHandlers,Sch:word;
  MyName,TempName:string[8];
  CurSFont: TStrokedFont;
  ActiveFont, StrokedFontLoaded: boolean;
  FontScaleX, FontScaleY: real;

Procedure PutPixel(x,y:integer;Color:byte);External;
Procedure PutImage_(x,y:integer;p:pointer;Reg:integer);External;
Procedure PutSprite_(x,y:integer;p:pointer);External;
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
Procedure GetImage_(x1,y1,x2,y2:integer;p:pointer);External;
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
Procedure WaitVBL;External;
Function  GetMaxX:integer;External;
Function  GetMaxY:integer;External;
Procedure SetUserCursor(p:pointer);External;
Procedure SetStandartCursor;External;
Procedure SetShadowMode(SM:byte);External;

procedure PutBigSprite(x, y: integer; StartPage: word); external;
{$L VESA.OBJ}

Procedure DoneHiMem;
Begin
  Asm
    mov ah,45h
    mov dx,Handle
    int 67h
  End
End;

Procedure Error(Message:string);
Begin
  WriteLn('Ошибка: ',Message);
  If Mem Then DoneHiMem;
  Halt(1)
End;

Function GetIntVector(Num:word):pointer;Assembler;
Asm
  xor ax,ax
  mov es,ax
  mov bx,Num
  shl bx,1
  shl bx,1
  mov ax,es:[bx]
  mov dx,es:[bx+2]
End;

Procedure SwapPage(FizNum:byte;LogNum:word);
  Var
    Er:byte;
Begin
  Asm
    mov ah,44h
    mov al,FizNum
    mov bx,LogNum
    mov dx,Handle
    int 67h
    mov Er,ah
  End;
  If Er<>0 Then Error('Некорректное отображение страницы');
End;

Procedure LoadOldPages;
  Var
    i:byte;
Begin
  For i:=0 to 3 do
    SwapPage(i,FizPages[i]);
End;

Procedure InitEMS;
  Var
    Er:byte;
    i:word;
    f:boolean;
    p:pointer;
    SpriteHeader:pSpriteHeader;
Begin
  p:=GetIntVector($67);
  If p=nil Then Error('Драйвер не установлен');
  Asm
    mov ah,40h
    int 67h
    mov Er,ah
  End;
  If Er<>0 Then Error('Драйвер не установлен');
  Asm
    mov ah,41h
    int 67h
    mov Base,bx
    mov ah,4Bh
    int 67h
    mov KolHandlers,bx
  End;
  Sch:=0;
  f:=false;
  While (Sch<=KolHandlers-1)and(not(f)) do
  Begin
    Asm
      mov  ax,5300h
      mov  dx,Sch
      push ds
      pop  es
      mov  di,offset TempName+1
      int  67h
    End;
    Inc(Sch);
    If MyName=TempName
    Then
      Begin
        f:=true;
        Handle:=Sch-1;
        Asm
          mov ah,4Ch
          mov dx,Handle
          int 67h
          mov FreePages,bx
        End;
      End;
  End;
  If Not(f) Then
  Begin
    Asm
      mov ah,42h
      int 67h
      mov FreePages,bx
    End;
    If FreePages<4 Then Error('Слишком мало дополнительной памяти');
    Asm
      mov ah,43h
      mov bx,FreePages
      int 67h
      mov Handle,dx
      mov Er,ah
    End;
    If Er<>0 Then Error('Невозможно разместить страницы');
    Asm
      mov ax,5301h
      mov dx,Handle
      mov si,offset MyName+1
      int 67h
    End
  End;
  Mem:=True;
  SpriteHeader:=ptr(Base,0);
  For i:=0 to FreePages-1 do
  Begin
    SwapPage(0,i);
    SpriteHeader^.Size:=65535;
    SpriteHeader^.NextSpriteOffset:=PageSize
  End;
  For i:=0 to 3 do
    Begin
      FizPages[i]:=i;
      OldPages[i]:=0;
      SwapPage(i,i)
    End
End;

Procedure CreateHeader(FizNum:byte;Offs,Size,Next:word);
  Var
    p:pSpriteHeader;
Begin
  p:=ptr(Base,FizNum*PageSize+Offs);
  p^.Size:=Size;
  p^.NextSpriteOffset:=Next
End;

Function GetPageNumber(_p:pointer):word;
  Var
    Number:word;
    p:pointer;
Begin
  p:=_p;
  Asm
    mov         ax,word ptr p+2
    and         ax,0FFFh
    mov         Number,ax
  End;
  GetPageNumber:=Number
End;

procedure GetNextPage(var i: word);
  var
    p: PSpriteHeader;
    s: longint;
begin
  SwapPage(0, i);
  p := ptr(Base, 0);
  if (p^.Size <> BlockPart) and (p^.Size <> FreeBlock) and (p^.Size > PageSize - HeaderSize)
  and not ((p^.Size = PageSize) and (p^.NextSpriteOffset = PageSize)) and (word(p) = 0)
  then
    begin
      s := p^.Size - (PageSize - HeaderSize);
      i := i + (s - 1) div PageSize + 2
    end
  else
    Inc(i)
end;

function PageStart(i: word): word;
  var
    j, Old: word;
    p: PSpriteHeader;
begin
  PageStart := 0;
  j := 0;
  while (j < FreePages) and (j < i) do
  begin
    Old := j;
    GetNextPage(j)
  end;
  if j <> i
  then
    begin
      SwapPage(0, Old);
      p := ptr(Base, 0);
      PageStart := p^.NextSpriteOffset
    end
end;

Procedure FreeHiMem(Var _pp:pointer);
  Var
    p,p1:pSpriteHeader;
    pp:pointer;
    i, Kol, j, Offs, st: word;
Begin
  pp:=_pp;
  i := GetPageNumber(pp);
  SwapPage(0, i);
  p:=ptr(Base,Word(pp)-4);
  if (p^.Size <> FreeBlock) and (p^.Size <> BlockPart) and (p^.Size > PageSize - HeaderSize)
  and not ((p^.Size = PageSize) and (p^.NextSpriteOffset = PageSize)) and (word(p) = 0)
  then
    begin
      Kol := (p^.Size - (PageSize - HeaderSize) - 1) div PageSize + 1;
      Offs := p^.NextSpriteOffset;
      for j := 1 to Kol do
      begin
        p^.Size := FreeBlock;
        p^.NextSpriteOffset := PageSize;
        Inc(i);
        SwapPage(0, i);
        p := ptr(Base, 0)
      end;
      p^.Size := FreeBlock;
      p^.NextSpriteOffset := Offs;
      if Offs <> PageSize
      then
        begin
          p1 := ptr(Base, Offs);
          if p1^.Size = FreeBlock
          then
            p^.NextSpriteOffset := p1^.NextSpriteOffset
        end
    end
  else
    begin
      while p^.Size = BlockPart do
      begin
        p^.Size := FreeBlock;
        Inc(i);
        SwapPage(0, i);
        p := ptr(Base, 0)
      end;

      p^.Size:=65535;
      If p^.NextSpriteOffset<>PageSize
      Then
        Begin
          p1:=ptr(Base,p^.NextSpriteOffset);
          If p1^.Size=65535
          Then
            p^.NextSpriteOffset:=p1^.NextSpriteOffset
        End;
      st := PageStart(i);
      SwapPage(0, i);
      If Word(p)<>st
      Then
        Begin
          p1:=ptr(Base,st);
          While p1^.NextSpriteOffset<>Word(p) do
            Word(p1):=p1^.NextSpriteOffset;
          If p1^.Size=65535
          Then
            p1^.NextSpriteOffset:=p^.NextSpriteOffset
        End;
    end;
  SwapPage(0,FizPages[0]);
  _pp:=nil
End;

function MinPageForSmall(Size: longint; var i: word; var Offs: word): boolean;
  var
    f: boolean;
    p: PSpriteHeader;
    MedSpr: boolean;
    s: longint;
begin
  i := 0;
  f := false;
  MedSpr := false;
  repeat
    SwapPage(0, i);
    p := ptr(Base, 0);
    if MedSpr
    then
      word(p) := Offs;
    MedSpr := false;
    repeat
      if (p^.Size = FreeBlock) and (p^.NextSpriteOffset - word(p) - 4 >= Size)
      then
        begin
          f := True;
          Offs := word(p)
        end
      else
        if (p^.Size <> BlockPart) and (p^.Size <> FreeBlock) and (p^.Size > PageSize - HeaderSize)
        and not ((p^.Size = PageSize) and (p^.NextSpriteOffset = PageSize)) and (word(p) = 0)
        then
          begin
            MedSpr := true;
            s := p^.Size - (PageSize - HeaderSize);
            i := i + (s - 1) div PageSize + 1;
            Offs := p^.NextSpriteOffset;
            if Offs = PageSize
            then
              begin
                Offs := 0;
                Inc(i)
              end
          end
        else
          word(p) := p^.NextSpriteOffset
    until f or (word(p) = PageSize) or MedSpr;
    if not (f or MedSpr)
    then
      Inc(i)
  until f or (i >= FreePages);
  MinPageForSmall := f
end;

function MinPageForMedium(Size: longint; var i: word): boolean;
  var
    f, f1: boolean;
    p: PSpriteHeader;
    Kol: integer;
    Ost, Start: word;
    j: integer;
begin
  i := 0;
  f := false;
  Kol := (Size - (PageSize - HeaderSize) - 1) div PageSize + 1;
  Ost := (Size - (PageSize - HeaderSize)) mod PageSize;
  if Ost = 0
  then
    Ost := PageSize;
  while (i < FreePages) and not f do
  begin
    j := 1;
    f1 := true;
    Start := i;
    while (j <= Kol) and f1 do
    begin
      SwapPage(0, i);
      p := ptr(Base, 0);
      if not ((p^.Size = FreeBlock) and (p^.NextSpriteOffset = PageSize))
      then
        f1 := false
      else
        Inc(j);
      GetNextPage(i)
    end;
    if f1
    then
      begin
        SwapPage(0, i);
        p := ptr(Base, 0);
        if (p^.Size = FreeBlock) and (p^.NextSpriteOffset >= Ost)
        then
          f := true
        else
          GetNextPage(i)
      end
  end;
  if f
  then
    i := Start;
  MinPageForMedium := f
end;

procedure GetMediumArea(var _pp: pointer; Size: longint);
  var
    i, Old, Ost: word;
    p: PSpriteHeader;
    pp: pointer;
begin
  pp := nil;
  Ost := (Size - (PageSize - HeaderSize)) mod PageSize;
  if Ost = 0
  then
    Ost := PageSize;
  if Ost < 4
  then
    Size := Size + (4 - Ost);
  if MinPageForMedium(Size, i)
  then
    begin
      Old := i;
      SwapPage(0, i);
      p := ptr(Base, 0);
      Ost := (Size - (PageSize - HeaderSize)) mod PageSize;
      if Ost = 0
      then
        Ost := PageSize;
      CreateHeader(0, word(p), Size, Ost);
      i := i + (Size - (PageSize - HeaderSize) - 1) div PageSize + 1;
      SwapPage(0, i);
      p := ptr(Base, 0);
      if p^.NextSpriteOffset > Ost + HeaderSize
      then
        CreateHeader(0, Ost, FreeBlock, p^.NextSpriteOffset)
      else
        begin
          Ost := p^.NextSpriteOffset - Ost;
          SwapPage(0, Old);
          p := ptr(Base, 0);
          CreateHeader(0, word(p), Size + Ost, PageSize)
        end;
      asm
        mov     ax,Old
        mov     word ptr pp+2,ax
        or      word ptr pp+2,0F000h
        mov     word ptr pp,4
      end
    end;
  _pp := pp;
  SwapPage(0,FizPages[0])
end;

procedure GetBigArea(var _pp: pointer; Size: longint);
  var
    i, Start, Ost, Next: word;
    p: pSpriteHeader;
    f, f1: boolean;
    CurSize: longint;
    pp: pointer;
begin
  CurSize := Size;
  i := 0;
  f := false;
  pp := nil;
  while (i <= FreePages) and not f do
  begin
    SwapPage(0,i);
    p:=ptr(Base,0);
    if (p^.Size = 65535) and (p^.NextSpriteOffset = PageSize)
    then
      begin
        Start := i;
        f1 := true;
        CurSize := CurSize - PageSize + HeaderSize;
        while (CurSize > PageSize - HeaderSize) and f1 do
        begin
          Inc(i);
          SwapPage(0,i);
          p:=ptr(Base,0);
          if (p^.Size = 65535) and (p^.NextSpriteOffset = PageSize)
          then
            CurSize := CurSize - PageSize + HeaderSize
          else
            f1 := false
        end;
        if f1
        then
          begin
            Inc(i);
            SwapPage(0,i);
            p:=ptr(Base,0);
            if (p^.Size=65535)and(p^.NextSpriteOffset-word(p)-4 >= CurSize)
            then
              begin
                f := true;
                {Нашли}
                CurSize := Size;
                i := Start;
                while CurSize > PageSize - HeaderSize do
                begin
                  SwapPage(0,i);
                  p:=ptr(Base,0);
                  CreateHeader(0, Word(p), BlockPart, PageSize);
                  CurSize := CurSize - PageSize + HeaderSize;
                  Inc(i)
                end;
                SwapPage(0,i);
                p:=ptr(Base,0);
                Ost:=p^.NextSpriteOffset-word(p)-4-CurSize;
                Next := p^.NextSpriteOffset;
                If Ost>4
                Then
                  Begin
                    CreateHeader(0,Word(p),CurSize+4,Word(p)+CurSize+4);
                    CreateHeader(0,Word(p)+CurSize+4,FreeBlock,Next)
                  End
                Else
                  CreateHeader(0,Word(p),CurSize+4+Ost,Next);
                Asm
                  mov     ax,Start
                  mov     word ptr pp+2,ax
                  or      word ptr pp+2,0F000h
                  mov     ax,4
                  mov     word ptr pp,ax
                End
              end
            else
              GetNextPage(i)
          end
        else
          GetNextPage(i)
      end
    else
      GetNextPage(i)
  end;
  _pp := pp;
  SwapPage(0,FizPages[0])
end;

Procedure GetHiMem(Var _pp:pointer; Size: longint);
  Var
    i,j:word;
    n:boolean;
    p1,pp:pointer;
    p:pSpriteHeader;
    Ost:word;
    Next, Offs:word;
Begin
  if Size > -HeaderSize + 4 * PageSize
  then
    GetBigArea(_pp, Size)
  else
    if Size > PageSize - HeaderSize
    then
      GetMediumArea(_pp, Size)
    else
      begin
        pp := nil;
        if MinPageForSmall(Size, i, Offs)
        then
          Begin
            SwapPage(0, i);
            p := ptr(Base, Offs);
            Ost := p^.NextSpriteOffset - word(p) - (Size + HeaderSize);
            Next := p^.NextSpriteOffset;
            If Ost>4
            Then
              Begin
                CreateHeader(0,Word(p),Size+4,Word(p)+Size+4);
                CreateHeader(0,Word(p)+Size+4,65535,Next)
              End
            Else
              CreateHeader(0,Word(p),Size+4+Ost,Next);
            Asm
              mov     ax,i
              mov     word ptr pp+2,ax
              or      word ptr pp+2,0F000h
            End;
            i:=Word(p)+4;
            Asm
              mov     ax,i
              mov     word ptr pp,ax
            End;
          End;
        _pp:=pp;
        SwapPage(0,FizPages[0])
      end
End;

Function LoadSprite(Name:string):pointer;
  Var
    f:file;
    x,Size, i:word;
    p1,p:pointer;
    RealSize: longint;
Begin
  {$I-}
  Assign(f,Name);
  Reset(f,1);
  {$I+}
  If (IOResult=0) Then
    Begin
      BlockRead(f,x,2);
      RealSize := x;
      BlockRead(f,x,2);
      RealSize := RealSize * x + 4;
      BlockRead(f, Size, 2);

      VESAError:=0;
      GetHiMem(p, RealSize);
      If VESAError<>0 Then
        LoadSprite:=nil
      Else
        Begin
          LoadSprite:=p;
          i := GetPageNumber(p);
          if (RealSize > PageSize - HeaderSize) and (RealSize <= -HeaderSize + PageSize * 4)
          then
            begin
              SwapPage(0, i);
              p1 := ptr(Base, 4);
              BlockRead(f, p1^, PageSize - HeaderSize);
              RealSize := RealSize - PageSize + HeaderSize;
              Inc(i);
              while RealSize > PageSize do
              begin
                SwapPage(0, i);
                p1:=ptr(Base, 0);
                BlockRead(f,p1^, PageSize);
                RealSize := RealSize - PageSize;
                Inc(i)
              end;
              SwapPage(0, i);
              p1:=ptr(Base, 0);
              BlockRead(f,p1^,RealSize)
            end
          else
            begin
              while RealSize > PageSize - HeaderSize do
              begin
                SwapPage(0, i);
                p1:=ptr(Base, 4);
                BlockRead(f,p1^,PageSize - HeaderSize);
                RealSize := RealSize - PageSize + HeaderSize;
                Inc(i)
              end;
              SwapPage(0, i);
              p1:=ptr(Base, word(p));
              BlockRead(f,p1^,RealSize)
            end;
          SwapPage(0,FizPages[0])
        End;

      Close(f);
    End
  Else
    Begin
      VESAError:=$FF;
      LoadSprite:=nil;
    End;
End;

Function LoadPage(Page:word):word;
  Var
    Max,i:word;
    n:word;
Begin
  Max:=0;n:=0;
  i:=0;
  While not((i>3)or(Page=FizPages[i])) do
    Begin
      If OldPages[i]>Max
      Then
        Begin
          Max:=OldPages[i];
          n:=i
        End;
      If OldPages[i]<255 Then OldPages[i]:=OldPages[i]+1;
      Inc(i)
    End;
  If i<=3 Then
    Begin
      OldPages[i]:=0;
      LoadPage:=i*PageSize
    End
  Else
    Begin
      SwapPage(n,Page);
      LoadPage:=n*PageSize;
      FizPages[n]:=Page;
      OldPages[n]:=0
    End
End;

Procedure InitHiMem;
Begin
  InitEMS
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
End;

Procedure VESADone;
Begin
  Asm
    mov     ah,00h
    mov     al,byte ptr OldMode
    int     10h
  End;
  Dispose(CurSFont.Data)
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
{$R-}
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
{$R+}
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

Procedure PutSprite(x,y:integer;p:pointer);
  Var
    pp, pp1: pSpriteHeader;
    HiByte:byte;
    Start, s: word;
    i: byte;
Begin
  pp:=p;
  Asm
    mov         ax,word ptr pp+2
    mov         cl,4
    shr         ah,cl
    mov         HiByte,ah
  End;
  If HiByte=$0F
  Then
    Begin
      pp:=ptr(Base,LoadPage(GetPageNumber(p))+Word(p));
      pp1 := pp;
      word(pp1) := word(pp1) - 4;
      if pp1^.Size = BlockPart
      then
        PutBigSprite(x, y, GetPageNumber(p))
      else
        begin
          if (pp1^.Size <> BlockPart) and (pp1^.Size <> FreeBlock) and (pp1^.Size > PageSize - HeaderSize)
          and not ((pp1^.Size = PageSize) and (pp1^.NextSpriteOffset = PageSize)) and (word(pp1) mod PageSize = 0)
          then
            begin
              s := pp1^.Size;
              Start := GetPageNumber(p);
              SwapPage(0, Start);
              pp := ptr(Base, 4);
              for i := 1 to (-PageSize + s + HeaderSize - 1) div PageSize + 1 do
              begin
                Inc(Start);
                SwapPage(i, Start)
              end;
              PutSprite_(x,y,pp);
              LoadOldPages
            end
          else
            PutSprite_(x,y,pp)
        end
    End
  Else
    PutSprite_(x,y,p)
End;

procedure WriteToHiMem(p: pointer; var Buf; Size: word);
  var
    pp, b: pointer;
    s: word;
begin
  s := Size; b := Addr(Buf);
  pp:=ptr(Base,LoadPage(GetPageNumber(p))+Word(p));
  asm
    push        ds
    push        es
    mov         cx,s
    les         di,pp
    lds         si,b
    cld
    rep movsb
    pop         es
    pop         ds
  end
end;

procedure ReadFromHiMem(p: pointer; var Buf; Size: word);
  var
    pp, b: pointer;
    s: word;
begin
  s := Size; b := Addr(Buf);
  pp:=ptr(Base,LoadPage(GetPageNumber(p))+Word(p));
  asm
    push        ds
    push        es
    mov         cx,s
    les         di,b
    lds         si,pp
    cld
    rep movsb
    pop         es
    pop         ds
  end
end;

Procedure PutImage(x,y:integer;p:pointer;Reg:integer);
  Var
    pp, pp1: PSpriteHeader;
    HiByte:byte;
    s, Start, i: word;
Begin
  pp:=p;
  Asm
    mov         ax,word ptr pp+2
    mov         cl,4
    shr         ah,cl
    mov         HiByte,ah
  End;
  If HiByte=$0F
  Then
    Begin
      pp:=ptr(Base,LoadPage(GetPageNumber(p))+Word(p));
      pp1 := pp;
      word(pp1) := word(pp1) - 4;
      if (pp1^.Size <> BlockPart) and (pp1^.Size <> FreeBlock) and (pp1^.Size > PageSize - HeaderSize)
      and not ((pp1^.Size = PageSize) and (pp1^.NextSpriteOffset = PageSize)) and (word(pp1) mod PageSize = 0)
      then
        begin
          s := pp1^.Size;
          Start := GetPageNumber(p);
          SwapPage(0, Start);
          pp := ptr(Base, 4);
          for i := 1 to (-PageSize + s + HeaderSize - 1) div PageSize + 1 do
          begin
            Inc(Start);
            SwapPage(i, Start)
          end;
          PutImage_(x, y, pp, Reg);
          LoadOldPages
        end
      else
        PutImage_(x, y, pp, Reg)
    End
  Else
    PutImage_(x,y,p,Reg)
End;

Procedure GetImage(x1,y1,x2,y2:integer;p:pointer);
  Var
    pp1, pp: PSpriteHeader;
    HiByte:byte;
    Start, i, s: word;
Begin
  pp:=p;
  Asm
    mov         ax,word ptr pp+2
    mov         cl,4
    shr         ah,cl
    mov         HiByte,ah
  End;
  If HiByte=$0F
  Then
    Begin
      pp:=ptr(Base,LoadPage(GetPageNumber(p))+Word(p));
      pp1 := pp;
      word(pp1) := word(pp1) - 4;
      if (pp1^.Size <> BlockPart) and (pp1^.Size <> FreeBlock) and (pp1^.Size > PageSize - HeaderSize)
      and not ((pp1^.Size = PageSize) and (pp1^.NextSpriteOffset = PageSize)) and (word(pp1) mod PageSize = 0)
      then
        begin
          s := pp1^.Size;
          Start := GetPageNumber(p);
          SwapPage(0, Start);
          pp := ptr(Base, 4);
          for i := 1 to (-PageSize + s + HeaderSize - 1) div PageSize + 1 do
          begin
            Inc(Start);
            SwapPage(i, Start)
          end;
          GetImage_(x1, y1, x2, y2, pp);
          LoadOldPages
        end
      else
        GetImage_(x1,y1,x2,y2,pp)
    End
  Else
    GetImage_(x1,y1,x2,y2,p)
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


Begin
  VESAError:=0;
  {CurrentSprite:=0;}
  HeaderSize:=SizeOf(SpriteHeader);
  Mem:=False;
  ScanLine:=0;
  MyName:='VESAMode';
  TempName:='        ';
  ActiveFont := afRaster;
  StrokedFontLoaded := false;
  FontScaleX := 1;
  FontScaleY := 1
End.