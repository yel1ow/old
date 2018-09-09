{$G+,O-,F+}
UNIT VESA256; {version 1.1; 11-29-96}

{**********************************************************
 **                                                      **
 **      VESA256: VESA Graph unit for 256 colors         **
 **    ___________________________________________       **
 **                                                      **
 **    Source by Peter de Jong.                          **
 **              Niek Engelschmanlaan 121,               **
 **              6532 CR, Nijmegen,                      **
 **              The Netherlands.                        **
 **              Phone  : +31-24-3554399                 **
 **              E-Mail : WPDEJONG@WORLDONLINE.NL        **
 **    ___________________________________________       **
 **                                                      **
 **    Additional support: - 256 color mouse             **
 **                        - multiple pages              **
 **                        - huge (>64Kb) copies         **
 **                        - better images support       **
 **                        - PCX image files             **
 **    ___________________________________________       **
 **                                                      **
 **    Updates: - version 1.1, 11-29-96.                 **
 **                                                      **
 **********************************************************}

INTERFACE


TYPE
{these VESA modes that are supported}
  VESAModeClass = (VESA640x480,               {640x480 pixels}
                   VESA800x600,               {800x600 pixels}
                   VESA1024x768,              {1024x768 pixels}
                   VESA1152x864,              {1154x864 pixels}
                   VESA1280x1024,             {1280x1024 pixels}
                   VESA1600x1200);            {1600x1200 pixels}
{the viewport type}
  ViewPortType  = RECORD
                    V_X1,
                    V_Y1,
                    V_X2,
                    V_Y2            :INTEGER;
                    V_ClipOn        :BOOLEAN;
                  END;
{the draw mode type}
  DrawModeType  = RECORD
                    D_Mode,
                    D_FGColor,
                    D_BGColor,
                    D_Pattern,
                    D_Width,
                    D_BitBlit       :BYTE;
                  END;
{rgb color type}
  RGBColor      = RECORD
                    C_R,                       {red intensity 0..255}
                    C_G,                       {green intensity 0..255}
                    C_B             :BYTE;     {blue intensity 0..255}
                  END;
{a palette with 256 colors}
  PaletteType   = ARRAY [0..255] OF RGBColor;


