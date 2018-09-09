{$A+,B-,D+,E+,F+,G-,I+,L+,N-,O-,P+,Q+,R+,S+,T-,V+,X+}
{$M 16384,0,655360}
unit Keyboard;
interface

  const
    kNothing = 0;
    kCtrl = 29000;
    kLeftShift = 42000;
    kRightShift = 54000;
    kAlt = 56000;

    kEsc = 1;
    k1 = 2; k6 = 7;              kBackSpace = 14;
    k2 = 3; k7 = 8;              kEnter = 28;
    k3 = 4; k8 = 9;              kF1 = 59; kF7 = 65;
    k4 = 5; k9 = 10;             kF2 = 60; kF8 = 66;
    k5 = 6; k0 = 11;             kF3 = 61; kF9 = 67;
    kTilda = 41;                 kF4 = 62; kF10 = 68;
    kWhiteMinus = 12;            kF5 = 63; kF11 = 87;
    kWhitePlus = 13;             kF6 = 64; kF12 = 88;
    kSlash = 43;                 kScrollLock = 70;
    kTab = 15;                   kInsert = 82;
    kCapsLock = 58;              kDelete = 83;
    kHome = 71;                  kPageUp = 73;
    kEnd = 79;                   kPageDown = 81;
    kNumLock = 69;               kLeft = 75;
    kRight = 77;                 kUp = 72;
    kDown = 80;                  k5OnNumberKeyboard = 76;
    kGrayMul = 55;               kGrayMinus = 74;
    kGrayPlus = 78;              kPipka = 93;

    kQ = 16; kW = 17; kE = 18; kR = 19; kT = 20; kY = 21; kU = 22;
    kI = 23; kO = 24; kP = 25; kLeftFigScob = 26; kRightFigScob = 27;
    kA = 30; kS = 31; kD = 32; kF = 33; kG = 34; kH = 35; kJ = 36;
    kK = 37; kL = 38; kDouble = 39; kKavichki = 40;
    kZ = 44; kX = 45; kC = 46; kV = 47; kB = 48; kN = 49; kM = 50;
    kLess = 51; kMore = 52; kDiv = 53; kSpace = 57;

    {При одновременном нажатии с Ctrl, Alt или Shift к результату
     добавляются соответствующие константы}
    {Пример:
          ...
       x := ReadKeyboard(y);
       if x <> kNothing
       then
         case x of
          ...
         end;
          ...}
  type
    TKeys = array [0 .. 255] of boolean;
  var
    Keys: TKeys;

  procedure KeyboardInit;
  procedure KeyboardDone;
  function  ReadKeyboard(var c: char): word;
  procedure SwitchLanguage;
  procedure SetBreakCode(Code: word);

