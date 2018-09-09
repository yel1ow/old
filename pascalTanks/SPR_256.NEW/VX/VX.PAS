xunit VX;
{VESA support module VSM_2.50NB85}
{$G+ $N+}

interface

  const
    M640x400       = $100;
    M640x480       = $101;
    M800x600       = $103;
    M1024x768      = $105;
    M1280x1024     = $107;
    NormalPut      = 0;
    XORPut         = 1;
    ORPut          = 2;
    ANDPut         = 3;
    X0Put          = 4;
    ShadowPut      = 5;
    GlassPut       = 6;
    TexturePut     = 7;
    PolarMode      = $80;
    MatrixMode     = $40;
    VectorMode     = $20;

    NoButton       = 0;
    LeftButton     = 1;
    RightButton    = 2;
    BothButtons    = 3;
    Transparent    = 0;
    Black          = 42;
    Blue           = 1;
    Green          = 2;
    Cyan           = 3;
    Red            = 4;
    Magenta        = 5;
    Brown          = 6;
    LightGray      = 7;
    DarkGray       = 8;
    LightBlue      = 9;
    LightGreen     = 10;
    LightCyan      = 11;
    LightRed       = 12;
    LightMagenta   = 13;
    Yellow         = 14;
    White          = 15;

  procedure PutSpriteS(x,y:integer; p:pointer); far;
  procedure AddSpecialArea (x1,y1,x2,y2 : word; Anim : pointer); far;
  procedure AddSprBlock(x,y:word;p:pointer);far;
  procedure Bar (x1,y1,x2,y2 : word); far;
  procedure BorlandFontInit;
  procedure BorlandOutTextXY (x, y : integer; Message : string; PFont : pointer);
  procedure BorlandSetTextSize (NewSize : byte);
  procedure BorlandSetUserCharSize (MX, DX, MY, DY : byte);
  procedure DelSpecialArea (Number : byte); far;
  procedure DelSprBlock(x,y:word); far;
  procedure GetImage (x1,y1,x2,y2 : integer; p : pointer); far;
  function  GetMapVal(x,y:word):word;far;
  function  GetMaxX : word; far;
  function  GetMaxY : word; far;
  procedure GetModeInfo (ModeN : word); far;
  function  GetPixel (x,y : integer) : byte;
  function  GraphResult : byte; far;
  procedure GrayScale (Start,Count : word); far;
  procedure HideMouse; far;
  function  ImageSize (x1,y1,x2,y2 : integer) : word; far;
  procedure Line (x1,y1,x2,y2 : integer); far;
  function  LoadSprite(p:pointer):pointer; far;
  procedure MirrorPage; far;
  procedure MouseAutoDetect; far;
  function  MouseButton : integer; far;
  function  MouseInactive : integer; far;
  function  MouseX : integer; far;
  function  MouseY : integer; far;
  procedure NullPalette; far;
  function  NumOfSpecialAreas : byte; far;
  procedure OutTextXY (x,y : word; Msg : string); far;
  procedure PutImage (x,y : integer; p : pointer; Op : byte); far;
  procedure PutPixel (x,y : integer; Color : byte); far;
  procedure PutSprite(x,y:integer; p:pointer); far;
  procedure ReadDACBlock (Start,Count : word; Store : pointer); far;
  procedure ReadDACRegister (Reg : word; var _Red,_Green,_Blue : byte); far;
  procedure Rectangle (x1,y1,x2,y2 : integer; Color1,Color2 : byte);
  procedure Refresh; far;

  procedure ResetMouseCursor; far;

  procedure ResetMouseAC; far;
  procedure RestorePalette; far;
  procedure RestoreWindow(x1,y1,x2,y2:word;hand:word);
  procedure SavePalette; far;
  procedure SaveWindow(x1,y1,x2,y2:word;var hand:word);
  procedure SetAnimDelay (NewDelay : byte); far;
  procedure SetAnimSequence (NewAnim : pointer); far;
  procedure SetColor (NewColor : byte); far;
  procedure SetDACBlock (Start,Count : word; Store : pointer); far;
  procedure SetDACRegister (Reg : word; _Red,_Green,_Blue : byte); far;
  procedure SetDisplayStart (x,y:word); far;
  procedure SetHotSpotX (HotSpotX : byte); far;
  procedure SetHotSpotY (HotSpotY : byte); far;
  procedure SetMapBorder(y,left,right:word);far;
  procedure SetMapPos(x,y:byte);far;
  procedure SetMapSize(leng,high:word);far;
  procedure SetMapTexture(value:word; Texture:pointer);far;
  procedure SetMapVal(x,y,value:word);far;
  procedure SetMatrFont(p:pointer);far;
  procedure SetMouseArea (NewX1, NewY1, NewX2, NewY2 : word); far;
  procedure SetMouseMul(XMul,YMul: integer); far;
  procedure SetMousePos(X,Y: integer); far;
  procedure SetVisualPage(x:word);far;
  procedure SetActivePage(x:word);far;
  procedure SetStdPalette; far;
  procedure SetTexture(p:pointer);
  procedure SetWorkScreen(x,y,leng,high:word);far;
  procedure SetWriteMode (NewMode : byte); far;
  procedure SetWSize (NewX1, NewY1, NewX2, NewY2 : word); far;
  procedure ShowMouse; far;
  procedure VESADone; far;
  procedure VESAInit (ModeN : word); far;
  procedure VXMouseDone; far;
  procedure VXMouseInit; far;
  procedure ChangeCursor; far;

  procedure SetUserCursor(Cursor: pointer); far;

  procedure SetPolarParams(FullRect,CenterX,CenterY: integer); far;
  procedure SetMatrix(CenterX,CenterY,A11C,A11Z,A12C,A12Z,
                      A21C,A21Z,A22C,A22Z: Integer); far;
  procedure SetXVector(Index,Value: integer); far;
  procedure SetYVector(Index,Value: integer); far;
  procedure EnableMMX; far;
  procedure DisableMMX; far;
  function  EMSResourse(Res: pointer; Size: word): pointer; far;
  function  EMSPrepare(Res: pointer): pointer; far;