CONST
{bitblit operators}
  NormalBlit            = 0;            {operates as MOV}
  CopyBlit              = 0;            {operates as MOV}
  XORBlit               = 1;            {operates as XOR}
  OrBlit                = 2;            {operates as OR}
  AndBlit               = 3;            {operates as AND}
  NotBlit               = 4;            {operates as NOT}
  XNorBlit              = 5;            {operates as XNOR}
  NorBlit               = 6;            {operates as NOR}
  NAndBlit              = 7;            {operates as NAND}
{not used for drawing, only for data...}
  SpriteBlit            = 8;            {does not copy color number 0}
{draw modes}
  PixelDrawing          = 0;
  LineDrawing           = 1;
  FillDrawing           = 2;
{line widths}
  NormWidth             = 1;
  ThickWidth            = 3;
{line type}
  SolidLn               = 0;            {oooooooooooooooo}
  Dotted1Ln             = 1;            {o-o-o-o-o-o-o-o-}
  Dotted3Ln             = 2;            {o---o---o---o---}
  Dotted7Ln             = 3;            {o-------o-------}
  Dashed2Ln             = 4;            {oo--oo--oo--oo--}
  Dashed6Ln             = 5;            {oo------oo------}
  DotDash2Ln            = 6;            {o--oo--o--o--o--}
  DotDash4Ln            = 7;            {o----oo----o----}
{fill type}
  SolidFill             = 0;            {uses fill color}
  EmptyFill             = 1;            {uses background color}
  LineFill              = 2;            {--- fill}
  LtSlashFill           = 3;            {/// fill}
  SlashFill             = 4;            {/// thick fill}
  BkSlashFill           = 5;            {\thick fill}
  LtBkSlashFill         = 6;            {\fill}
  HatchFill             = 7;            {light hatch fill}
  XHatchFill            = 8;            {heavy cross hatch}
  InterleaveFill        = 9;            {interleaving line}
  WideDotFill           = 10;           {widely spaced dot}
  CloseDotFill          = 11;           {closely spaced dot}
  Closest1Fill          = 12;           {closest spaced dot}
  Closest2Fill          = 13;           {alternate closest spaced dot}
{clipping constants}
  ClipOn                = TRUE;
  ClipOff               = FALSE;
{colors}
  Black                 = 0;
  Blue                  = 1;
  Green                 = 2;
  Cyan                  = 3;
  Red                   = 4;
  Magenta               = 5;
  Brown                 = 6;
  LightGray             = 7;
  DarkGray              = 8;
  LightBlue             = 9;
  LightGreen            = 10;
  LightCyan             = 11;
  LightRed              = 12;
  LightMagenta          = 13;
  Yellow                = 14;
  White                 = 15;


{return the amount of accessable video memory in bytes,
 note that this function does not have to return the
 actual amount of memory mounted on the video card!}
FUNCTION  GetVESAMemorySize:LONGINT;
{try to initialize the given VESA card in the given mode,
 returns whether the operation was succesfull, always
 initialize before using ANY of the other functions}
FUNCTION  StartVESA256(VESAMode:VESAModeClass;StartColor:BYTE):BOOLEAN;
{close down the graphics again}
PROCEDURE FinishVESA256;
{will wait until the vertical retrace starts, normal VGA is 60 Hz}
PROCEDURE WaitTOF;
{paging system}
FUNCTION  GetHighestPageNr:BYTE;
FUNCTION  ExistingPage(PageNr:BYTE):BOOLEAN;
PROCEDURE SetVisualPage(PageNr:BYTE);
FUNCTION  GetVisualPage:BYTE;
PROCEDURE SetActivePage(PageNr:BYTE);
FUNCTION  GetActivePage:BYTE;
PROCEDURE ScrollToPage(PageNr:BYTE;ScrollTime:REAL);
{screen dimemsions}
FUNCTION  GetMaxX:INTEGER;
FUNCTION  GetMaxY:INTEGER;
FUNCTION  GetScreenWidth:INTEGER;
FUNCTION  GetScreenHeight:INTEGER;
PROCEDURE GetAspectRatio(VAR AspectX,AspectY:WORD);
{viewport system}
PROCEDURE GetViewSettings(VAR ViewPort:ViewPortType);
PROCEDURE SetViewSettings(ViewPort:ViewPortType);
PROCEDURE SetViewPort(X1,Y1,X2,Y2:INTEGER;Clip:BOOLEAN);
PROCEDURE ClipGraphics(X,Y,W,H:INTEGER);
PROCEDURE UnClipGraphics;
{drawing style system}
PROCEDURE SetBGColor(Color:BYTE);
PROCEDURE SetPixelMode(Color,BitBlit:BYTE);
PROCEDURE SetLineMode(Color,Pattern,Width,BitBlit:BYTE);
PROCEDURE SetFillMode(Color,Pattern,BitBlit:BYTE);
PROCEDURE GetDrawingMode(VAR Mode:DrawModeType);
PROCEDURE SetDrawingMode(VAR Mode:DrawModeType);
{cursor system}
FUNCTION  GetX:INTEGER;
FUNCTION  GetY:INTEGER;
PROCEDURE MoveTo(X,Y:INTEGER);
PROCEDURE RelMoveTo(X,Y:INTEGER);
{lines}
PROCEDURE HorLine(X1,X2,Y:INTEGER);
PROCEDURE VertLine(X,Y1,Y2:INTEGER);
PROCEDURE Line(X1,Y1,X2,Y2:INTEGER);
PROCEDURE LineTo(X,Y:INTEGER);
PROCEDURE RelLineTo(X,Y:INTEGER);
{boxes}
PROCEDURE Box(X1,Y1,X2,Y2:INTEGER);
{clearing system}
PROCEDURE ClearGraphics(Color:BYTE);
{pixels}
PROCEDURE PutPixel(X,Y:INTEGER;Color:BYTE);
FUNCTION  GetPixel(X,Y:INTEGER):BYTE;
{curves}
PROCEDURE Circle(X,Y,R:INTEGER);
PROCEDURE Bezier(X0,Y0,X1,Y1,X2,Y2,X3,Y3:INTEGER);
PROCEDURE Ellipse(X,Y,RX,RY:INTEGER);
{flood system}
PROCEDURE Flood(X,Y:INTEGER;BorderColor:BYTE);
PROCEDURE Bleed(X,Y:INTEGER;BleedColor:BYTE);
{polygon system}
PROCEDURE ResetPoly;
PROCEDURE PolyPoint(X,Y:INTEGER);
PROCEDURE RenderPoly;
PROCEDURE RotatePolygonXY(X,Y:INTEGER;Angle:REAL);
PROCEDURE RotatePolygon(Angle:REAL);
PROCEDURE TranslatePolygon(DeltaX,DeltaY:INTEGER);
PROCEDURE ScalePolygon(ScaleX,ScaleY:REAL);
{palette system}
PROCEDURE RefreshPalette(Extended:BOOLEAN);
PROCEDURE SetRGBColor(ColorNr,R,G,B:BYTE);
PROCEDURE GetRGBColor(ColorNr:BYTE;VAR R,G,B:BYTE);
PROCEDURE SetFullPalette(VAR Palette:PaletteType);
PROCEDURE GetFullPalette(VAR Palette:PaletteType);
PROCEDURE SetPartialPalette(VAR Palette:PaletteType;Start,Finish:BYTE);
PROCEDURE GetPartialPalette(VAR Palette:PaletteType;Start,Finish:BYTE);
PROCEDURE SetDefaultPalette;
PROCEDURE FadeOutPalette(R,G,B:BYTE;FadeTime:REAL);
PROCEDURE FadeInPalette(FadeTime:REAL);
FUNCTION  GetColorDifference(RefColor,TestColor:RGBColor):INTEGER;
{copy system, no memory limit}
PROCEDURE CopyPage(SourcePageNr,DestPageNr,BitBlit:BYTE);
PROCEDURE CopyHugeBox(SourcePage,SourceX,SourceY,
                      DestPage,DestX,DestY,W,H:INTEGER;BitBlit:BYTE);
PROCEDURE CopyBox(SourceX,SourceY,DestX,DestY,W,H:INTEGER;BitBlit:BYTE);
{image system, 64Kb memory limit}
PROCEDURE StampInImage(DestBitMap,SourceBitMap:POINTER;
                       OffsetX,OffsetY:INTEGER;BitBlit:BYTE);
PROCEDURE ExtractFromImage(DestBitMap,SourceBitMap:POINTER;
                           OffsetX,OffsetY,W,H:INTEGER);
PROCEDURE GetImage(X1,Y1,X2,Y2:INTEGER;BitMap:POINTER);
PROCEDURE PutImage(X,Y:INTEGER;BitMap:POINTER;BitBlit:BYTE);
FUNCTION  GetImageSize(W,H:INTEGER):LONGINT;
FUNCTION  AllocAndGetImage(X,Y,W,H:INTEGER):POINTER;
PROCEDURE PutAndForgetImage(VAR BitMap:POINTER;X,Y:INTEGER;BitBlit:BYTE);
FUNCTION  AllocImage(W,H:INTEGER):POINTER;
PROCEDURE ForgetImage(VAR BitMap:POINTER);
{bitmap fonts}
FUNCTION  GetTextWidth(S:PCHAR;Proportional:BOOLEAN;FontNr:BYTE):INTEGER;
PROCEDURE PutText(X,Y:INTEGER;S:PCHAR;Proportional:BOOLEAN;
                  FontNr,TextColor,BackColor,BitBlit:BYTE);
{pcx images}
FUNCTION  ValidPCXImage(FileName:PCHAR):BOOLEAN;
PROCEDURE GetPCXImageSize(FileName:PCHAR;VAR W,H:INTEGER);
PROCEDURE LoadPCXImageXY(FileName:PCHAR;
                         X,Y:INTEGER;BitBlit:WORD;
                         NewPal,ReFreshPal,AdaptHighColors:BOOLEAN);
FUNCTION  GetPCXImage(FileName:PCHAR;
                      AdaptHighColors,FixateBlack:BOOLEAN):POINTER;
PROCEDURE LoadPCXImage(FileName:PCHAR;BitBlit:WORD;
                       NewPal,RefreshPal,AdaptHighColors:BOOLEAN);
PROCEDURE SavePCXImageXYWH(FileName:PCHAR;X,Y,W,H:INTEGER);
PROCEDURE SavePCXImage(Path:PCHAR);
{mouse support}
FUNCTION  MouseDriverInstalled:BOOLEAN;
PROCEDURE GetMouseInfo(VAR MouseType,IRQNr:WORD);
PROCEDURE SetMousePointers(HotSpotOffsetX,HotSpotOffsetY:WORD;
                           NormalPath,BusyPath,QuestionPath:PCHAR);
PROCEDURE MoveMouse;
PROCEDURE ShowMouse;                           {enable cursor display}
PROCEDURE HideMouse;                           {disable cursor display}
PROCEDURE ShowBusyMouse;                       {enable busy cursor}
PROCEDURE HideBusyMouse;                       {disable busy cursor}
PROCEDURE ShowQuestionMouse;                   {enable busy cursor}
PROCEDURE HideQuestionMouse;                   {disable busy cursor}
FUNCTION  IsLeftMouseButtonDown:BOOLEAN;
FUNCTION  IsRightMouseButtonDown:BOOLEAN;
FUNCTION  IsMouseButtonDown:BOOLEAN;
FUNCTION  IsOneMouseButtonDown:BOOLEAN;
FUNCTION  AreBothMouseButtonsDown:BOOLEAN;
PROCEDURE GetMouseXY(VAR X,Y:INTEGER);
PROCEDURE SetMouseXY(X,Y:INTEGER);
PROCEDURE SetMouseBox(Left,Top,Right,Bottom:INTEGER);
PROCEDURE ClearMouseBox;
PROCEDURE SaveMouseState;
PROCEDURE LoadMouseState;
PROCEDURE DefaultMousePointer;


IMPLEMENTATION


USES
  DOS;


CONST
{whether or not we have graphics....}
  GraphicsOn         :BOOLEAN = FALSE;
{polygons}
  MaxPolyCount       = 1000;
{bezier curve constants}
  Flatness           = 0.50;            {limit value of curvature}
  MaxDepth           = 20;              {limit value for recursion}


TYPE
{contence of a long record pointer}
  LongRec            = RECORD
                         L:WORD;
                         H:BYTE;
                         X:BYTE;
                       END;
{simple type to index a 64Kb block of memory}
  MemType            = ARRAY [0..65534] OF BYTE;
  MemPtr             = ^MemType;
{mode information}
  ModeInfoRec        = RECORD
                         M_W,
                         M_H,
                         M_Line       :INTEGER;
                         M_Size       :LONGINT;
                       END;
{VESA video modes!}
  VideoModePtr       = ^VideoModeType;
  VideoModeType      = ARRAY [1..128] OF WORD;
{VESA general information block}
  VESAInfoBlock =
    RECORD
      I_VESASignature       :ARRAY [0..3] OF CHAR;    {'VESA' 4 byte signature}
      I_VESAVersion         :WORD;                    {VBE version number}
      I_OEMStringPtr        :PCHAR;                   {far pointer to OEM string}
      I_Capabilities        :LONGINT; {?}             {capabilities of video card}
      I_VideoModePtr        :VideoModePtr;            {far pointer to supported modes}
      I_TotalMemory         :WORD;                    {number of 64kb memory blocks}
      I_Reserved            :ARRAY [21..256] OF BYTE; {pad to 256 byte block size}
    END;
{VESA mode information block}
  VESAModeInfoBlock =
    RECORD
      M_ModeAttr            :WORD;                    {mode attributes}
      M_WinAAttr            :BYTE;                    {window A attributes}
      M_WinBAttr            :BYTE;                    {window B attributes}
      M_WinGranularity      :WORD;                    {window granularity in k}
      M_WinSize             :WORD;                    {window size in k}
      M_WinASegment         :WORD;                    {window A segment}
      M_WinBSegment         :WORD;                    {window B segment}
      M_WinFuncPtr          :POINTER;                 {far pointer to window function}
      M_BytesPerScanLine    :WORD;                    {bytes per scanline}
      M_XResolution         :WORD;                    {horizontal resolution}
      M_YResolution         :WORD;                    {vertical resolution}
      M_XCharSize           :BYTE;                    {character cell width}
      M_YCharSize           :BYTE;                    {character cell height}
      M_NumberOfPlanes      :BYTE;                    {number of memory planes}
      M_BitsPerPixel        :BYTE;                    {bits per pixel}
      M_NumberOfBanks       :BYTE;                    {number of CGA style banks}
      M_MemoryModel         :BYTE;                    {memory model type}
      M_BankSize            :BYTE;                    {size of CGA style banks}
      M_NumberOfImagePages  :BYTE;                    {number of images pages}
      M_Reserved1           :BYTE;                    {reserved}
      M_RedMaskSize         :BYTE;                    {size of direct color red mask}
      M_RedFieldPosition    :BYTE;                    {bit posn of lsb of red mask}
      M_GreenMaskSize       :BYTE;                    {size of direct color green mask}
      M_GreenFieldPosition  :BYTE;                    {bit posn of lsb of green mask}
      M_BlueMaskSize        :BYTE;                    {size of direct color blue mask}
      M_BlueFieldPosition   :BYTE;                    {bit posn of lsb of blue mask}
      M_RsvdMaskSize        :BYTE;                    {size of direct color res mask}
      M_RsvdFieldPosition   :BYTE;                    {bit posn of lsb of res mask}
      M_DirectColorModeInfo :BYTE;                    {direct color mode attributes}
      M_Reserved2           :ARRAY [41..256] OF CHAR; {pad to 256 byte block size}
    END;
{used for block filling}
  FillPatternType    = ARRAY [0..7] OF BYTE;
{ordinairy point type (don't change)}
  PolyPointType      = RECORD
                         P_Reoccur          :BYTE;
                         P_X,
                         P_Y                :INTEGER;
                       END;
{representing the arguments and local variables of a fill call}
  RawFillType        = RECORD
                       {arguments}
                         F_X,
                         F_Y,
                         F_D,
                         F_OldXL,
                         F_OldXR            :INTEGER;
                       {local variables}
                         F_CurXL,
                         F_CurXR            :INTEGER;
                         F_NothingFilled    :BOOLEAN;
                       END;
  RawFillPtr         = ^RawFillType;
{points type}
  PolyPointsPtr      = ^PolyPointsType;
  PolyPointsType     = ARRAY [1..MaxPolyCount] OF PolyPointType;
{bitmap type for images}
  BitMapType         = RECORD
                         B_MemSize           :WORD;     {mem. space occupied}
                         B_OffsetX,                     {internal offset}
                         B_OffsetY,                     {internal offset}
                         B_W,
                         B_H                 :INTEGER;
                         B_Data              :ARRAY [0..65524] OF BYTE;
                       END;
  BitMapPtr          = ^BitMapType;
{bitmap fonts}
  RAM8x6CharType     = ARRAY [0..5] OF BYTE;
  RAM8x6FontType     = ARRAY [0..255] OF RAM8x6CharType;
  RAM8x6FontPtr      = ^RAM8x6FontType;
  RAM8x7CharType     = ARRAY [0..6] OF BYTE;
  RAM8x7FontType     = ARRAY [0..255] OF RAM8x7CharType;
  RAM8x7FontPtr      = ^RAM8x7FontType;
  RAM8x8CharType     = ARRAY [0..7] OF BYTE;
  RAM8x8FontType     = ARRAY [0..255] OF RAM8x8CharType;
  RAM8x8FontPtr      = ^RAM8x8FontType;
  RAM8x9CharType     = ARRAY [0..8] OF BYTE;
  RAM8x9FontType     = ARRAY [0..255] OF RAM8x9CharType;
  RAM8x9FontPtr      = ^RAM8x9FontType;
  RAM8x10CharType    = ARRAY [0..9] OF BYTE;
  RAM8x10FontType    = ARRAY [0..255] OF RAM8x10CharType;
  RAM8x10FontPtr     = ^RAM8x10FontType;
  RAM8x11CharType    = ARRAY [0..10] OF BYTE;
  RAM8x11FontType    = ARRAY [0..255] OF RAM8x11CharType;
  RAM8x11FontPtr     = ^RAM8x11FontType;
  RAM8x12CharType    = ARRAY [0..11] OF BYTE;
  RAM8x12FontType    = ARRAY [0..255] OF RAM8x12CharType;
  RAM8x12FontPtr     = ^RAM8x12FontType;
  RAM8x13CharType    = ARRAY [0..12] OF BYTE;
  RAM8x13FontType    = ARRAY [0..255] OF RAM8x13CharType;
  RAM8x13FontPtr     = ^RAM8x13FontType;
  RAM8x14CharType    = ARRAY [0..13] OF BYTE;
  RAM8x14FontType    = ARRAY [0..255] OF RAM8x14CharType;
  RAM8x14FontPtr     = ^RAM8x14FontType;
  RAM8x16CharType    = ARRAY [0..15] OF BYTE;
  RAM8x16FontType    = ARRAY [0..255] OF RAM8x16CharType;
  RAM8x16FontPtr     = ^RAM8x16FontType;
{PCX header type}
  Palette16Type = ARRAY [0..15] OF RGBColor;
  PCXHeaderPtr  = ^PCXHeaderType;
  PCXHeaderType = RECORD
                    H_Manufacturer,                 {always 10}
                    H_Version,                      {always 5 (version 3.0)}
                    H_Encoding,                     {always 1 (run-length)}
                    H_BitsPerPixel     :BYTE;       {bits/pixel per plane}
                    H_MinX,
                    H_MinY,                         {window of image}
                    H_MaxX,
                    H_MaxY,
                    H_HRes,                         {aspect ratio settings}
                    H_VRes             :WORD;
                    H_ColorMap         :Palette16Type;   {all 16 colors}
                    H_Reserved,                     {do not use}
                    H_NPlanes          :BYTE;       {number of color planes}
                    H_BytesPerLine,                 {bytes/scan line per plane}
                    H_PaletteInfo,                  {always 1; not checked}
                    H_Width,
                    H_Height           :WORD;       {window of image}
                    H_Padding          :ARRAY [1..54] OF BYTE;
                  END;
{handy buffer type for reading fast}
  BytesPtr      = ^BytesType;
  BytesType     = ARRAY [0..8000] OF BYTE;
{color modify list}
  ColorListType = ARRAY [0..255] OF BYTE;
{different mouse pointers}
  MouseClass    = (Normal,Busy,Question);


CONST
{paging of the graphical screen}
  ShowRenderOn       :BOOLEAN = TRUE;
{do we have a bitmap font in memory?}
  RAMFontsOn         :BOOLEAN = FALSE;
{a VESA status flag}
  VESAStatus         :WORD    = 0;
{the all important modus numbers, VESA adds $100 to this number}
  ModeTable          :ARRAY[VESAModeClass] OF BYTE =
                        {640  800 1024 1152 1280 1600    X-resolution
                         480  600  768  864 1024 1200    Y-resolution}
                        ($01, $03, $05, $24, $07, $20);  {VESA}
{all the modes that are defined}
  ModeInfo           :ARRAY[VESAModeClass] OF ModeInfoRec =
                    ((M_W:  640; M_H:  480; M_Line:  640; M_Size:  307200),
                     (M_W:  800; M_H:  600; M_Line:  800; M_Size:  480000),
                     (M_W: 1024; M_H:  768; M_Line: 1024; M_Size:  804864),
                     (M_W: 1152; M_H:  864; M_Line: 1152; M_Size:  995328),
                     (M_W: 1280; M_H: 1024; M_Line: 1280; M_Size: 1310720),
                     (M_W: 1600; M_H: 1200; M_Line: 1600; M_Size: 1920000));
{segment address of (S)VGA screen memory}
  VGASeg                       = $A000;
{last selected banks}
  ActiveBank         :BYTE     = $FF;
  ActiveWriteBank    :BYTE     = $FF;
  ActiveReadBank     :BYTE     = $FF;
{does card support dual mode in the current mode?}
  DualModePossible   :BOOLEAN  = FALSE;
{a math constant}
  PiDiv180           = Pi/180.0;
{line patterns}
  Lining             :ARRAY [0..7] OF WORD =
                       ($FFFF,$AAAA,$8888,$8080,$CCCC,$C0C0,$9924,$8610);
{fill patterns}
  Filling            :ARRAY [0..13] OF FillPatternType =
                       (($FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF),
                        ($00,$00,$00,$00,$00,$00,$00,$00),
                        ($FF,$FF,$00,$00,$FF,$FF,$00,$00),
                        ($01,$02,$04,$08,$10,$20,$40,$80),
                        ($E0,$C1,$83,$07,$0E,$1C,$38,$70),
                        ($F0,$78,$3C,$1E,$0F,$87,$C3,$E1),
                        ($A5,$D2,$69,$B4,$5A,$2D,$96,$4B),
                        ($FF,$88,$88,$88,$FF,$88,$88,$88),
                        ($81,$42,$24,$18,$18,$24,$42,$81),
                        ($CC,$33,$CC,$33,$CC,$33,$CC,$33),
                        ($80,$00,$08,$00,$80,$00,$08,$00),
                        ($88,$00,$22,$00,$88,$00,$22,$00),
                        ($55,$AA,$55,$AA,$55,$AA,$55,$AA),
                        ($AA,$55,$AA,$55,$AA,$55,$AA,$55));
{current font number}
  CurrentFontNr      :BYTE     = 0;
{on which one we have proportional information?}
  CurrentPropNr      :BYTE     = 0;
{a pointer to the font data}
  FontDataPtr        :POINTER  = NIL;
{default palette}
  DefaultPalette     :Palette16Type = ((C_R:$00;C_G:$00;C_B:$00),
                                       (C_R:$00;C_G:$00;C_B:$A0),
                                       (C_R:$00;C_G:$A0;C_B:$00),
                                       (C_R:$00;C_G:$A0;C_B:$A0),
                                       (C_R:$A0;C_G:$1C;C_B:$1C),
                                       (C_R:$A0;C_G:$00;C_B:$A0),
                                       (C_R:$A0;C_G:$78;C_B:$00),
                                       (C_R:$C4;C_G:$C4;C_B:$C4),
                                       (C_R:$68;C_G:$68;C_B:$68),
                                       (C_R:$00;C_G:$00;C_B:$FC),
                                       (C_R:$24;C_G:$FC;C_B:$24),
                                       (C_R:$00;C_G:$FC;C_B:$FC),
                                       (C_R:$FC;C_G:$28;C_B:$28),
                                       (C_R:$A4;C_G:$00;C_B:$FC),
                                       (C_R:$FC;C_G:$FC;C_B:$12),
                                       (C_R:$FC;C_G:$FC;C_B:$FC));
{good starting point to save a image}
  DefaultHeader :PCXHeaderType = (H_Manufacturer :10;
                                  H_Version      :5;
                                  H_Encoding     :1;
                                  H_BitsPerPixel :8;
                                  H_MinX         :0;
                                  H_MinY         :0;
                                  H_MaxX         :639;
                                  H_MaxY         :479;
                                  H_HRes         :300;
                                  H_VRes         :300;
                                  H_ColorMap     :((C_R:$00;C_G:$00;C_B:$00),
                                                   (C_R:$00;C_G:$00;C_B:$A0),
                                                   (C_R:$00;C_G:$A0;C_B:$00),
                                                   (C_R:$00;C_G:$A0;C_B:$A0),
                                                   (C_R:$A0;C_G:$1C;C_B:$1C),
                                                   (C_R:$A0;C_G:$00;C_B:$A0),
                                                   (C_R:$A0;C_G:$78;C_B:$00),
                                                   (C_R:$C4;C_G:$C4;C_B:$C4),
                                                   (C_R:$68;C_G:$68;C_B:$68),
                                                   (C_R:$00;C_G:$00;C_B:$FC),
                                                   (C_R:$24;C_G:$FC;C_B:$24),
                                                   (C_R:$00;C_G:$FC;C_B:$FC),
                                                   (C_R:$FC;C_G:$28;C_B:$28),
                                                   (C_R:$A4;C_G:$00;C_B:$FC),
                                                   (C_R:$FC;C_G:$FC;C_B:$12),
                                                   (C_R:$FC;C_G:$FC;C_B:$FC));
                                  H_Reserved     :0;
                                  H_NPlanes      :1;
                                  H_BytesPerLine :80;
                                  H_PaletteInfo  :1;
                                  H_Width        :640;
                                  H_Height       :480;
                                  H_Padding      :(0,0,0,0,0,0,0,0,0,0,0,
                                                   0,0,0,0,0,0,0,0,0,0,0,
                                                   0,0,0,0,0,0,0,0,0,0,0,
                                                   0,0,0,0,0,0,0,0,0,0,0,
                                                   0,0,0,0,0,0,0,0,0,0));
{mouse interrupt}
  MOUSE_INT           = $33;
{mouse commands}
  RESET_MOUSE         = 0;    {don't change these values!}
  SHOW_MOUSE          = 1;
  HIDE_MOUSE          = 2;
  GET_DATA_MOUSE      = 3;
  SET_DATA_MOUSE      = 4;
  RANGE_X_MOUSE       = 7;
  RANGE_Y_MOUSE       = 8;
  HANDLE_MOUSE        = 20;
  STATE_SIZE_MOUSE    = 21;
  SAVE_STATE_MOUSE    = 22;
  LOAD_STATE_MOUSE    = 23;
  UNDO_MOUSE          = 33;
  INFO_MOUSE          = 36;
{proportional position}
  MousePropX          :REAL    = 0.5;
  MousePropY          :REAL    = 0.5;
{here the normal handler and mask are stored}
  MaskBuffer          :WORD    = 0;
  InterruptBuffer     :POINTER = NIL;
{here the new position is noted and stored}
  MouseOldDX :INTEGER = 0;
  MouseOldDY :INTEGER = 0;
  MouseNewDX :INTEGER = 0;
  MouseNewDY :INTEGER = 0;
  MouseOldSet:BOOLEAN = FALSE;   {whether old is valid}
  MouseMoved :BOOLEAN = FALSE;   {used in the overlayed mouse  unit}
  MouseUsed  :BOOLEAN = FALSE;   {used in the overlayed gadget unit}
{very special flag with which you can indicate
 that the bitmap should be reread and refreshed!}
  RefreshMouseBitMap :BOOLEAN    = TRUE;
{mouse on?}
  MouseOn            :BOOLEAN    = FALSE;
{digitizer mouse on?}
  PenMouseOn         :BOOLEAN    = FALSE;
{the type of our mouse}
  MouseStyle         :MouseClass = Normal;
{policy: only show when interaction is possible}
  IsMouseShown       :BOOLEAN    = FALSE;
{the sensitivity of the pen mouse when in relative mode}
  PenMouseRelSens    :SINGLE     = 0.01;
  InvPenMouseRelSens :SINGLE     = 100.0;


VAR
{representation of the CPU}
  Regs               :REGISTERS;       {needed to contact the mouse}
{the CRTC port address}
  CRTCPort           :WORD ABSOLUTE 0:$463;
{this variable contains the number of bytes for one scan line}
  BytesPerLine       :WORD;
{should contain the amount of video memory (only when card is active)}
  VideoMemorySize    :LONGINT;
{following variables are pointers to routines
 for the management detailed of memory banks}
  _SetDualMode,                             {set dual mode}
  _SetSingleMode     :PROCEDURE;            {set single mode}
  _ExtStartAddr      :PROCEDURE(Bank:BYTE); {set video start address}
{direct and quick access to bank selection routines}
  _SetVESABank,                             {single mode read and write bank}
  _SetVESAWriteBank,                        {dual mode write bank}
  _SetVESAReadBank   :PROCEDURE(Bank:BYTE); {dual mode read bank}
{quick access to the display dimensions}
  VESAMaxX,
  VESAMaxY           :INTEGER;
{bank call routine pointer}
  BankCall           :POINTER;
{shift of bank number to get a 64Kb granularity}
  ShiftCount         :BYTE;
{window1 contains the read/write window number for single mode and
 the write window number for dual mode, window2 contains the read
 window number for dual mode only}
  BankWindow1,
  BankWindow2        :BYTE;
{visual and active page numbers}
  VisualPageNr       :WORD;
  ActivePageTop      :INTEGER;
  ActivePageNr       :WORD;
{drawing mode}
  DrawMode,
  DrawFGColor,
  DrawBGColor,
  DrawPattern,
  DrawWidth,
  DrawBitBlit,
  DrawLogic          :BYTE;
  DrawInverse        :BOOLEAN;
{contains the current viewport}
  ViewPortWidth,
  ViewPortHeight,
  ViewPortLeft,
  ViewPortRight,
  ViewPortTop,
  ViewPortBottom     :INTEGER;
  ViewPortClipOn     :BOOLEAN;
{draw bits}
  LineBits           :WORD;
{cursor system}
  CursorX,
  CursorY            :INTEGER;
  CursorDown         :BOOLEAN;
{polygons}
  PolyPoints         :PolyPointsPtr;
  PolyCount          :WORD;
  LastestPolyX,
  LastestPolyY       :INTEGER;
{bezier curves}
  A,B,C,                           {used for flatting}
  Dist1,Dist2,                     {used for flatting}
  MaxDist            :REAL;        {used for flatting}
{fill system}
  FillColor          :BYTE;
  FillEquals         :BOOLEAN;
{palette that is used during a Palette refresh}
  CurrentPalette     :PaletteType;
{the heigth of the current font}
  FontHeight         :INTEGER;
{a pointer to the font bitmap}
  FontBitMap         :BitMapPtr;
{compact proportional information on current font}
  PropInfo           :ARRAY [#0..#255] OF BYTE;
{pcx buffer}
  Buffer             :BytesPtr;
  BufferIndex,
{pcx scanning}
  ScanLine,
  ScanIndex          :INTEGER;
{pcx one image line}
  BitMap             :BitMapPtr;
{bitmaps of the mouse pointer}
  NormalForeGround,
  BusyForeGround,
  QuestionForeGround,
  ActiveForeGround,
  MouseBackGround    :BitMapPtr;
{for buffering the state of the mouse}
  MouseStateBuffer   :POINTER;
  MouseStateBuffSize :WORD;
{in graphical mode we should know our mouse view port}
  MouseMinX,
  MouseMinY,
  MouseMaxX,
  MouseMaxY,
{remember position}
  MouseX,
  MouseY,
  OldMouseX,
  OldMouseY          :INTEGER;
{used for temporarily buffering the view port}
  ViewPortBuffer     :ViewPortType;
  DrawModeBuffer     :DrawModeType;
{paths of the pointer files}
  NormalMouseFileName,
  BusyMouseFileName,
  QuestionMouseFileName :ARRAY [0..79] OF CHAR;
{offsets}
  ActiveMouseOfsX,
  ActiveMouseOfsY    :WORD;
{old program exit routine}
  OldExitProc        :POINTER;


{*****************************************************
 **                                                 **
 ** string routines; you could also use the BP unit **
 **                                                 **
 *****************************************************}


FUNCTION StrLen(Str:PCHAR):WORD; ASSEMBLER;
{StrLen returns the number of characters
 in Str, not counting the null terminator}
ASM
  CLD
  LES    DI, Str
  MOV    CX, $FFFF
  XOR    AL, AL
  REPNE  SCASB
  MOV    AX, $FFFE
  SUB    AX, CX
END; {StrLen}


FUNCTION StrMove(Dest,Source:PCHAR;Count:WORD):PCHAR; ASSEMBLER;
{StrMove copies exactly Count characters from Source
 to Dest and returns Dest. Source and Dest may overlap}
ASM
  PUSH   DS
  CLD
  LDS    SI, Source
  LES    DI, Dest
  MOV    AX, DI
  MOV    DX, ES
  MOV    CX, Count
  CMP    SI, DI
  JAE   @Jump1
  STD
  ADD    SI, CX
  ADD    DI, CX
  DEC    SI
  DEC    DI
@Jump1:
  REP    MOVSB
  CLD
  POP    DS
END; {StrMove}


FUNCTION StrLCopy(Dest,Source:PCHAR;MaxLen:WORD):PCHAR; ASSEMBLER;
{StrLCopy copies at most MaxLen characters
 from Source to Dest and returns Dest}
ASM
  PUSH   DS
  CLD
  LES    DI, Source
  MOV    CX, MaxLen
  MOV    BX, CX
  XOR    AL, AL
  REPNE  SCASB
  SUB    BX, CX
  MOV    CX, BX
  LDS    SI, Source
  LES    DI, Dest
  MOV    BX, DI
  MOV    DX, ES
  REP    MOVSB
  STOSB
  XCHG   AX, BX
  POP    DS
END; {StrLCopy}


FUNCTION StrComp(Str1,Str2:PCHAR):INTEGER; ASSEMBLER;
{StrComp compares Str1 to Str2. The return value is less than 0
 if Str1 < Str2, 0 if Str1 = Str2, or greater than 0 if Str1 > Str2}
ASM
  PUSH   DS
  CLD
  LES    DI, Str2
  MOV    SI, DI
  MOV    CX, $FFFF
  XOR    AX, AX
  CWD
  REPNE  SCASB
  NOT    CX
  MOV    DI, SI
  LDS    SI, Str1
  REPE   CMPSB
  MOV    AL, DS:[SI-1]
  MOV    DL, ES:[DI-1]
  SUB    AX, DX
  POP    DS
END; {StrComp}


FUNCTION StrEat(Dest,Source:PCHAR;EatLen,MaxLen:WORD):PCHAR;
{move eatlen characters from source to dest, destination can be nil}
{otherwise; dest and source should be of equal size and cannot overlap}
VAR Len:WORD;
BEGIN
  IF Dest = Source THEN HALT(204);
  Len := StrLen(Source);
  IF EatLen > Len THEN EatLen := Len;
  IF Dest <> NIL THEN
  BEGIN
    IF EatLen > MaxLen THEN EatLen := MaxLen;
    StrLCopy(Dest,Source,EatLen);
  END;
  StrMove(Source,@Source[EatLen],Len-EatLen+1);
  StrEat := Dest;
END; {StrEat}


{*****************************************************
 **                                                 **
 **  A better deallocation routine                  **
 **                                                 **
 *****************************************************}

PROCEDURE ForgetMem(VAR P;Size:WORD);
{free size heap memory, set P to NIL}
BEGIN
{is it already free?}
  IF POINTER(P) = NIL THEN EXIT;
{are we trying to free stack mem?}
  IF Seg(POINTER(P)^) = SSeg THEN EXIT;
{free to heap}
  FreeMem(POINTER(P),Size);
{return nil}
  POINTER(P) := NIL;
END; {ForgetMem}


{*****************************************************
 **                                                 **
 **  non-accessable VESA routines                   **
 **                                                 **
 *****************************************************}


FUNCTION _ReadAndWritablePort(PortAddr:WORD):BOOLEAN;
{find out whether we can read and write to the given port address}
VAR B:BYTE;
BEGIN
{start optimistic this time}
  _ReadAndWritablePort := TRUE;
{save contence}
  B := Port[PortAddr];
{try two different write and read to that port}
  Port[PortAddr] := $AA;
  IF Port[PortAddr] <> $AA THEN _ReadAndWritablePort := FALSE
  ELSE
  BEGIN
    Port[PortAddr] := $55;
    IF Port[PortAddr] <> $55 THEN _ReadAndWritablePort := FALSE
  END;
{restore contence}
  Port[PortAddr] := B;
END; {_ReadAndWritablePort}


FUNCTION _ReadAndWritablePortBits(PortAddr:WORD;Mask:BYTE):BOOLEAN;
{find out whether we can read and write the
 specified bits to the given port address}
VAR B:BYTE;
BEGIN
{start optimistic this time}
  _ReadAndWritablePortBits := TRUE;
{save contence}
  B := Port[PortAddr];
{try to clear bits}
  Port[PortAddr] := B AND NOT Mask;
  IF Port[PortAddr] AND Mask <> $00 THEN _ReadAndWritablePortBits := FALSE
  ELSE
  BEGIN
    {now try to set the same bits again}
    Port[PortAddr] := B OR Mask;
    IF Port[PortAddr] AND Mask <> Mask THEN _ReadAndWritablePortBits := FALSE;
  END;
  {try to restore, although we might not be succesfull at this}
  Port[PortAddr] := B;
END; {_ReadAndWritablePortBits}


PROCEDURE _DummyProc; FAR;
{this is a procedure that does nothing, it is usally attached to
 pointers which normally should not be used, just for safety..}
BEGIN
END; {_DummyProc}


FUNCTION _VESA_Valid:BOOLEAN;
{was the last VESA operation succesfull?}
BEGIN
  _VESA_Valid := (VESAStatus = $004F);
END; {_VESA_Valid}


PROCEDURE _VESA_SetMode(ModeNr:WORD);
{standard way to set the VESA mode}
BEGIN
  ASM
    MOV AX, $4F02          {function number}
    MOV BX, ModeNr         {mode number}
    INT $10                {BIOS-call 10h}
    MOV VESAStatus, AX     {report back}
  END;
END; {_VESA_SetMode}


PROCEDURE _VESA_Info(Info:POINTER);
{get the general VESA information block}
{might change stack when no VESA is present!!!!}
BEGIN
{clear it to be on the safe side}
  FillChar(Info^,SizeOf(VESAInfoBlock),0);
{request info}
  ASM
    MOV AX, $4F00
    LES DI, Info
    INT $10
    MOV VESAStatus, AX
  END;
END; {_VESA_Info}


PROCEDURE _VESA_ModeInfo(Mode:WORD;Info:POINTER);
{get the VESA information block of a paticular video modus}
BEGIN
{clear it to be on the safe side}
  FillChar(Info^,SizeOf(VESAInfoBlock),0);
{request info}
  ASM
    MOV AX, $4F01
    MOV CX, Mode
    LES DI, Info
    INT $10
    MOV VESAStatus, AX
  END;
END; {_VESA_ModeInfo}


FUNCTION _IsVESA:BOOLEAN;
{check whether there is a VESA BIOS interface section}
VAR Info:VESAInfoBlock;
BEGIN
  _VESA_Info(@Info);
  _IsVESA := _VESA_Valid AND (Info.I_VESASignature = 'VESA');
END; {_IsVESA}


FUNCTION _VESAMemorySize:LONGINT;
{returns the amount of memory available to the VESA}
VAR Info     :VESAInfoBlock;
    BlockSize:LONGINT;
BEGIN
  _VESA_Info(@Info);
  BlockSize        :=  $10000;                          {64 Kb block}
  _VESAMemorySize :=  BlockSize*Info.I_TotalMemory;    {number of blocks}
END; {_VESAMemorySize}


FUNCTION _VESAProducer:PCHAR;
{returns the name of the VESA product}
VAR Info:VESAInfoBlock;
BEGIN
  _VESA_Info(@Info);
  _VESAProducer := Info.I_OEMStringPtr;                {who did it?}
END; {_VESAProducer}


PROCEDURE _BankCall_VESA(Window,Bank:WORD); ASSEMBLER;
{goto the given window and bank}
ASM
  MOV DX, Bank             {get bank}
  MOV BX, Window           {get window}
  MOV BH, 0                {and set BH to zero}
  CALL BankCall            {call VESA BIOS}
END; {_BankCall_VESA}


PROCEDURE _SetBank_VESA(Bank:BYTE); FAR;
{set the 64Kb read and write bank}
BEGIN
  _BankCall_VESA(BankWindow1,WORD(Bank) SHL ShiftCount);
END; {_SetBank_VESA}


PROCEDURE _SetWriteBank_VESA(Bank:BYTE); FAR;
{set the 64Kb write bank}
BEGIN
  _BankCall_VESA(BankWindow1,WORD(Bank) SHL ShiftCount);
END; {_SetWriteBank_VESA}


PROCEDURE _SetReadBank_VESA(Bank:BYTE); FAR;
{set the 64Kb read bank}
BEGIN
  _BankCall_VESA(BankWindow2,WORD(Bank) SHL ShiftCount);
END; {_SetReadBank_VESA}


PROCEDURE _SetDualBank_VESA(Bank:BYTE); FAR;
{emulate a single mode while VESA supports dual mode only}
BEGIN
  _BankCall_VESA(BankWindow1,Word(Bank) SHL ShiftCount);
  _BankCall_VESA(BankWindow2,Word(Bank) SHL ShiftCount);
END; {_SetDualBank_VESA}


PROCEDURE _SetSplitBank_VESA(Bank:BYTE); FAR;
{emulate a single mode while VESA supports split mode only}
BEGIN
  _BankCall_VESA(BankWindow1,Word(Bank) SHL ShiftCount);
  _BankCall_VESA(BankWindow2,Word(Bank) SHL ShiftCount + 1 SHL (ShiftCount-1));
END; {_SetSplitBank_VESA}


FUNCTION _InitVESA(ModeNr:BYTE):BOOLEAN;
{initialize the card to the given mode, returns succes of operation}
VAR ModeInfo:VESAModeInfoBlock;
    Flag    :BOOLEAN;
    Name    :PCHAR;
FUNCTION __IsSingle:BOOLEAN;
{returns true when only one window is used for reading and writing}
BEGIN
  {start pessimistic}
  __IsSingle := FALSE;
  WITH ModeInfo DO
  BEGIN
    IF M_WinSize = 64 THEN {we should have a window of 64Kb}
    BEGIN
      IF (M_WinAAttr AND $07 = $07) AND (M_WinASegment = VGASeg) THEN
      BEGIN
        BankWindow1 := 0;    {window A is used for reading and writing}
        __IsSingle  := TRUE;
      END
      ELSE
      IF (M_WinBAttr AND $07 = $07) AND (M_WinBSegment = VGASeg) THEN
      BEGIN
        BankWindow1 := 1;    {window B is used for reading and writing}
        __IsSingle  := TRUE;
      END;
    END;
  END;
END; {__IsSingle}
FUNCTION __IsDual:BOOLEAN;
{returns true when one windows is used for reading and
 another for writing, this is called the dual mode}
BEGIN
  {start pessimistic}
  __IsDual := FALSE;
  WITH ModeInfo DO
  BEGIN
    IF (M_WinSize = 64) AND           {we should have windows of 64Kb}
       (M_WinASegment = VGASeg) AND   {both windows A and B at $A0000}
       (M_WinBSegment = VGASeg) THEN
    BEGIN
      IF (M_WinAAttr AND $07 = $05) AND (M_WinBAttr AND $07 = $03) THEN
      BEGIN
        {windows A used for writing and B for reading}
        BankWindow1 := 0;
        BankWindow2 := 1;
        __IsDual    := TRUE;
      END
      ELSE
      IF (M_WinAAttr AND $07 = $03) AND (M_WinBAttr AND $07 = $05) THEN
      BEGIN
        {windows B used for writing and A for reading}
        BankWindow1 := 1;
        BankWindow2 := 0;
        __IsDual    := TRUE;
      END;
    END;
  END;
END; {__IsDual}
FUNCTION __IsSplit:BOOLEAN;
{returns true when VESA uses the split mode; there are
 two windows of 32Kb, both for reading and writing but
 for two different part of the display memory}
BEGIN
  {start pessimistic}
  __IsSplit := FALSE;
  WITH ModeInfo DO
  BEGIN
    IF (M_WinSize = 32) AND            {we should have windows of 32Kb}
       (M_WinAAttr AND $07 = $07) AND  {both reading and writing}
       (M_WinBAttr AND $07 = $07) THEN
    BEGIN
      IF (M_WinASegment = $A000) AND (M_WinBSegment = $A800) THEN
      BEGIN
        {window A above window B}
        BankWindow1 := 0;
        BankWindow2 := 1;
        __IsSplit   := TRUE;
      END
      ELSE IF (M_WinASegment = $A800) AND (M_WinBSegment = $A000) THEN
      BEGIN
        {window B above window A}
        BankWindow1 := 1;
        BankWindow2 := 0;
        __IsSplit   := TRUE;
      END;
    END;
  END;
END; {__IsSplit}
BEGIN {_InitVESA}
{start pessimistic}
  _InitVESA := FALSE;
{get modus information}
  _VESA_ModeInfo(Word(ModeNr) OR $100,@ModeInfo);
  WITH ModeInfo DO
  BEGIN
    IF _VESA_Valid AND (M_WinFuncPtr <> NIL) THEN
    BEGIN
      {yes, it's there, copy the bank call routine pointer}
      BankCall := M_WinFuncPtr;
      IF __IsDual THEN {dual mode implementation}
      BEGIN
        _SetVESABank      := _SetDualBank_VESA;
        _SetVESAWriteBank := _SetWriteBank_VESA;
        _SetVESAReadBank  := _SetReadBank_VESA;
        DualModePossible   := TRUE;
      END
      ELSE
      IF __IsSingle THEN {single mode implementation}
      BEGIN
        _SetVESABank      := _SetBank_VESA;
        _SetVESAWriteBank := _SetBank_VESA;
        _SetVESAReadBank  := _SetBank_VESA;
        DualModePossible   := FALSE;
      END
      ELSE
      IF __IsSplit THEN {split mode implementation}
      BEGIN
        _SetVESABank      := _SetSplitBank_VESA;
        _SetVESAWriteBank := _SetSplitBank_VESA;
        _SetVESAReadBank  := _SetSplitBank_VESA;
        DualModePossible   := FALSE;
      END
      ELSE EXIT; {not a known implementation}
      {determine the shift to ajust window granularity}
      ShiftCount := 0;
      IF M_WinGranularity <> 0 THEN
      BEGIN
        WHILE (M_WinGranularity SHL ShiftCount < 64) DO Inc(ShiftCount);
      END;
      {determine amount of memory}
      VideoMemorySize := _VESAMemorySize;
      {actually start the VESA modus}
      _VESA_SetMode(Word(ModeNr) OR $100);
      {return succes}
      _InitVESA := _VESA_Valid;
    END;
  END;
END; {_InitVESA}


{*****************************************************
 **                                                 **
 **  accessable VESA routines                       **
 **                                                 **
 *****************************************************}


PROCEDURE SelectVESABank(Bank:BYTE);
{select bank for reading and writing in single mode}
BEGIN
  IF Bank <> ActiveBank THEN {we need to select another bank}
  BEGIN
    _SetVESABank(Bank);
    ActiveBank := Bank;
  END;
END; {SelectVESABank}


PROCEDURE NextVESABank;
{goto next bank for reading and writing in single mode}
BEGIN
  Inc(ActiveBank);
  _SetVESABank(ActiveBank);
END; {NextVESABank}


PROCEDURE SelectVESAWriteBank(Bank:BYTE);
{select bank for writing in dual mode}
BEGIN
  IF Bank <> ActiveWriteBank THEN
  BEGIN
    _SetVESAWriteBank(Bank);
    ActiveWriteBank := Bank;
  END;
END; {SelectVESAWriteBank}


PROCEDURE NextVESAWriteBank;
{goto next bank for writing in dual mode}
BEGIN
  Inc(ActiveWriteBank);
  _SetVESABank(ActiveWriteBank);
END; {NextVESAWriteBank}


PROCEDURE SelectVESAReadBank(Bank:BYTE);
{select bank for reading in dual mode}
BEGIN
  IF Bank <> ActiveReadBank THEN
  BEGIN
    _SetVESAReadBank(Bank);
    ActiveReadBank := Bank;
  END;
END; {SelectVESAReadBank}


PROCEDURE NextVESAReadBank;
{goto next bank for reading in dual mode}
BEGIN
  Inc(ActiveReadBank);
  _SetVESABank(ActiveReadBank);
END; {NextVESAReadBank}


FUNCTION SelectVESADualMode:BOOLEAN;
{switch to dual mode}
BEGIN
  IF DualModePossible THEN
  BEGIN
    ActiveWriteBank := $FF;
    ActiveReadBank  := $FF;
    _SetDualMode;
  END;
{return}
  SelectVESADualMode := DualModePossible;
END; {SelectVESADualMode}


PROCEDURE SelectVESASingleMode;
{switch to single mode}
BEGIN
  ActiveBank := $FF;
  _SetSingleMode;
END; {SelectVESASingleMode}


FUNCTION GetVESAMemorySize:LONGINT;
{return the amount of accessable video memory in bytes,
 note that this function does not have to return the
 actual amount of memory mounted on the video card!}
BEGIN
  GetVESAMemorySize := VideoMemorySize;
END; {GetVESAMemorySize}


FUNCTION GetVESAVirtualHeight:INTEGER;
{returns the possible height of the virtual screen,
 this simply depends on the amount of memory}
BEGIN
  GetVESAVirtualHeight := VideoMemorySize DIV BytesPerLine;
END; {GetVESAVirtualHeight}


FUNCTION GetVESAAbsAddress(X,Y:INTEGER):LONGINT;
{returns the absolute adress of the start of the given line}
BEGIN
  GetVESAAbsAddress := LONGINT(Y)*BytesPerLine+X;
END; {GetVESAAbsAddress}


PROCEDURE SetVESAVirtualTop(Y:INTEGER);
{set the y position in the virtual display
 where the extranal video signal should start
 by settting the extended display start address}
BEGIN
  ASM
    MOV AX, $4F07
    MOV BX, $0000
    MOV CX, $0000
    MOV DX, Y
    INT $10
    MOV VESAStatus, AX
  END;
END; {SetVESAVirtualTop}


PROCEDURE StartMouse; FORWARD;
PROCEDURE StopMouse; FORWARD;


FUNCTION StartVESA256(VESAMode:VESAModeClass;StartColor:BYTE):BOOLEAN;
{try to initialize the given VESA card in the given mode,
 returns whether the operation was succesfull}
VAR ModeNr:BYTE;
BEGIN
{start pessimistic}
  StartVESA256 := FALSE;
{stop before start}
  IF GraphicsOn THEN FinishVESA256;
{stop the mouse}
  StopMouse;
{get the mode number}
  ModeNr := ModeTable[VESAMode];
{attach dummy procs to the bank selectors}
  _SetSingleMode := _DummyProc;
  _SetDualMode   := _DummyProc;
  IF _IsVESA THEN
  IF _InitVESA(ModeNr) THEN
  BEGIN
    {always start with the single mode}
    SelectVESASingleMode;
    {get some info}
    VESAMaxX     := ModeInfo[VESAMode].M_W-1;
    VESAMaxY     := ModeInfo[VESAMode].M_H-1;
    BytesPerLine := ModeInfo[VESAMode].M_Line;
    {it's on!}
    GraphicsOn   := TRUE;
    {full view port}
    SetViewPort(0,0,VESAMaxX,VESAMaxY,TRUE);
    {default palette}
    SetDefaultPalette;
    {use starting color}
    ClearGraphics(StartColor);
    {start the mouse}
    StartMouse;
    {report succes}
    StartVESA256 := TRUE;
  END;
END; {StartVESA256}


PROCEDURE StopRAMFonts; FORWARD;


PROCEDURE FinishVESA256;
{close down the graphics again}
BEGIN
{make sure we don't use heap anymore for bitmap fonts}
  StopRAMFonts;
{stop the mouse}
  StopMouse;
{simply switch back to 80x25 text mode by 16 colors}
  ASM
    MOV AX, $0003
    INT $10
  END;
{and it is off again}
  GraphicsOn := FALSE;
{start the mouse}
  StartMouse;
END; {FinishVESA256}


{*****************************************************
 **                                                 **
 **  one special crt routine                        **
 **                                                 **
 *****************************************************}

PROCEDURE WaitTOF;
{will wait until the vertical retrace starts, normal VGA is 60 Hz}
BEGIN
  ASM
  @Retry1:
      MOV DX,3DAH    {get the video adress in dx}
      IN  AL,DX      {load what's there}
      AND AL,08H     {get the flag}
      JNZ @Retry1    {wait until it is not zero}
  @Retry2:
      MOV DX,3DAH    {get the video adress in dx}
      IN  AL,DX      {load what's there}
      AND AL,08H     {get the flag}
      JZ @Retry2     {wait until it is zero}
  END;
END; {WaitTOF}


{*****************************************************
 **                                                 **
 **  paging system                                  **
 **                                                 **
 *****************************************************}


FUNCTION GetHighestPageNr:BYTE;
{get highest page number; improvement on borland's pascal}
BEGIN
{return}
  GetHighestPageNr := (GetVESAVirtualHeight DIV GetScreenHeight)-1;
END; {GetHighestPageNr}


FUNCTION ExistingPage(PageNr:BYTE):BOOLEAN;
{test whether a page does exist; improvement on borland's pascal}
BEGIN
{return}
  ExistingPage := GetVESAVirtualHeight >= (PageNr+1)*GetScreenHeight;
END; {ExistingPage}


PROCEDURE SetVisualPage(PageNr:BYTE);
{same as in borland's pascal graph unit}
BEGIN
{protect}
  IF NOT ExistingPage(PageNr) THEN EXIT;
{do it}
  SetVESAVirtualTop(PageNr*(VESAMaxY+1));
{remember that}
  VisualPageNr := PageNr;
{and wait.... until that page is indeed show!}
  WaitTOF;
END; {SetVisualPage}


FUNCTION GetVisualPage:BYTE;
{return the currently selected visual page}
BEGIN
  GetVisualPage := VisualPageNr;
END; {GetVisualPage}


PROCEDURE SetActivePage(PageNr:BYTE);
{same as in borland's pascal graph unit}
BEGIN
{protect}
  IF NOT ExistingPage(PageNr) THEN EXIT;
  IF ActivePageNr = PageNr THEN EXIT;
{do it}
  ActivePageTop := PageNr*(VESAMaxY+1);
{reset viewport!}
  SetViewPort(0,0,GetMaxX,GetMaxY,TRUE);
{remember that}
  ActivePageNr  := PageNr;
END; {SetActivePage}


FUNCTION GetActivePage:BYTE;
{return the currently selected active page}
BEGIN
{return}
  GetActivePage := ActivePageNr;
END; {GetActivePage}


PROCEDURE ScrollToPage(PageNr:BYTE;ScrollTime:REAL);
{scroll to the given page with the given speed (assuming 60 Hz)}
CONST VESAFrequency = 60;
VAR SourceY,DestY,HalfY,Index,Size,Steps,CurrentY:INTEGER;
    HalfPiInvSteps,HalfSize                      :REAL;
BEGIN
{protect}
  IF NOT ExistingPage(PageNr) THEN EXIT;
  ScrollTime := Abs(ScrollTime);
  IF ScrollTime > 15.0 THEN ScrollTime := 15.0;
{compute the route}
  SourceY        := VisualPageNr*(VESAMaxY+1);
  DestY          := PageNr*(VESAMaxY+1);
  HalfY          := (SourceY+DestY) DIV 2;
  Size           := Abs(DestY-SourceY);
  Steps          := Round(ScrollTime*VESAFrequency);
  HalfPiInvSteps := 0.5*Pi/Steps;
  HalfSize       := 0.5*Size;
  FOR Index := -Steps TO Steps DO
  BEGIN
    CurrentY := Round(HalfSize*Sin(HalfPiInvSteps*Index));
    IF SourceY < DestY THEN CurrentY := HalfY+CurrentY
                       ELSE CurrentY := HalfY-CurrentY;
    WaitTOF;
    SetVESAVirtualTop(CurrentY);
  END;
{make sure we get there}
  WaitTOF;
  SetVESAVirtualTop(DestY);
{remember that}
  VisualPageNr := PageNr;
{it is also activated!}
  SetActivePage(PageNr);
END; {ScrollToPage}


{*****************************************************
 **                                                 **
 **  screen dimemsions                              **
 **                                                 **
 *****************************************************}


FUNCTION GetMaxX:INTEGER;
{same function, but corrected for text mode 8x16 font}
BEGIN
  ASM
    MOV AX,  VESAMaxX
    INC AX
    AND AX,  $FFF8       {mask out lower 3 bits}
    DEC AX
    MOV [@Result], AX
  END;
END; {GetMaxX}


FUNCTION GetMaxY:INTEGER;
{same function, but corrected for text mode 8x16 font}
BEGIN
  ASM
    MOV AX,  VESAMaxY
    INC AX
    AND AX,  $FFF0       {mask out lower 4 bits}
    DEC AX
    MOV [@Result], AX
  END;
END; {GetMaxY}


FUNCTION GetScreenWidth:INTEGER;
{corrected for text mode 8x16 font}
BEGIN
  GetScreenWidth := GetMaxX+1;
END; {GetScreenWidth}


FUNCTION GetScreenHeight:INTEGER;
{corrected for text mode 8x16 font}
BEGIN
  GetScreenHeight := GetMaxY+1;
END; {GetScreenHeight}


PROCEDURE GetAspectRatio(VAR AspectX,AspectY:WORD);
{return the aspect ratio of the currently displayed mode}
BEGIN
  AspectX := 10000;
  AspectY := Round(13333.33333*(GetScreenHeight/GetScreenWidth));
END; {GetAspectRatio}


{*****************************************************
 **                                                 **
 **  viewport system                                **
 **                                                 **
 *****************************************************}


PROCEDURE BoxInOrder(VAR X1,Y1,X2,Y2:INTEGER); ASSEMBLER;
{some routines require X1 <= X2 and Y1 <= Y2}
ASM
{highly optimized code:}
  LES DI,      [X1]
  MOV AX,      [ES:DI]           {AX contains X1}
  LES DI,      [X2]
  MOV BX,      [ES:DI]           {BX contains X2}
  CMP AX, BX
  JLE @X_OK                      {check order}
  MOV [ES:DI], AX                {put AX into X2}
  LES DI,      [X1]
  MOV [ES:DI], BX                {put BX into X1}
@X_OK:
  LES DI,      [Y1]
  MOV AX,      [ES:DI]           {AX contains Y1}
  LES DI,      [Y2]
  MOV BX,      [ES:DI]           {BX contains Y2}
  CMP AX, BX
  JLE @Y_OK                      {check order}
  MOV [ES:DI], AX                {put AX into Y2}
  LES DI,      [Y1]
  MOV [ES:DI], BX                {put BX into Y1}
@Y_OK:
END; {BoxInOrder}


PROCEDURE GetViewSettings(VAR ViewPort:ViewPortType);
{same as in borland's pascal graph unit}
BEGIN
{fill record}
  WITH ViewPort DO
  BEGIN
    V_X1     := ViewPortLeft;
    V_X2     := ViewPortRight;
    V_Y1     := ViewPortTop-ActivePageTop;
    V_Y2     := ViewPortBottom-ActivePageTop;
    V_ClipOn := ViewPortClipOn;
  END;
END; {GetViewSettings}


PROCEDURE SetViewSettings(ViewPort:ViewPortType);
{setting it using a predefined record}
BEGIN
{do it}
  WITH ViewPort DO SetViewPort(V_X1,V_Y1,V_X2,V_Y2,V_ClipOn);
END; {SetViewSettings}


PROCEDURE SetViewPort(X1,Y1,X2,Y2:INTEGER;Clip:BOOLEAN);
{same as in borland's pascal graph unit}
BEGIN
{protect}
  BoxInOrder(X1,Y1,X2,Y2);
  IF X1 < 0 THEN X1 := 0;
  IF Y1 < 0 THEN Y1 := 0;
  IF X2 > GetMaxX THEN X2 := GetMaxX;
  IF Y2 > GetMaxY THEN Y2 := GetMaxY;
{do it}
  ViewPortWidth  := X2-X1+1;
  ViewPortHeight := Y2-Y1+1;
  ViewPortLeft   := X1;
  ViewPortRight  := X2;
  ViewPortTop    := Y1+ActivePageTop;
  ViewPortBottom := Y2+ActivePageTop;
  ViewPortClipOn := Clip;
END; {SetViewPort}


PROCEDURE ValidateGraphicsBox(VAR X,Y,W,H:INTEGER); FORWARD;


PROCEDURE ClipGraphics(X,Y,W,H:INTEGER);
{select a part of the display}
BEGIN
{protect}
  ValidateGraphicsBox(X,Y,W,H);
{select the area}
  SetViewPort(X,Y,X+W-1,Y+H-1,TRUE);
END; {ClipGraphics}


PROCEDURE UnClipGraphics;
{selects the whole display}
BEGIN
{select the area specific to text mode!}
  SetViewPort(0,0,GetMaxX,GetMaxY,TRUE);
END; {UnClipGraphics}


FUNCTION ViewPortLineClipping(VAR X1,Y1,X2,Y2:INTEGER):BOOLEAN;
{special clipping routine for a line; advanced coding!
 returns only true when the line can be drawn,
 input : viewport coordinates
 output: raw coordinates (only when it can be drawn)}
LABEL RepeatClipping,NoClipBottom,NoClipTop,
      NoClipRight,AcceptClip,RejectClip;
VAR   Flipped        :BOOLEAN;
      LX1,LY1,LX2,LY2:INTEGER;
BEGIN
  ASM
  {we have not flipped}
    MOV  Flipped, $00
  {move arguments to local variables}
    LES  DI, [X1]
    MOV  AX, [ES:DI]
    MOV  LX1, AX
    LES  DI, [Y1]
    MOV  AX, [ES:DI]
    MOV  LY1, AX
    LES  DI, [X2]
    MOV  AX, [ES:DI]
    MOV  LX2, AX
    LES  DI, [Y2]
    MOV  AX, [ES:DI]
    MOV  LY2, AX
  {quickest way to change to viewport coordinates}
    {get x-axis}
    MOV  AX, LX1
    MOV  BX, LX2
    {move into viewport}
    MOV  CX, ViewPortLeft
    ADD  AX, CX
    ADD  BX, CX
    {return x-axis}
    MOV  LX1, AX
    MOV  LX2, BX
    {get y-axis}
    MOV  AX, LY1
    MOV  BX, LY2
    {move into viewport}
    MOV  CX, ViewPortTop
    ADD  AX, CX
    ADD  BX, CX
    {return y-axis}
    MOV  LY1, AX
    MOV  LY2, BX
  {perform the complex clipping?}
    XOR  AL, AL
    CMP  AL, ViewPortClipOn
    JE  AcceptClip           {no clipping needed}
  RepeatClipping:
  {determine outcodes; remember that they will stay in CX for a long time!}
    XOR  CL, CL              {CL will be code1; make it zero}
    MOV  AX, LX1             {X1 will be in AX}
    MOV  BX, LY1             {Y1 will be in BX}
    CMP  BX, ViewPortBottom
    JG  @Below1              {point is below viewport}
    CMP  BX, ViewPortTop
    JGE @NextAxis1           {point not above viewport}
    OR   CL, 2               {code for above}
    JMP @NextAxis1
  @Below1:
    OR   CL, 1               {code for below}
  @NextAxis1:
    CMP  AX, ViewPortRight
    JG  @Right1              {point is right of viewport}
    CMP  AX, ViewPortLeft
    JGE @Done1               {point not left of viewport}
    OR   CL, 8               {code for left}
    JMP @Done1
  @Right1:
    OR   CL, 4               {code for right}
  @Done1:
  {the same code again for the second point}
    XOR  CH, CH              {CH will be code2; make it zero}
    MOV  AX, LX2             {X2 will be in AX}
    MOV  BX, LY2             {Y2 will be in BX}
    CMP  BX, ViewPortBottom
    JG  @Below2              {point is below viewport}
    CMP  BX, ViewPortTop
    JGE @NextAxis2           {point not above viewport}
    OR   CH, 2               {code for above}
    JMP @NextAxis2
  @Below2:
    OR   CH, 1               {code for below}
  @NextAxis2:
    CMP  AX, ViewPortRight
    JG  @Right2              {point is right of viewport}
    CMP  AX, ViewPortLeft
    JGE @Done2               {point not left of viewport}
    OR   CH, 8               {code for left}
    JMP @Done2
  @Right2:
    OR   CH, 4               {code for right}
  @Done2:
    {can it be rejected right away?}
    MOV  AX, CX
    AND  AL, AH
    JNZ RejectClip
    {can it be accepted right away?}
    MOV  AX, CX
    OR   AL, AH
    JZ  AcceptClip
  {is code1 already inside the viewport?}
    TEST CL, CL
    JNZ @StartClipping
  {swap points on each pass when code1 is inside viewport}
    MOV  AX, LX1
    MOV  BX, LX2
    MOV  LX1, BX
    MOV  LX2, AX
    MOV  AX, LY1
    MOV  BX, LY2
    MOV  LY1, BX
    MOV  LY2, AX
    XCHG CL, CH              {exchange code1 and code2}
    {confirm swap}
    NOT  Flipped
  @StartClipping:
  {actual clipping; remember that CL contains the clipping code}
    TEST CL, $01
    JZ NoClipBottom
  END;
  {this stuff had better be coded by borland...}
  Inc(LX1,Round((ViewPortBottom-LY1)/(LY2-LY1)*(LX2-LX1)));
  LY1 := ViewPortBottom;
  ASM
    JMP RepeatClipping
  NoClipBottom:
    TEST CL, $02
    JZ NoClipTop
  END;
  {this stuff had better be coded by borland...}
  Inc(LX1,Round((ViewPortTop-LY1)/(LY2-LY1)*(LX2-LX1)));
  LY1 := ViewPortTop;
  ASM
    JMP RepeatClipping
  NoClipTop:
    TEST CL, $04
    JZ NoClipRight
  END;
  {this stuff had better be coded by borland...}
  Inc(LY1,Round((ViewPortRight-LX1)/(LX2-LX1)*(LY2-LY1)));
  LX1 := ViewPortRight;
  ASM
    JMP RepeatClipping
  NoClipRight:
  END;
  {this stuff had better be coded by borland...}
  Inc(LY1,Round((ViewPortLeft-LX1)/(LX2-LX1)*(LY2-LY1)));
  LX1 := ViewPortLeft;
  ASM
    JMP RepeatClipping
  {clipping is accepted!}
  AcceptClip:
    {return true}
    MOV [@Result], TRUE
  {do we need to unswap while putting back the arguments?}
    MOV  AL, Flipped
    TEST AL, AL
    JZ  @NotFlipped
    MOV  AX, LX1
    MOV  BX, LX2
    LES  DI, [X1]
    MOV  [ES:DI], BX
    LES  DI, [X2]
    MOV  [ES:DI], AX
    MOV  AX, LY1
    MOV  BX, LY2
    LES  DI, [Y1]
    MOV  [ES:DI], BX
    LES  DI, [Y2]
    MOV  [ES:DI], AX
    JMP @Finish
  @NotFlipped:
    MOV  AX, LX1
    MOV  BX, LX2
    LES  DI, [X1]
    MOV  [ES:DI], AX
    LES  DI, [X2]
    MOV  [ES:DI], BX
    MOV  AX, LY1
    MOV  BX, LY2
    LES  DI, [Y1]
    MOV  [ES:DI], AX
    LES  DI, [Y2]
    MOV  [ES:DI], BX
    JMP @Finish
  RejectClip:
    {return false}
    MOV [@Result], FALSE
  @Finish:
  END;
END; {ViewPortLineClipping}


FUNCTION ViewPortBoxClipping(VAR X1,Y1,X2,Y2:INTEGER):BOOLEAN;
{simple box clipping routine, it is highly optimized,
 it also puts the box in order, see 'BoxInOrder'.
 returns only true when the box can be drawn,
 input : viewport coordinates
 output: raw coordinates (only when it can be drawn)}
BEGIN
  ASM
    {start pessimistic}
    MOV  [@Result], FALSE
    {get arguments}
    LES  DI, [X1]
    MOV  AX, [ES:DI]                {AX contains X1}
    LES  DI, [X2]
    MOV  BX, [ES:DI]                {BX contains X2}
    CMP  AX, BX
    JLE  @X_OK                      {check order}
    XCHG AX, BX                     {correct it}
  @X_OK:
    LES  DI, [Y1]
    MOV  CX, [ES:DI]                {CX contains Y1}
    LES  DI, [Y2]
    MOV  DX, [ES:DI]                {DX contains Y2}
    CMP  CX, DX
    JLE  @Y_OK                      {check order}
    XCHG CX, DX                     {correct it}
  @Y_OK:
    {move into viewport}
    MOV  SI, ViewPortLeft
    ADD  AX, SI
    ADD  BX, SI
    MOV  SI, ViewPortTop
    ADD  CX, SI
    ADD  DX, SI
    {perform the clipping?}
    MOV  SI, AX                     {store AX in SI}
    XOR  AL, AL
    CMP  AL, ViewPortClipOn
    MOV  AX, SI                     {restore AX, don't change flags}
    JE  @AcceptClip                 {no clipping needed}
    {out of range right?}
    CMP  AX, ViewPortRight
    JG  @RejectClip
    {out of range left?}
    CMP  BX, ViewPortLeft
    JL  @RejectClip
    {out of range bottom?}
    CMP  CX, ViewPortBottom
    JG  @RejectClip
    {out of range top?}
    CMP  DX, ViewPortTop
    JL  @RejectClip
    {now do the actual clipping}
    MOV  SI, ViewPortLeft
    CMP  AX, SI
    JGE @Jump1
    MOV  AX, SI
  @Jump1:
    MOV  SI, ViewPortRight
    CMP  BX, SI
    JLE @Jump2
    MOV  BX, SI
  @Jump2:
    MOV  SI, ViewPortTop
    CMP  CX, SI
    JGE @Jump3
    MOV  CX, SI
  @Jump3:
    MOV  SI, ViewPortBottom
    CMP  DX, SI
    JLE @Jump4
    MOV  DX, SI
  @Jump4:
  {clipping is accepted!}
  @AcceptClip:
    {return true}
    MOV [@Result], TRUE
    LES  DI, [X1]
    MOV  [ES:DI], AX
    LES  DI, [X2]
    MOV  [ES:DI], BX
    LES  DI, [Y1]
    MOV  [ES:DI], CX
    LES  DI, [Y2]
    MOV  [ES:DI], DX
    JMP @Finish
  @RejectClip:
    {return false}
    MOV [@Result], FALSE
  @Finish:
  END;
END; {ViewPortBoxClipping}


{*****************************************************
 **                                                 **
 **  drawing style system                           **
 **                                                 **
 *****************************************************}


PROCEDURE SetBGColor(Color:BYTE);
{set the background color}
BEGIN
  DrawBGColor := Color;
END; {SetBGColor}


PROCEDURE _SetColorAndBitBlit(Color,BitBlit:BYTE); ASSEMBLER;
{only set the color and blit operation}
ASM
  MOV AL, Color         {get color}
  MOV DrawFGColor, AL   {into drawfgcolor}
  MOV AL, BitBlit       {get bitblit}
  MOV DrawBitBlit, AL   {into drawbitblit}
  MOV BL, AL            {make copy in BL}
  AND BL, $0B           {keep 3 bits}
  MOV DrawLogic, BL     {store in drawlogic}
  AND AL, $04           {extract inverse bit}
  SHR AL, 2             {move it down}
  MOV DrawInverse, AL   {store in drawinverse}
END; {_SetColorAndBlit}


PROCEDURE SetPixelMode(Color,BitBlit:BYTE);
{set all the things needed for pixel drawing, optimized!}
BEGIN
  DrawMode    := PixelDrawing;
  _SetColorAndBitBlit(Color,BitBlit);
END; {SetPixelMode}


PROCEDURE SetLineMode(Color,Pattern,Width,BitBlit:BYTE);
{set all the things needed for line drawing, optimized!}
BEGIN
  DrawMode    := LineDrawing;
  DrawPattern := Pattern;
  DrawWidth   := Width;
  _SetColorAndBitBlit(Color,BitBlit);
  SetBGColor(Black);
END; {SetLineMode}


PROCEDURE SetFillMode(Color,Pattern,BitBlit:BYTE);
{set all the things needed for fill drawing, optimized!}
BEGIN
  DrawMode    := FillDrawing;
  DrawPattern := Pattern;
  _SetColorAndBitBlit(Color,BitBlit);
  SetBGColor(Black);
END; {SetLineMode}


PROCEDURE GetDrawingMode(VAR Mode:DrawModeType);
{get the complete drawing mode}
BEGIN
  WITH Mode DO
  BEGIN
    D_Mode    := DrawMode;
    D_Pattern := DrawPattern;
    D_Width   := DrawWidth;
    D_FGColor := DrawFGColor;
    D_BGColor := DrawBGColor;
    D_BitBlit := DrawBitBlit;
  END;
END; {GetDrawingMode}


PROCEDURE SetDrawingMode(VAR Mode:DrawModeType);
{set the complete drawing mode}
BEGIN
  WITH Mode DO
  BEGIN
    DrawMode    := D_Mode;
    DrawPattern := D_Pattern;
    DrawWidth   := D_Width;
    DrawBGColor := D_BGColor;
    _SetColorAndBitBlit(D_FGColor,D_BitBlit);
  END;
END; {SetDrawingMode}


{*****************************************************
 **                                                 **
 **  cursor system                                  **
 **                                                 **
 *****************************************************}


FUNCTION GetX:INTEGER;
{get the horizontal position of the graphical cursor}
BEGIN
{return}
  GetX := CursorX;
END; {GetX}


FUNCTION GetY:INTEGER;
{get the vertical position of the graphical cursor}
BEGIN
{return}
  GetY := CursorY;
END; {GetY}


PROCEDURE _MoveCursor(X,Y:INTEGER;WhileDrawing:BOOLEAN);
{move cursor to x,y}
BEGIN
{move}
  CursorX    := X;
  CursorY    := Y;
  CursorDown := WhileDrawing;
END; {_MoveCursor}


PROCEDURE MoveTo(X,Y:INTEGER);
{move cursor to x,y}
BEGIN
  _MoveCursor(X,Y,FALSE);
END; {MoveTo}


PROCEDURE RelMoveTo(X,Y:INTEGER);
{relative move cursor to x,y}
BEGIN
  _MoveCursor(CursorX+X,CursorY+Y,FALSE);
END; {RelMoveTo}


{*****************************************************
 **                                                 **
 **  line system                                    **
 **                                                 **
 *****************************************************}


PROCEDURE _HL(Ofs,Len:WORD); FAR;
{draw a horizontal line of length+1 bytes in given color
 this is a sub-routine of _RawHorLine which does no bank switching
 note that this routine is much faster that the 'PutPixel' routine}
BEGIN
  IF LineBits = $FFFF THEN
  CASE DrawBitBlit OF
    CopyBlit   : ASM
                 {32 bit optimized}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   AL, DrawFGColor {get color in AL}
                   MOV   AH, AL          {copy color also to AH}
                   MOV   BX, AX          {temporarily push AX in BX}
                   DB    $66             {next instruction is 32Bit!}
                   SHL   AX, 16          {shift AX into extended part}
                   MOV   AX, BX          {restore AX from BX}
                   MOV   CX, Len         {CX = len}
                   CLD                   {move forward}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JNC  @Jump1           {when even then skip next}
                   STOSB                 {add one byte}
                 @Jump1:
                   JZ   @Finish          {skip when length = 0}
                   SHR   CX, 1           {again (len-1) DIV 2}
                   JNC  @Jump2           {when even then skip next}
                   STOSW                 {add two bytes}
                 @Jump2:
                   JZ   @Finish          {skip when length = 0}
                   DB    $66             {next instruction is 32Bit!}
                   REP   STOSW           {fill CX double words with AX}
                 @Finish:
                   STOSB                 {add an extra pixel}
                 END;
    XORBlit    : ASM
                 {32 bit optimized}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, BL          {copy color also to BH}
                   MOV   AX, BX          {temporarily push BX in AX}
                   DB    $66             {next instruction is 32Bit!}
                   SHL   BX, 16          {shift AX into extended part}
                   MOV   BX, AX          {restore BX from AX}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JNC  @Jump1           {when even then skip next}
                   MOV   AL, [ES:DI]     {put one pixel}
                   XOR   AL, BL
                   MOV   [ES:DI], AL
                   INC   DI              {advance one step}
                 @Jump1:
                   TEST  CX, CX
                   JZ   @Finish          {skip when length = 0}
                   SHR   CX, 1           {again (len-1) DIV 2}
                   JNC  @Jump2           {when even then skip next}
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   XOR   AX, BX          {perform XOR operation}
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                 @Jump2:
                   TEST  CX, CX
                   JZ   @Finish          {skip when length = 0}
                   MOV   DX, 4           {four steps forward}
                 @Repeat:
                   DB    $66             {next instruction is 32Bit!}
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   DB    $66             {next instruction is 32Bit!}
                   XOR   AX, BX          {perform XOR operation}
                   DB    $66             {next instruction is 32Bit!}
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   ADD   DI, DX          {do four steps!}
                   LOOP @Repeat
                 @Finish:
                   MOV   AL, [ES:DI]     {put one pixel extra}
                   XOR   AL, BL
                   MOV   [ES:DI], AL
                 END;
    SpriteBlit : ASM
                 {32 bit optimized}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   AL, DrawFGColor {get color in AL}
                 {when color is zero we do nothing otherwise we simply draw}
                   CMP   AL, $00
                   JE   @AfterFinish
                   MOV   AH, AL          {copy color also to AH}
                   MOV   BX, AX          {temporarily push AX in BX}
                   DB    $66             {next instruction is 32Bit!}
                   SHL   AX, 16          {shift AX into extended part}
                   MOV   AX, BX          {restore AX from BX}
                   MOV   CX, Len         {CX = len}
                   CLD                   {move forward}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JNC  @Jump1           {when even then skip next}
                   STOSB                 {add one byte}
                 @Jump1:
                   JZ   @Finish          {skip when length = 0}
                   SHR   CX, 1           {again (len-1) DIV 2}
                   JNC  @Jump2           {when even then skip next}
                   STOSW                 {add two bytes}
                 @Jump2:
                   JZ   @Finish          {skip when length = 0}
                   DB    $66             {next instruction is 32Bit!}
                   REP   STOSW           {fill CX double words with AX}
                 @Finish:
                   STOSB                 {add an extra pixel}
                 @AfterFinish:
                 END;
    OrBlit     : ASM
                 {32 bit optimized}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, BL          {copy color also to BH}
                   MOV   AX, BX          {temporarily push BX in AX}
                   DB    $66             {next instruction is 32Bit!}
                   SHL   BX, 16          {shift AX into extended part}
                   MOV   BX, AX          {restore BX from AX}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JNC  @Jump1           {when even then skip next}
                   MOV   AL, [ES:DI]     {put one pixel}
                   OR    AL, BL
                   MOV   [ES:DI], AL
                   INC   DI              {advance one step}
                 @Jump1:
                   TEST  CX, CX
                   JZ   @Finish          {skip when length = 0}
                   SHR   CX, 1           {again (len-1) DIV 2}
                   JNC  @Jump2           {when even then skip next}
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   OR    AX, BX          {perform OR operation}
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                 @Jump2:
                   TEST  CX, CX
                   JZ   @Finish          {skip when length = 0}
                   MOV   DX, 4           {four steps forward}
                 @Repeat:
                   DB    $66             {next instruction is 32Bit!}
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   DB    $66             {next instruction is 32Bit!}
                   OR    AX, BX          {perform OR operation}
                   DB    $66             {next instruction is 32Bit!}
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   ADD   DI, DX          {do four steps!}
                   LOOP @Repeat
                 @Finish:
                   MOV   AL, [ES:DI]     {put one pixel extra}
                   OR    AL, BL
                   MOV   [ES:DI], AL
                 END;
    AndBlit    : ASM
                 {32 bit optimized}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, BL          {copy color also to BH}
                   MOV   AX, BX          {temporarily push BX in AX}
                   DB    $66             {next instruction is 32Bit!}
                   SHL   BX, 16          {shift AX into extended part}
                   MOV   BX, AX          {restore BX from AX}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JNC  @Jump1           {when even then skip next}
                   MOV   AL, [ES:DI]     {put one pixel}
                   AND   AL, BL
                   MOV   [ES:DI], AL
                   INC   DI              {advance one step}
                 @Jump1:
                   TEST  CX, CX
                   JZ   @Finish          {skip when length = 0}
                   SHR   CX, 1           {again (len-1) DIV 2}
                   JNC  @Jump2           {when even then skip next}
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   AND   AX, BX          {perform AND operation}
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                 @Jump2:
                   TEST  CX, CX
                   JZ   @Finish          {skip when length = 0}
                   MOV   DX, 4           {four steps forward}
                 @Repeat:
                   DB    $66             {next instruction is 32Bit!}
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   DB    $66             {next instruction is 32Bit!}
                   AND   AX, BX          {perform AND operation}
                   DB    $66             {next instruction is 32Bit!}
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   ADD   DI, DX          {do four steps!}
                   LOOP @Repeat
                 @Finish:
                   MOV   AL, [ES:DI]     {put one pixel extra}
                   AND   AL, BL
                   MOV   [ES:DI], AL
                 END;
    NotBlit,
    XNORBlit,
    NOrBlit,
    NAndBlit   : BEGIN
                   DrawFGColor := NOT DrawFGColor;
                   Dec(DrawBitBlit,4);
                   _HL(Ofs,Len);
                   DrawFGColor := NOT DrawFGColor;
                   Inc(DrawBitBlit,4);
                 END;
  END
  ELSE {not a solid line}
  CASE DrawBitBlit OF
    CopyBlit   : ASM
                 {preperations}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, DrawBGColor {get background in BH}
                   MOV   SI, LineBits    {SI = pattern bits}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JZ   @SkipLoop
                   JMP  @Repeat          {jump over routines}
                 {nice roll routines}
                 @RoutineL:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearL
                   MOV   AL, BL          {perform MOV operation}
                   JMP  @RoutineH        {next byte}
                 @JumpClearL:
                   MOV   AL, BH          {perform MOV operation}
                 @RoutineH:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearH
                   MOV   AH, BL          {perform MOV operation}
                   RETN                  {return}
                 @JumpClearH:
                   MOV   AH, BH          {perform MOV operation}
                   RETN                  {return}
                 {loop the line}
                 @Repeat:
                   CALL  [@RoutineL]
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                   LOOP @Repeat
                 @SkipLoop:
                 {end the line when odd}
                   MOV   AX, Len         {get len again}
                   AND   AX, $0001       {test if is odd}
                   JZ   @Jump
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   INC   DI              {advance one step}
                 @Jump:
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   MOV   LineBits, SI    {remember state of linebits}
                 END;
    XORBlit    : ASM
                 {preperations}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, DrawBGColor {get background in BH}
                   MOV   SI, LineBits    {SI = pattern bits}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JZ   @SkipLoop
                   JMP  @Repeat          {jump over routines}
                 {nice roll routines}
                 @RoutineL:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearL
                   XOR   AL, BL          {perform XOR operation}
                   JMP   @RoutineH       {next byte}
                 @JumpClearL:
                   XOR   AL, BH          {perform XOR operation}
                 @RoutineH:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearH
                   XOR   AH, BL          {perform XOR operation}
                   RETN                  {return}
                 @JumpClearH:
                   XOR   AH, BH          {perform XOR operation}
                   RETN                  {return}
                 {loop the line}
                 @Repeat:
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   CALL  [@RoutineL]
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                   LOOP @Repeat
                 @SkipLoop:
                 {end the line when odd}
                   MOV   AX, Len         {get len again}
                   AND   AX, $0001       {test if is odd}
                   JZ @Jump
                   MOV   AH, [ES:DI]     {put one pixel}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   INC   DI              {advance one step}
                 @Jump:
                   MOV   AH, [ES:DI]     {put one pixel extra}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   MOV   LineBits, SI    {remember state of linebits}
                 END;
    SpriteBlit : ASM
                 {preperations}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   SI, LineBits    {SI = pattern bits}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JZ   @SkipLoop
                   JMP  @Repeat          {jump over routines}
                 {nice roll routines}
                 @RoutineL:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearL
                   MOV   AL, BL          {perform operation}
                 @JumpClearL:
                 @RoutineH:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearH
                   MOV   AH, BL          {perform operation}
                 @JumpClearH:
                   RETN                  {return}
                 {loop the line}
                 @Repeat:
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   CALL  [@RoutineL]
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                   LOOP @Repeat
                 @SkipLoop:
                 {end the line when odd}
                   MOV   AX, Len         {get len again}
                   AND   AX, $0001       {test if is odd}
                   JZ   @Jump
                   MOV   AH, [ES:DI]     {put one pixel}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   INC   DI              {advance one step}
                 @Jump:
                   MOV   AH, [ES:DI]     {put one pixel extra}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   MOV   LineBits, SI    {remember state of linebits}
                 END;
    OrBlit     : ASM
                 {preperations}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, DrawBGColor {get background in BH}
                   MOV   SI, LineBits    {SI = pattern bits}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JZ   @SkipLoop
                   JMP  @Repeat          {jump over routines}
                 {nice roll routines}
                 @RoutineL:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearL
                   OR    AL, BL          {perform OR operation}
                   JMP  @RoutineH        {next byte}
                 @JumpClearL:
                   OR    AL, BH          {perform OR operation}
                 @RoutineH:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearH
                   OR    AH, BL          {perform OR operation}
                   RETN                  {return}
                 @JumpClearH:
                   OR    AH, BH          {perform OR operation}
                   RETN                  {return}
                 {loop the line}
                 @Repeat:
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   CALL  [@RoutineL]
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                   LOOP @Repeat
                 @SkipLoop:
                 {end the line when odd}
                   MOV   AX, Len         {get len again}
                   AND   AX, $0001       {test if is odd}
                   JZ   @Jump
                   MOV   AH, [ES:DI]     {put one pixel}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   INC   DI              {advance one step}
                 @Jump:
                   MOV   AH, [ES:DI]     {put one pixel extra}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   MOV   LineBits, SI    {remember state of linebits}
                 END;
    AndBlit    : ASM
                 {preperations}
                   MOV   AX, VGASeg
                   MOV   ES, AX          {ES = VGASeg}
                   MOV   DI, Ofs         {DI = VGAOfs}
                   MOV   BL, DrawFGColor {get color in BL}
                   MOV   BH, DrawBGColor {get background in BH}
                   MOV   SI, LineBits    {SI = pattern bits}
                   MOV   CX, Len         {CX = len}
                   SHR   CX, 1           {(len-1) DIV 2}
                   JZ   @SkipLoop
                   JMP  @Repeat          {jump over routines}
                 {nice roll routines}
                 @RoutineL:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearL
                   AND   AL, BL          {perform AND operation}
                   JMP  @RoutineH       {next byte}
                 @JumpClearL:
                   AND   AL, BH          {perform AND operation}
                 @RoutineH:
                   ROL   SI, 1           {rotate pattern}
                   JNC  @JumpClearH
                   AND   AH, BL          {perform AND operation}
                   RETN                  {return}
                 @JumpClearH:
                   AND   AH, BH          {perform AND operation}
                   RETN                  {return}
                 {loop the line}
                 @Repeat:
                   MOV   AX, [ES:DI]     {copy vga mem to AX}
                   CALL  [@RoutineL]
                   MOV   [ES:DI], AX     {copy AX to vga mem}
                   INC   DI              {advance two steps}
                   INC   DI              {in the vga mem}
                   LOOP @Repeat
                 @SkipLoop:
                 {end the line when odd}
                   MOV   AX, Len         {get len again}
                   AND   AX, $0001       {test if is odd}
                   JZ   @Jump
                   MOV   AH, [ES:DI]     {put one pixel}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   INC   DI              {advance one step}
                 @Jump:
                   MOV   AH, [ES:DI]     {put one pixel extra}
                   CALL  [@RoutineH]
                   MOV   [ES:DI], AH
                   MOV   LineBits, SI    {remember state of linebits}
                 END;
    NotBlit,
    XNORBlit,
    NOrBlit,
    NAndBlit   : BEGIN
                   DrawFGColor := NOT DrawFGColor;
                   DrawBGColor := NOT DrawBGColor;
                   Dec(DrawBitBlit,4);
                   _HL(Ofs,Len);
                   DrawFGColor := NOT DrawFGColor;
                   DrawBGColor := NOT DrawBGColor;
                   Inc(DrawBitBlit,4);
                 END;
  END;
END; {__HL}


PROCEDURE _RawHorLine(X1,X2,Y:INTEGER); FAR;
{draw a horizontal line in given color, because this is
 one of the most important routines in this routine it is
 highly optimized and consequently rather long.
 this one is not ajusted for the viewport settings!}
BEGIN {_RawHorLine}
  ASM
    MOV  AX, BytesPerLine     {get width}
    MOV  DX, Y                {get y}
    MUL  DX                   {multiply w*y, result in DX:AX}
    ADD  AX, X1               {add x1 to AX}
    ADC  DX, 0                {add carry to DX}
    CMP  DL, ActiveBank       {test whether another bank is needed}
    JE   @SkipBankSelection
    PUSH AX                   {save the VGA offset on stack}
    MOV  ActiveBank, DL       {update bank number}
    PUSH DX                   {push bank number to select}
    CALL _SetVESABank         {call bank selector routine}
    POP  AX                   {load the VGA offset from stack}
  @SkipBankSelection:         {remember, AX contains the offset!}
    MOV  BX, X2
    SUB  BX, X1               {compute length minus one pixel in BX}
    XOR  CX, CX
    NOT  CX                   {put $FFFF in CX}
    SUB  CX, AX               {bytes that are available in that bank}
    CMP  CX, BX
    JNB @LineFitsInBank       {does the line fit in selected bank?}
    MOV  DX, BX
    SUB  DX, CX
    SUB  BX, DX
    DEC  DX
    PUSH $0000
    PUSH DX
    PUSH AX
    PUSH BX
    CALL FAR [_HL]
    CALL NextVESABank
    CALL FAR [_HL]
    JMP @Finish
  @LineFitsInBank:
    PUSH AX
    PUSH BX
    CALL FAR [_HL]
  @Finish:
 END;
END; {_RawHorLine}


PROCEDURE _RawVertLine(X,Y1,Y2:INTEGER); FAR;
{this seems to be a rather quick implementation of a vertical line,
 at least it is quicker than calling a pixel routine every time.
 note that it could be faster if we made seperate routines for
 each blit operation and for solid lines, but we don't bother}
BEGIN
  ASM
  {get and set bank and offset of first pixel}
    MOV  DX, Y1               {get y into DX}
    MOV  AX, BytesPerLine     {get width into AX}
    MUL  DX                   {multiply w*y, result in DX:AX}
    ADD  AX, X                {add x to AX}
    ADC  DX, 0                {add carry to DX}
    CMP  DL, ActiveBank       {test whether another bank is needed}
    JE   @SkipBankSelection1
    PUSH AX                   {save the VGA offset on stack}
    MOV  ActiveBank, DL       {update bank number}
    PUSH DX                   {push bank number to select}
    CALL _SetVESABank         {call bank selector routine}
    POP  AX                   {load the VGA offset from stack}
  @SkipBankSelection1:
  {load our VGA pointer}
    MOV  DI, AX               {DI = VGAOfs}
    MOV  AX, VGASeg
    MOV  ES, AX               {ES = VGASeg}
  {determine length of line to draw and put it in CX}
    MOV  CX, Y2
    MOV  DX, Y1
    SUB  CX, DX
    INC  CX                   {Y2-Y1+1}
  {load more information}
    MOV  DX, BytesPerLine     {DX = the bytes we need to add}
    MOV  SI, LineBits         {SI = pattern bits}
    MOV  BL, DrawFGColor      {get color in BL}
    MOV  BH, DrawBGColor      {get background in BH}
    MOV  AH, DrawLogic        {get the blit operator in AH}
  {inverse colors?}
    MOV  AL, DrawInverse      {get inverse flag in BL}
    TEST AL, AL               {set flags}
    JZ  @SkipInvert
    NOT  BX                   {invert both colors in BX}
  @SkipInvert:
  {draw pixels in a loop; ES:DI = VGAPtr, SI = Pattern, AH = DrawLogic,
                          BX = colors,    CX = length,  DX = BytesPerLine}
  @Repeat:
    ROL  SI, 1                {rotate pattern}
    JNC @JumpClear
{foreground}
    MOV  AL, BL               {AL = foreground color}
{copy blit}
    CMP  AH, CopyBlit
    JE  @DoWriting            {we don't need to read on a copy (AL=color)}
{sprite blit}
    CMP  AH, SpriteBlit
    JE @DoWriting             {goto writing}
    MOV  AL, [ES:DI]          {get current pixel into AL}
{xor blit}
    CMP  AH, XorBlit
    JNE @SkipXorBlit1
    XOR  AL, BL               {do xor operation with foreground color}
    JMP @DoWriting            {goto writing}
  @SkipXorBlit1:
{or blit}
    CMP  AH, OrBlit
    JNE @SkipOrBlit1
    OR   AL, BL               {do or operation with foreground color}
    JMP @DoWriting            {goto writing}
  @SkipOrBlit1:
{and blit}
    AND  AL, BL               {do and operation with foreground color}
    JMP @DoWriting            {goto writing}
  @JumpClear:
{background}
    MOV  AL, BH               {AL = background color}
{copy blit}
    CMP  AH, CopyBlit
    JE  @DoWriting            {we don't need to read on a copy (AL=color)}
    MOV  AL, [ES:DI]          {get current pixel into AL}
{sprite blit}
    CMP  AH, SpriteBlit
    JE @DoWriting             {goto writing}
{xor blit}
    CMP  AH, XorBlit
    JNE @SkipXorBlit2
    XOR  AL, BH               {do xor operation with background color}
    JMP @DoWriting            {goto writing}
  @SkipXorBlit2:
{or blit}
    CMP  AH, OrBlit
    JNE @SkipOrBlit2
    OR   AL, BH               {do or operation with background color}
    JMP @DoWriting            {goto writing}
  @SkipOrBlit2:
{and blit}
    AND  AL, BH               {do and operation with background color}
  @DoWriting:
{start doing it}
    MOV [ES:DI], AL           {set pixel}
  {are we finished?}
    DEC CX
    JZ @Finish                {yes, we're finished}
  {compute new offset of next pixel}
    ADD  DI, DX               {add width to the offset}
    JNC @SkipBankSelection2   {does it still fit?}
  {compute new bank and offset}
    PUSHA                     {save all registers}
    XOR AX, AX                {clear DX}
    MOV AL, ActiveBank        {get current bank}
    INC AL                    {next one}
    MOV  ActiveBank, AL       {update bank number}
    PUSH AX                   {push bank number to select}
    CALL _SetVESABank         {call bank selector routine}
    POPA                      {load all registers}
  @SkipBankSelection2:
  {end of loop?}
    JMP @Repeat
  @Finish:
  END;
END; {_RawVertLine}


PROCEDURE PutRawPixel(X,Y:INTEGER;Color:BYTE); ASSEMBLER;
{put a pixel on the screen, it reacts on:
 DrawColor, DrawInverse, and DrawLogic
 this one does not check the view port!
 because this is one of the most important
 routines in this unit it is somewhat optimized}
ASM
  MOV  AX, BytesPerLine     {get width}
  MOV  DX, Y                {get y}
  MUL  DX                   {multiply w*y, result in DX:AX}
  ADD  AX, X                {add x to AX}
  ADC  DX, 0                {add carry to DX}
  CMP  DL, ActiveBank       {test whether another bank is needed}
  JE   @SkipBankSelection
  PUSH AX                   {save the VGA offset on stack}
  MOV  ActiveBank, DL       {update bank number}
  PUSH DX                   {push bank number to select}
  CALL _SetVESABank         {call bank selector routine}
  POP  AX                   {load the VGA offset from stack}
@SkipBankSelection:
  MOV  DI, AX               {DI = VGAOfs}
  MOV  AX, VGASeg
  MOV  ES, AX               {ES = VGASeg}
  MOV  CL, Color            {put color in CL}
  MOV  BL, DrawInverse      {get inverse flag in BL}
  TEST BL, BL               {set flags}
  JZ  @SkipInvert
  NOT  CL                   {invert color in CL}
@SkipInvert:
  MOV  BL, DrawLogic        {get the blit operator in BL}
  CMP  BL, CopyBlit
  JE  @DoWriting            {we don't need to read on a copy}
  CMP  BL, SpriteBlit       {do sprite operation}
  JNE @SkipSpriteBlit
  CMP  CL, DrawBGColor
  JNE @DoWriting
  JMP @Finish
@SkipSpriteBlit:
  MOV  AL, [ES:DI]          {get pixel}
  CMP  BL, XorBlit
  JNE @SkipXorBlit
  XOR  CL, AL               {do xor operation}
  JMP @DoWriting
@SkipXorBlit:
  CMP  BL, OrBlit
  JNE @SkipOrBlit
  OR   CL, AL               {do or operation}
  JMP @DoWriting
@SkipOrBlit:
  AND  CL, AL               {do and operation}
@DoWriting:
  MOV [ES:DI], CL           {set pixel}
@Finish:
END; {PutRawPixel}


PROCEDURE _RawLine(X1,Y1,X2,Y2:INTEGER); FAR; ASSEMBLER;
{put a line in any direction; don't use for horizontal and vertical lines!}
VAR D,Lx,Ly,Ra,Rb,Rx,Ry:INTEGER;
ASM
{compute Lx, Ly, Rx, and Ry}
  XOR  CX, CX
  MOV  AX, X1
  MOV  BX, X2
  CMP  AX, BX
  JG @LeftWard
  MOV  Rx, 1
  SUB  BX, AX
  INC  BX
  MOV  Lx, BX
  JMP @WasRightWard
@LeftWard:
  MOV  Rx, -1
  SUB  AX, BX
  INC  AX
  MOV  Lx, AX
@WasRightWard:
  MOV  AX, Y1
  MOV  BX, Y2
  CMP  AX, BX
  JG @UpWard
  MOV  Ry, 1
  SUB  BX, AX
  INC  BX
  MOV  Ly, BX
  JMP @WasDownWard
@UpWard:
  MOV  Ry, -1
  SUB  AX, BX
  INC  AX
  MOV  Ly, AX
@WasDownWard:
{prepare and test whether that one pixel was enough!}
  MOV  AX, Lx
  MOV  BX, Ly
  CMP  AX, BX
  JNE @NotOnePixel
  TEST AX, AX
  JZ  @Finish              {it was one pixel only}
@NotOnePixel:
  JL @DrawUpRight
{draw a more horizontal line}
  MOV  CX, BX              {backup}
  SUB  BX, AX
  SHL  BX, 1
  MOV  Ra, BX              {Ra = (Ly-Lx) SHL 1}
  MOV  BX, CX              {retrieve}
  SHL  BX, 1
  MOV  Rb, BX              {Rb = Ly SHL 1}
  SUB  BX, CX
  MOV  D, BX               {D = Rb-Lx}
{loop: AX = X, BX = Y, CX = color, DX = decision, SI = linebits}
  MOV  AX, X1              {X in AX}
  MOV  BX, Y1              {Y in BX}
  SUB  AX, Rx
  SUB  BX, Ry
@Repeat1:
  MOV  DX, D               {decision variable in DX}
  MOV  SI, LineBits        {SI = pattern bits}
  TEST DX, DX              {compare DX with zero}
  JLE @NoStep1             {make a step down or up?}
  ADD  BX, Ry              {step}
  MOV  Y1, BX              {store}
  ADD  DX, Ra              {update the decision variable}
  JMP @Move1
@NoStep1:
  ADD  DX, Rb              {update the decision variable}
@Move1:
  ADD  AX, Rx              {move}
  MOV  X1, AX              {store}
  XOR  CH, CH              {clear CH}
  MOV  CL, DrawFGColor     {move normal color in CL}
  ROL  SI, 1               {rotate pattern}
  JC @NoClear1             {we do not need to use the BG color}
  MOV  CL, DrawBGColor     {move background color in CL}
@NoClear1:
  MOV  LineBits, SI        {store}
  MOV  D,  DX              {store}
  PUSH AX                  {argument for _RawPutPixel}
  PUSH BX                  {argument for _RawPutPixel}
  PUSH CX                  {argument for _RawPutPixel}
  CALL FAR [PutRawPixel]  {draw that pixel}
  MOV  AX, X1              {X in AX}
  MOV  BX, Y1              {Y in BX}
  CMP  AX, X2              {are we at the end?}
  JNE @Repeat1             {loop}
  JMP @Finish
  {draw a more vertical line}
@DrawUpRight:
  MOV  CX, AX              {backup}
  SUB  AX, BX
  SHL  AX, 1
  MOV  Ra, AX              {Ra = (Lx-Ly) SHL 1}
  MOV  AX, CX              {retrieve}
  SHL  AX, 1
  MOV  Rb, AX              {Rb = Lx SHL 1}
  SUB  AX, CX
  MOV  D, AX               {D = Rb-Ly}
{loop: AX = X, BX = Y, CX = color, DX = decision, SI = linebits}
  MOV  AX, X1              {X in AX}
  MOV  BX, Y1              {Y in BX}
  SUB  AX, Rx
  SUB  BX, Ry
@Repeat2:
  MOV  DX, D               {decision variable in DX}
  MOV  SI, LineBits        {SI = pattern bits}
  TEST DX, DX              {compare DX with zero}
  JLE  @NoStep2            {make a step down or up?}
  ADD  AX, Rx              {step}
  MOV  X1, AX              {store}
  ADD  DX, Ra              {update the decision variable}
  JMP @Move2
@NoStep2:
  ADD  DX, Rb              {update the decision variable}
@Move2:
  ADD  BX, Ry              {move}
  MOV  Y1, BX              {store}
  XOR  CH, CH              {clear CH}
  MOV  CL, DrawFGColor     {move normal color in CL}
  ROL  SI, 1               {rotate pattern}
  JC @NoClear2             {we do not need to use the BG color}
  MOV  CL, DrawBGColor     {move background color in CL}
@NoClear2:
  MOV  LineBits, SI        {store}
  MOV  D,  DX              {store}
  PUSH AX                  {argument for PutRawPixel}
  PUSH BX                  {argument for PutRawPixel}
  PUSH CX                  {argument for PutRawPixel}
  CALL FAR [PutRawPixel]   {draw that pixel}
  MOV  AX, X1              {X in AX}
  MOV  BX, Y1              {Y in BX}
  CMP  BX, Y2              {are we at the end?}
  JNE @Repeat2             {loop}
@Finish:
END; {_RawLine}


PROCEDURE _ViewPortHorLine(X1,X2,Y:INTEGER;ClipOn:BOOLEAN); FAR; ASSEMBLER;
{same a _RawHorLine but this one is adapted to the viewport settings}
ASM
{get arguments of this routine, and the next, into AX, BX, and CX}
  MOV  AX, X1
  MOV  BX, X2
  MOV  CX, Y
{move into viewport}
  MOV  DX, ViewPortLeft
  ADD  AX, DX
  ADD  BX, DX
  ADD  CX, ViewPortTop
{do we clip?}
  XOR  DL, DL
  CMP  DL, ClipOn
  JE  @NoClipping
{we do clip!}
  CMP  CX, ViewPortTop
  JL  @NoLine
  CMP  CX, ViewPortBottom
  JG  @NoLine
  MOV  DX, ViewPortLeft
  CMP  BX, DX
  JL  @NoLine
  CMP  AX, DX
  JGE @NoCorrectionOnX1
  XCHG AX, CX                 {temporary exchange AX and CX}
  SUB  CX, DX                 {compute difference}
  AND  CL, $0F                {mask}
  ROR  LineBits, CL           {correct line bits}
  MOV  CX, AX                 {move CX back}
  MOV  AX, DX                 {set X1 to view port left}
@NoCorrectionOnX1:
  MOV  DX, ViewPortRight
  CMP  AX, DX
  JG  @NoLine
  CMP  BX, DX
  JLE @NoCorrectionOnX2
  MOV  BX, DX                 {set X2 to view port right}
@NoCorrectionOnX2:
{push arguments onto stack}
@NoClipping:
  PUSH AX
  PUSH BX
  PUSH CX
{now we can draw the line!}
  CALL FAR [_RawHorLine];
@NoLine:
END; {_ViewPortHorLine}


PROCEDURE _ViewPortVertLine(X,Y1,Y2:INTEGER;ClipOn:BOOLEAN); FAR; ASSEMBLER;
{same a _RawVertLine but this one is adapted to the viewport settings}
ASM
{get them}
  MOV  AX, X
  MOV  BX, Y1
  MOV  CX, Y2
{move into viewport}
  ADD  AX, ViewPortLeft
  MOV  DX, ViewPortTop
  ADD  BX, DX
  ADD  CX, DX
{do we clip?}
  XOR  DL, DL
  CMP  DL, ClipOn
  JE  @NoClipping
{we do clip!}
  CMP  AX, ViewPortLeft
  JL  @NoLine
  CMP  AX, ViewPortRight
  JG  @NoLine
  MOV  DX, ViewPortTop
  CMP  CX, DX
  JL  @NoLine
  CMP  BX, DX
  JGE @NoCorrectionOnY1
  MOV  BX, DX
@NoCorrectionOnY1:
  MOV  DX, ViewPortBottom
  CMP  BX, DX
  JG  @NoLine
  CMP  CX, DX
  JLE @NoCorrectionOnY2
  MOV  CX, DX
@NoCorrectionOnY2:
{push arguments onto stack}
@NoClipping:
  PUSH AX
  PUSH BX
  PUSH CX
{now we can draw the line!}
  CALL FAR [_RawVertLine];
@NoLine:
END; {_ViewPortVertLine}


PROCEDURE _ViewPortLine(X1,Y1,X2,Y2:INTEGER); FAR;
{draw and clip a line in viewport coordinates, this routine
 extract vertical and horizontal lines for quick drawing}
LABEL Finish;
BEGIN
{extract vertical and horizontal lines and a single point line}
  ASM
    {do we not need to draw a pattern?}
    MOV  CL, DrawPattern
    TEST CL, CL
    JNZ @DoNotUseQuickDrawing
    {AX will be zero when X1 and X2 are equal}
    MOV  AX, X1
    SUB  AX, X2
    {BX will be zero when Y1 and Y2 are equal}
    MOV  BX, Y1
    SUB  BX, Y2
    {test for vertical lines (see if AX is zero)}
    TEST AX, AX
    JNZ @MaybeHorizontal
    {we can already push something}
    PUSH X1
    {test for a single point line}
    TEST BX, BX
    JNZ @NotSinglePoint
    {draw the single point}
    PUSH Y1
    XOR  DH, DH
    MOV  DL, DrawFGColor
    PUSH DX
    CALL FAR [PutPixel]
    {finish it off}
    JMP  Finish
  @NotSinglePoint:
    {we still have the BX flags}
    TEST BX, BX
    JG  @UpsideDown
    PUSH Y1
    PUSH Y2
    JMP @WasCorrect1
  @UpsideDown:
    PUSH Y2
    PUSH Y1
  @WasCorrect1:
    PUSH TRUE
    {draw the vertical line}
    CALL FAR [_ViewPortVertLine]
    {finish it off}
    JMP  Finish
  @MaybeHorizontal:
    {test for a horizontal line}
    TEST BX, BX
    JNZ @DoNotUseQuickDrawing
    TEST AX, AX
    JG  @LeftWard
    PUSH X1
    PUSH X2
    JMP @WasCorrect2
  @LeftWard:
    PUSH X2
    PUSH X1
  @WasCorrect2:
    PUSH Y1
    PUSH TRUE
    {draw horizontal line}
    CALL FAR [_ViewPortHorLine]
    {finish it off}
    JMP  Finish
  @DoNotUseQuickDrawing:
  END;
  {clip and draw a normal line if possible}
  IF ViewPortLineClipping(X1,Y1,X2,Y2)
  THEN _RawLine(X1,Y1,X2,Y2);
Finish:
END; {_ViewPortLine}


PROCEDURE HorLine(X1,X2,Y:INTEGER);
{draw a horizontal line}
BEGIN
{get line bits}
  LineBits := Lining[DrawPattern];
{swapping}
  ASM
    MOV AX, X1
    MOV BX, X2
    CMP AX, BX
    JL @NoSwap
    MOV X1, BX
    MOV X2, AX
  @NoSwap:
  END;
{draw}
  _ViewPortHorLine(X1,X2,Y,TRUE);
{move cursor}
  _MoveCursor(X2,Y,TRUE);
END; {HorLine}


PROCEDURE VertLine(X,Y1,Y2:INTEGER);
{draw a vertical line}
BEGIN
{get line bits}
  LineBits := Lining[DrawPattern];
{swapping}
  ASM
    MOV AX, Y1
    MOV BX, Y2
    CMP AX, BX
    JL @NoSwap
    MOV Y1, BX
    MOV Y2, AX
  @NoSwap:
  END;
{draw}
  _ViewPortVertLine(X,Y1,Y2,TRUE);
{move cursor}
  _MoveCursor(X,Y2,TRUE);
END; {VertLine}


PROCEDURE _ThickLine(X1,Y1,X2,Y2:INTEGER);
{draw a line that is three pixels width by simply drawing three lines;
 this is not a good solution but it is the one that is used by
 borland as well, so we are still compatible with their graph unit,
 note that this code is not optimized for speed, it just works...}
VAR DX,DY:INTEGER;
BEGIN
  {compute steepness of line}
  DX := X2-X1;
  DY := Y2-Y1;
  {is it a more horizontal, or a more vertical line?}
  IF Abs(DX) > Abs(DY) THEN                 {it's more horizontal}
  BEGIN
    LineBits := Lining[DrawPattern];
    _ViewPortLine(X1,Y1+1,X2,Y2+1);
    LineBits := Lining[DrawPattern];
    _ViewPortLine(X1,Y1,X2,Y2);
    LineBits := Lining[DrawPattern];
    _ViewPortLine(X1,Y1-1,X2,Y2-1);
  END
  ELSE                                      {it's more vertical}
  BEGIN
    LineBits := Lining[DrawPattern];
    _ViewPortLine(X1+1,Y1,X2+1,Y2);
    LineBits := Lining[DrawPattern];
    _ViewPortLine(X1,Y1,X2,Y2);
    LineBits := Lining[DrawPattern];
    _ViewPortLine(X1-1,Y1,X2-1,Y2);
  END;
END; {_ThickLine}


PROCEDURE Line(X1,Y1,X2,Y2:INTEGER);
{draw a line}
BEGIN
{get line bits}
  LineBits := Lining[DrawPattern];
{watch out for those thick lines!}
  IF DrawWidth > 1 THEN _ThickLine(X1,Y1,X2,Y2)
                   ELSE _ViewPortLine(X1,Y1,X2,Y2);
{move cursor}
  _MoveCursor(X2,Y2,TRUE);
END; {Line}


PROCEDURE LineTo(X,Y:INTEGER);
{draw a line to x,y}
LABEL Finish;
BEGIN
{get line bits}
  LineBits := Lining[DrawPattern];
{watch out for those thick lines and the first pixel!}
  IF CursorDown THEN {we need to make a step in the right direction!}
  ASM
  {get DistX in AX and DistY in BX (absolute values!)}
    MOV  AX, Y             {get Y in AX}
    SUB  AX, CursorY       {compute DistY in AX}
    CWD
    XOR  AX, DX
    SUB  AX, DX
    MOV  BX, AX            {put absolute Y in BX}
    MOV  AX, X             {get X in AX}
    SUB  AX, CursorX       {compute DistX in AX}
    CWD
    XOR  AX, DX
    SUB  AX, DX            {put absolute X in AX}
  {when there is no movement we should leave at once!}
    MOV  CX, AX
    ADD  CX, BX
    JZ  Finish
  {when distY >= 2*distX we not need to step over X}
    MOV  CX, AX
    SHL  CX, 1
    CMP  BX, CX
    JGE @DoneWithX
  {we need to make a step over X, but in which direction?}
    MOV  CX, X
    MOV  DX, CursorX
    CMP  CX, DX
    JG  @PositiveStepX
    DEC  DX
    MOV  CursorX, DX
    JMP @DoneWithX
  @PositiveStepX:
    INC  DX
    MOV  CursorX, DX
  @DoneWithX:
  {when distX >= 2*distY we not need to step over Y}
    MOV  CX, BX
    SHL  CX, 1
    CMP  AX, CX
    JGE @DoneWithY
  {we need to make a step over Y, but in which direction?}
    MOV  CX, Y
    MOV  DX, CursorY
    CMP  CX, DX
    JG  @PositiveStepY
    DEC  DX
    MOV  CursorY, DX
    JMP @DoneWithY
  @PositiveStepY:
    INC  DX
    MOV  CursorY, DX
  @DoneWithY:
  END;
  IF DrawWidth > 1 THEN _ThickLine(CursorX,CursorY,X,Y)
                   ELSE _ViewPortLine(CursorX,CursorY,X,Y);
{move cursor}
  _MoveCursor(X,Y,TRUE);
Finish:
END; {LineTo}


PROCEDURE RelLineTo(X,Y:INTEGER);
{draw a relative line to x,y}
BEGIN
  LineTo(GetX+X,GetY+Y);
END; {RelLineTo}


PROCEDURE RawAllignedLine(X1,X2,Y:INTEGER);
{same a _RawHorLine but with an alligned pattern,
 that is, the pattern has a fixed position in the display,
 note that no clipping is performed at all!}
 VAR B:BYTE;
BEGIN
{get the fresh pattern}
  B := Filling[DrawPattern,Y MOD 8];
{allign it}
  ASM
    MOV AL, B
    MOV AH, AL
    MOV CX, X1
    AND CL, $0F
    ROL AX, CL
    MOV LineBits, AX
  END;
{and draw it}
  _RawHorLine(X1,X2,Y);
END; {RawAllignedLine}


PROCEDURE ViewPortAllignedLine(X1,X2,Y:INTEGER;ClipOn:BOOLEAN);
{same a _ViewPortHorLine but with an alligned pattern,
 that is, the pattern has a fixed position in the viewport}
 VAR B:BYTE;
BEGIN
  IF (Y < 0) OR (Y > ViewPortBottom) THEN
  BEGIN
    EXIT;
  END;
{get the fresh pattern}
  B := Filling[DrawPattern,Y MOD 8];
{allign it}
  ASM
    MOV AL, B
    MOV AH, AL
    MOV CX, X1
    AND CL, $0F
    ROL AX, CL
    MOV LineBits, AX
  END;
{and draw it}
  _ViewPortHorLine(X1,X2,Y,ClipOn);
END; {ViewPortAllignedLine}


{*****************************************************
 **                                                 **
 **  box system                                     **
 **                                                 **
 *****************************************************}


PROCEDURE ValidateGraphicsBox(VAR X,Y,W,H:INTEGER); ASSEMBLER;
{make sure that we refer to a valid graphical box,
 that is, width and height should be positive!}
ASM
  LES  DI,      [W]
  MOV  AX,      [ES:DI]           {AX contains W}
  TEST AX,      AX
  JG @WidthOK                     {nothing to do}
  LES  DI,      [X]
  MOV  BX,      [ES:DI]           {BX contains X}
  ADD  BX,      AX                {add W to X}
  NEG  AX                         {negate X}
  MOV  [ES:DI], BX                {put BX into X}
  LES  DI,      [W]
  MOV  [ES:DI], AX                {put AX into W}
@WidthOK:
  LES  DI,      [H]
  MOV  AX,      [ES:DI]           {AX contains H}
  TEST AX,      AX
  JG @HeightOK                    {nothing to do}
  LES  DI,      [Y]
  MOV  BX,      [ES:DI]           {BX contains Y}
  ADD  BX,      AX                {add H to Y}
  NEG  AX                         {negate Y}
  MOV  [ES:DI], BX                {put BX into Y}
  LES  DI,      [H]
  MOV  [ES:DI], AX                {put AX into H}
@HeightOK:
END; {ValidateGraphicsBox}


PROCEDURE Box(X1,Y1,X2,Y2:INTEGER);
{draw a box, either a line or a filled box...}
VAR Y:INTEGER;
BEGIN
{do it}
  IF DrawMode = LineDrawing THEN  {draw an open box}
  BEGIN
    {get line bits}
    LineBits := Lining[DrawPattern];
    BoxInOrder(X1,Y1,X2,Y2);
    IF DrawWidth = NormWidth THEN
    BEGIN
      _ViewPortHorLine(X1,X2,Y1,TRUE);
      IF Y2-Y1 > 1 THEN
      BEGIN
        _ViewPortVertLine(X2,Y1+1,Y2,TRUE);
        IF X2-X1 > 1 THEN
        BEGIN
          _ViewPortVertLine(X1,Y1+1,Y2-1,TRUE);
          _ViewPortHorLine(X1,X2-1,Y2,TRUE);
        END;
      END;
    END
    ELSE {thickwidth}
    BEGIN
      _ThickLine(X1-1,Y1,X2+1,Y1);
      IF Y2-Y1 > 4 THEN
      BEGIN
        _ThickLine(X2,Y1+2,X2,Y2-2);
        IF X2-X1 > 4 THEN
        BEGIN
          _ThickLine(X1,Y1+2,X1,Y2-2);
          _ThickLine(X1-1,Y2,X2+1,Y2);
        END;
      END;
    END;
  END
  ELSE
  IF ViewPortBoxClipping(X1,Y1,X2,Y2) THEN {it can be moved inside the viewport}
  BEGIN
    FOR Y := Y1 TO Y2 DO
    BEGIN
      {look at pattern}
      LineBits := Filling[DrawPattern,Y MOD 8];
      ASM
        MOV AX, LineBits
        MOV AH, AL
        MOV LineBits, AX
      END;
      {draw a line}
      _RawHorLine(X1,X2,Y);
    END;
  END;
END; {Box}


{*****************************************************
 **                                                 **
 **  clearing system                                **
 **                                                 **
 *****************************************************}


PROCEDURE ClearGraphics(Color:BYTE);
{most efficient way to clear the display, apart from clearing
 whole banks, that is however only 5% faster, who cares...}
VAR Mode      :DrawModeType;
    X,Y,Bottom:INTEGER;
BEGIN
{buffer drawing mode}
  GetDrawingMode(Mode);
{set filling}
  SetFillMode(Color,SolidFill,CopyBlit);
  LineBits := $FFFF;
{draw lines}
  X      := VESAMaxX;
  Y      := ActivePageTop;
  Bottom := Y+VESAMaxY;
  REPEAT
    {draw a line}
    _RawHorLine(0,X,Y);
    {next}
    Inc(Y);
  UNTIL Y > Bottom;
{restore drawing mode}
  SetDrawingMode(Mode);
END; {ClearGraphics}


{*****************************************************
 **                                                 **
 **  pixel system                                   **
 **                                                 **
 *****************************************************}

FUNCTION _ViewPortPointClipping(VAR X,Y:INTEGER):BOOLEAN;
{change to viewport coordinates and check position, I have
 not even taken the trouble to optimize it because it should
 not be used extensively anyway.}
BEGIN
  _ViewPortPointClipping := FALSE;
  IF (X < 0) OR (Y < 0) THEN EXIT;
  Inc(X,ViewPortLeft);
  Inc(Y,ViewPortTop);
  IF (X > ViewPortRight) OR (Y > ViewPortBottom) THEN EXIT;
  _ViewPortPointClipping := TRUE;
END; {_ViewPortPointClipping}


PROCEDURE _ViewPortPutPixel(X,Y:INTEGER;Color:BYTE;ClipOn:BOOLEAN); FAR; ASSEMBLER;
{same a PutRawPixel but this one is adapted to the viewport settings}
ASM
{get x and x}
  MOV  AX, X                {move X into AX}
  MOV  BX, Y                {move Y into BX}
{get clip flag}
  MOV  CL, ClipOn           {move clip flag into CL}
  XOR  DX, DX               {clear DX; a zero reference!}
  CMP  CL, DL
  JE  @NoClipping1          {should we clip?}
  CMP  AX, DX
  JL  @NoPixel              {is X < 0?}
  CMP  BX, DX
  JL  @NoPixel              {is Y < 0?}
@NoClipping1:
{correct x and y}
  ADD  AX, ViewPortLeft     {move X into viewport}
  ADD  BX, ViewPortTop      {move Y into viewport}
{test inside or test not}
  CMP  CL, DL
  JE  @NoClipping2          {should we clip?}
  MOV  DX, ViewPortRight
  CMP  AX, DX
  JG  @NoPixel              {is X > right side?}
  MOV  DX, ViewPortBottom
  CMP  BX, DX
  JG  @NoPixel              {is Y > bottom side?}
@NoClipping2:
{now we can draw the pixel!}
  PUSH AX
  PUSH BX
  XOR  AH, AH
  MOV  AL, Color
  PUSH AX
  CALL PutRawPixel          {draw it}
@NoPixel:
END; {_ViewPortPutPixel}


PROCEDURE PutPixel(X,Y:INTEGER;Color:BYTE);
{outside entrance to pixels}
BEGIN
{put pixel}
  _ViewPortPutPixel(X,Y,Color,ViewPortClipOn);
END; {PutPixel}


FUNCTION _RawGetPixel(X,Y:INTEGER):BYTE; FAR;
{get the color number of a pixel in the raw mode,
 always provide valid coordinates!}
BEGIN
  ASM
  {get x and x}
    MOV  CX, X                 {move X into CX}
    MOV  DX, Y                 {move Y into DX}
    MOV  AX, BytesPerLine      {get width}
    MUL  DX                    {multiply w*y, result in DX:AX}
    ADD  AX, CX                {add x to AX}
    ADC  DX, 0                 {add carry to DX}
    CMP  DL, ActiveBank        {test whether another bank is needed}
    JE   @SkipBankSelection
    PUSH AX                    {save the VGA offset on stack}
    MOV  ActiveBank, DL        {update bank number}
    PUSH DX                    {push bank number to select}
    CALL _SetVESABank          {call bank selector routine}
    POP  AX                    {load the VGA offset from stack}
  @SkipBankSelection:
    MOV  DI, AX                {DI = VGAOfs}
    MOV  AX, VGASeg
    MOV  ES, AX                {ES = VGASeg}
    MOV  AL, [ES:DI]           {get color}
    MOV  [@Result], AL         {and store it}
  END;
END; {_RawGetPixel}


FUNCTION GetPixel(X,Y:INTEGER):BYTE;
{get the color number of a pixel relative to the viewport,
 who ever said that getting the color of one pixel is easy?
 zero is returned when the pixel is outside a clipped viewport}
BEGIN
{get it}
  ASM
  {get x and x}
    MOV  CX, X                 {move X into CX}
    MOV  DX, Y                 {move Y into DX}
  {get clip flag}
    MOV  AL, ViewPortClipOn    {move clip flag into AL}
    XOR  BX, BX                {clear BX; a zero reference!}
    CMP  AL, BL
    JE  @NoClipping1           {should we clip?}
    CMP  CX, BX
    JL  @NoPixel               {is X < 0?}
    CMP  DX, BX
    JL  @NoPixel               {is Y < 0?}
  @NoClipping1:
  {correct x and y}
    ADD  CX, ViewPortLeft      {move X into viewport}
    ADD  DX, ViewPortTop       {move Y into viewport}
  {test inside or test not}
    CMP  AL, BL
    JE  @NoClipping2           {should we clip?}
    MOV  BX, ViewPortRight
    CMP  CX, BX
    JG  @NoPixel               {is X > right side?}
    MOV  BX, ViewPortBottom
    CMP  DX, BX
    JG  @NoPixel               {is Y > bottom side?}
  @NoClipping2:
    MOV  AX, BytesPerLine      {get width}
    MUL  DX                    {multiply w*y, result in DX:AX}
    ADD  AX, CX                {add x to AX}
    ADC  DX, 0                 {add carry to DX}
    CMP  DL, ActiveBank        {test whether another bank is needed}
    JE   @SkipBankSelection
    PUSH AX                    {save the VGA offset on stack}
    MOV  ActiveBank, DL        {update bank number}
    PUSH DX                    {push bank number to select}
    CALL _SetVESABank          {call bank selector routine}
    POP  AX                    {load the VGA offset from stack}
  @SkipBankSelection:
    MOV  DI, AX                {DI = VGAOfs}
    MOV  AX, VGASeg
    MOV  ES, AX                {ES = VGASeg}
    MOV  AL, [ES:DI]           {get color}
    MOV  [@Result], AL         {and store it}
    JMP @Finish
  @NoPixel:
    MOV  [@Result], 0          {return 0}
  @Finish:
  END;
END; {GetPixel}


{*****************************************************
 **                                                 **
 **  curve system                                   **
 **                                                 **
 *****************************************************}


PROCEDURE Circle(X,Y,R:INTEGER);
{draw a circle using the Bresenham's circle algorithm,
 does not take the line pattern into account...
 it is somewhat optimized but it still could be faster!
 currently it is a nice mix of pascal and assembler...}
LABEL EndCircle;
VAR DotX,DotY,D:INTEGER;
    ClipOn     :BOOLEAN;
    OldY       :INTEGER;
BEGIN
{protect}
  R := Abs(R);
{determine whether we need to clip or not draw the circle at all}
  ASM
    {prepare horizontal}
    MOV  AX, R                {get radius into AX}
    MOV  BX, X                {get x into BX}
    ADD  BX, ViewPortLeft     {move into viewport}
    MOV  CX, BX               {copy x to CX}
    ADD  BX, AX               {add radius to x}
    SUB  CX, AX               {subtract radius from x}
    {do right side}
    MOV  DX, ViewPortRight    {get right side of view port into DX}
    XOR  AX, AX               {clear AL and AH}
    MOV  ClipOn, AL           {set clipon to false once!}
    CMP  BX, DX
    JLE @Jump1                {if (x+radius) > viewportright then...}
    INC  AL                   {set AL to 1}
  @Jump1:
    CMP  CX, DX
    JLE @Jump2                {if (x-radius) > viewportright then...}
    INC  AH                   {set AH to 1}
    CMP  AL, AH
    JE EndCircle              {if both are > viewportright then finish}
  @Jump2:
    JNE @SetClipOn            {if not both are > viewportright then clip}
    {do left side}
    MOV  DX, ViewPortLeft     {get left side of view port into DX}
    XOR  AX, AX               {clear AL and AH}
    CMP  BX, DX
    JGE @Jump3                {if (x+radius) < viewportleft then...}
    INC  AL                   {set AL to 1}
  @Jump3:
    CMP  CX, DX
    JGE @Jump4                {if (x-radius) < viewportleft then...}
    INC  AH                   {set AH to 1}
    CMP  AL, AH
    JE EndCircle              {if both are < viewportleft then finish}
  @Jump4:
    JNE @SetClipOn            {if not both are > viewportleft then clip}
    {prepare vertical}
    MOV  AX, R                {get radius into AX}
    MOV  BX, Y                {get y into BX}
    ADD  BX, ViewPortTop      {move into viewport}
    MOV  CX, BX               {copy y to CX}
    ADD  BX, AX               {add radius to y}
    SUB  CX, AX               {subtract radius from y}
    {do bottom side}
    MOV  DX, ViewPortBottom   {get bottom side of view port into DX}
    XOR  AX, AX               {clear AL and AH}
    CMP  BX, DX
    JLE @Jump5                {if (y+radius) > viewportbottom then...}
    INC  AL                   {set AL to 1}
  @Jump5:
    CMP  CX, DX
    JLE @Jump6                {if (y-radius) > viewportbottom then...}
    INC  AH                   {set AH to 1}
    CMP  AL, AH
    JE EndCircle              {if both are > viewportbottom then finish}
  @Jump6:
    CMP  AL, AH
    JNE @SetClipOn            {if not both are > viewportbottom then clip}
    {do left side}
    MOV  DX, ViewPortTop      {get top side of view port into DX}
    XOR  AX, AX               {clear AL and AH}
    CMP  BX, DX
    JGE @Jump7                {if (y+radius) < viewporttop then...}
    INC  AL                   {set AL to 1}
  @Jump7:
    CMP  CX, DX
    JGE @Jump8                {if (y-radius) < viewporttop then...}
    INC  AH                   {set AH to 1}
    CMP  AL, AH
    JE EndCircle              {if both are < viewporttop then finish}
  @Jump8:
    CMP  AL, AH
    JNE @SetClipOn            {if not both are > viewporttop then clip}
  {finish}
    JMP @NoClipOn             {do not clip}
  @SetClipOn:
    MOV  ClipOn, $01          {set clip on}
  @NoClipOn:                  {jump here when done}
  END;
{draw only one pixel when the radius is zero}
  IF R = 0 THEN
  BEGIN
    _ViewPortPutPixel(X,Y,DrawFGColor,ClipOn);
    EXIT;
  END;
{prepare some variables}
  ASM
    XOR AX, AX
    MOV DotX, AX        {DotX := 0}
    MOV AX, R
    MOV DotY, AX        {DotY := R}
    SHL AX, 1
    MOV BX, 3
    SUB BX, AX
    MOV D, BX           {D := 3-(R SHL 1)}
  END;
{now actually start to draw the circle}
  IF DrawMode = LineDrawing THEN  {draw an open circle}
  ASM
  @Start:
    MOV AX, DotX
    CMP AX, DotY
    JGE @Finish
  {quick way to push arguments for two or four points}
    XOR  AH, AH
    MOV  AL, DrawFGColor
    MOV  ES, AX
    MOV  AL, ClipOn
    MOV  SI, AX
    MOV  AX, X
    MOV  BX, AX
    MOV  CX, Y
    MOV  DX, CX
    ADD  AX, DotX
    SUB  BX, DotX
    ADD  CX, DotY
    SUB  DX, DotY
    PUSH AX
    PUSH CX
    PUSH ES
    PUSH SI
    PUSH BX
    PUSH DX
    PUSH ES
    PUSH SI
    CMP DotX, 0
    JLE @SkipPixels1
    PUSH AX
    PUSH DX
    PUSH ES
    PUSH SI
    PUSH BX
    PUSH CX
    PUSH ES
    PUSH SI
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
  @SkipPixels1:
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
  {quick way to push arguments for two or four other points}
    XOR  AH, AH
    MOV  AL, DrawFGColor
    MOV  ES, AX
    MOV  AL, ClipOn
    MOV  SI, AX
    MOV  AX, X
    MOV  BX, AX
    MOV  CX, Y
    MOV  DX, CX
    ADD  AX, DotY
    SUB  BX, DotY
    ADD  CX, DotX
    SUB  DX, DotX
    PUSH AX
    PUSH CX
    PUSH ES
    PUSH SI
    PUSH BX
    PUSH DX
    PUSH ES
    PUSH SI
    CMP DotX, 0
    JLE @SkipPixels2
    PUSH AX
    PUSH DX
    PUSH ES
    PUSH SI
    PUSH BX
    PUSH CX
    PUSH ES
    PUSH SI
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
  @SkipPixels2:
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
  {the special quick Bresenham's decision algorithm}
    MOV AX, D
    MOV BX, DotX
    XOR CX, CX
    CMP AX, CX
    JGE @Jump1
    SHL BX, 2           {D := D+(DotX SHL 2)+6}
    ADD AX, BX
    ADD AX, 6
    MOV D,  AX
    JMP @Jump2
  @Jump1:
    SUB BX, DotY        {D := D+((DotX-DotY) SHL 2)+10}
    SHL BX, 2
    ADD AX, BX
    ADD AX, 10
    MOV D,  AX
    DEC DotY            {Inc(DotY)}
  @Jump2:
    INC DotX            {Inc(DotX)}
    JMP @Start
  @Finish:
    MOV AX, DotX
    CMP AX, DotY
    JNE EndCircle
  {quick way to push arguments for the four remaining points}
    XOR  AH, AH
    MOV  AL, DrawFGColor
    MOV  ES, AX
    MOV  AL, ClipOn
    MOV  SI, AX
    MOV  AX, X
    MOV  BX, AX
    MOV  CX, Y
    MOV  DX, CX
    ADD  AX, DotX
    SUB  BX, DotX
    ADD  CX, DotY
    SUB  DX, DotY
    PUSH AX
    PUSH CX
    PUSH ES
    PUSH SI
    PUSH BX
    PUSH DX
    PUSH ES
    PUSH SI
    PUSH AX
    PUSH DX
    PUSH ES
    PUSH SI
    PUSH BX
    PUSH CX
    PUSH ES
    PUSH SI
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
    CALL FAR [_ViewPortPutPixel]
  END
  ELSE {draw a disk using horizontal lines}
  ASM
    MOV OldY, 0
  @Start:
    MOV AX, DotX
    CMP AX, DotY
    JGE @Finish
  {do we need to draw new lines?}
    MOV AX, DotY
    CMP AX, OldY
    JE @SkipLines1
    MOV OldY, AX
  {quick way to push arguments for two lines}
    XOR  AH, AH
    MOV  AL, ClipOn
    MOV  SI, AX
    MOV  AX, X
    MOV  BX, AX
    MOV  CX, Y
    MOV  DX, CX
    ADD  AX, DotX
    SUB  BX, DotX
    ADD  CX, DotY
    SUB  DX, DotY
    PUSH BX
    PUSH AX
    PUSH CX
    PUSH SI
    PUSH BX
    PUSH AX
    PUSH DX
    PUSH SI
    CALL FAR [ViewPortAllignedLine]
    CALL FAR [ViewPortAllignedLine]
  @SkipLines1:
  {quick way to push arguments for one or two lines}
    XOR  AH, AH
    MOV  AL, ClipOn
    MOV  SI, AX
    MOV  AX, X
    MOV  BX, AX
    MOV  CX, Y
    MOV  DX, CX
    ADD  AX, DotY
    SUB  BX, DotY
    ADD  CX, DotX
    SUB  DX, DotX
    PUSH BX
    PUSH AX
    PUSH CX
    PUSH SI
    CMP DotX, 0
    JLE @Skiplines2
    PUSH BX
    PUSH AX
    PUSH DX
    PUSH SI
    CALL FAR [ViewPortAllignedLine]
  @Skiplines2:
    CALL FAR [ViewPortAllignedLine]
  {the special quick Bresenham's decision algorithm}
    MOV AX, D
    MOV BX, DotX
    XOR CX, CX
    CMP AX, CX
    JGE @Jump1
    SHL BX, 2           {D := D+(DotX SHL 2)+6}
    ADD AX, BX
    ADD AX, 6
    MOV D,  AX
    JMP @Jump2
  @Jump1:
    SUB BX, DotY        {D := D+((DotX-DotY) SHL 2)+10}
    SHL BX, 2
    ADD AX, BX
    ADD AX, 10
    MOV D,  AX
    DEC DotY            {Inc(DotY)}
  @Jump2:
    INC DotX            {Inc(DotX)}
    JMP @Start
  @Finish:
    MOV AX, DotX
    CMP AX, DotY
    JNE EndCircle
  {quick way to push arguments for the remaining two lines}
    XOR  AH, AH
    MOV  AL, ClipOn
    MOV  SI, AX
    MOV  AX, X
    MOV  BX, AX
    MOV  CX, Y
    MOV  DX, CX
    ADD  AX, DotX
    SUB  BX, DotX
    ADD  CX, DotY
    SUB  DX, DotY
    PUSH BX
    PUSH AX
    PUSH CX
    PUSH SI
    PUSH BX
    PUSH AX
    PUSH DX
    PUSH SI
    CALL FAR [ViewPortAllignedLine]
    CALL FAR [ViewPortAllignedLine]
  END;
  EndCircle:
END; {Circle}


FUNCTION _Real2Int(X:REAL):INTEGER;
{rounds and ranges a real to a integer}
BEGIN
  IF X < -32768.0 THEN X := -32768;
  IF X > 32767.0 THEN X := 32767;
  _Real2Int := Round(X);
END; {_Real2Int}


PROCEDURE _FlattenBezier(X0,Y0,X1,Y1,X2,Y2,X3,Y3:REAL;Depth:WORD);
{find the flatness of the curve, as it lies within the convex hull
 of its control points we just find the maximum distance of the
 intermediate control points from the straight line joining the ends}
VAR N1X,N1Y,N2X,N2Y,N3X,N3Y,N4X,N4Y,N5X,N5Y:REAL;
BEGIN
  IF Depth > MaxDepth THEN EXIT;
  A := Y3-Y0;
  B := X0-X3;
  C := X3*Y0-X0*Y3;
  Dist1   := Sqr(A*X1+B*Y1+C);
  Dist2   := Sqr(A*X2+B*Y2+C);
  MaxDist := Flatness*(Sqr(A)+Sqr(B));
{if the curve is not flat enough bisect it and flatten the halves}
  IF (Dist1 > MaxDist) OR (Dist2 > MaxDist) THEN
  BEGIN
    N1X := 0.5*X0+0.5*X1;
    N1Y := 0.5*Y0+0.5*Y1;
    N2X := 0.25*X0+0.5*X1+0.25*X2;
    N2Y := 0.25*Y0+0.5*Y1+0.25*Y2;
    N3X := 0.125*X0+0.375*X1+0.375*X2+0.125*X3;
    N3Y := 0.125*Y0+0.375*Y1+0.375*Y2+0.125*Y3;
    N4X := 0.25*X1+0.5*X2+0.25*X3;
    N4Y := 0.25*Y1+0.5*Y2+0.25*Y3;
    N5X := 0.5*X2+0.5*X3;
    N5Y := 0.5*Y2+0.5*Y3;
    Inc(Depth);
    _FlattenBezier(X0,Y0,N1X,N1Y,N2X,N2Y,N3X,N3Y,Depth);
    _FlattenBezier(N3X,N3Y,N4X,N4Y,N5X,N5Y,X3,Y3,Depth);
  END
  ELSE {otherwise make it a straight line from 0 to 3}
  BEGIN
    LineTo(_Real2Int(X3),_Real2Int(Y3));
  END;
END; {_FlattenBezier}


PROCEDURE Bezier(X0,Y0,X1,Y1,X2,Y2,X3,Y3:INTEGER);
{draw a bezier curve, overflow protection is installed,
 I know it's not very efficient, sorry for that...}
BEGIN
{do it}
  MoveTo(X0,Y0);
  _FlattenBezier(X0,Y0,X1,Y1,X2,Y2,X3,Y3,0);
END; {Bezier}


PROCEDURE Ellipse(X,Y,RX,RY:INTEGER);
{draw a ellipse; bezier are used because they inplement the line mode blits}
VAR MinX,MaxX,MinY,MaxY:INTEGER;
BEGIN
{do it}
  MinX := X-RX;
  MaxX := X+RX;
  RY   := _Real2Int(1.32*RY);
  MinY := Y-RY;
  MaxY := Y+RY;
  MoveTo(MinX,Y);
  _FlattenBezier(MinX,Y,MinX,MaxY,MaxX,MaxY,MaxX,Y,0);
  _FlattenBezier(MaxX,Y,MaxX,MinY,MinX,MinY,MinX,Y,0);
END; {Ellipse}


{*****************************************************
 **                                                 **
 **  flood system                                   **
 **                                                 **
 *****************************************************}


FUNCTION _IsRawFillPixel(X,Y:INTEGER):BOOLEAN;
{test whether the given pixel should been flooded}
VAR Color:BYTE;
BEGIN
  Color := _RawGetPixel(X,Y);
  IF FillEquals THEN _IsRawFillPixel := Color = FillColor
                ELSE _IsRawFillPixel := (Color <> FillColor) AND
                                        (Color <> DrawFGColor);
END; {_IsRawFillPixel}


FUNCTION _RawFillOneLine(X,Y:INTEGER;VAR XL,XR:INTEGER):INTEGER;
{flood a single line and return flood range, uses raw routines}
BEGIN
{set left-right range to current seed}
  XL := X;
  XR := X;
{seach in the left direction for an end of the current line}
  REPEAT
    Dec(XL);
    IF XL < ViewPortLeft THEN BREAK;
  UNTIL NOT _IsRawFillPixel(XL,Y);
  Inc(XL);
{seach in the right direction for an end of the current line}
  REPEAT
    Inc(XR);
    IF XR > ViewPortRight THEN BREAK;
  UNTIL NOT _IsRawFillPixel(XR,Y);
  Dec(XR);
{now we draw the current line}
  RawAllignedLine(XL,XR,Y);
{return rightmost pixel}
  _RawFillOneLine := XR;
END; {_RawFillOneLine}


FUNCTION _NewFill(X,Y,D,OldXL,OldXR:INTEGER):POINTER;
{allocate and fill a new 'RawFill' record, by doing this
 we try to alleviate the stack a bit, although this does
 not help that much, just use a big stack and you'll be fine}
VAR RawFill:RawFillPtr;
BEGIN
{get it from heap}
  GetMem(RawFill,SizeOf(RawFillType));
{fill in arguments}
  WITH RawFill^ DO
  BEGIN
    F_X     := X;
    F_Y     := Y;
    F_D     := D;
    F_OldXL := OldXL;
    F_OldXR := OldXR;
  END;
{return it on stack}
  _NewFill := RawFill;
END; {_NewFill}


FUNCTION _RawFill(RawFill:RawFillPtr):INTEGER;
{x,y should contain a valid seed, since the parent routine does not
 remember the pointer to 'RawFill' we should forget it ourselves}
BEGIN
  WITH RawFill^ DO
  BEGIN
  {flood current seed and get a local range}
    _RawFill := _RawFillOneLine(F_X,F_Y,F_CurXL,F_CurXR);
  {we now try to continue in the same direction unless we backfire}
    REPEAT
      {we first check whether we should go back}
      Dec(F_Y,F_D);
      IF (F_Y >= ViewPortTop) AND (F_Y <= ViewPortBottom) THEN
      BEGIN
        {check any expanded left part}
        F_X := F_CurXL;
        WHILE F_X < F_OldXL DO
        BEGIN
          {actual backfire!}
          IF _IsRawFillPixel(F_X,F_Y) THEN
          BEGIN
            F_X := _RawFill(_NewFill(F_X,F_Y,-F_D,F_CurXL,F_OldXL-1));
          END;
          Inc(F_X);
        END;
        {check any expanded right part}
        F_X := F_OldXR+1;
        WHILE F_X <= F_CurXR DO
        BEGIN
          {actual backfire!}
          IF _IsRawFillPixel(F_X,F_Y) THEN
          BEGIN
            F_X := _RawFill(_NewFill(F_X,F_Y,-F_D,F_OldXR+1,F_CurXR));
          END;
          Inc(F_X);
        END;
      END;
      {oke we checked the backfire, now we can try to continue}
      Inc(F_Y,F_D+F_D);
      {make sure we don't run wild}
      F_NothingFilled := TRUE;
      {scan this next line for new seeds}
      IF (F_Y >= ViewPortTop) AND (F_Y <= ViewPortBottom) THEN
      BEGIN
        {current becomes old now}
        F_OldXL := F_CurXL;
        F_OldXR := F_CurXR;
        F_X     := F_OldXL;
        REPEAT
          IF _IsRawFillPixel(F_X,F_Y) THEN
          BEGIN
            IF F_NothingFilled THEN
            BEGIN
              {we can fill a new line}
              F_x := _RawFillOneLine(F_X,F_Y,F_CurXL,F_CurXR);
              {so we did it}
              F_NothingFilled := FALSE;
            END
            ELSE {we have found a second, or thirh, or... path!}
            BEGIN
              {branch into new path!}
              F_X := _RawFill(_NewFill(F_X,F_Y,F_D,F_X,F_OldXR));
            END;
          END;
          Inc(F_X);
        UNTIL F_X > F_OldXR;
      END;
    {only end when nothing got filled}
    UNTIL F_NothingFilled;
  END;
  ForgetMem(RawFill,SizeOf(RawFillType));
END; {_RawFill}


PROCEDURE Flood(X,Y:INTEGER;BorderColor:BYTE);
{flood an area with a continuous color until
 border color or the filling color is met}
VAR ModeBuffer:DrawModeType;
BEGIN
{directly go to raw coordinates and protect}
  IF NOT _ViewPortPointClipping(X,Y) THEN EXIT;
{store draw mode}
  GetDrawingMode(ModeBuffer);
{set globals}
  FillEquals := FALSE;
  FillColor  := BorderColor;
{set drawing style}
  SetFillMode(DrawFGColor,SolidFill,CopyBlit);
{do it!}
  IF _IsRawFillPixel(X,Y) THEN _RawFill(_NewFill(X,Y,1,X,X));
{restore draw mode}
  SetDrawingMode(ModeBuffer);
END; {Flood}


PROCEDURE Bleed(X,Y:INTEGER;BleedColor:BYTE);
{flood an area with a continuous color
 while color at the given pixel is met}
VAR ModeBuffer:DrawModeType;
BEGIN
{directly go to raw coordinates and protect}
  IF NOT _ViewPortPointClipping(X,Y) THEN EXIT;
{store draw mode}
  GetDrawingMode(ModeBuffer);
{set globals}
  FillEquals := TRUE;
  FillColor  := _RawGetPixel(X,Y);
{prevent strange behaviour}
  IF FillColor = BleedColor THEN EXIT;
{set drawing style}
  SetFillMode(BleedColor,SolidFill,CopyBlit);
{do it!}
  _RawFill(_NewFill(X,Y,1,X,X));
{restore draw mode}
  SetDrawingMode(ModeBuffer);
END; {Bleed}


{*****************************************************
 **                                                 **
 **  polygon system                                 **
 **                                                 **
 *****************************************************}


TYPE
  SegmentListPtr         = ^SegmentListType;
  SegmentListType        = ARRAY [1..32000] OF INTEGER;
  SegmentListHeaderType  = RECORD
                             L_MaxCount,
                             L_RealCount        :WORD;
                             L_List             :SegmentListPtr;
                           END;
  SegmentListArrayPtr    = ^SegmentListArrayType;
  SegmentListArrayType   = ARRAY [1..2048] OF SegmentListHeaderType;


VAR
  SegmentLists           :SegmentListArrayPtr;



PROCEDURE _DrawSegmentList(VAR SegmentListHeader:SegmentListHeaderType;Y:INTEGER);
{draw all segments of a line list}
VAR Index,X1,X2:INTEGER;
BEGIN
  WITH SegmentListHeader DO
  BEGIN
    Index := 1;
    REPEAT
      X1 := L_List^[Index];
      Inc(Index);
      X2 := L_List^[Index];
      IF X1 <> X2 THEN
      BEGIN
        ViewPortAllignedLine(X1,X2,Y,TRUE);
      END;
      Inc(Index);
    UNTIL Index > L_RealCount;
  END;
END; {_DrawSegmentList}


PROCEDURE _QuickSortSegmentList(VAR SegmentListHeader:SegmentListHeaderType);
{sorts a line list really very fast using the stack a little}
PROCEDURE __SubSort(L,R:INTEGER);
  VAR I,J,Middle,Dummy:INTEGER;
  BEGIN
    WITH SegmentListHeader DO
    BEGIN
      I := L;
      J := R;
      Middle := L_List^[(L+R) DIV 2];
      REPEAT
        WHILE L_List^[I] < Middle DO Inc(I);
        WHILE Middle < L_List^[J] DO Dec(J);
        IF I <= J THEN
        BEGIN
          Dummy      := L_List^[I];
          L_List^[I] := L_List^[J];
          L_List^[J] := Dummy;
          Inc(I);
          Dec(J);
        END;
      UNTIL I > J;
      IF L < J THEN __SubSort(L,J);
      IF I < R THEN __SubSort(I,R);
    END;
  END; {SubSort}
BEGIN {QuickSort}
  __SubSort(1,SegmentListHeader.L_RealCount);
END; {_QuickSortSegmentList}


PROCEDURE _FillPoly;
{my own solution, who can do it better?}
VAR NormalPolyCount,
    PointNr,Count    :WORD;
    MinY,MaxY,Height,
    R1,X1,Y1,R2,X2,Y2,
    Index            :INTEGER;
    TotalCount       :LONGINT;
    UseSingleList    :BOOLEAN;
    RX,DeltaX        :REAL;
    SingleList       :SegmentListPtr;
BEGIN
{enter}
  IF PolyCount < 2 THEN EXIT;
{first of all we find out on which heigth we should render}
  MinY := MaxInt;
  MaxY := -MaxInt;
  FOR PointNr := 1 TO PolyCount DO
  WITH PolyPoints^[PointNr] DO
  BEGIN
    IF P_Y < MinY THEN MinY := P_Y;
    IF P_Y > MaxY THEN MaxY := P_Y;
  END;
  IF MinY < 0       THEN MinY := 0;
  IF MaxY > GetMaxY THEN MaxY := GetMaxY;
  Height := MaxY-MinY;
  IF Height <= 0 THEN EXIT;
{and we allocate memory for the line buffer lists}
  GetMem(SegmentLists,Height SHL 3);
{and clear it}
  FillChar(SegmentLists^,Height SHL 3,0);
{add one extra point when needed}
  NormalPolyCount := PolyCount;
  WITH PolyPoints^[1] DO PolyPoint(P_X,P_Y);
{now we start to determine the maximum count of elements in each list}
  TotalCount := 0;
  FOR PointNr := 1 TO PolyCount-1 DO
  BEGIN
    {get points of one line}
    WITH PolyPoints^[PointNr] DO
    BEGIN
      R1 := P_ReOccur;
      X1 := P_X;
      Y1 := P_Y;
    END;
    WITH PolyPoints^[PointNr+1] DO
    BEGIN
      R2 := P_ReOccur;
      X2 := P_X;
      Y2 := P_Y;
    END;
    {only act when not horizontal and both points do not reoccur}
    IF (Y1 <> Y2) AND ((R1 < 1) OR (R2 < 1)) THEN
    BEGIN
      IF Y1 > Y2 THEN {swap points}
      ASM
        MOV AX, X1
        MOV BX, Y1
        MOV CX, X2
        MOV DX, Y2
        MOV X2, AX
        MOV Y2, BX
        MOV X1, CX
        MOV Y1, DX
      END;
      {only the part that is used!}
      IF Y1 < 0       THEN Y1 := 0;
      IF Y2 > GetMaxY THEN Y2 := GetMaxY;
      {now we add this line to the list, last point not included}
      FOR Index := Y1-MinY+1 TO Y2-MinY DO
      BEGIN
        Inc(SegmentLists^[Index].L_MaxCount);
        Inc(TotalCount);
      END;
    END;
  END;
{is the anything to draw?}
  IF TotalCount > 0 THEN
  BEGIN
  {and we allocate memory used in the line lists}
    UseSingleList := TotalCount < 32000;
    IF UseSingleList THEN
    BEGIN
      {using a single list is somewhat quicker!}
      GetMem(SingleList,TotalCount*SizeOf(INTEGER));
      Count := 1;
      FOR Index := 1 TO Height DO
      WITH SegmentLists^[Index] DO
      BEGIN
        L_List := @SingleList^[Count];
        Inc(Count,L_MaxCount);
      END;
    END
    ELSE
    FOR Index := 1 TO Height DO
    WITH SegmentLists^[Index] DO
    BEGIN
      GetMem(L_List,L_MaxCount*SizeOf(INTEGER));
    END;
  {now we code all the lines into this list}
    FOR PointNr := 1 TO PolyCount-1 DO
    BEGIN
      {get points of one line}
      WITH PolyPoints^[PointNr] DO
      BEGIN
        R1 := P_ReOccur;
        X1 := P_X;
        Y1 := P_Y;
      END;
      WITH PolyPoints^[PointNr+1] DO
      BEGIN
        R2 := P_ReOccur;
        X2 := P_X;
        Y2 := P_Y;
      END;
      {only act when not horizontal}
      IF (Y1 <> Y2) AND ((R1 < 1) OR (R2 < 1)) THEN
      BEGIN
        IF Y1 > Y2 THEN {swap points}
        ASM
          MOV AX, X1
          MOV BX, Y1
          MOV CX, X2
          MOV DX, Y2
          MOV X2, AX
          MOV Y2, BX
          MOV X1, CX
          MOV Y1, DX
        END;
        {now we add this line to the list, last point not included}
        RX     := X1;
        DeltaX := (X2-X1)/(Y2-Y1);
        {only the part that is used!}
        IF Y1 < 0 THEN
        BEGIN
          RX := RX-DeltaX*Y1;
          Y1 := 0;
        END;
        IF Y2 > GetMaxY THEN Y2 := GetMaxY;
        FOR Index := Y1-MinY+1 TO Y2-MinY DO
        WITH SegmentLists^[Index] DO
        BEGIN
          Inc(L_RealCount);
          L_List^[L_RealCount] := Round(RX);
          RX := RX+DeltaX;
        END;
      END;
    END;
  {and now we sort the line lists and draw the segments!}
    FOR Index := 1 TO Height DO
    WITH SegmentLists^[Index] DO
    IF (L_RealCount > 0) AND NOT Odd(L_RealCount) THEN
    BEGIN
      _QuickSortSegmentList(SegmentLists^[Index]);
      _DrawSegmentList(SegmentLists^[Index],MinY+Index-1);
    END;
  {and we deallocate memory used in the line lists}
    IF UseSingleList THEN
    BEGIN
      ForgetMem(SingleList,TotalCount*SizeOf(INTEGER));
    END
    ELSE
    FOR Index := 1 TO Height DO
    WITH SegmentLists^[Index] DO
    BEGIN
      ForgetMem(L_List,L_MaxCount*SizeOf(INTEGER));
    END;
  END;
{and we deallocate memory for the line buffer lists}
  ForgetMem(SegmentLists,Height SHL 3);
{exit}
  PolyCount := NormalPolyCount;
END; {_FillPoly}


PROCEDURE _LinePoly(Closure:BOOLEAN);
{this is a very complex way to do something that's not so complex}
VAR PointNr,NormalPolyCount,X2,Y2,R2:INTEGER;
BEGIN
  IF PolyCount < 2 THEN EXIT;
  IF Closure THEN
  BEGIN
    NormalPolyCount := PolyCount;
    WITH PolyPoints^[1] DO PolyPoint(P_X,P_Y);
  END;
  FOR PointNr := 1 TO PolyCount-1 DO
  BEGIN
    WITH PolyPoints^[PointNr+1] DO
    BEGIN
      R2 := P_ReOccur;
      X2 := P_X;
      Y2 := P_Y;
    END;
    {only act when both points do not reoccur}
    WITH PolyPoints^[PointNr] DO
    IF ((P_ReOccur < 1) OR (R2 < 1)) THEN Line(P_X,P_Y,X2,Y2);
  END;
  IF Closure THEN PolyCount := NormalPolyCount;
END; {_LinePoly}


PROCEDURE ResetPoly;
{simply resets the counter to zero}
BEGIN
  PolyCount := 0;
END; {ResetPoly}


PROCEDURE PolyPoint(X,Y:INTEGER);
{adds a point to a polygon}
VAR Index:INTEGER;
BEGIN
{prevent overflow of point buffer}
  IF PolyCount = MaxPolyCount THEN EXIT;
{never add the same point twice}
  IF (LastestPolyX <> X) OR
     (LastestPolyY <> Y) OR
     (PolyCount = 0) THEN
  BEGIN
  {ok, we can add the point}
    Inc(PolyCount);
    WITH PolyPoints^[PolyCount] DO
    BEGIN
      P_ReOccur := 0;
      P_X       := X;
      P_Y       := Y;
    END;
    {check reoccurance for quick and correct rendering}
    Index := PolyCount;
    WHILE Index > 1 DO
    BEGIN
      Dec(Index);
      WITH PolyPoints^[Index] DO
      IF (P_X = X) AND (P_Y = Y) THEN
      BEGIN
        Inc(P_ReOccur);
        PolyPoints^[PolyCount].P_ReOccur := P_ReOccur;
      END;
    END;
  {remember that point}
    LastestPolyX := X;
    LastestPolyY := Y;
  END;
END; {PolyPoint}


PROCEDURE RenderPoly;
{draws the given polypoints}
BEGIN
{protect}
  IF PolyCount < 2 THEN EXIT;
{draw it}
  IF DrawMode = FillDrawing THEN _FillPoly ELSE _LinePoly(TRUE);
END; {RenderPoly}


PROCEDURE RotatePolygonXY(X,Y:INTEGER;Angle:REAL);
VAR C,S,Ph        :REAL;
    Index,PX,DX,DY:INTEGER;
BEGIN
  IF PolyCount >= 2 THEN
  BEGIN
    Ph := Pi/180.0*Angle;
    C  := Cos(Ph);
    S  := Sin(Ph);
    FOR Index := 1 TO PolyCount DO
    WITH PolyPoints^[Index] DO
    BEGIN
      DX  := P_X-X;
      DY  := P_Y-Y;
      P_X := X+Round(C*DX-S*DY);
      P_Y := Y+Round(S*DX+C*DY);
    END;
  END;
END; {RotatePolygonXY}


PROCEDURE RotatePolygon(Angle:REAL);
VAR X,Y  :LONGINT;
    Index:INTEGER;
BEGIN
{compute centerpoint}
  X := 0;
  Y := 0;
  FOR Index := 1 TO PolyCount DO
  WITH PolyPoints^[PolyCount] DO
  BEGIN
    Inc(X,P_X);
    Inc(Y,P_Y);
  END;
  X := X DIV PolyCount;
  Y := Y DIV PolyCount;
{rotate}
  RotatePolygonXY(X,Y,Angle);
END; {RotatePolygon}


PROCEDURE TranslatePolygon(DeltaX,DeltaY:INTEGER);
VAR Index:INTEGER;
BEGIN
  FOR Index := 1 TO PolyCount DO
  WITH PolyPoints^[PolyCount] DO
  BEGIN
    Inc(P_X,DeltaX);
    Inc(P_Y,DeltaY);
  END;
END; {TranslatePolygon}


PROCEDURE ScalePolygon(ScaleX,ScaleY:REAL);
VAR Index:INTEGER;
BEGIN
  FOR Index := 1 TO PolyCount DO
  WITH PolyPoints^[PolyCount] DO
  BEGIN
    P_X := Round(P_X*ScaleX);
    P_Y := Round(P_Y*ScaleX);
  END;
END; {ScalePolygon}


{*****************************************************
 **                                                 **
 **  palette system                                 **
 **                                                 **
 *****************************************************}


PROCEDURE _SetRGBColor(ColorNr,R,G,B:BYTE);ASSEMBLER;
{set a color register (color = 0..255 and r,g,b = 0..255)}
ASM
  CALL WaitTOF
  MOV  DX, $03C8               {get color write count port into DX}
  MOV  AL, ColorNr
  OUT  DX, AL
  INC  DX
  MOV  AL, R
  SHR  AL, 2                   {divide it by 4}
  OUT  DX, AL
  MOV  AL, G
  SHR  AL, 2                   {divide it by 4}
  OUT  DX, AL
  MOV  AL, B
  SHR  AL, 2                   {divide it by 4}
  OUT  DX, AL
END; {_SetRGBColor}


PROCEDURE _GetRGBColor(ColorNr:BYTE;VAR R,G,B:BYTE); ASSEMBLER;
{get a color register (color = 0..255 and r,g,b = 0..255)}
ASM
  MOV  DX, $03C7               {get color read count port into DX}
  MOV  AL, colorNr
  OUT  DX, AL
  ADD  DX, 2
  IN   AL, DX
  SHL  AL, 2                   {multiply by 4}
  LES  DI, [R]
  MOV  [ES:DI], AL             {put AL into R}
  IN   AL, DX
  SHL  AL, 2                   {multiply by 4}
  LES  DI, [G]
  MOV  [ES:DI], AL             {put AL into G}
  IN   AL, DX
  SHL  AL, 2                   {multiply by 4}
  LES  DI, [B]
  MOV  [ES:DI], AL             {put AL into B}
END; {_GetRGBColor}


PROCEDURE _SetFullPalette(VAR Palette:PaletteType); ASSEMBLER;
{set color registers from the given color map}
ASM
{actual routine}
  CALL WaitTOF;
  MOV   CX, 3*256               {change all colors}
  PUSH  DS                      {store DS}
  LDS   SI, Palette             {get palette address}
  CLD                           {forward}
  MOV   DX, $03C8               {get color write count port into DX}
  MOV   AL, 0
  OUT   DX, AL                  {start from zero}
  INC   DX                      {move to color read/write port}
 @Repeat:
  LODSB                         {get a color channel from the palette}
  SHR   AL, 2                   {divide it by 4}
  OUT   DX, AL                  {and put it in the DAC}
  LOOP @Repeat
  pop   DS                      {restore DS}
 @Finish:
END; {_SetFullPalette}


PROCEDURE _GetFullPalette(VAR Palette:PaletteType); ASSEMBLER;
{get color registers to the given color map,
 who ever said that assembler was a stupid language?}
ASM
  MOV   CX, 3*256               {change all colors}
  LES   DI, Palette             {get palette address}
  CLD                           {forward}
  MOV   DX, $03C7               {get color read count port into DX}
  MOV   AL, 0
  OUT   DX, AL                  {start from zero}
  ADD   DX, 2                   {move to color read/write port}
 @Repeat:
  IN    AL, DX                  {get color channel in AL}
  SHL   AL, 2                   {multiply by 4}
  STOSB                         {and store it in the palette}
  LOOP @Repeat
END; {_GetFullPalette}


FUNCTION _SamePalettes(VAR Palette1,Palette2:PaletteType;
                                            Extended:BOOLEAN):BOOLEAN;
{returns true when they are the same!}
VAR Index,Max:BYTE;
BEGIN
  _SamePalettes := FALSE;
  IF Extended THEN Max := 255 ELSE Max := 15;
  FOR Index := 0 TO Max DO
  WITH Palette1[Index] DO
  BEGIN
    IF (Abs(C_R-Palette2[Index].C_R) > 4) OR
       (Abs(C_G-Palette2[Index].C_G) > 4) OR
       (Abs(C_B-Palette2[Index].C_B) > 4) THEN
    BEGIN
       EXIT;
    END;
  END;
  _SamePalettes := TRUE;
END; {_SamePalettes}


PROCEDURE RefreshPalette(Extended:BOOLEAN);
{the only routine that can update the shown palette,
 when extended is selected all 256 colors are updated,
 otherwise only the 16 EGA colors are updata via BIOS,
 we perform a extensive text to see whether the palette
 is acually different form the current palette}
VAR Palette:PaletteType;
BEGIN
{get real current palette}
  _GetFullPalette(Palette);
{leave when they are the same}
  IF _SamePalettes(Palette,CurrentPalette,Extended) THEN EXIT;
{set the mouse bitmap refresh flag!}
  RefreshMouseBitMap := TRUE;
{palette itselve}
  _SetFullPalette(CurrentPalette);
END; {RefreshPalette}


PROCEDURE SetRGBColor(ColorNr,R,G,B:BYTE);
{set a color register (color = 0..255 and r,g,b = 0..255)}
BEGIN
  WITH CurrentPalette[ColorNr] DO
  BEGIN
    C_R := R;
    C_B := B;
    C_G := G;
  END;
END; {SetRGBColor}


PROCEDURE GetRGBColor(ColorNr:BYTE;VAR R,G,B:BYTE);
{get a color register (color = 0..255 and r,g,b = 0..255)}
BEGIN
  WITH CurrentPalette[ColorNr] DO
  BEGIN
    R := C_R;
    B := C_B;
    G := C_G;
  END;
END; {GetRGBColor}


PROCEDURE SetFullPalette(VAR Palette:PaletteType);
{set color registers from the given color map}
BEGIN
  CurrentPalette := Palette;
END; {SetFullPalette}


PROCEDURE GetFullPalette(VAR Palette:PaletteType);
{get color registers to the given color map,
 who ever said that assembler was a stupid language?}
BEGIN
  Palette := CurrentPalette;
END; {GetFullPalette}


PROCEDURE SetPartialPalette(VAR Palette:PaletteType;Start,Finish:BYTE);
{set given color registers from the given color map}
VAR ColorNr:BYTE;
BEGIN
  FOR ColorNr := Start TO Finish DO
  WITH CurrentPalette[ColorNr] DO
  BEGIN
    C_R := Palette[ColorNr].C_R;
    C_B := Palette[ColorNr].C_B;
    C_G := Palette[ColorNr].C_G;
  END;
END; {SetPartialPalette}


PROCEDURE GetPartialPalette(VAR Palette:PaletteType;Start,Finish:BYTE);
{get given color registers to the given color map,
 who ever said that assembler was a stupid language?}
VAR ColorNr:BYTE;
BEGIN
  FOR ColorNr := Start TO Finish DO
  WITH CurrentPalette[ColorNr] DO
  BEGIN
    Palette[ColorNr].C_R := C_R;
    Palette[ColorNr].C_B := C_B;
    Palette[ColorNr].C_G := C_G;
  END;
END; {GetFullPalette}


PROCEDURE SetDefaultPalette;
{set some type of default palette}
VAR Palette:PaletteType;
    ColorNr:BYTE;
BEGIN
{first the default colors}
  FOR ColorNr := 0 TO 15 DO
  WITH DefaultPalette[ColorNr] DO
  BEGIN
    SetRGBColor(ColorNr,C_R,C_G,C_B);
  END;
{now the remaining 15 groups}
  FOR ColorNr := 0 TO 255-16 DO
  BEGIN
    SetRGBColor(ColorNr+16,Round(255/5*((ColorNr DIV 36) MOD 6)),
                           Round(255/5*((ColorNr DIV 6) MOD 6)),
                           Round(255/5*(ColorNr MOD 6)));
  END;
  RefreshPalette(GraphicsOn);
END; {SetDefaultPalette}


PROCEDURE FadeOutPalette(R,G,B:BYTE;FadeTime:REAL);
{fade out the complete palette}
CONST VESAFrequency = 60;
VAR Steps    :LONGINT;
    StepNr   :INTEGER;
    Palette  :PaletteType;
    ColorNr  :BYTE;
    Rol1,Rol2:REAL;
BEGIN
{get the current palette}
  Palette := CurrentPalette;
{determine the number of steps to get it faded out}
  Steps := Round(FadeTime*VESAFrequency)+1;
{and then perform that amount of steps}
  StepNr := Steps;
  REPEAT
    Dec(StepNr);
    {you need a somewhat fast computer to do this in less than 15 ms}
    FOR ColorNr := 0 TO 255 DO
    WITH Palette[ColorNr] DO
    BEGIN
      Rol1 := StepNr/Steps;
      Rol2 := 1.0-Rol1;
      C_R  := Round(Rol1*CurrentPalette[ColorNr].C_R+Rol2*R);
      C_G  := Round(Rol1*CurrentPalette[ColorNr].C_G+Rol2*G);
      C_B  := Round(Rol1*CurrentPalette[ColorNr].C_B+Rol2*B);
    END;
    _SetFullPalette(Palette)
  UNTIL StepNr < 1;
END; {FadeOutPalette}


PROCEDURE FadeInPalette(FadeTime:REAL);
{fade in the complete palette}
CONST VESAFrequency = 60;
VAR Steps    :LONGINT;
    StepNr   :INTEGER;
    Palette  :PaletteType;
    ColorNr  :BYTE;
    Rol1,Rol2:REAL;
    R,G,B    :BYTE;
BEGIN
{get the faded out palette}
  _GetFullPalette(Palette);
  WITH Palette[0] DO
  BEGIN
    R := C_R;
    G := C_G;
    B := C_B;
  END;
{determine the number of steps to get it back to normal}
  Steps := Round(FadeTime*VESAFrequency)+1;
{and then perform that amount of steps}
  StepNr := 1;
  REPEAT
    {you need a somewhat fast computer to do this in less than 15 ms}
    FOR ColorNr := 0 TO 255 DO
    WITH Palette[ColorNr] DO
    BEGIN
      Rol1 := StepNr/Steps;
      Rol2 := 1.0-Rol1;
      C_R  := Round(Rol1*CurrentPalette[ColorNr].C_R+Rol2*R);
      C_G  := Round(Rol1*CurrentPalette[ColorNr].C_G+Rol2*G);
      C_B  := Round(Rol1*CurrentPalette[ColorNr].C_B+Rol2*B);
    END;
    _SetFullPalette(Palette);
    Inc(StepNr);
  UNTIL StepNr > Steps;
END; {FadeInPalette}


FUNCTION GetColorDifference(RefColor,TestColor:RGBColor):INTEGER;
{compute the difference between the two given colors}
BEGIN
  WITH RefColor DO
  BEGIN
    GetColorDifference := Abs(C_R-TestColor.C_R)+
                          Abs(C_G-TestColor.C_G)+
                          Abs(C_B-TestColor.C_B)+
                          Abs((C_R-C_G)-(TestColor.C_R-TestColor.C_G))+
                          Abs((C_G-C_B)-(TestColor.C_G-TestColor.C_B))+
                          Abs((C_B-C_R)-(TestColor.C_B-TestColor.C_R));
  END;
END; {GetColorDifference}


PROCEDURE GetOptimalColors(VAR ColorList:ColorListType;
                           VAR NewPalette:PaletteType;
                           AdaptHighColors,FixateBlack:BOOLEAN);
{return an optimized list of the 256 color palette,
 it is possible to adapt the 32 to 255 (high) colors}
VAR AssignedZero,
    BestDiff,Diff       :INTEGER;
    LowNr,Nr1,Nr2,BestNr:BYTE;
BEGIN
{set the low number}
  IF FixateBlack THEN LowNr := 1 ELSE LowNr := 0;
{then we clear the modify array}
  FillChar(ColorList,256,0);
{first the adaption of the high colors}
  IF AdaptHighColors THEN
  BEGIN
    {color number zero has not been assigned}
    AssignedZero := -1; {that is too small}
    {now we start to search for the 32 colors in the pcx file
     palette which are closest to the first 32 current colors}
    FOR Nr1 := LowNr TO 31 DO
    BEGIN
      BestNr   := LowNr;
      BestDiff := MaxInt; {now the worst!}
      FOR Nr2 := 0 TO 255 DO
      BEGIN
        {compute color difference}
        Diff := GetColorDifference(CurrentPalette[Nr1],NewPalette[Nr2]);
        {and see how well it does}
        IF (Diff < BestDiff) AND
           (ColorList[Nr2] = 0) AND
           (Nr2 <> AssignedZero) THEN
        BEGIN
          BestNr   := Nr2;
          BestDiff := Diff;
        END;
      END;
      {so now we have a best color!}
      ColorList[BestNr] := Nr1;
      {watch out for color number zero!}
      IF Nr1 = 0 THEN AssignedZero := BestNr;
    END;
    {now the 224 other colors can get an adapted color!}
    Nr2 := 0;
    FOR Nr1 := 32 TO 255 DO
    BEGIN
      {find an unused pcx color}
      WHILE (ColorList[Nr2] <> 0) OR (Nr2 = AssignedZero) DO Inc(Nr2);
      {use it to change the color registers}
      WITH NewPalette[Nr2] DO SetRGBColor(Nr1,C_R,C_G,C_B);
      {and note that we did that}
      ColorList[Nr2] := Nr1;
    END;
    {now see if we don't regret one of our choices}
    FOR Nr1 := LowNr TO 255 DO
    IF ColorList[Nr1] < 32 THEN {we check if there is a better color}
    BEGIN
      BestNr   := 0;
      BestDiff := MaxInt; {now the worst!}
      FOR Nr2 := 0 TO 255 DO
      BEGIN
        {compute color difference}
        Diff := GetColorDifference(CurrentPalette[Nr2],NewPalette[Nr1]);
        {and see how well it does}
        IF Diff < BestDiff THEN
        BEGIN
          BestNr   := Nr2;
          BestDiff := Diff;
        END;
        {so now we have a best color!}
        ColorList[Nr1] := BestNr;
      END;
    END;
  END
  ELSE {we are not allowed to adapt the higher palette colors!}
  BEGIN
    {find the best colors in the current palette}
    FOR Nr2 := LowNr TO 255 DO
    BEGIN
      BestNr   := LowNr;
      BestDiff := MaxInt; {now the worst!}
      FOR Nr1 := 0 TO 255 DO
      BEGIN
        {compute color difference}
        Diff := GetColorDifference(CurrentPalette[Nr1],NewPalette[Nr2]);
        {and see how well it does}
        IF Diff < BestDiff THEN
        BEGIN
          BestNr   := Nr1;
          BestDiff := Diff;
        END;
      END;
      {so now we have a best color!}
      ColorList[Nr2] := BestNr;
    END;
  END;
  {when in sprite blit mode we may not alter color zero!}
  IF FixateBlack THEN ColorList[0] := 0;
END; {GetOptimalColors}


{*****************************************************
 **                                                 **
 **  copy system                                    **
 **                                                 **
 *****************************************************}


PROCEDURE _RawMoveForwards(SourceSeg,SourceOfs,DestSeg,DestOfs,
                            Pixels:WORD;BitBlit:BYTE); ASSEMBLER;
{copy pixels+1 pixels from source to dest. using forward words transfer}
ASM
{preperations}
  PUSH  DS                {save data segment register}
  MOV   AX, SourceSeg
  MOV   DS, AX
  MOV   SI, SourceOfs     {source address in DS:SI}
  MOV   AX, DestSeg
  MOV   ES, AX
  MOV   DI, DestOfs       {destination address in ES:DI}
  MOV   CX, Pixels        {store number of pixels in CX}
  MOV   DL, BitBlit       {store bitblit in DL}
  XOR   BX, BX            {clear BH and BL}
  SHR   CX, 1             {change by factor two}
  JNC  @NoCarry1
  INC   BL                {set BL=1 when carry else BL=0}
 @NoCarry1:
{branch on BitBlit}
  CMP   DL, CopyBlit
  JNE  @IsNotCopyBlit     {is it a mov blit?}
{start of copy blit; 32 bit version!}
  SHR   CX, 1             {change by factor four}
  JNC  @NoCarry2
  INC   BH                {set BH=1 when carry else BH=0}
 @NoCarry2:
  TEST  CX, CX
  JZ   @SkipCopyLoop      {skip when length = 0 (actual = 1)}
  CLD                     {forward!}
  DB    $66               {next instruction is 32Bit!}
  REP   MOVSW             {copy CX double words}
@SkipCopyLoop:
  MOVSB                   {and add one byte to that}
  TEST  BH, BH
  JZ   @NoCopyCarry2      {only when count is odd we need...}
  MOVSW                   {to add another byte to that}
@NoCopyCarry2:
  TEST  BL, BL
  JZ   @NoCopyCarry1      {only when count is odd we need...}
  MOVSB                   {to add another byte to that}
@NoCopyCarry1:
  JMP  @Finish
{end of copy blit}
@IsNotCopyBlit:
  CMP   DL, XORBlit
  JNE  @IsNotXORBlit      {is it a xor blit?}
{start of xor blit}
  TEST  CX, CX
  JZ   @SkipXORLoop       {skip when length = 0 (actual = 1)}
@RepeatXOR:
  MOV   AX, [DS:SI]       {copy source to AX}
  XOR   [ES:DI], AX       {perform XOR with destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatXOR
@SkipXORLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  XOR   [ES:DI], AL       {perform XOR with destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  XOR   [ES:DI], AL       {perform XOR with destination}
  JMP  @Finish
{end of xor blit}
@IsNotXORBlit:
  CMP   DL, SpriteBlit
  JNE  @IsNotSpriteBlit   {is it a sprite blit?}
{start of sprite blit}
  TEST  CX, CX
  JZ   @SkipSpriteLoop    {skip when length = 0 (actual = 1)}
@RepeatSprite:
  MOV   AX, [DS:SI]       {copy source to AX}
  TEST  AL, AL
  JZ   @NoCopyAL1         {test and replace the lower byte}
  MOV   [ES:DI], AL       {move to destination}
@NoCopyAL1:
  INC   DI                {advance one steps}
  INC   SI                {in the vga mem}
  TEST  AH, AH
  JZ   @NoCopyAH          {test and replace the higher byte}
  MOV   [ES:DI], AH       {move to destination}
@NoCopyAH:
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatSprite
@SkipSpriteLoop:
  MOV   AL, [DS:SI]       {copy source to AL}
  TEST  AL, AL
  JZ   @NoCopyAL2         {test and replace the lower byte}
  MOV   [ES:DI], AL       {move to destination}
@NoCopyAL2:
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {copy source to AL}
  TEST  AL, AL
  JZ   @NoCopyAL3         {test and replace the lower byte}
  MOV   [ES:DI], AL       {move to destination}
@NoCopyAL3:
  JMP  @Finish
{end of sprite blit}
@IsNotSpriteBlit:
  CMP   DL, ORBlit
  JNE  @IsNotORBlit       {is it an or blit?}
{start of or blit}
  TEST  CX, CX
  JZ   @SkipORLoop        {skip when length = 0 (actual = 1)}
@RepeatOR:
  MOV   AX, [DS:SI]       {copy source to AX}
  OR    [ES:DI], AX       {perform OR with destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatOR
@SkipORLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  OR    [ES:DI], AL       {perform OR with destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  OR    [ES:DI], AL       {perform OR with destination}
  JMP  @Finish
{end of or blit}
@IsNotORBlit:
  CMP   DL, ANDBlit
  JNE  @IsNotANDBlit      {is it an and blit?}
{start of and blit}
  TEST  CX, CX
  JZ   @SkipANDLoop       {skip when length = 0 (actual = 1)}
@RepeatAND:
  MOV   AX, [DS:SI]       {copy source to AX}
  AND   [ES:DI], AX       {perform AND with destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatAND
@SkipANDLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  AND   [ES:DI], AL       {perform AND with destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  AND   [ES:DI], AL       {perform AND with destination}
  JMP  @Finish
{end of and blit}
@IsNotANDBlit:
  CMP   DL, NOTBlit
  JNE  @IsNotNOTBlit      {is it a not blit?}
{start of not blit}
  TEST  CX, CX
  JZ   @SkipNOTLoop       {skip when length = 0 (actual = 1)}
@RepeatNOT:
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  MOV   [ES:DI], AX       {store in destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatNOT
@SkipNOTLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  NOT   AL                {perform NOT}
  MOV   [ES:DI], AL       {store in destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  MOV   [ES:DI], AL       {store in destination}
  JMP  @Finish
{end of not blit}
@IsNotNOTBlit:
  CMP   DL, XNORBlit
  JNE  @IsNotXNORBlit     {is it a xnor blit?}
{start of xnor blit}
  TEST  CX, CX
  JZ   @SkipNXORLoop      {skip when length = 0 (actual = 1)}
@RepeatNXOR:
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  XOR   [ES:DI], AX       {perform XOR with destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatNXOR
@SkipNXORLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  NOT   AL                {perform NOT}
  XOR   [ES:DI], AL       {perform XOR with destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  XOR   [ES:DI], AL       {perform XOR with destination}
  JMP  @Finish
{end of xnor blit}
@IsNotXNORBlit:
  CMP   DL, NORBlit
  JNE  @IsNotNORBlit      {is it an nor blit?}
{start of nor blit}
  TEST  CX, CX
  JZ   @SkipNORLoop       {skip when length = 0 (actual = 1)}
@RepeatNOR:
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  OR    [ES:DI], AX       {perform OR with destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatNOR
@SkipNORLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  NOT   AL                {perform NOT}
  OR    [ES:DI], AL       {perform OR with destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  OR    [ES:DI], AL       {perform OR with destination}
  JMP  @Finish
{end of nor blit}
@IsNotNORBlit:
  CMP   DL, NANDBlit
  JNE  @Finish            {is it an nand blit?}
{start of nand blit}
  TEST  CX, CX
  JZ   @SkipNANDLoop      {skip when length = 0 (actual = 1)}
@RepeatNAND:
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  AND   [ES:DI], AX       {perform AND with destination}
  INC   SI                {advance one steps}
  INC   SI                {in the vga mem}
  INC   DI                {advance one steps}
  INC   DI                {in the vga mem}
  LOOP @RepeatNAND
@SkipNANDLoop:
  MOV   AL, [DS:SI]       {and add one byte to that}
  NOT   AL                {perform NOT}
  AND   [ES:DI], AL       {perform AND with destination}
  INC   SI                {advance one steps}
  INC   DI                {in the vga mem}
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  AND   [ES:DI], AL       {perform AND with destination}
{end of nand blit}
@Finish:
  POP   DS              {restore DS}
END; {_RawMoveForwards}


PROCEDURE _RawMoveBackwards(SourceSeg,SourceOfs,DestSeg,DestOfs,
                             Pixels:WORD;BitBlit:BYTE); ASSEMBLER;
{copy pixels+1 pixels from source to dest. using backward words transfer}
ASM
{preperations}
  PUSH  DS                {save data segment register}
  MOV   AX, SourceSeg
  MOV   DS, AX
  MOV   SI, SourceOfs     {source address in DS:SI}
  MOV   AX, DestSeg
  MOV   ES, AX
  MOV   DI, DestOfs       {destination address in ES:DI}
  MOV   CX, Pixels        {store number of pixels in CX}
  MOV   DL, BitBlit       {store bitblit in DL}
  XOR   BX, BX            {clear BH and BL}
  SHR   CX, 1             {change by factor two}
  JNC  @NoCarry1
  INC   BL                {set BL=1 when carry else BL=0}
 @NoCarry1:
{branch on BitBlit}
  CMP   DL, CopyBlit
  JNE  @IsNotCopyBlit     {is it a mov blit?}
{start of copy blit; 32 bit version!}
  SHR   CX, 1             {change by factor four}
  JNC  @NoCarry2
  INC   BH                {set BH=1 when carry else BH=0}
 @NoCarry2:
  STD                     {backward!}
  MOVSB                   {do the first one, carefully!}
  TEST  BL, BL
  JZ   @NoCopyCarry1      {only when count is odd we need...}
  MOVSB                   {to add another byte to that}
@NoCopyCarry1:
  TEST  BH, BH
  JZ   @NoCopyCarry2      {only when count is odd we need...}
  MOVSB                   {this one is only done to shift the pointers!}
  MOVSW                   {to add two bytes to that}
@NoCopyCarry2:
  TEST  CX, CX
  JZ   @SkipCopyLoop      {skip when length = 0 (actual = 1)}
  MOVSW                   {this one is only done to shift the pointers!}
  DB    $66               {next instruction is 32Bit!}
  REP   MOVSW             {copy CX double words}
@SkipCopyLoop:
  JMP  @Finish
{end of copy blit}
@IsNotCopyBlit:
  CMP   DL, XORBlit
  JNE  @IsNotXORBlit      {is it a xor blit?}
{start of xor blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  XOR   [ES:DI], AL       {perform XOR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipXORLoop       {skip when length = 0 (actual = 1)}
@RepeatXOR:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  XOR   [ES:DI], AX       {perform XOR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatXOR
@SkipXORLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  XOR   [ES:DI], AL       {perform XOR with destination}
  JMP  @Finish
{end of xor blit}
@IsNotXORBlit:
  CMP   DL, SpriteBlit
  JNE  @IsNotSpriteBlit   {is it a sprite blit?}
{start of sprite blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  TEST  AL, AL
  JZ   @NoCopyAL1         {test and replace the lower byte}
  MOV   [ES:DI], AL       {move to destination}
@NoCopyAL1:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipSpriteLoop    {skip when length = 0 (actual = 1)}
@RepeatSprite:
  DEC   SI                {already do the step in source}
  MOV   AX, [DS:SI]       {copy source to AX}
  TEST  AH, AH
  JZ   @NoCopyAH          {test and replace the higher byte}
  MOV   [ES:DI], AH       {move to destination}
@NoCopyAH:
  DEC   DI                {one step in destination}
  TEST  AL, AL
  JZ   @NoCopyAL2         {test and replace the lower byte}
  MOV   [ES:DI], AL       {move to destination}
@NoCopyAL2:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatSprite
@SkipSpriteLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  TEST  AL, AL
  JZ   @NoCopyAL3         {test and replace the lower byte}
  MOV   [ES:DI], AL       {move to destination}
  JMP  @Finish
@NoCopyAL3:
{end of sprite blit}
@IsNotSpriteBlit:
  CMP   DL, ORBlit
  JNE  @IsNotORBlit       {is it an or blit?}
{start of or blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  OR    [ES:DI], AL       {perform OR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipORLoop        {skip when length = 0 (actual = 1)}
@RepeatOR:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  OR    [ES:DI], AX       {perform OR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatOR
@SkipORLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  OR    [ES:DI], AL       {perform OR with destination}
  JMP  @Finish
{end of or blit}
@IsNotORBlit:
  CMP   DL, ANDBlit
  JNE  @IsNotANDBlit      {is it an and blit?}
{start of and blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  AND   [ES:DI], AL       {perform AND with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipANDLoop       {skip when length = 0 (actual = 1)}
@RepeatAND:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  AND   [ES:DI], AX       {perform AND with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatAND
@SkipANDLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  AND   [ES:DI], AL       {perform AND with destination}
  JMP  @Finish
{end of and blit}
@IsNotANDBlit:
  CMP   DL, NOTBlit
  JNE  @IsNotNOTBlit      {is it a not blit?}
{start of not blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  NOT   AL                {perform NOT}
  MOV   [ES:DI], AL       {store in destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipNOTLoop       {skip when length = 0 (actual = 1)}
@RepeatNOT:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  MOV   [ES:DI], AX       {store in destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatNOT
@SkipNOTLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  MOV   [ES:DI], AL       {store in destination}
  JMP  @Finish
{end of not blit}
@IsNotNOTBlit:
  CMP   DL, XNORBlit
  JNE  @IsNotXNORBlit     {is it a xnor blit?}
{start of xnor blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  NOT   AL                {perform NOT}
  XOR   [ES:DI], AL       {perform XOR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipNXORLoop      {skip when length = 0 (actual = 1)}
@RepeatNXOR:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  XOR   [ES:DI], AX       {perform XOR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatNXOR
@SkipNXORLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  XOR   [ES:DI], AL       {perform XOR with destination}
  JMP  @Finish
{end of xnor blit}
@IsNotXNORBlit:
  CMP   DL, NORBlit
  JNE  @IsNotNORBlit      {is it an nor blit?}
{start of nor blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  NOT   AL                {perform NOT}
  OR    [ES:DI], AL       {perform OR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipNORLoop       {skip when length = 0 (actual = 1)}
@RepeatNOR:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  OR    [ES:DI], AX       {perform OR with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatNOR
@SkipNORLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  OR    [ES:DI], AL       {perform OR with destination}
  JMP  @Finish
{end of nor blit}
@IsNotNORBlit:
  CMP   DL, NANDBlit
  JNE  @Finish            {is it an nand blit?}
{start of nand blit}
  MOV   AL, [DS:SI]       {do the first one, carefully}
  NOT   AL                {perform NOT}
  AND   [ES:DI], AL       {perform AND with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  TEST  CX, CX
  JZ   @SkipNANDLoop      {skip when length = 0 (actual = 1)}
@RepeatNAND:
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  MOV   AX, [DS:SI]       {copy source to AX}
  NOT   AX                {perform NOT}
  AND   [ES:DI], AX       {perform AND with destination}
  DEC   SI                {advance one steps}
  DEC   DI                {in the vga mem}
  LOOP @RepeatNAND
@SkipNANDLoop:
  TEST  BL, BL
  JZ   @Finish            {only when count is odd we need...}
  MOV   AL, [DS:SI]       {to add another byte to that}
  NOT   AL                {perform NOT}
  AND   [ES:DI], AL       {perform AND with destination}
{end of nand blit}
@Finish:
  POP   DS              {restore DS}
END; {_MoveWordBackward}


PROCEDURE _RawCopyForward(Source,Dest,Pixels:LONGINT;BitBlit:BYTE);
{copy a certain amount of display memory from source to destination}
CONST BufSize = 1024;
VAR CopySize,BufSeg,BufOfs:WORD;
    DualModeOn            :BOOLEAN;
    Buffer                :ARRAY [0..BufSize-1] OF BYTE;
BEGIN
{get segment and offset of buffer}
  BufSeg := Seg(Buffer[0]);
  BufOfs := Ofs(Buffer[0]);
{goto dual mode when possible}
  DualModeOn := SelectVESADualMode;
{loop until all pixels are transferred}
  WHILE Pixels > 0 DO
  BEGIN
    {number of bytes, minus one, till end of source bank}
    CopySize := $FFFF-LongRec(Source).L;
    {when there are less bytes till end of dest bank then take that}
    IF CopySize > $FFFF-LongRec(Dest).L
    THEN CopySize := $FFFF-LongRec(Dest).L;
    {when there are less bytes to copy then take that}
    IF CopySize > Pixels-1 THEN CopySize := Pixels-1;
    {select method according to mode and position of source and dest.}
    IF DualModeOn THEN  {we have dual mode; it's easy!}
    BEGIN
      {select read and write banks}
      SelectVESAReadBank(LongRec(Source).H);
      SelectVESAWriteBank(LongRec(Dest).H);
      {perform copy}
      _RawMoveForwards(VGASeg,LongRec(Source).L,
                       VGASeg,LongRec(Dest).L,
                       CopySize,BitBlit);
    END
    ELSE
    IF LongRec(Source).H = LongRec(Dest).H THEN {single mode, but in one bank!}
    BEGIN
      {select read and write bank}
      SelectVESABank(LongRec(Source).H);
      {perform copy}
      _RawMoveForwards(VGASeg,LongRec(Source).L,
                       VGASeg,LongRec(Dest).L,
                       CopySize,BitBlit);
    END
    ELSE {single mode, not one bank; use data buffer}
    BEGIN
      {when there are less bytes in the buffer then take that}
      IF CopySize > BufSize-1 THEN CopySize := BufSize-1;
      {select read bank}
      SelectVESABank(LongRec(Source).H);
      {perform read}
      _RawMoveForwards(VGASeg,LongRec(Source).L,
                       BufSeg,BufOfs,CopySize,CopyBlit);
      {select write bank}
      SelectVESABank(LongRec(Dest).H);
      {perform write}
      _RawMoveForwards(BufSeg,BufOfs,VGASeg,LongRec(Dest).L,CopySize,BitBlit);
    END;
    {update arguments}
    Inc(Source,CopySize+1);
    Inc(Dest,CopySize+1);
    Dec(Pixels,CopySize+1);
  END;
{always return to single mode}
  IF DualModeOn THEN SelectVESASingleMode;
END; {_RawCopyForward}


PROCEDURE _RawCopyBackward(Source,Dest,Pixels:LONGINT;BitBlit:BYTE);
{copy a certain amount of display memory from source to destination}
CONST BufSize = 1024;
VAR CopySize,BufSeg,BufOfs:WORD;
    DualModeOn            :BOOLEAN;
    Buffer                :ARRAY [0..BufSize-1] OF BYTE;
BEGIN
{get segment and offset of buffer}
  BufSeg := Seg(Buffer[BufSize-1]);
  BufOfs := Ofs(Buffer[BufSize-1]);
{move arguments to end of their copy space}
  Inc(Source,Pixels-1);
  Inc(Dest,Pixels-1);
{goto dual mode when possible}
  DualModeOn := SelectVESADualMode;
{loop until all pixels are transferred}
  WHILE Pixels > 0 DO
  BEGIN
    {number of bytes, till begin of source bank}
    CopySize := LongRec(Source).L;
    {when there are less bytes till begin of dest bank then take that}
    IF CopySize > LongRec(Dest).L THEN CopySize := LongRec(Dest).L;
    {when there are less bytes to copy then take that}
    IF CopySize > Pixels-1 THEN CopySize := Pixels-1;
    {select method according to mode and position of source and dest.}
    IF DualModeOn THEN  {we have dual mode; it's easy!}
    BEGIN
      {select read and write banks}
      SelectVESAReadBank(LongRec(Source).H);
      SelectVESAWriteBank(LongRec(Dest).H);
      {perform copy}
      _RawMoveBackwards(VGASeg,LongRec(Source).L,
                        VGASeg,LongRec(Dest).L,
                        CopySize,BitBlit);
    END
    ELSE
    IF LongRec(Source).H = LongRec(Dest).H THEN {single mode, but in one bank!}
    BEGIN
      {select read and write bank}
      SelectVESABank(LongRec(Source).H);
      {perform copy}
      _RawMoveBackwards(VGASeg,LongRec(Source).L,
                        VGASeg,LongRec(Dest).L,
                        CopySize,BitBlit);
    END
    ELSE  {single mode, not one bank; use data buffer}
    BEGIN
      {when there are less bytes in the buffer then take that}
      IF CopySize > BufSize-1 THEN CopySize := BufSize-1;
      {select read bank}
      SelectVESABank(LongRec(Source).H);
      {perform read}
      _RawMoveBackwards(VGASeg,LongRec(Source).L,
                        BufSeg,BufOfs,CopySize,CopyBlit);
      {select write bank}
      SelectVESABank(LongRec(Dest).H);
      {perform write}
      _RawMoveBackwards(BufSeg,BufOfs,VGASeg,LongRec(Dest).L,CopySize,BitBlit);
    END;
    {update arguments}
    Dec(Source,CopySize+1);
    Dec(Dest,CopySize+1);
    Dec(Pixels,CopySize+1);
  END;
{always return to single mode}
  IF DualModeOn THEN SelectVESASingleMode;
END; {_RawCopyBackward}


PROCEDURE _RawCopy(Source,Dest,Pixels:LONGINT;BitBlit:BYTE);
{copy a certain amount of display memory from source to
 destination, note that large areas can be copied in one go!}
BEGIN
{take special precausions not to overwrite source with dest.}
  IF Source < Dest THEN _RawCopyBackward(Source,Dest,Pixels,BitBlit)
                   ELSE _RawCopyForward(Source,Dest,Pixels,BitBlit);
END; {_RawCopy}


PROCEDURE CopyPage(SourcePageNr,DestPageNr,BitBlit:BYTE);
{copy a complete page, a fine way to make a snapshot}
VAR Source,Dest,Pixels:LONGINT;
BEGIN
{protect}
  IF NOT ExistingPage(SourcePageNr) THEN EXIT;
  IF NOT ExistingPage(DestPageNr) THEN EXIT;
  IF SourcePageNr = DestPageNr THEN EXIT;
{compute}
  Source := GetVESAAbsAddress(0,SourcePageNr*(VESAMaxY+1));
  Dest   := GetVESAAbsAddress(0,DestPageNr*(VESAMaxY+1));
  Pixels := LONGINT(GetScreenWidth)*GetScreenHeight;
{do it}
  _RawCopy(Source,Dest,Pixels,BitBlit);
END; {CopyPage}


PROCEDURE _RawCopyBox(SourceX,SourceY,DestX,DestY,W,H:INTEGER;BitBlit:BYTE);
{very adequate routine to copy a box of any size within the display memory}
VAR Source,Dest:LONGINT;
    Index      :WORD;
BEGIN
{compute source and destination address}
  Source := GetVESAAbsAddress(SourceX,SourceY);
  Dest   := GetVESAAbsAddress(DestX,DestY);
{take special precausions not to overwrite source with dest.}
  IF Source < Dest THEN
  BEGIN
    Inc(Source,LONGINT(H-1)*BytesPerLine);
    Inc(Dest,LONGINT(H-1)*BytesPerLine);
    FOR Index := H DOWNTO 1 DO
    BEGIN
       _RawCopyBackward(Source,Dest,W,BitBlit);
      Dec(Source,BytesPerLine);
      Dec(Dest,BytesPerLine);
    END
  END
  ELSE
  FOR Index := 1 TO H DO
  BEGIN
    _RawCopyForward(Source,Dest,W,BitBlit);
    Inc(Source,BytesPerLine);
    Inc(Dest,BytesPerLine);
  END;
END; {_RawCopyBox}


PROCEDURE CopyHugeBox(SourcePage,SourceX,SourceY,
                      DestPage,DestX,DestY,W,H:INTEGER;BitBlit:BYTE);
{copy a box of any size from source to destinations}
VAR X2,Y2:INTEGER;
BEGIN
{protect}
  ValidateGraphicsBox(SourceX,SourceY,W,H);
{correct destination for clippings that will happen on source}
  IF SourceX < 0 THEN
  BEGIN
    Dec(DestX,SourceX);
    Inc(W,SourceX);
    SourceX := 0;
  END;
  IF SourceY < 0 THEN
  BEGIN
    Dec(DestY,SourceY);
    Inc(H,SourceY);
    SourceY := 0;
  END;
{and also the other way around, no destination correction needed!}
  IF DestX < 0 THEN Dec(SourceX,DestX);
  IF DestY < 0 THEN Dec(SourceY,DestY);
{determine which area can actual be copied}
  SetActivePage(SourcePage);
  X2 := SourceX+W-1;
  Y2 := SourceY+H-1;
  IF NOT ViewPortBoxClipping(SourceX,SourceY,X2,Y2) THEN EXIT;
  W  := X2-SourceX+1;
  H  := Y2-SourceY+1;
{now determine where it can actually be copied to}
  SetActivePage(DestPage);
  X2 := DestX+W-1;
  Y2 := DestY+H-1;
  IF NOT ViewPortBoxClipping(DestX,DestY,X2,Y2) THEN EXIT;
{correct dimensions for any additional clippings}
  W   := X2-DestX+1;
  H   := Y2-DestY+1;
{and finally we perform the copy}
  _RawCopyBox(SourceX,SourceY,DestX,DestY,W,H,BitBlit);
END; {CopyHugeBox}


PROCEDURE CopyBox(SourceX,SourceY,DestX,DestY,W,H:INTEGER;BitBlit:BYTE);
{copy a box of any size from source to destinations}
BEGIN
  CopyHugeBox(GetActivePage,SourceX,SourceY,
              GetActivePage,DestX,DestY,W,H,BitBlit);
END; {CopyBox}


{*****************************************************
 **                                                 **
 **  image system                                   **
 **                                                 **
 *****************************************************}


PROCEDURE StampInImage(DestBitMap,SourceBitMap:POINTER;
                       OffsetX,OffsetY:INTEGER;BitBlit:BYTE);
{complex routine to stamp one image into another...,
 source and dest can have internal offsets!}
VAR DestIndex,SourceIndex,
    SourceOfsX,SourceOfsY:WORD;
    X,Y,W,H              :INTEGER;
    Data                 :BYTE;
BEGIN
{first of all we correct for bitmap offsets and
 try to find the part that can actually be stamped}
  WITH BitMapPtr(SourceBitMap)^ DO
  BEGIN
  {correct for offsets in source!}
    Inc(OffsetX,B_OffsetX);
    Inc(OffsetY,B_OffsetY);
  {get size}
    W := B_W;
    H := B_H;
  END;
{then we stamp it}
  WITH BitMapPtr(DestBitMap)^ DO
  BEGIN
  {correct for offsets in destination!}
    Dec(OffsetX,B_OffsetX);
    Dec(OffsetY,B_OffsetY);
  {correct for negative offsets}
    IF OffsetX < 0 THEN
    BEGIN
      SourceOfsX := -OffsetX;
      Dec(W,SourceOfsX);
      OffsetX    := 0;
    END
    ELSE SourceOfsX := 0;
    IF OffsetY < 0 THEN
    BEGIN
      SourceOfsY := -OffsetY;
      Dec(H,SourceOfsY);
      OffsetY    := 0;
    END
    ELSE SourceOfsY := 0;
  {correct for oversizing}
    IF OffsetX+W > B_W THEN W := B_W-OffsetX;
    IF OffsetY+H > B_H THEN H := B_H-OffsetY;
  {check size}
    IF (W <= 0) OR (H <= 0) THEN EXIT;
  {then we do the actual stamping}
    FOR Y := 0 TO H-1 DO
    BEGIN
      SourceIndex := WORD(SourceOfsY+Y)*BitMapPtr(SourceBitMap)^.B_W+SourceOfsX;
      DestIndex   := WORD(OffsetY+Y)*B_W+OffsetX;
      FOR X := 1 TO W DO
      BEGIN
        Data := BitMapPtr(SourceBitMap)^.B_Data[SourceIndex];
        CASE BitBlit OF
          SpriteBlit : IF Data <> 0 THEN B_Data[DestIndex] := Data;
          NormalBlit,
          CopyBlit   : B_Data[DestIndex] := Data;
          XORBlit    : B_Data[DestIndex] := B_Data[DestIndex] XOR Data;
          OrBlit     : B_Data[DestIndex] := B_Data[DestIndex] OR Data;
          AndBlit    : B_Data[DestIndex] := B_Data[DestIndex] AND Data;
          NotBlit    : B_Data[DestIndex] := NOT Data;
          XNORBlit   : B_Data[DestIndex] := B_Data[DestIndex] XOR NOT Data;
          NOrBlit    : B_Data[DestIndex] := B_Data[DestIndex] OR NOT Data;
          NAndBlit   : B_Data[DestIndex] := B_Data[DestIndex] AND NOT Data;
        END;
        Inc(DestIndex);
        Inc(SourceIndex);
      END;
    END;
  END;
END; {StampInImage}


PROCEDURE ExtractFromImage(DestBitMap,SourceBitMap:POINTER;
                           OffsetX,OffsetY,W,H:INTEGER);
{complex routine to extract an image from another,
 make sure that there an overlap between the two images
 and that there is enough memory space in destination!}
VAR DestIndex,SourceIndex,Y:WORD;
BEGIN
{correct for offsets in source!}
  WITH BitMapPtr(SourceBitMap)^ DO
  BEGIN
    Dec(OffsetX,B_OffsetX);
    Dec(OffsetY,B_OffsetY);
  END;
{correct for negative offsets}
  WITH BitMapPtr(DestBitMap)^ DO
  BEGIN
    IF OffsetX < 0 THEN
    BEGIN
      B_OffsetX := -OffsetX;
      OffsetX   := 0;
      Dec(W,B_OffsetX);
    END;
    IF OffsetY < 0 THEN
    BEGIN
      B_OffsetY := -OffsetY;
      OffsetY   := 0;
      Dec(H,B_OffsetY);
    END;
  END;
{correct for oversizing}
  WITH BitMapPtr(SourceBitMap)^ DO
  BEGIN
    IF OffsetX+W > B_W THEN W := B_W-OffsetX;
    IF OffsetY+H > B_H THEN H := B_H-OffsetY;
  END;
{start extraction}
  WITH BitMapPtr(DestBitMap)^ DO
  BEGIN
  {set new width and heigth}
    B_W := W;
    B_H := H;
  {now make sure we have something to extract!}
    IF (W <= 0) OR (H <= 0) THEN EXIT;
  {now copy that what needs to be copied}
    DestIndex := 0;
    FOR Y := 0 TO H-1 DO
    BEGIN
      SourceIndex := WORD(Y+OffsetY)*BitMapPtr(SourceBitMap)^.B_W+OffsetX;
      Move(BitMapPtr(SourceBitMap)^.B_Data[SourceIndex],
           B_Data[DestIndex],W);
      Inc(DestIndex,W);
    END;
  END;
END; {ExtractFromImage}


PROCEDURE _RawCopyToDisplay(Source:MemPtr;Pixels:WORD;
                            Dest:LONGINT;BitBlit:BYTE);
{copy some data (a line?) from memory to a certain display
 location, maximum size of source is of course 64Kb}
VAR Index,CopySize:WORD;
BEGIN
  Index := 0;
{loop until all pixels are transferred}
  WHILE Pixels > 0 DO
  BEGIN
    {number of bytes, minus one, till end of source}
    CopySize := Pixels-1;
    {when there are less bytes till end of dest bank then take that}
    IF CopySize > $FFFF-LongRec(Dest).L
    THEN CopySize := $FFFF-LongRec(Dest).L;
    {select write bank}
    SelectVESABank(LongRec(Dest).H);
    {perform write}
    _RawMoveForwards(Seg(Source^[Index]),Ofs(Source^[Index]),
                     VGASeg,LongRec(Dest).L,CopySize,BitBlit);
    {update arguments}
    Index  := Index+CopySize+1;
    Dest   := Dest+CopySize+1;
    Pixels := Pixels-CopySize-1;
  END;
END; {_RawCopyToDisplay}


PROCEDURE _RawCopyFromDisplay(Source:LONGINT;Pixels:WORD;Dest:MemPtr);
{copy a certain display location (a line?) to
 memory, maximum size of source is of course 64Kb}
VAR Index,CopySize:WORD;
BEGIN
  Index := 0;
{loop until all pixels are transferred}
  WHILE Pixels > 0 DO
  BEGIN
    {number of bytes, minus one, till end of source bank}
    CopySize := $FFFF-LongRec(Source).L;
    {when there are less bytes to copy then take that}
    IF CopySize > Pixels-1 THEN CopySize := Pixels-1;
    {select read bank}
    SelectVESABank(LongRec(Source).H);
    {perform read, note the 'CopyBlit'}
    _RawMoveForwards(VGASeg,LongRec(Source).L,
                     Seg(Dest^[Index]),Ofs(Dest^[Index]),
                     CopySize,CopyBlit);
    {update arguments}
    Source := Source+CopySize+1;
    Index  := Index+CopySize+1;
    Pixels := Pixels-CopySize-1;
  END;
END; {_RawCopyFromDisplay}


PROCEDURE GetImage(X1,Y1,X2,Y2:INTEGER;BitMap:POINTER);
{almost same as Borland's; but this one is clipped,
 note that you might not get what you expect; it can be smaller!
 still you have to make sure that there is enough memory out there!}
VAR Line :INTEGER;
    Index:WORD;
BEGIN
  WITH BitMapPtr(BitMap)^ DO
  BEGIN
    {test the size: if not correct then reset to zero,
     and protect againt aquiring a too large an image}
    IF B_MemSize < GetImageSize(X2-X1+1,Y2-Y1+1) THEN
    BEGIN
      B_W := 0;
      B_H := 0;
      EXIT;
    END;
    {clip}
    BoxInOrder(X1,Y1,X2,Y2);
    {set internal offsets}
    IF X1 < 0 THEN B_OffsetX := -X1 ELSE B_OffsetX := 0;
    IF Y1 < 0 THEN B_OffsetY := -Y1 ELSE B_OffsetY := 0;
    {perform necessary clipping}
    IF ViewPortBoxClipping(X1,Y1,X2,Y2) THEN
    BEGIN
      {set dimensions}
      B_W   := X2-X1+1;
      B_H   := Y2-Y1+1;
      {read the display memory}
      Index := 0;
      FOR Line := Y1 TO Y2 DO
      BEGIN
        {read one line of display data}
        _RawCopyFromDisplay(GetVESAAbsAddress(X1,Line),B_W,@B_Data[Index]);
        {update index in data}
        Inc(Index,B_W);
      END;
    END
    ELSE {we could not get any part of that box!}
    BEGIN
      B_OffsetX := 0;
      B_OffsetY := 0;
      B_W       := 0;
      B_H       := 0;
    END;
  END;
END; {GetImage}


PROCEDURE PutImage(X,Y:INTEGER;BitMap:POINTER;BitBlit:BYTE);
{almost same as Borland's; but this one is clipped}
VAR Line,X1,Y1,X2,Y2:INTEGER;
    Index,LineSize  :WORD;
BEGIN
  WITH BitMapPtr(BitMap)^ DO
{test whether we have some data}
  IF (B_W > 0) AND (B_H > 0) THEN {yes, we do...}
  BEGIN
    {incorporate offsets}
    Inc(X,B_OffsetX);
    Inc(Y,B_OffsetY);
    {create the box coordinates}
    X1 := X;
    Y1 := Y;
    X2 := X1+B_W-1;
    Y2 := Y1+B_H-1;
    {perform necessary clipping}
    IF ViewPortBoxClipping(X1,Y1,X2,Y2) THEN {it can be (partly) drawn}
    BEGIN
      {compute size of one line}
      LineSize := X2-X1+1;
      {compute start of index in data}
      Index := 0;
      IF Y < ViewPortTop  THEN Inc(Index,(Y1-(ViewPortTop+Y))*B_W);
      IF X < ViewPortLeft THEN Inc(Index,X1-(ViewPortLeft+X));
      {do only the lines we need to do}
      FOR Line := Y1 TO Y2 DO
      BEGIN
        {write one line of display data}
        _RawCopyToDisplay(@B_Data[Index],LineSize,
                          GetVESAAbsAddress(X1,Line),BitBlit);
        {update index in data}
        Inc(Index,B_W);
      END;
    END;
  END;
END; {PutImage}


FUNCTION GetImageSize(W,H:INTEGER):LONGINT;
{returns the size in bytes of such an image}
VAR Size:LONGINT;
BEGIN
  Size := LONGINT(W)*LONGINT(H)+10;
{ingenius routine to get what we want!}
  Dec(Size);
  Size := Size OR $0F;
  Inc(Size);
{test and protect}
  IF Size > $FFFF THEN Size := 0;
{return}
  GetImageSize := Size;
END; {GetImageSize}


FUNCTION AllocAndGetImage(X,Y,W,H:INTEGER):POINTER;
{get a pointer to an image stored somewhere in memory}
VAR ImageSize:WORD;
    Image    :BitMapPtr;
BEGIN
{protect}
  ValidateGraphicsBox(X,Y,W,H);
{box size}
  ImageSize := GetImageSize(W,H);
{allocate the memory}
  GetMem(Image,ImageSize);
  WITH Image^ DO
  BEGIN
    B_MemSize := ImageSize;
    B_W       := W;         {set these, in case no image is aquired}
    B_H       := H;
  END;
{get the image}
  IF (W > 0) AND (H > 0) THEN GetImage(X,Y,X+W-1,Y+H-1,Image);
{return}
  AllocAndGetImage := Image;
END; {AllocAndGetImage}


PROCEDURE PutAndForgetImage(VAR BitMap:POINTER;X,Y:INTEGER;BitBlit:BYTE);
{put an image that was stored somewhere in memory on screen,
 only use this routine for images that were aquired with the
 'AllocAndGetImage' routine!}
BEGIN
{put the image}
  PutImage(X,Y,BitMap,BitBlit);
{forget the box}
  ForgetImage(BitMap);
END; {PutAndForgetImage}


FUNCTION AllocImage(W,H:INTEGER):POINTER;
{get a pointer to an bitmap somewhere in memory}
VAR ImageSize:WORD;
    Image    :BitMapPtr;
BEGIN
{box size}
  ImageSize := GetImageSize(W,H);
{allocate the memory}
  GetMem(Image,ImageSize);
  FillChar(Image^,ImageSize,0);
  WITH Image^ DO
  BEGIN
    B_MemSize := ImageSize;
    B_W       := W;
    B_H       := H;
  END;
{return}
  AllocImage := Image;
END; {AllocImage}


PROCEDURE ForgetImage(VAR BitMap:POINTER);
{forget this image, only use this routine for images
 that were aquired with the 'AllocAndGetImage' routine!}
VAR ImageSize:WORD;
BEGIN
{protect}
  IF BitMap <> NIL THEN
  WITH BitMapPtr(BitMap)^ DO
  BEGIN
    {forget}
    ForgetMem(BitMap,B_MemSize);
  END;
END; {ForgetImage}


{*****************************************************
 **                                                 **
 **  bitmap fonts                                   **
 **                                                 **
 *****************************************************}


FUNCTION GetRAMFontHeight(FontNr:BYTE):BYTE;
{return the height of the given RAM font}
VAR Height:INTEGER;
BEGIN
  IF (FontNr < 1) OR (FontNr > 61) THEN FontNr := 1;
  CASE FontNr OF
    15                 : Height := 6;
    16                 : Height := 7;
     2, 17, 58, 61     : Height := 8;
     9, 18             : Height := 9;
     3, 13, 22, 54     : Height := 10;
     8, 10, 14         : Height := 11;
     7                 : Height := 12;
     6                 : Height := 13;
     1, 30, 38, 45, 50 : Height := 16;
    ELSE Height := 14;
  END;
  GetRAMFontHeight := Height;
END; {GetRAMFontHeight}


PROCEDURE _LoadRAMFont(FontNr:BYTE);
{load a new font type; the [bitmaps.fnt] file contains
 the seperate sets of font bitmaps at each 5126 bytes}
VAR FilePtr:FILE;
    Header :ARRAY[1..6] OF BYTE;
BEGIN
{open font file; no checking is build-in create one yourself!}
  Assign(FilePtr,'BITMAPS.FNT');
  Reset(FilePtr,1);
{goto position where the bitmap is stored}
  Seek(FilePtr,LONGINT(5126)*(FontNr-1));
{read header, no checking!}
  BlockRead(FilePtr,Header,6);
{set new height}
  FontHeight := Header[5];
{allocate heap space for font data}
  GetMem(FontDataPtr,FontHeight SHL 8);
{read font data}
  BlockRead(FilePtr,FontDataPtr^,FontHeight SHL 8);
{close font file}
  Close(FilePtr);
END; {_LoadRAMFont}


PROCEDURE _AllocFontCopy(VAR DestPtr,SourcePtr:POINTER;Height:WORD);
{allocate a copy of the given source}
BEGIN
{allocate heap space for font data}
  GetMem(DestPtr,Height SHL 8);
{copy source into destination}
  Move(SourcePtr^,DestPtr^,Height SHL 8);
END; {_AllocFontCopy}


PROCEDURE StopRAMFonts;
{simply free the memory and reset number}
BEGIN
{protect}
  IF RAMFontsOn THEN
  BEGIN
    {free heap space for font data}
    ForgetMem(FontDataPtr,FontHeight SHL 8);
    {free heap space for font bitmap}
    ForgetMem(FontBitMap,5200);
    {reset number}
    CurrentFontNr := 0;
    {say so}
    RAMFontsOn    := FALSE;
  END;
END; {StopRAMFonts}


PROCEDURE LoadRAMFont(FontNr:BYTE);
{load a new font type; the [bitmaps.fnt] file contains
 the seperate sets of font bitmaps at each 5126 bytes}
BEGIN
{protect}
  IF FontNr < 1  THEN FontNr := 1;
  IF FontNr > 61 THEN FontNr := 61;
{make sure we don't load the same twice!}
  IF FontNr = CurrentFontNr THEN EXIT;
{forget previous font}
  StopRAMFonts;
{load it!}
  _LoadRAMFont(FontNr);
{allocate heap space for font bitmap}
  GetMem(FontBitMap,5200);
  FillChar(FontBitMap^,5200,0);
{say it is on}
  RAMFontsOn := TRUE;
{set font nr}
  CurrentFontNr := FontNr;
END; {LoadRAMFont}


FUNCTION _GetPattern(Ch:CHAR;RowNr:BYTE):BYTE;
{returns the requested pattern of the bitmap character}
BEGIN
  CASE FontHeight OF
  {mostly we will be using 16 or 8}
    16 : _GetPattern := RAM8x16FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
     8 : _GetPattern := RAM8x8FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
    14 : _GetPattern := RAM8x14FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
    13 : _GetPattern := RAM8x13FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
    12 : _GetPattern := RAM8x12FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
    11 : _GetPattern := RAM8x11FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
    10 : _GetPattern := RAM8x10FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
     9 : _GetPattern := RAM8x9FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
     7 : _GetPattern := RAM8x7FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
     6 : _GetPattern := RAM8x6FontPtr(FontDataPtr)^[BYTE(Ch),RowNr];
  END;
END; {_GetPattern}


PROCEDURE _UpdatePropInfo(FontNr:BYTE);
{update the proportional information}
VAR RowNr,B1,B2,
    Left,Right  :BYTE;
    Ch          :CHAR;
BEGIN
  FOR Ch := #0 TO #255 DO
  BEGIN
    {scan the character and press it into one byte}
    B1 := 0;
    FOR RowNr := 0 TO FontHeight-1 DO B1 := B1 OR _GetPattern(Ch,RowNr);
    {determine open space in front of character}
    Left := 0;
    B2   := B1;
    WHILE (B2 AND $80 = $00) AND (Left < 8) DO
    BEGIN
      B2 := B2 SHL 1;
      Inc(Left);
    END;
    {correct for spaces}
    IF Left > 7 THEN Left := 1;
    {determine open space after character}
    Right := 0;
    B2    := B1;
    WHILE (B2 AND $01 = $00) AND (Right < 8) DO
    BEGIN
      B2 := B2 SHR 1;
      Inc(Right);
    END;
    {correct for spaces}
    IF Right > 7 THEN Right := 1;
    {try to keep one pixel in front}
    IF Right > 0 THEN Dec(Right);
    {set the prop info}
    PropInfo[Ch] := (Left SHL 4)+(8-Left-Right);
  END;
END; {_UpdatePropInfo}


FUNCTION GetTextWidth(S:PCHAR;Proportional:BOOLEAN;FontNr:BYTE):INTEGER;
{returns the actual width of this text with the given settings}
VAR Index,Width:WORD;
BEGIN
{make sure we loaded the right font!}
  IF FontNr <> CurrentFontNr THEN LoadRAMFont(FontNr);
{now we compute it}
  IF Proportional THEN
  BEGIN
  {make sure we have updated the proportional information for this font}
    IF FontNr <> CurrentPropNr THEN _UpdatePropInfo(FontNr);
  {walk through all the individual characters and summ their width}
    Width := 0;
    FOR Index := 0 TO StrLen(S)-1 DO Inc(Width,PropInfo[S[Index]] AND $0F);
  END
  ELSE Width := 8*StrLen(S); {non-proportional}
{return that}
  GetTextWidth := Width;
END; {GetTextWidth}


PROCEDURE PutText(X,Y:INTEGER;S:PCHAR;Proportional:BOOLEAN;
                  FontNr,TextColor,BackColor,BitBlit:BYTE);
{same routine as 'PutText' but now it is proportional!}
VAR ViewPort               :ViewPortType;
    Len,ShortLen,Index,ChNr:WORD;
    PropStart,PropLength,
    Pattern,ColumnNr,RowNr :BYTE;
    Ch                     :CHAR;
    LocalStr               :ARRAY [0..191] OF CHAR;
    ShortStr               :ARRAY [0..47] OF CHAR;
BEGIN
{make sure we loaded the right font!}
  IF FontNr <> CurrentFontNr THEN LoadRAMFont(FontNr);
{make sure we have updated the proportional information for this font}
  IF Proportional AND (FontNr <> CurrentPropNr) THEN _UpdatePropInfo(FontNr);
{use it}
  WITH ViewPort, FontBitMap^ DO
  BEGIN
    {get current view port}
    GetViewSettings(ViewPort);
    {only show string when it is vertically in the view}
    IF (-Y >= FontHeight) OR (Y > V_Y2-V_Y1) THEN EXIT;
    {get the length of the string}
    Len := StrLen(S);
    {only show string when it is horizontally in the view}
    IF (Len = 0) OR (-X >= Len SHL 3) OR (X > V_X2-V_X1) THEN EXIT;
    {cut off any horizontal characters that are not visible}
    IF X < -7 THEN {cut-off left}
    BEGIN
      Index := -X SHR 3;                       {amount}
      StrMove(LocalStr,@S[Index],Len-Index+1); {and #0 at end}
      Dec(Len,Index);                          {new length}
      Inc(X,Index SHL 3);                      {new position}
    END
    ELSE StrLCopy(LocalStr,S,191);             {also copy to local}
    IF NOT Proportional THEN
    BEGIN
      Index := (V_X2-V_X1-X+8) SHR 3;          {were the #0 should be}
      IF Index <= Len THEN {cut-off right}
      BEGIN
        LocalStr[Index] := #0;                 {put an #0}
        Len             := Index;              {reduce length}
      END;
      {default values for non-proportional font!}
      PropStart  := $80;
      PropLength := 8;
    END;
    {only fourty characters fit the memory buffer...}
    REPEAT
      {get maximal 40 characters to print in each loop}
      IF Len > 40 THEN
      BEGIN
        StrEat(ShortStr,LocalStr,40,47);
        ShortLen := 40;
      END
      ELSE
      BEGIN
        StrLCopy(ShortStr,LocalStr,47);
        ShortLen := Len;
      END;
      {now stamp the string into the image}
      Index       := 0;
      FOR RowNr := 0 TO FontHeight-1 DO
      FOR ChNr := 0 TO ShortLen-1 DO
      BEGIN
        {get the character}
        Ch := ShortStr[ChNr];
        {get the bit pattern for this row}
        Pattern := _GetPattern(Ch,RowNr);
        {see where we should start and how long it is}
        IF Proportional THEN
        BEGIN
          PropStart  := $80 SHR (PropInfo[Ch] SHR 4);
          PropLength := PropInfo[Ch] AND $0F;
        END;
        {stamp the seperate pixels into the image (optimized!)}
        ASM
          MOV   AL, Pattern         {get pattern in AL}
          MOV   AH, PropStart       {to compare with AL}
          MOV   BL, TextColor       {get text color}
          MOV   BH, BackColor       {get back color}
          XOR   CH, CH
          MOV   CL, PropLength      {count of loop is ?}
          MOV   DX, Index           {get index into DX}
          LES   DI, FontBitMap      {Font BitMap address in ES:DI}
          ADD   DI, 10              {default offset of data is 10}
          ADD   DI, DX              {goto current point in data}
          ADD   DX, CX              {do ? steps forward}
          MOV   Index, DX           {and store that in index}
        @Repeat:
          TEST  AL, AH              {see if text or back color is used}
          JZ   @Back                {we should do background}
          MOV  [ES:DI], BL          {stamp text color}
          ROL   AL, 1               {rol AL}
          INC   DI                  {next byte in bitmap}
          LOOP @Repeat              {reloop}
          JMP  @Finish
        @Back:
          MOV  [ES:DI], BH          {stamp back color}
          ROL   AL, 1               {rol AL}
          INC   DI                  {next byte in bitmap}
          LOOP @Repeat              {reloop}
        @Finish:
        END;
      END;
      {set the dimensions of the bitmap we have filled}
      B_W := Index DIV FontHeight;
      B_H := FontHeight;
      {now the image is complete we can simple put it on display}
      PutImage(X,Y,FontBitMap,BitBlit);
      {next short string}
      Dec(Len,ShortLen);
      Inc(X,B_W);
    UNTIL Len < 1;
  END;
END; {PutPropText}


{*****************************************************
 **                                                 **
 **  PCX image files                                **
 **                                                 **
 *****************************************************}


FUNCTION _256ColorPCX(Header:PCXHeaderPtr):BOOLEAN;
{is this a 256 color PCX?}
BEGIN
  WITH Header^ DO _256ColorPCX := (H_BitsPerPixel = 8) AND (H_NPlanes = 1);
END; {_256ColorPCX}


FUNCTION _ReadHeader(Header:PCXHeaderPtr;FileName:PCHAR):BOOLEAN;
{read header and return succes}
VAR FilePtr:FILE;
BEGIN
{start pessimistic}
  _ReadHeader := FALSE;
{open file; again checking is missing completely!}
  Assign(FilePtr,FileName);
  Reset(FilePtr,1);
{check file size}
  IF FileSize(FilePtr) < 128 THEN
  BEGIN
    Close(FilePtr);
    EXIT;
  END;
{read header for some extra checks}
  BlockRead(FilePtr,Header^,128);
{close file}
  Close(FilePtr);
{that's all}
  _ReadHeader := TRUE;
END; {_ReadHeader}


FUNCTION _ValidPCXImage(Header:PCXHeaderPtr;FileName:PCHAR):BOOLEAN;
{is this a valid PCX file}
BEGIN
{start reading header}
  _ValidPCXImage := FALSE;
  IF NOT _ReadHeader(Header,FileName) THEN EXIT;
{perform the stringent tests}
  WITH Header^ DO
  BEGIN
    {manufacturer should be ZSoft}
    IF H_Manufacturer <> 10 THEN EXIT;
    {only the latest version!}
    IF H_Version <> 5 THEN EXIT;
    {encoding should be run-length}
    IF H_Encoding <> 1 THEN EXIT;
    {test for eight bits per pixel in one plane or
          for one bit per pixel in four planes}
    IF NOT _256ColorPCX(Header) THEN EXIT;
  END;
{all is well}
  _ValidPCXImage := TRUE;
END; {_ValidPCXImage}


FUNCTION ValidPCXImage(FileName:PCHAR):BOOLEAN;
{is this a valid PCX file}
VAR Header:PCXHeaderType;
BEGIN
  ValidPCXImage := _ValidPCXImage(@Header,FileName);
END; {ValidPCXImage}


PROCEDURE GetPCXImageSize(FileName:PCHAR;VAR W,H:INTEGER);
{get the size of the given image}
VAR Header:PCXHeaderType;
BEGIN
  WITH Header DO
  BEGIN
    {protect and read the header}
    IF NOT _ValidPCXImage(@Header,FileName) THEN
    BEGIN
      W := 0;
      H := 0;
      EXIT;
    END;
    {return sizes}
    WITH Header DO
    BEGIN
      W := H_MaxX-H_MinX+1;
      H := H_MaxY-H_MinY+1;
    END;
  END;
END; {GetPCXImageSize}


FUNCTION _ReadByte(VAR FilePtr:FILE):BYTE;
{read a byte from the PCX file}
VAR Size:LONGINT;
BEGIN
  {read a new block when needed}
  IF BufferIndex >= 8000 THEN
  BEGIN
    Size        := FileSize(FilePtr)-FilePos(FilePtr);
    IF Size < 0 THEN Size := 0
                ELSE IF Size > 8000 THEN Size := 8000;
    BlockRead(FilePtr,Buffer^,Size);
    BufferIndex := 0;
  END;
  _ReadByte := Buffer^[BufferIndex];
  Inc(BufferIndex);
END; {_ReadByte}


FUNCTION _FindSystemColor(Color:RGBColor):BYTE;
{find the best fitting system color for this given PCX color}
VAR Nr,BestNr    :BYTE;
    Diff,BestDiff:WORD;
BEGIN
{first get the current palette}
  GetFullPalette(CurrentPalette);
{start with black}
  BestNr   := 0;
  BestDiff := GetColorDifference(CurrentPalette[0],Color);
  FOR Nr := 1 TO 15 DO
  BEGIN
    Diff := GetColorDifference(CurrentPalette[Nr],Color);
    IF Diff < BestDiff THEN
    BEGIN
      BestNr   := Nr;
      BestDiff := Diff;
    END;
  END;
  _FindSystemColor := BestNr;
END; {_FindSystemColor}


PROCEDURE _OptimizeColors(VAR FilePtr:FILE;
                          VAR ColorList:ColorListType;
                          NewPal,ReFreshPal,AdaptHighColors,FixateBlack:BOOLEAN);
{optimize the 256 color palette with the given settings}
VAR AssignedZero,
    BestDiff,Diff :INTEGER;
    Palette       :PaletteType;
    Nr1,Nr2,BestNr:BYTE;
BEGIN
  {goto palette data}
  Seek(FilePtr,FileSize(FilePtr)-769);
  {read palette flag and...}
  BlockRead(FilePtr,Nr1,1);
  {test its value}
  IF Nr1 = $0C THEN {it was valid}
  BEGIN
    {read it}
    BlockRead(FilePtr,Palette,SizeOf(PaletteType));
    {we need to adapt the pcx colors?}
    IF NewPal
    THEN SetFullPalette(Palette)
    ELSE GetOptimalColors(ColorList,Palette,AdaptHighColors,FixateBlack);
    {and after all this has taken place we can refresh the palette}
    IF RefreshPal THEN RefreshPalette(TRUE);
  END;
END; {_OptimizeColors}


PROCEDURE LoadPCXImageXY(FileName:PCHAR;
                         X,Y:INTEGER;BitBlit:WORD;
                         NewPal,ReFreshPal,AdaptHighColors:BOOLEAN);
{read a pcx image from a file and put is on screen,
 the most complex job here is the selection of colors}
VAR Header    :PCXHeaderType;
    FilePtr   :FILE;
    B1,B2     :BYTE;
    ColorList :ColorListType;
    MaxY,W,H  :INTEGER;
BEGIN
  WITH Header DO
  BEGIN
    {read header}
    IF NOT _ValidPCXImage(@Header,FileName) THEN EXIT;
    {get size}
    GetPCXImageSize(FileName,W,H);
    {open file}
    Assign(FilePtr,FileName);
    Reset(FilePtr,1);
    {get those colors right!}
    _OptimizeColors(FilePtr,ColorList,NewPal,
                    ReFreshPal,AdaptHighColors,BitBlit = SpriteBlit);
    {go back to start of PCX data}
    Seek(FilePtr,SizeOf(PCXHeaderType));
    {buffers to decode all scan lines}
    GetMem(BitMap,W+16);
    GetMem(Buffer,8000);
    BufferIndex := 8000;
    WITH BitMap^ DO
    BEGIN
      {first set up the contence of the bitmap}
      B_OffsetX := 0;
      B_OffsetY := 0;
      B_W       := W;
      B_H       := 1;
      {find bottom}
      MaxY := Y+H-1;
      IF MaxY >= ViewPortHeight THEN MaxY := ViewPortHeight-1;
      {do all scan lines until bottom}
      FOR ScanLine := Y TO MaxY DO
      BEGIN
        {reset buffer index}
        ScanIndex := 0;
        REPEAT
          {read a byte}
          B1 := _ReadByte(FilePtr);
          {does it have two high bits?}
          IF B1 AND $C0 = $C0 THEN {yes!}
          BEGIN
            {compute count}
            B1 := B1 AND $3F;
            {read repeated byte and repeat...}
            FillChar(B_Data[ScanIndex],B1,_ReadByte(FilePtr));
            {count them}
            Inc(ScanIndex,B1);
          END
          ELSE {no!}
          BEGIN
            B_Data[ScanIndex] := B1;
            Inc(ScanIndex);
          END;
        UNTIL ScanIndex >= H_BytesPerLine;
        {do we need to adapt the pcx colors?}
        IF NOT NewPal THEN
        FOR ScanIndex := 0 TO H_BytesPerLine-1 DO
        BEGIN
          {use the modified color numbers}
          B_Data[ScanIndex] := ColorList[B_Data[ScanIndex]];
        END;
        {and then put the image}
        PutImage(X,ScanLine,BitMap,BitBlit);
      END;
    END;
    {forget buffers}
    ForgetMem(BitMap,W+16);
    ForgetMem(Buffer,8000);
    {close file}
    Close(FilePtr);
  END;
END; {LoadPCXImageXY}


FUNCTION GetPCXImage(FileName:PCHAR;
                     AdaptHighColors,FixateBlack:BOOLEAN):POINTER;
{read a pcx image from a file and put it in a bitmap,
 the most complex job here is the selection of colors}
VAR Header    :PCXHeaderType;
    FilePtr   :FILE;
    B1,B2     :BYTE;
    ColorList :ColorListType;
    W,H       :INTEGER;
    Index     :WORD;
BEGIN
  GetPCXImage := NIL;
  WITH Header DO
  BEGIN
    {read header}
    IF NOT _ValidPCXImage(@Header,FileName) THEN EXIT;
    {get size and check it}
    GetPCXImageSize(FileName,W,H);
    IF GetImageSize(W,H) > $FFFF THEN EXIT;
    {open file}
    Assign(FilePtr,FileName);
    Reset(FilePtr,1);
    {get those colors right!}
    _OptimizeColors(FilePtr,ColorList,FALSE,FALSE,AdaptHighColors,FixateBlack);
    {go back to start of PCX data}
    Seek(FilePtr,SizeOf(PCXHeaderType));
    {buffers to decode all scan lines}
    BitMap := AllocImage(H_BytesPerLine,H);
    GetMem(Buffer,8000);
    BufferIndex := 8000;
    Index       := 0;
    WITH BitMap^ DO
    BEGIN
      {note that we used bytes per line to allocate it,
       these values do not always correspond...!}
      B_W := W;
      {decode and adapt colors all at once}
      FOR ScanLine := 0 TO H-1 DO
      BEGIN
        {reset buffer index}
        ScanIndex := 0;
        Index     := ScanLine*W;
        REPEAT
          {read a byte}
          B1 := _ReadByte(FilePtr);
          {does it have two high bits?}
          IF B1 AND $C0 = $C0 THEN {yes!}
          BEGIN
            {compute count}
            B1 := B1 AND $3F;
            {read repeated byte and repeat...}
            FillChar(B_Data[Index],B1,ColorList[_ReadByte(FilePtr)]);
            {count them}
            Inc(ScanIndex,B1);
            Inc(Index,B1);
          END
          ELSE {no!}
          BEGIN
            B_Data[Index] := ColorList[B1];
            Inc(ScanIndex);
            Inc(Index);
          END;
        UNTIL ScanIndex >= H_BytesPerLine;
      END;
    END;
    {forget buffer}
    ForgetMem(Buffer,8000);
    {close file}
    Close(FilePtr);
  END;
{return}
  GetPCXImage := BitMap;
END; {GetPCXImage}


PROCEDURE LoadPCXImage(FileName:PCHAR;BitBlit:WORD;
                       NewPal,RefreshPal,AdaptHighColors:BOOLEAN);
{read a pcx image from a file and put is on screen}
VAR Header:PCXHeaderType;
BEGIN
  WITH Header DO
  BEGIN
    {read header}
    IF NOT _ValidPCXImage(@Header,FileName) THEN EXIT;
    {really load it here!}
    LoadPCXImageXY(FileName,H_MinX,H_MinY,BitBlit,
                   NewPal,RefreshPal,AdaptHighColors);
  END;
END; {LoadPCXImage}


PROCEDURE _WriteByte(VAR FilePtr:FILE;B:BYTE);
{write a byte to the PCX file}
BEGIN
  {write a new block when needed}
  IF BufferIndex >= 8000 THEN
  BEGIN
    BlockWrite(FilePtr,Buffer,8000);
    BufferIndex := 0;
  END;
  Buffer^[BufferIndex] := B;
  Inc(BufferIndex);
END; {_WriteByte}


PROCEDURE SavePCXImageXYWH(FileName:PCHAR;X,Y,W,H:INTEGER);
{get a portion of the screen and save it as a PCX file}
VAR Header     :PCXHeaderType;
    FilePtr    :FILE;
    B,Count    :BYTE;
    X1,Y1,X2,Y2:INTEGER;
BEGIN
  {protect}
  ValidateGraphicsBox(X,Y,W,H);
  {peform pre-clipping so we can write the header correctly!}
  X1 := X;
  Y1 := Y;
  X2 := X+W-1;
  Y2 := Y+H-1;
  IF NOT ViewPortBoxClipping(X1,Y1,X2,Y2) THEN EXIT;
  Dec(X1,ViewPortLeft);
  Dec(Y1,ViewPortTop);
  Dec(X2,ViewPortLeft);
  Dec(Y2,ViewPortTop);
  W := X2-X1+1;
  H := Y2-Y1+1;
  {get buffer for writing}
  BitMap := AllocImage(W,1);
  GetMem(Buffer,8000);
  BufferIndex := 0;
  {set default header}
  Header := DefaultHeader;
  WITH Header, BitMap^ DO
  BEGIN
    {fill header}
    H_MinX         := X1;
    H_MinY         := Y1;
    H_MaxX         := X2;
    H_MaxY         := Y2;
    H_BytesPerLine := W;
    H_Width        := W;
    H_Height       := H;
    {open file}
    Assign(FilePtr,FileName);
    Rewrite(FilePtr,1);
    {write header}
    BlockWrite(FilePtr,Header,128);
    {encode all scan lines}
    FOR ScanLine := H_MinY TO H_MaxY DO
    BEGIN
      {get one line of the image}
      GetImage(H_MinX,ScanLine,H_MaxX,ScanLine,BitMap);
      {and compress it into the file}
      ScanIndex := 0;
      WHILE ScanIndex < W DO
      BEGIN
        {reset repeat counter}
        Count := 1;
        {get a byte}
        B     := B_Data[ScanIndex];
        {and count it}
        Inc(ScanIndex);
        {chech repetitions}
        WHILE (ScanIndex < W) AND
              (Count < 63) AND
              (B = B_Data[ScanIndex]) DO
        BEGIN
          Inc(ScanIndex);
          Inc(Count);
        END;
        {when required; write counter into file}
        IF (Count > 1) OR (B AND $C0 = $C0) THEN
        BEGIN
          _WriteByte(FilePtr,$C0 OR Count);   {write full count}
        END;
        {finally write the byte itselve}
        _WriteByte(FilePtr,B);
      END;
    END;
    {already write the flag for the 256 color palette}
    _WriteByte(FilePtr,$0C);
    {flush buffer}
    BlockWrite(FilePtr,Buffer^,BufferIndex);
    {forget buffer}
    ForgetImage(POINTER(BitMap));
    ForgetMem(Buffer,8000);
    {and then write the 256 color palette}
    BlockWrite(FilePtr,CurrentPalette,SizeOf(PaletteType));
    {close file}
    Close(FilePtr);
  END;
END; {SavePCXImageXYWH}


PROCEDURE SavePCXImage(Path:PCHAR);
{get the screen and save it as a PCX file}
VAR ViewPortBuffer:ViewPortType;
BEGIN
{disable view port}
  GetViewSettings(ViewPortBuffer);
  UnClipGraphics;
{save}
  SavePCXImageXYWH(Path,0,0,GetScreenWidth,GetScreenHeight);
{reset view port}
  SetViewSettings(ViewPortBuffer);
END; {SavePCXImage}


{**********************************************************************
 **********************************************************************
 *****                                                            *****
 *****  SUPPORT FUNCTIONS                                         *****
 *****                                                            *****
 **********************************************************************
 **********************************************************************}

FUNCTION _HasFlag(Flags,Flag:WORD):BOOLEAN;
{checks for the flag in flags}
BEGIN
  _HasFlag := (Flags AND Flag) <> 0;
END; {_HasFlag}


PROCEDURE _ClrRegs;
{simply clear the global register type
 always do this before using it in a interrupt call}
BEGIN
  FillChar(Regs,SizeOf(Regs),#0);
END; {_ClrRegs}


{**********************************************************************
 **********************************************************************
 *****                                                            *****
 *****  INTERNAL MOUSE ROUTINES                                   *****
 *****                                                            *****
 **********************************************************************
 **********************************************************************}


PROCEDURE _SetMouseData(DataCX,DataDX:WORD);
{set (x,y) in registers}
BEGIN
  WITH Regs DO
  BEGIN
    CX := DataCX;
    DX := DataDX;
  END;
END; {_SetMouseData}


PROCEDURE _GetMouseData(VAR DataCX,DataDX:WORD);
{get (x,y) from registers}
BEGIN
  WITH Regs DO
  BEGIN
    DataCX := CX;
    DataDX := DX;
  END;
END; {_GetMouseData}


PROCEDURE _SetMousePointer(P:POINTER);
{set a pointer in the registers}
BEGIN
  WITH Regs DO
  BEGIN
    DX := Ofs(P^);
    ES := Seg(P^);
  END;
END; {_SetMouseData}


PROCEDURE _CallMouse(Command:WORD);
{set a call to mouse driver}
BEGIN
  Regs.AX := Command;
  Intr(MOUSE_INT,Regs);
END; {_CallMouse}


{**********************************************************************
 **********************************************************************
 *****                                                            *****
 *****  MOUSE ROUTINES                                            *****
 *****                                                            *****
 **********************************************************************
 **********************************************************************}


PROCEDURE MouseInterruptRoutine; FAR; ASSEMBLER;
{this is our mouse interrupt routine; reacting to mouse movement,
 and displaying the cursor when needed you should put this routine
 in a seperate unit when you plan to overlay this unit!}
ASM
  PUSH  DS
  MOV   AX, SEG @DATA
  MOV   DS, AX
  MOV   AL, MouseOldSet
  TEST  AL, AL
  JZ   @NotSet
  SUB   SI, MouseOldDX
  SUB   DI, MouseOldDY
  STI
  MOV   MouseNewDX, SI
  MOV   MouseNewDY, DI
  MOV   MouseMoved, TRUE
  MOV   MouseUsed,  TRUE
  JMP  @Finish
 @NotSet:
  MOV  MouseOldDX, SI
  MOV  MouseOldDY, DI
  MOV  MouseOldSet, TRUE
 @Finish:
  POP   DS
END; {MouseInterruptRoutine}



FUNCTION MouseDriverInstalled:BOOLEAN;
{this routine can detect whether a mouse driver is loaded}
CONST IRET = $CF;
VAR Int33Vec:POINTER;
BEGIN
  MouseDriverInstalled := FALSE;
  GetIntVec(MOUSE_INT,Int33Vec);
  IF (Byte(Int33Vec^) <> IRET) AND (Int33Vec <> NIL) THEN
  WITH Regs DO
  BEGIN
    {reset driver and read status}
    _ClrRegs;
    _CallMouse(RESET_MOUSE);
    MouseDriverInstalled := (AX = $FFFF);
  END;
END; {MouseDriverInstalled}


PROCEDURE GetMouseInfo(VAR MouseType,IRQNr:WORD);
{ returns the mouse type, and the IRQ number of
  the interrupt used by the mouse adapter.
  MouseType: 1 = bus mouse, 2 = serial mouse
  3 = InPort mouse, 4 = PS/2 mouse, 5 = HP mouse
  IRQ number: 0 = PS/2, 2, 3, 4, 5, or 7 = IRQ number}
BEGIN
  WITH Regs DO
  BEGIN
    _ClrRegs;
    _CallMouse(INFO_MOUSE);
    MouseType := CH;
    IRQNr     := CL;
  END;
END; {GetMouseInfo}


PROCEDURE _SuspendViewPort;
{buffer viewport and render it invalid}
BEGIN
  GetDrawingMode(DrawModeBuffer);
  GetViewSettings(ViewPortBuffer);
{select the area specific to text mode!}
  UnClipGraphics;
END; {_SuspendViewPort}


PROCEDURE _ContinueViewPort;
{continue with the buffer viewport (not checked!)}
BEGIN
  SetViewSettings(ViewPortBuffer);
  SetDrawingMode(DrawModeBuffer);
END; {_ContinueViewPort}


PROCEDURE _UpdateMousePosition;
{process mouse movements}
BEGIN
  {quickly get it}
  ASM
    CLI
    MOV AX, MouseNewDX
    MOV BX, MouseNewDY
    ADD MouseX, AX
    ADD MouseY, BX
    ADD MouseOldDX, AX
    ADD MouseOldDY, BX
    XOR AX, AX
    MOV MouseNewDX, AX
    MOV MouseNewDY, AX
    MOV MouseMoved, FALSE
    STI
  END;
  {do the bitmap offsets and range it}
  MouseX := MouseX-ActiveMouseOfsX;
  IF MouseMinX > MouseX THEN MouseX := MouseMinX
                        ELSE IF MouseMaxX < MouseX THEN MouseX := MouseMaxX;
  MouseY := MouseY-ActiveMouseOfsY;
  IF MouseMinY > MouseY THEN MouseY := MouseMinY
                        ELSE IF MouseMaxY < MouseY THEN MouseY := MouseMaxY;
END; {_UpdateMousePosition}


PROCEDURE _DrawMouse;
{draw the mouse pointer at the given location}
BEGIN
  _UpdateMousePosition;
  {get background}
  WITH ActiveForeGround^ DO
  BEGIN
    GetImage(MouseX,MouseY,MouseX+B_W-1,MouseY+B_H-1,MouseBackGround);
  END;
  {draw the mouse pointer}
  PutImage(MouseX,MouseY,ActiveForeGround,SpriteBlit);
  {remember where it is draw}
  OldMouseX  := MouseX;
  OldMouseY  := MouseY;
END; {_DrawMouse}


PROCEDURE _EraseMouse;
{erase the mouse drawing}
BEGIN
  PutImage(OldMouseX,OldMouseY,MouseBackGround,CopyBlit);
END; {_EraseMouse}


PROCEDURE _MoveMouse;
{moving the mouse bitmap over the screen, this operation is highly
complex! In any case, the basics are that, when the old and the new
pointer partially overlap, you aquire an image from the diplay
containing both. three operations are done on this bitmap:
- remove the old pointer with the old background.
- get the background of the new pointer.
- stamp in the new pointer.
after all this you can render the image back into the display.}
VAR MinX,MinY,MaxX,MaxY,W,
    OldX,OldY,NewX,NewY,H:INTEGER;
    ExtraBitMap          :POINTER;
    Overlap              :BOOLEAN;
BEGIN
  {drawing needed?}
  IF  MouseMoved THEN
  BEGIN
  {refresh position}
    _UpdateMousePosition;
  {refresh pointer?}
    IF IsMouseShown THEN
    BEGIN
      {determine the ideal new dimensions}
      WITH ActiveForeGround^ DO
      BEGIN
        IF OldMouseX < MouseX THEN
        BEGIN
          MinX := OldMouseX;
          MaxX := MouseX+B_W-1;
          OldX := 0;
          NewX := MouseX-OldMouseX;
        END
        ELSE
        BEGIN
          MinX := MouseX;
          MaxX := OldMouseX+B_W-1;
          OldX := OldMouseX-MouseX;
          NewX := 0;
        END;
        IF OldMouseY < MouseY THEN
        BEGIN
          MinY := OldMouseY;
          MaxY := MouseY+B_H-1;
          OldY := 0;
          NewY := MouseY-OldMouseY;
        END
        ELSE
        BEGIN
          MinY := MouseY;
          MaxY := OldMouseY+B_H-1;
          OldY := OldMouseY-MouseY;
          NewY := 0;
        END;
        W := MaxX-MinX+1;
        H := MaxY-MinY+1;
        OverLap := (W < 2*B_W) AND (H < 2*B_H);
      END;
    {start}
      _SuspendViewPort;
      IF OverLap THEN
      BEGIN
      {aquire extra bitmap, result can be smaller than requested!}
        ExtraBitMap := AllocAndGetImage(MinX,MinY,W,H);
        IF ExtraBitMap <> NIL THEN
        BEGIN
        {first step: put old background in this bitmap}
          StampInImage(ExtraBitMap,MouseBackGround,OldX,OldY,CopyBlit);
        {second step: get the background of the new pointer}
          WITH ActiveForeGround^ DO
          BEGIN
            ExtractFromImage(MouseBackGround,ExtraBitMap,NewX,NewY,B_W,B_H);
          END;
        {protect; the nasty thing is that our extra bitmap has moved!!!}
          WITH MouseBackGround^ DO
          BEGIN
            IF (MouseY >= 0) AND (OldMouseY < 0) THEN B_OffsetY := 0;
            IF (MouseX >= 0) AND (OldMouseX < 0) THEN B_OffsetX := 0;
          END;
        {third step: stamp in the new pointer}
          StampInImage(ExtraBitMap,ActiveForeGround,NewX,NewY,SpriteBlit);
        {finally draw the newly created bitmap}
          PutAndForgetImage(ExtraBitMap,MinX,MinY,CopyBlit);
        END;
      END
      ELSE {no overlap}
      BEGIN
        {put back old background}
        PutImage(OldMouseX,OldMouseY,MouseBackGround,CopyBlit);
        {get new background}
        WITH ActiveForeGround^ DO
        BEGIN
          GetImage(MouseX,MouseY,MouseX+B_W-1,MouseY+B_H-1,MouseBackGround);
        END;
        {draw the mouse pointer}
        PutImage(MouseX,MouseY,ActiveForeGround,SpriteBlit);
      END;
    {finish}
      _ContinueViewPort;
    {remember where it is draw}
      OldMouseX  := MouseX;
      OldMouseY  := MouseY;
    END;
  END;
END; {_MoveMouse}




PROCEDURE MoveMouse;
{my mouse does not always use an interrupt routine and should
 therefore be moved by calling this routine regularily}
BEGIN
  IF MouseOn AND GraphicsOn THEN _MoveMouse;
END; {MoveMouse}




FUNCTION _LoadMouseBitMap(Path:PCHAR):POINTER;
{load the bitmap of the mouse!}
VAR W,H:INTEGER;
BEGIN
  _LoadMouseBitMap := NIL;
  IF Path[0] <> #0 THEN
  BEGIN
    GetPCXImageSize(Path,W,H);
    IF GetImageSize(W,H) > $3FF0 THEN EXIT;
    _LoadMouseBitMap := GetPCXImage(Path,FALSE,TRUE);
  END;
END; {_LoadMouseBitMap}


PROCEDURE _SetActiveMouseBitMap;
{set the pointer to the active bitmap}
BEGIN
{set the current pointer}
  CASE MouseStyle OF
    Normal   : ActiveForeGround := NormalForeGround;
    Busy     : ActiveForeGround := BusyForeGround;
    Question : ActiveForeGround := QuestionForeGround;
  END;
{all but the normal one can be NIL!}
  IF ActiveForeGround = NIL THEN ActiveForeGround := NormalForeGround;
{forget old background if it exists}
  IF MouseBackGround <> NIL THEN ForgetImage(POINTER(MouseBackGround));
{adapt the background bitmap to the correct size}
  WITH ActiveForeGround^ DO
  BEGIN
    MouseBackGround := AllocImage(B_W,B_H);
  END;
END; {_SetActiveMouseBitMap}


PROCEDURE _LoadMousePointer;
{load the bitmap of the mouse!}
BEGIN
{protect}
  IF NormalMouseFileName[0] = #0 THEN EXIT;
{foregound}
  NormalForeGround   := _LoadMouseBitMap(NormalMouseFileName);
  BusyForeGround     := _LoadMouseBitMap(BusyMouseFileName);
  QuestionForeGround := _LoadMouseBitMap(QuestionMouseFileName);
{select the active one}
  _SetActiveMouseBitMap;
END; {_LoadMousePointer}


PROCEDURE _ForgetMousePointer;
{free the allocated pointer bitmaps}
BEGIN
{deallocate heap memory for the graphical mouse}
  IF NormalForeGround <> NIL   THEN ForgetImage(POINTER(NormalForeGround));
  IF BusyForeGround <> NIL     THEN ForgetImage(POINTER(BusyForeGround));
  IF QuestionForeGround <> NIL THEN ForgetImage(POINTER(QuestionForeGround));
  IF MouseBackGround <> NIL    THEN ForgetImage(POINTER(MouseBackGround));
END; {_ForgetMousePointer}


PROCEDURE SetMousePointers(HotSpotOffsetX,HotSpotOffsetY:WORD;
                           NormalPath,BusyPath,QuestionPath:PCHAR);
{change the graphical pointers}
BEGIN
  IF MouseOn AND GraphicsOn THEN
  BEGIN
    MouseOn := FALSE;
    ActiveMouseOfsX := HotSpotOffsetX;
    ActiveMouseOfsY := HotSpotOffsetY;
    {normal}
    IF RefreshMouseBitMap OR
       (StrComp(NormalMouseFileName,NormalPath) <> 0) THEN
    BEGIN
      IF NormalForeGround <> NIL THEN ForgetImage(POINTER(NormalForeGround));
      StrLCopy(NormalMouseFileName,NormalPath,79);
      NormalForeGround := _LoadMouseBitMap(NormalMouseFileName);
    END;
    {busy}
    IF RefreshMouseBitMap OR
       (StrComp(BusyMouseFileName,BusyPath) <> 0) THEN
    BEGIN
      IF BusyForeGround <> NIL THEN ForgetImage(POINTER(BusyForeGround));
      StrLCopy(BusyMouseFileName,BusyPath,79);
      BusyForeGround := _LoadMouseBitMap(BusyMouseFileName);
    END;
    {question}
    IF RefreshMouseBitMap OR
       (StrComp(QuestionMouseFileName,QuestionPath) <> 0) THEN
    BEGIN
      IF QuestionForeGround <> NIL THEN ForgetImage(POINTER(QuestionForeGround));
      StrLCopy(QuestionMouseFileName,QuestionPath,79);
      QuestionForeGround := _LoadMouseBitMap(QuestionMouseFileName);
    END;
    {select the active one}
    _SetActiveMouseBitMap;
    {switch of refresh flag, used when palette changes}
    RefreshMouseBitMap := FALSE;
    MouseOn := TRUE;
  END;
END; {SetMousePointers}


PROCEDURE _RefreshMousePointer;
{make sure the bitmaps are up to date}
BEGIN
{load the bitmaps}
  SetMousePointers(ActiveMouseOfsX,ActiveMouseOfsY,
                   NormalMouseFileName,BusyMouseFileName,QuestionMouseFileName);
END; {_RefreshMousePointer}





PROCEDURE ShowMouse;
{displays the mouse pointer, and cancels any pointer exclusion area.
 note: a counter is maintained which is decremented by HideMouse and is
       incremented (if nonzero) by this function. the mouse pointer is
       displayed any time the counter is zero. the counter is set to -1
       when the mouse driver is reset.}
BEGIN
  IF MouseOn THEN
  BEGIN
    IF GraphicsOn THEN
    BEGIN
      {refresh it}
      IF RefreshMouseBitMap THEN _RefreshMousePointer;
      {then draw it}
      _SuspendViewPort;
      _DrawMouse;
      _ContinueViewPort;
    END
    ELSE
    BEGIN
      _ClrRegs;
      _CallMouse(SHOW_MOUSE);
    END;
    IsMouseShown := TRUE;
  END;
END; {ShowMouse}


PROCEDURE HideMouse;
{removes the mouse pointer from the screen,
 but continues to track the position of the mouse}
BEGIN
  IF MouseOn THEN
  BEGIN
    IF GraphicsOn THEN
    BEGIN
      _SuspendViewPort;
      _EraseMouse;
      _ContinueViewPort;
    END
    ELSE
    BEGIN
      _ClrRegs;
      _CallMouse(HIDE_MOUSE);
    END;
    IsMouseShown := FALSE;
  END;
END; {HideMouse}


PROCEDURE ShowBusyMouse;
{enable busy cursor}
BEGIN
  IF MouseOn THEN
  BEGIN
    IF IsMouseShown THEN HideMouse;
    MouseStyle := Busy;
    IF GraphicsOn THEN
    BEGIN
      IF RefreshMouseBitMap THEN _RefreshMousePointer;
      _SetActiveMouseBitMap;
    END;
    ShowMouse;
  END;
END; {ShowBusyMouse}


PROCEDURE HideBusyMouse;
{disable busy cursor}
BEGIN
  IF NOT MouseOn THEN EXIT;
  HideMouse;
  MouseStyle := Normal;
  IF GraphicsOn THEN _SetActiveMouseBitMap;
END; {HideBusyMouse}


PROCEDURE ShowQuestionMouse;
{enable busy cursor}
VAR X,Y:INTEGER;
BEGIN
  IF MouseOn THEN
  BEGIN
    IF IsMouseShown THEN HideMouse;
    MouseStyle := Question;
    IF GraphicsOn THEN
    BEGIN
      IF RefreshMouseBitMap THEN _RefreshMousePointer;
      _SetActiveMouseBitMap;
    END;
    ShowMouse;
  END;
END; {ShowQuestionMouse}


PROCEDURE HideQuestionMouse;
{disable busy cursor}
BEGIN
  IF NOT MouseOn THEN EXIT;
  HideMouse;
  MouseStyle := Normal;
  IF GraphicsOn THEN _SetActiveMouseBitMap;
END; {HideQuestionMouse}


FUNCTION _TestMouseButtons(Buttons:BYTE):BOOLEAN;
{quenstion the mouse button}
VAR Dummy      :SINGLE;
    Valid,
    LeftButton,
    RightButton:BOOLEAN;
BEGIN
  _TestMouseButtons := FALSE;
  IF MouseOn THEN
  BEGIN
    _ClrRegs;
    _CallMouse(GET_DATA_MOUSE);
    IF _HasFlag(Regs.BX,Buttons) THEN
    BEGIN
      _TestMouseButtons := TRUE;
      EXIT;
    END;
  END;
END; {_TestMouseButtons}


FUNCTION IsLeftMouseButtonDown:BOOLEAN;
{quenstion the left button}
BEGIN
  IsLeftMouseButtonDown := _TestMouseButtons(1);
END; {IsLeftMouseButtonDown}


FUNCTION IsRightMouseButtonDown:BOOLEAN;
{quenstion the right button}
BEGIN
  IsRightMouseButtonDown := _TestMouseButtons(2);
END; {IsRightMouseButtonDown}


FUNCTION IsMouseButtonDown:BOOLEAN;
{quenstion both buttons}
BEGIN
  IsMouseButtonDown := _TestMouseButtons(1) OR _TestMouseButtons(2);
END; {IsMouseButtonDown}


FUNCTION IsOneMouseButtonDown:BOOLEAN;
{quenstion both buttons}
BEGIN
  IsOneMouseButtonDown := _TestMouseButtons(1) XOR _TestMouseButtons(2);
END; {IsOneMouseButtonDown}


FUNCTION AreBothMouseButtonsDown:BOOLEAN;
{quenstion both buttons}
BEGIN
  AreBothMouseButtonsDown := _TestMouseButtons(1) AND _TestMouseButtons(2);
END; {AreBothMouseButtonsDown}


PROCEDURE GetMouseXY(VAR X,Y:INTEGER);
{get the current position}
BEGIN
  X := 0;
  Y := 0;
  IF MouseOn THEN
  BEGIN
    IF GraphicsOn THEN
    BEGIN
      _MoveMouse;
      X := MouseX;
      Y := MouseY;
    END
    ELSE
    BEGIN
      _ClrRegs;
      _CallMouse(GET_DATA_MOUSE);
      _GetMouseData(WORD(X),WORD(Y));
    END;
  END;
END; {GetMouseXY}


PROCEDURE SetMouseXY(X,Y:INTEGER);
{set mouse to (x,y)}
BEGIN
  IF MouseOn THEN
  BEGIN
    {reset offsets}
    MouseOldSet := FALSE;
    {reset most deltas}
    MouseNewDX  := 0;
    MouseNewDY  := 0;
    IF GraphicsOn THEN
    BEGIN
      MouseX     := X;
      MouseY     := Y;
      MouseMoved := TRUE;
      _MoveMouse;
    END
    ELSE {text mode}
    BEGIN
      _ClrRegs;
      _SetMouseData(X,Y);
      _CallMouse(SET_DATA_MOUSE);
    END;
  END;
END; {SetMouseXY}


FUNCTION IntRange(Item,Bottom,Top:INTEGER):INTEGER;
{range an integer}
BEGIN
  IF Item < Bottom THEN Item := Bottom;
  IF Item > Top THEN Item := Top;
  IntRange := Item;
END; {IntRange}


PROCEDURE SetMouseBox(Left,Top,Right,Bottom:INTEGER);
{restrict mouse movements}
BEGIN
  IF NOT MouseOn THEN EXIT;
{make sure they are ordered}
  IF (Left > Right) THEN
  ASM
    MOV AX,     Left
    MOV BX,     Right
    MOV Left,   BX
    MOV Right,  AX
  END;
  IF (Top > Bottom) THEN
  ASM
    MOV AX,     Top
    MOV BX,     Bottom
    MOV Top,    BX
    MOV Bottom, AX
  END;
  IF GraphicsOn THEN
  BEGIN
    MouseMinX := IntRange(Left,0,GetMaxX);
    MouseMinY := IntRange(Top,0,GetMaxY);
    MouseMaxX := IntRange(Right,0,GetMaxX);
    MouseMaxY := IntRange(Bottom,0,GetMaxY);
  END
  ELSE {text mode}
  BEGIN
  {set x range}
    _ClrRegs;
    _SetMouseData(Left,Right);
    _CallMouse(RANGE_X_MOUSE);
  {set y range}
    _ClrRegs;
    _SetMouseData(Top,Bottom);
    _CallMouse(RANGE_Y_MOUSE);
  END;
END; {SetMouseBox}


PROCEDURE ClearMouseBox;
{undo any mouse box}
VAR MaxX,MaxY:INTEGER;
BEGIN
  IF NOT MouseOn THEN EXIT;
  IF GraphicsOn THEN MaxX := GetMaxX
                ELSE MaxX := (80-1) SHL 3;
  IF GraphicsOn THEN MaxY := GetMaxY
                ELSE MaxY := (25-1) SHL 3;
  SetMouseBox(0,0,MaxX,MaxY);
END; {ClearMouseBox}


PROCEDURE SaveMouseState;
{saves the mouse driver state in a user buffer. the minimum
 size for the buffer must be determined by GetSaveStateSize.}
BEGIN
  IF MouseOn THEN
  WITH Regs DO
  BEGIN
    _ClrRegs;
    _CallMouse(STATE_SIZE_MOUSE);
    MouseStateBuffSize := BX;
    GetMem(MouseStateBuffer,MouseStateBuffSize);
    _SetMousePointer(MouseStateBuffer);
    _CallMouse(SAVE_STATE_MOUSE);
    _ClrRegs;
    _CallMouse(UNDO_MOUSE);
  END;
END; {SaveMouseState}


PROCEDURE LoadMouseState;
{restores the mouse driver state from a user buffer.
 the mouse driver state must have been previously saved
 into the same buffer with SaveDriverState. the format of
 the data in the buffer in undocumented and subject to change.}
BEGIN
  IF MouseOn THEN
  WITH Regs DO
  BEGIN
    _ClrRegs;
    _CallMouse(RESET_MOUSE);
    BX := MouseStateBuffSize;
    _SetMousePointer(MouseStateBuffer);
    _CallMouse(LOAD_STATE_MOUSE);
    ForgetMem(MouseStateBuffer,MouseStateBuffSize);
    {handle digitizer mouse}
  END;
END; {LoadMouseState}


PROCEDURE SwapMouseHandlers(VAR Mask:WORD;VAR Handle:POINTER);
{set the address and event mask for an application program's mouse event
 handler and returns the address and event mask for the previous handler.
 the newly installed handler is called by the mouse driver whenever the
 specified mouse events occur. calls to the event handler are disabled
 with InitMouse or by setting an event mask of zero.}
BEGIN
  IF NOT MouseOn THEN Exit;
  _ClrRegs;
  WITH Regs DO
  BEGIN
    CX := Mask;
    _SetMousePointer(Handle);
    _CallMouse(HANDLE_MOUSE);
    Mask   := CX;
    Handle := Ptr(ES,DX);
  END;
END; {SwapMouseHandlers}


PROCEDURE DefaultMousePointer;
{select the default mouse pointers}
BEGIN
  SetMousePointers(0,0,'NORMAL.PCX','BUSY.PCX','QUESTION.PCX');
END; {DefaultMousePointer}


PROCEDURE StartMouse;
{initializes the mouse driver. after a call to this function
 the driver is initialized to the following state:
 - mouse pointer at screen center and hidden.
 - display page is set to zero.
 - mouse pointer shape set to default arrow shape in graphics modes,
   or reverse block in text modes.
 - user mouse event handlers are disabled.
 - light pen emulation enabled.
 - mouse sensitivity set to default vales (see SetMouseSense)
 - pointer limits set to entire screen.}
VAR MX,MY:INTEGER;
BEGIN
{protect}
  IF MouseOn THEN EXIT;
{reset driver}
  _ClrRegs;
  _CallMouse(RESET_MOUSE);
  IF Regs.AX <> 0 THEN
  BEGIN
    {mouse is installed}
    MouseOn   := TRUE;
    {switch on graphical mouse when needed}
    IF GraphicsOn THEN
    BEGIN
    {always back to default pointers}
      RefreshMouseBitMap := TRUE;
      DefaultMousePointer;
      ClearMouseBox;
    {set the proportional position}
      MX := Trunc(MousePropX*GetMaxX);
      MY := Trunc(MousePropY*GetMaxY);
    END
    ELSE
    BEGIN
    {set the proportional position}
      MX := Trunc(8*MousePropX*80);
      MY := Trunc(8*MousePropY*25);
    END;
    {set it}
    SetMouseXY(MX,MY);
    {swap handlers}
    MaskBuffer      := $01;
    InterruptBuffer := @MouseInterruptRoutine;
    SwapMouseHandlers(MaskBuffer,InterruptBuffer);
  END;
END; {StartMouse}


PROCEDURE StopMouse;
{resets the mouse driver and returns driver status.
 if the mouse pointer was previously visible, it is
 removed trom the screen, and any previously installed
 user event handlers for mouse events are disabled.
 this procedure differ from InitMouse in that there is
 no initialization of the mouse hardware.}
VAR MX,MY:INTEGER;
BEGIN
  IF MouseOn THEN
  BEGIN
    {unload our graphical driver}
    SwapMouseHandlers(MaskBuffer,InterruptBuffer);
    {get the proportional position}
    GetMouseXY(MX,MY);
    IF GraphicsOn THEN
    BEGIN
      MousePropX := MX/GetMaxX;
      MousePropY := MY/GetMaxY;
    END
    ELSE
    BEGIN
      MousePropX := MX/(8*80);
      MousePropY := MY/(8*25);
    END;
    {actually stopping it}
    _ClrRegs;
    _CallMouse(UNDO_MOUSE);
    IF GraphicsOn THEN _ForgetMousePointer;
    {say it is off!}
    MouseOn := FALSE;
  END;
END; {StopMouse}



PROCEDURE FinishUnit; FAR;
{global exit routine}
BEGIN
{return old exit proc}
  ExitProc := OldExitProc;
{and stop graphics if the user doesn't do this}
  FinishVESA256;
{stop the mouse}
  StopMouse;
END; {FinishUnit}


PROCEDURE StartUnit;
{this one starts the mouse and installs an exit proc}
BEGIN
{install new exit routine}
  OldExitProc := ExitProc;
  ExitProc    := @FinishUnit;
{start mouse}
  StartMouse;
END; {StartUnit}


BEGIN
  StartUnit;
END.