implementation
  uses
    DOS;

  const
    ASCII: array [2 .. 78, 1 .. 4] of char = (
    ('1','!','1','!'), ('2','@','2','"'), ('3','#','3','№'), ('4','$','4',';'), ('5','%','5','%'),
    ('6','^','6',':'), ('7','&','7','?'), ('8','*','8','*'), ('9','(','9','('), ('0',')','0',')'),
    ('-','_','-','_'), ('=','+','=','+'), (#0,#0,#0,#0), (#0,#0,#0,#0), ('q','Q','й','Й'),
    ('w','W','ц','Ц'), ('e','E','у','У'), ('r','R','к','К'), ('t','T','е','Е'), ('y','Y','н','Н'),
    ('u','U','г','Г'), ('i','I','ш','Ш'), ('o','O','щ','Щ'), ('p','P','з','З'), ('[','{','х','Х'),
    (']','}','ъ','Ъ'), (#0,#0,#0,#0), (#0,#0,#0,#0), ('a','A','ф','Ф'), ('s','S','ы','Ы'),
    ('d','D','в','В'), ('f','F','а','А'), ('g','G','п','П'), ('h','H','р','Р'), ('j','J','о','О'),
    ('k','K','л','Л'), ('l','L','д','Д'), (';',':','ж','Ж'), (#39,'"','э','Э'), ('`','~','ё','Ё'),
    (#0,#0,#0,#0), ('\','|','\','/'), ('z','Z','я','Я'), ('x','X','ч','Ч'), ('c','C','с','С'),
    ('v','V','м','М'), ('b','B','и','И'), ('n','N','т','Т'), ('m','M','ь','Ь'), (',','<','б','Б'),
    ('.','>','ю','Ю'), ('/','?','.',','), (#0,#0,#0,#0), ('*','*','*','*'), (#0,#0,#0,#0),
    (' ',' ',' ',' '), (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0),
    (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0),
    (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0), (#0,#0,#0,#0),
    (#0,#0,#0,#0), (#0,#0,#0,#0), ('-','-','-','-'), (#0,#0,#0,#0), (#0,#0,#0,#0),
    (#0,#0,#0,#0), ('+','+','+','+'));
  type
    TQueue = array [1 .. 100] of word;
  var
    InitFlag, HaltFlag: boolean;
    KeyFlags: byte absolute $0: $0417;
    SCA, ASCIIKeys, Locks: set of byte;
    Language: boolean; {true - English}
    Queue: TQueue;
    BreakCode, LastCode: word;
    QLen, QUp, QDown: byte;
    OldExitProc: pointer;

  {$L keyboard.obj}
  procedure KeyboardInit_; far; external;
  procedure KeyboardDone_; far; external;

  procedure SetBreakCode(Code: word);
  begin
    BreakCode := Code
  end;

  procedure KeyboardDone;
    var
      p: pointer;
  begin
    if InitFlag
    then
      begin
        InitFlag := false;
        KeyboardDone_
      end
  end;

  procedure SwitchLanguage;
  begin
    Language := not Language
  end;

  procedure Pop(Code: word);
  begin
    if QLen < 100
    then
      begin
        Inc(QLen);
        Queue[QUp] := Code;
        Inc(QUp);
        if QUp > 100
        then
          QUp := 1
      end
  end;

  function Push: word;
  begin
    if QLen <= 0
    then
      Push := kNothing
    else
      begin
        Dec(QLen);
        Inc(QDown);
        if QDown > 100
        then
          QDown := 1;
        Push := Queue[QDown]
      end
  end;

  procedure MaybeHalt; far;


  begin
    if (BreakCode <> kNothing) and (BreakCode = LastCode)
    then
      HaltFlag := true
  end;

  procedure KeyboardHandler(a: byte); far;
  var
    b, i, x, k, y: byte;
    Code: word;
  begin
    x := 1 - ((a and $80) shr 7);
    k := a and $7F;
    Keys[k] := boolean(x);
    if Keys[42] and Keys[56]
    then
      Language := not Language;
    if (x = 1) and not (k in SCA)
    then
      begin
        if Keys[29]
        then
          Code := k + 29000
        else
          if Keys[42]
          then
            Code := k + 42000
          else
            if Keys[54]
            then
              Code := k + 54000
            else
              if Keys[56]
              then
                Code := k + 56000
              else
                Code := k;
        Pop(Code)
      end
    else
      Code := k;
    LastCode := Code
  end;

  function ReadKeyboard(var c: char): word;
    var
      Result: word;
      fff: boolean;
  begin
    if HaltFlag
    then
      Halt;
    c := #0;
    Result := Push;
    if (Result mod 1000 in ASCIIKeys) and not (Result div 1000 in [29, 56])
    then
      begin
        fff := Result div 1000 in [42, 54];
        case Language of
          true: case fff of
                  true: c := ASCII[Result mod 1000, 2];
                  false: c := ASCII[Result mod 1000, 1]
                end;
          false: case fff of
                   true: c := ASCII[Result mod 1000, 4];
                   false: c := ASCII[Result mod 1000, 3]
                 end
        end;
      end;
    ReadKeyboard := Result
  end;

  procedure KeyboardInit;
  begin
    if not InitFlag
    then
      begin
        FillChar(Keys, SizeOf(Keys), 0);
        InitFlag := true;
        while (KeyFlags and $0F) <> 0 do;
        KeyboardInit_
      end
  end;

  procedure ExitProcedure; far;
  begin
    ExitProc := OldExitProc;
    KeyboardDone
  end;

begin
  HaltFlag := false;
  BreakCode := kNothing;
  OldExitProc := ExitProc;
  ExitProc := Addr(ExitProcedure);
  QLen := 0; QDown := 0; QUp := 1;
  InitFlag := false;
  Language := true;
  SCA := [29, 42, 54, 56];
  Locks := [kNumLock, kCapsLock, kScrollLock];
  ASCIIKeys := [kTilda, k1 .. kWhitePlus, kSlash, kQ .. kRightFigScob, kA .. kKavichki, kZ .. kDiv, kSpace, kGrayMul,
                kGrayMinus, kGrayPlus]
end.