implementation
  uses
    ems;

  var
    TmpPal    : array [1..768] of byte;
    _TextMulX,
    _TextDivX,
    _TextMulY,
    _InitialX,
    _InitialY,
    _GranUnit,
    _TextDivY : word;
    _TextSize : byte;

  procedure AddSpecialArea; external;
  procedure Bar; external;
  procedure DelSpecialArea; external;
  procedure GetImage; external;
  function  GetMaxX; external;
  function  GetMaxY; external;
  procedure GetModeInfo; external;
  function  GraphResult; external;
  procedure GrayScale; external;
  procedure HideMouse; external;
  function  ImageSize; external;
  procedure Line; external;
  procedure MouseAutoDetect; external;
  function  MouseButton; external;
  function  MouseIdle : word; far; external;
  function  MouseX; external;
  function  MouseY; external;
  function  NumOfSpecialAreas; external;
  procedure OutText (x,y : word; Msg : string); far; external;
  procedure PutImage; external;
  procedure PutPixel; external;
  procedure ReadDACBlock; external;
  procedure ReadDACRegister; external;

  procedure ResetMouseCursor; external;

  procedure ResetMouseAC; external;
  procedure RestorePalette; external;
  procedure SavePalette; external;
  procedure SetAnimDelay; external;
  procedure SetAnimSequence; external;
  procedure SetColor; external;
  procedure SetDACBlock; external;
  procedure SetDACRegister; external;
  procedure SetHotSpotX; external;
  procedure SetHotSpotY; external;
  procedure SetMouseArea; external;
  procedure SetStdPalette; external;
  procedure SetWriteMode; external;
  procedure SetWSize; external;
  procedure ShowMouse; external;
  procedure VESADone; external;
  procedure VESAInit; external;
  procedure VXMouseDone; external;
  procedure _VXMouseInit; far; external;
  procedure ChangeCursor; external;

  procedure LinkEms(get,free,map,frame:pointer);far;external;
  {эта процеура устанавливает связь с модулем расширенной памяти}
  procedure SetTexture(p:pointer);external;
  {эта процедура устанавливает текущую текстуру заполнения}
  procedure SetWorkScreen(x,y,leng,high:word);external;
  {эта процедура устанавливает верхнийлевй угол рабочего окна,
  а также его высоту и ширину (в пкселах)}
  procedure SetMapBorder(y,left,right:word);external;
  {пока не работает !!!}
  procedure SetMapSize(leng,high:word);external;
  {устанавливает размер рабочей карты в квадратах 16х16}
  procedure SetMapVal(x,y,value:word);external;
  {утанавливает значение квадрата карты (номер отображаемого спрайта),
  если это значение превышает 127, то квадрат считается закрытым и
  отображается в виде черного квадрата}
  function  GetMapVal(x,y:word):word;external;
  {возвращает значениеквадрата карты с заданными координатами (также
   смотри процедуру выше)}
  procedure SetMapTexture(value:word; Texture:pointer);external;
  {связывает значение квадрата карты со спрайтом}
  procedure SetMapPos(x,y:byte);external;
  {устанавливает координаты верхнего отображаемого угла карты
  (позиционирует верхний левый угол карты)}
  procedure SetMatrFont(p:pointer);external;
  {устанавливает текущий матричный шрифт 8х16}
  procedure SetDinamic(list,bit:word);far;external;
  {указывает модулю расположение двух рабочих массивов}
  function  LoadSprite(p:pointer):pointer;external;
  {переносит спрайт в расширенную память}
  procedure AddSprBlock(x,y:word;p:pointer);external;
  {добавляет объект в список картинок переднего фона,
  координаты задаются в пикселах(!) относительно левого верхнего
  угла карты(!!!)}
  procedure DelSprBlock(x,y:word);external;
  {удаляет вышеупомянутый объект переднего фона}
  procedure Refresh; external;
  {выполняет полную перерисовку экрана}
  procedure SetDisplayStart (x,y:word); external;
  {}
  procedure SetVisualPage(x:word);external;
  {}
  procedure SetActivePage(x:word);external;
  {}
  procedure PutSpriteS(x,y:integer; p:pointer); external;
  {}
  procedure MirrorPage; external;
  {}
  procedure PutSprite(x,y:integer; p:pointer); external;

  procedure SetUserCursor(Cursor: pointer); external;

  procedure SetPolarParams(FullRect,CenterX,CenterY: integer); external;

  procedure SetMatrix(CenterX,CenterY,A11C,A11Z,A12C,A12Z,
                      A21C,A21Z,A22C,A22Z: Integer); external; 

  procedure SetXVector(Index,Value: integer); external;

  procedure SetYVector(Index,Value: integer); external;

  procedure EnableMMX; external;

  procedure DisableMMX; external;

  function  EMSResourse(Res: pointer; Size: word): pointer; external;

  function  EMSPrepare(Res: pointer): pointer; external;

  procedure SetMousePos(X,Y: integer); external;

  procedure SetMouseMul(XMul,YMul: integer); external;  {XMul*256, YMul*256}

  {$L VX.obj}


  procedure VXMouseInit;
  begin
    _VXMouseInit;
    SetMouseArea (0, 0, GetMaxX, GetMaxY);
  end;

  procedure OutTextXY;
  begin
    if Msg<>''
      then
        OutText(x,y,Msg);
  end;

  procedure Rectangle;
  begin
    SetColor(Color1);
    Line(x1,y1,x1,y2);
    Line(x1,y1,x2,y1);
    SetColor(Color2);
    Line(x2,y1+1,x2,y2);
    Line(x1+1,y2,x2,y2);
  end;

  procedure NullPalette;
  begin
    FillChar (TmpPal, 768, 0);
    SetDACBlock (0, 256, @TmpPal);
  end;

  procedure BorlandFontInit;
  begin
    _TextSize := 1;
    _TextMulX := 1;
    _TextDivX := 1;
    _TextMulY := 1;
    _TextDivY := 1;
  end;

  procedure BorlandSetTextSize;
  begin
    _TextSize := NewSize;
  end;

  procedure BorlandSetUserCharSize;
  begin
    _TextMulX := MX;
    _TextDivX := DX;
    _TextMulY := MY;
    _TextDivY := DY;
  end;

  procedure BorlandOutTextXY;
  var
    Diff,
    BaseX,
    BaseY     : integer;
    CurChar,
    GridSize,
    Flag,
    FirstChar : byte;
  begin
    if Message='' then Exit;
    CurChar := 0;
    asm
      push si
      push di
      push es
      mov  es,word ptr [PFont+2]
      mov  di,word ptr [PFont]
      mov  al,1Ah
      mov  cx,0FFFFh
      cld
      repnz scasb
      mov  al,2Bh
      mov  cx,0FFFFh
      cld
      repnz scasb
      dec  di
      mov  al,byte ptr es:[di+4]
      mov  FirstChar,al
      mov  al,byte ptr es:[di+8]
      mov  GridSize,al
      xor  ax,ax
      mov  al,byte ptr es:[di+1] {число символов}
      add  di,16                 {область указателей}
      mov  si,di
      add  si,ax
      add  si,ax
      add  si,ax                 {сами символы}
      mov  ax,x
      mov  BaseX,ax
      mov  ax,y
      mov  BaseY,ax
      mov  al,_TextSize
      mov  dl,GridSize
      mul  dl
      shr  ax,3
      mov  Diff,ax
    @@LettStart:
      mov  ax,BaseX
      xor  bx,bx
      mov  bl,CurChar
      inc  bl
      or   bl,bl
      jz   @@Exit
      mov  CurChar,bl
      push si
      cmp  bl,byte ptr [Message]
      ja   @@Exit_
      mov  si,bx
      mov  bl,byte ptr [Message+si]
      pop  si
      jmp  @@Cont
    @@Exit_:
      pop  si
      jmp  @@Exit
    @@Cont:
      sub  bl,FirstChar
      jc   @@LettStart
      shl  bx,1
      mov  bx,word ptr es:[di+bx]
      xor  ax,ax
      xor  cx,cx
      mov  al,byte ptr es:[si+bx]
      mov  cl,byte ptr es:[si+bx+1]
      or   al,al
      jz   @@NextChar
      shl  al,1
      shr  al,1
      test al,40h
      jz   @@XPosPrl
    @@XNegPrl:
      neg  al
      and  al,3Fh
      neg  al
    @@XPosPrl:
      imul _TextSize
      shl  cl,1
      shr  cl,1
      test cl,40h
      jz   @@YPosPrl
    @@YNegPrl:
      neg  cl
      and  cl,3Fh
      neg  cl
    @@YPosPrl:
      xchg ax,cx
      imul _TextSize
      xchg ax,cx
      add  bx,2
      imul _TextMulX
      idiv _TextDivX
      add  ax,BaseX
      xchg cx,ax
      imul _TextMulY
      idiv _TextDivY
      xchg cx,ax
      sub  cx,BaseY
      neg  cx
    @@Cycle:
      push ax
      push cx
      {UnpackCur}
      xor  ax,ax
      xor  cx,cx
      mov  al,byte ptr es:[si+bx]
      mov  cl,byte ptr es:[si+bx+1]
      or   al,al
      jz   @@NextChar
      shl  al,1
      shr  al,1
      test al,40h
      jz   @@XPosMain
    @@XNegMain:
      neg  al
      and  al,3Fh
      neg  al
    @@XPosMain:
      imul _TextSize
      mov  Flag,0
      shl  cl,1
      jc   @@NoFlagSet
      mov  Flag,1
    @@NoFlagSet:
      shr  cl,1
      test cl,40h
      jz   @@YPosMain
    @@YNegMain:
      neg  cl
      and  cl,3Fh
      neg  cl
    @@YPosMain:
      xchg ax,cx
      imul _TextSize
      xchg ax,cx
      imul _TextMulX
      idiv _TextDivX
      add  ax,BaseX
      xchg cx,ax
      imul _TextMulY
      idiv _TextDivY
      xchg cx,ax
      sub  cx,BaseY
      neg  cx
      cmp  Flag,0
      jnz  @@MoveOnly
    @@DrawToo:
      push ax
      push cx
      add  bx,2
      call Line
      jmp  @@Cycle
    @@MoveOnly:
      pop  dx
      pop  dx
      push ax
      push cx
      add  bx,2
      jmp  @@Cycle
    @@NextChar:
      pop  dx
      pop  dx
      mov  BaseX,dx
      jmp  @@LettStart
    @@Exit:
      pop  es
      pop  di
      pop  si
    end;
  end;

  function MouseInactive;
  begin
    MouseInactive := Round (MouseIdle*54.945);
  end;

  procedure SaveWindow(x1,y1,x2,y2:word;var hand:word);
  var
    p:pointer;
    leng:word;
    high:word;
    hn:word;
    hg:integer;
    i:word;
  begin
    leng:=x2-x1+1;
    high:=16382 div leng;
    hn:=GetPage;
    hand:=hn;
    hg:=y2-y1+1;
    i:=1;
    p:=GetPointer(0);
    Inc(Longint(p),2);
    Map(hn,0);
    if high>hg
      then
        GetImage(x1,y1,x2,y2,p)
      else
        GetImage(x1,y1,x2,y1+high-1,p);
    hg:=hg-high;
    while hg>0 do
      begin
        p:=GetPointer(0);
        hn:=GetPage;
        Word(p^):=hn;
        Map(hn,0);
        Word(p^):=$FFFF;
        Inc(Longint(p),2);
        if high>hg
          then
            GetImage(x1,y1+i*high,x2,y2,p)
          else
            GetImage(x1,y1+i*high,x2,y1+(i+1)*high-1,p);
        hg:=hg-high;
        inc(i);
      end;
  end;

  procedure RestoreWindow(x1,y1,x2,y2:word;hand:word);
  var
    p:pointer;
    leng:word;
    high:word;
    hn:word;
    hg:integer;
    i:word;
    t:word;
  begin
    leng:=x2-x1+1;
    high:=16382 div leng;
    hn:=hand;
    hg:=y2-y1+1;
    i:=1;
    p:=GetPointer(0);
    Inc(Longint(p),2);
    Map(hn,0);
    PutImage(x1,y1,p,NormalPut);
    hg:=hg-high;
    while hg>0 do
      begin
        p:=GetPointer(0);
        t:=hn;
        hn:=Word(p^);
        FreePage(t);
        Map(hn,0);
        Inc(Longint(p),2);
        PutImage(x1,y1+i*high,p,NormalPut);
        hg:=hg-high;
        inc(i);
      end;
    FreePage(hn);
  end;

  procedure SetDin;
  type
    tmp=array[0..1] of word;
  var
    t1,t2:pointer;
  begin
    GetMem(t1,{65535}50);
{    GetMem(t2,65535);}
    SetDinamic(tmp(t1)[1],tmp(t1)[1]);
  end;
  function GetPixel;
  var
    _GetPixel : byte;
  begin
    x := x+_InitialX;
    y := y+_InitialY;
    asm
      push es
      push di
      mov  ax,0A000h
      mov  es,ax
      mov  ax,y
      mov  di,640
      xor  dx,dx
      mul  di
      mov  di,ax
      add  di,x
      adc  dx,0
      cmp  dx,_GranUnit
      jz @@NoSwitch
      mov  _GranUnit,dx
      xor  bx,bx
      mov  ax,4F05h
      int  10h
    @@NoSwitch:
      mov  al,es:[di]
      mov  _GetPixel,al
      pop  di
      pop  es
    end;
    GetPixel := _GetPixel;
  end;

begin
  SetDin;
  LinkEms(@GetPage,@FreePage,@Map,@GetFrame);
end.