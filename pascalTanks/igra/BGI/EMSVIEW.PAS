unit EMSView; {Debug modul}
interface

  procedure ExecuteEMSView;

implementation
  uses
    VESA, Objects, Crt;
  const
    SwapFile = 'emsview.tmp';
    BTex = 'buttons.dat';
    WTex = 'texture.dat';
    LTex = 'labels.dat';
    ETex = 'labels.dat';
  type
    PBut = ^TBut;
    TBut = record
             Next: PBut;
             x1, y1, x2, y2: integer;
             Name: string[20];
             Code: byte
           end;
  var
    OldBTex, OldWTex, OldETex, OldLTex: string;
    OldColor: byte;
    MainList, ViewList: PBut;
    CurPage: longint;
    OldX1, OldX2, OldY1, OldY2: integer;

procedure SaveState;
  var
    f: file;
    p: pointer;
    i: integer;
begin
  HideMouse;
  GetWSize(OldX1, OldY1, OldX2, OldY2);
  SetWSize(0, 0, GetMaxX, GetMaxY);
  OldColor := GetColor;
  OldBTex := GetButtonTexture;
  OldWTex := GetWindowTexture;
  OldETex := GetEditTexture;
  OldLTex := GetLabelTexture;
  GetMem(p, 1000);
  Assign(f, SwapFile);
  Rewrite(f, 1);
  for i := 0 to 479 do
  begin
    GetImage(0, i, 639, i, p);
    BlockWrite(f, p^, 644)
  end;
  Close(f);
  FreeMem(p, 1000);
  SetWindowTexture(WTex);
  SetButtonTexture(BTex);
  SetLabelTexture(LTex);
  SetEditTexture(ETex);
  ShowMouse
end;

procedure LoadState;
  var
    f: file;
    p: pointer;
    i: integer;
begin
  HideMouse;
  SetColor(0);
  Bar(0, 0, GetMaxX, GetMaxY);
  GetMem(p, 1000);
  Assign(f, SwapFile);
  Reset(f, 1);
  for i := 0 to 479 do
  begin
    BlockRead(f, p^, 644);
    PutSprite(0, i, p)
  end;
  Close(f);
  FreeMem(p, 1000);
  SetWindowTexture(OldWTex);
  SetButtonTexture(OldBTex);
  SetLabelTexture(OldLTex);
  SetEditTexture(OldETex);
  SetColor(OldColor);
  SetWSize(OldX1, OldY1, OldX2, OldY2);
  ShowMouse
end;

procedure MyWin(x1, y1, x2, y2: integer; Name: string);
begin
  DrawWindow(x1, y1, x2, y2);
  DrawLabel(x1 + 9, y1 + 9, x2 - 9, y1 + 29, Name)
end;

procedure ShowScreen;
  var
    p: PBut;
    s: string;
begin
  HideMouse;
  SetColor(0);
  Bar(0, 0, GetMaxX, GetMaxY);
  MyWin(0, 0, 200, 230, 'Просмотр EMS-страниц');
  p := MainList;
  while p <> nil do
  begin
    DrawButton(p^.x1, p^.y1, p^.x2, p^.y2, p^.Name, false, false);
    p := p^.Next
  end;
  Str(CurPage, s);
  DrawLabel(15, 165, 185, 185, 'Текущая: ' + s);
  Str(FreePages, s);
  DrawLabel(15, 195, 185, 215, 'Всего: ' + s);
  ShowMouse
end;

procedure InsertB(var List: PBut; Name: string; x1, y1, x2, y2: integer; Code: byte);
  var
    p: PBut;
begin
  if List = nil
  then
    begin
      New(List);
      List^.Next := nil;
      p := List
    end
  else
    begin
      p := List;
      while p^.Next <> nil do
        p := p^.Next;
      New(p^.Next);
      p := p^.Next;
      p^.Next := nil
    end;
  p^.Name := Name;
  p^.Code := Code;
  p^.x1 := x1; p^.x2 := x2; p^.y1 := y1; p^.y2 := y2
end;

procedure DisposeList(List: PBut);
  var
    p, p1: PBut;
begin
  p := List;
  while p <> nil do
  begin
    p1 := p^.Next;
    Dispose(p);
    p := p1
  end
end;

function Inside(x1, y1, x2, y2, x, y: integer): boolean;
begin
  Inside := (x > x1) and (y > y1) and (x < x2) and (y < y2)
end;

function ExMain: byte;
  var
    f: boolean;
    c: byte;
    ch: char;
    p: PBut;
begin
  f := false;
  repeat
    if KeyPressed
    then
      begin
        ch := ReadKey;
        if ch = #0
        then
          ch := ReadKey
      end;
    if MouseButton = 1
    then
      begin
        p := MainList;
        while p <> nil do
        begin
          if Inside(p^.x1, p^.y1, p^.x2, p^.y2, MouseX, MouseY)
          then
            begin
              f := true;
              c := p^.Code;
              HideMouse;
              DrawButton(p^.x1, p^.y1, p^.x2, p^.y2, p^.Name, true, false);
              ShowMouse;
              repeat
              until MouseButton = 0;
              HideMouse;
              DrawButton(p^.x1, p^.y1, p^.x2, p^.y2, p^.Name, false, false);
              ShowMouse;
            end;
          p := p^.Next
        end;
      end
  until f;
  ExMain := c
end;

procedure ChangePage;
  var
    f: boolean;
    c: char;
    s: string;
    Code: integer;
begin
  HideMouse;
  MyWin(250, 200, 450, 330, 'Выбор страницы');
  OutTextXY(270, 235, 'Введите номер');
  DrawEdit(270, 250, 430, 270, '');
  DrawButton(310, 280, 390, 305, 'Ok', false, false);
  ShowMouse;
  f := false;
  s := '';
  repeat
    if KeyPressed
    then
      begin
        c := ReadKey;
        if c = #0
        then
          c := ReadKey;
        case c of
          '0' .. '9': if Length(s) < 3
                      then
                        begin
                          s := s + c;
                          HideMouse;
                          DrawEdit(270, 250, 430, 270, s);
                          ShowMouse
                        end;
          #08: if Length(s) > 0
               then
                 begin
                   Delete(s, Length(s), 1);
                   HideMouse;
                   DrawEdit(270, 250, 430, 270, s);
                   ShowMouse
                 end
        end
      end;
    if MouseButton = 1
    then
      begin
        if Inside(310, 280, 390, 305, MouseX, MouseY)
        then
          begin
            f := true;
            HideMouse;
            DrawButton(310, 280, 390, 305, 'Ok', true, false);
            ShowMouse;
            while MouseButton <> 0 do;
            HideMouse;
            DrawButton(310, 280, 390, 305, 'Ok', false, false);
            ShowMouse
          end
      end
  until f;
  HideMouse;
  SetColor(0);
  Bar(250, 200, 450, 330);
  Val(s, CurPage, Code);
  DrawLabel(15, 165, 185, 185, 'Текущая: ' + s);
  ShowMouse;
end;

function GetHex(c: byte): string;
  const
    Hex: string[16] = '0123456789ABCDEF';
  var
    s: string;
begin
  s := Hex[c mod 16 + 1];
  c := c div 16;
  s := Hex[c + 1] + s;
  GetHex := s
end;

procedure ViewPage;
  type
    PRec = ^TRec;
    TRec = record
             Size, Next: word;
           end;
  var
    s: string;
    p: PBut;
    c: char;
    f: boolean;
    pp, p1, p2: PRec;
    i, x, y, Max: integer;
    b, Offs: word;
    CurNum: word;
    Siz, Nex: word;
    Kol: longint;

  function Analize(Page: longint; var Kol: longint): boolean;
    var
      f: boolean;
      Size: longint;
  begin
    f := true;
    pp := ptr(Base, LoadPage(CurPage));
    Offs := word(pp);
    p1 := pp;
    Size := 0;
    Kol := 1;
    while (p1^.Next <> PageSize) and (Kol <= 20000) do
    begin
      if p1^.Size < 60000
      then
        begin
          Size := Size + p1^.Size;
          if p1^.Next <> Size
          then
            f := false
        end
      else
        Size := Size + p1^.Next - (word(p1) - Offs);
      word(p1) := p1^.Next + Offs;
      Inc(Kol)
    end;

    if p1^.Size < 60000
    then
      begin
        Size := Size + p1^.Size;
        if p1^.Next <> Size
        then
          f := false
      end
    else
      Size := Size + p1^.Next - (word(p1) - Offs);

    if (Size <> PageSize) or (Kol > 20000)
    then
      f := false;
    Analize := f
  end;

begin
  HideMouse;
  Str(CurPage, s);
  MyWin(0, 0, GetMaxX, GetMaxY, 'Страница ' + s);
  OutTextXY(20, 40, 'Записи:');
  DrawEdit(20, 60, 150, 459, '');
  OutTextXY(180, 40, 'Текущая запись:');
  DrawEdit(180, 60, 619, 330, '');
  OutTextXY(180, 350, 'Свойства:');
  p := ViewList;
  while p <> nil do
  begin
    DrawButton(p^.x1, p^.y1, p^.x2, p^.y2, p^.Name, false, false);
    p := p^.Next
  end;
  pp := ptr(Base, LoadPage(CurPage));
  Offs := word(pp);
  p1 := pp;
  x := 185;
  y := 68;
  for i := 1 to 247 do
  begin
    b := p1^.Size;
    OutTextXY(x, y, GetHex(byte(b)));
    x := x + 23;
    if x > 610
    then
      begin
        y := y + 20;
        x := 185
      end;
    Inc(word(p1))
  end;
  Str(word(pp) - Offs, s);
  Siz := pp^.Size;
  Nex := pp^.Next;
  DrawLabel(180, 370, 350, 390, 'Смещение: ' + s);
  Str(Siz, s);
  DrawLabel(180, 405, 350, 425, 'Размер: ' + s);
  Str(Nex, s);
  DrawLabel(180, 440, 350, 460, 'Следующая: ' + s);
  pp := ptr(Base, LoadPage(CurPage));
  Offs := word(pp);
  CurNum := 1;
  p1 := pp;
  i := 0;
  y := 65;
  while (word(p1) - Offs <> PageSize) and (y < 450) do
  begin
    Inc(i);
    if i = CurNum
    then
      SetColor(119)
    else
      SetColor(15);
    Str(i, s);
    while Length(s) < 4 do
      s := '0' + s;
    OutTextXY(25, y, 'Запись ' + s);
    y := y + 20;
    word(p1) := p1^.Next + Offs
  end;
  Max := i;
  ShowMouse;
  f := false;
  repeat
    c := #0;
    if KeyPressed
    then
      begin
        c := ReadKey;
        if c = #0
        then
          c := ReadKey
      end;
    case c of
      #72: if CurNum > 1
           then
             begin
               HideMouse;
               CurNum := CurNum - 1;
               p1 := pp;
               i := 0;
               y := 65;
               while (word(p1) - Offs <> PageSize) and (y < 450) do
               begin
                 Inc(i);
                 if i = CurNum
                 then
                   SetColor(119)
                 else
                   SetColor(15);
                 Str(i, s);
                 while Length(s) < 4 do
                   s := '0' + s;
                 OutTextXY(25, y, 'Запись ' + s);
                 y := y + 20;
                 word(p1) := p1^.Next + Offs
               end;
               DrawEdit(180, 60, 619, 330, '');
               pp := ptr(Base, LoadPage(CurPage));
               Offs := word(pp);
               p1 := pp;
               for i := 1 to CurNum - 1 do
                 word(p1) := p1^.Next + Offs;
               p2 := p1;
               x := 185;
               y := 68;
               SetColor(15);
               for i := 1 to 247 do
               begin
                 b := p1^.Size;
                 OutTextXY(x, y, GetHex(byte(b)));
                 x := x + 23;
                 if x > 610
                 then
                   begin
                     y := y + 20;
                     x := 185
                   end;
                 Inc(word(p1))
               end;
               Str(word(p2) - Offs, s);
               Siz := p2^.Size;
               Nex := p2^.Next;
               DrawLabel(180, 370, 350, 390, 'Смещение: ' + s);
               Str(Siz, s);
               DrawLabel(180, 405, 350, 425, 'Размер: ' + s);
               Str(Nex, s);
               DrawLabel(180, 440, 350, 460, 'Следующая: ' + s);
               pp := ptr(Base, LoadPage(CurPage));
               Offs := word(pp);
               ShowMouse
             end;
      #80: if CurNum < Max
           then
             begin
               HideMouse;
               CurNum := CurNum + 1;
               p1 := pp;
               i := 0;
               y := 65;
               while (word(p1) - Offs <> PageSize) and (y < 450) do
               begin
                 Inc(i);
                 if i = CurNum
                 then
                   SetColor(119)
                 else
                   SetColor(15);
                 Str(i, s);
                 while Length(s) < 4 do
                   s := '0' + s;
                 OutTextXY(25, y, 'Запись ' + s);
                 y := y + 20;
                 word(p1) := p1^.Next + Offs
               end;
               DrawEdit(180, 60, 619, 330, '');
               pp := ptr(Base, LoadPage(CurPage));
               Offs := word(pp);
               p1 := pp;
               for i := 1 to CurNum - 1 do
                 word(p1) := p1^.Next + Offs;
               p2 := p1;
               x := 185;
               y := 68;
               SetColor(15);
               for i := 1 to 247 do
               begin
                 b := p1^.Size;
                 OutTextXY(x, y, GetHex(byte(b)));
                 x := x + 23;
                 if x > 610
                 then
                   begin
                     y := y + 20;
                     x := 185
                   end;
                 Inc(word(p1))
               end;
               Str(word(p2) - Offs, s);
               Siz := p2^.Size;
               Nex := p2^.Next;
               DrawLabel(180, 370, 350, 390, 'Смещение: ' + s);
               Str(Siz, s);
               DrawLabel(180, 405, 350, 425, 'Размер: ' + s);
               Str(Nex, s);
               DrawLabel(180, 440, 350, 460, 'Следующая: ' + s);
               pp := ptr(Base, LoadPage(CurPage));
               Offs := word(pp);
               ShowMouse
             end;
    end;
    if MouseButton = 1
    then
      begin
        p := ViewList;
        while p <> nil do
        begin
          if Inside(p^.x1, p^.y1, p^.x2, p^.y2, MouseX, MouseY)
          then
            begin
              HideMouse;
              DrawButton(p^.x1, p^.y1, p^.x2, p^.y2, p^.Name, true, false);
              ShowMouse;
              while MouseButton <> 0 do;
              HideMouse;
              DrawButton(p^.x1, p^.y1, p^.x2, p^.y2, p^.Name, false, false);
              ShowMouse;
              case p^.Code of
                0: begin
                     if Analize(CurPage, Kol)
                     then
                       begin
                         HideMouse;
                         PictureToFile(100, 100, 300, 200, 'pic.pic');
                         MyWin(100, 100, 300, 200, 'Ok');
                         Str(Kol, s);
                         DrawLabel(120, 150, 280, 170, 'Всего: ' + s);
                         repeat
                           if KeyPressed
                           then
                             begin
                               c := ReadKey;
                               if c = #0
                               then
                                 c := ReadKey
                             end
                         until c = #27;
                         PictureFromFile(100, 100, 'pic.pic');
                         ShowMouse
                       end
                     else
                       begin
                         HideMouse;
                         PictureToFile(100, 100, 300, 200, 'pic.pic');
                         MyWin(100, 100, 300, 200, 'Глюки!!!');
                         Str(Kol, s);
                         DrawLabel(120, 150, 280, 170, 'Всего: ' + s);
                         repeat
                           if KeyPressed
                           then
                             begin
                               c := ReadKey;
                               if c = #0
                               then
                                 c := ReadKey
                             end
                         until c = #27;
                         PictureFromFile(100, 100, 'pic.pic');
                         ShowMouse
                       end;
                     pp := ptr(Base, LoadPage(CurPage));
                     Offs := word(pp);
                   end;
                1: f := true
              end
            end;
          p := p^.Next
        end
      end
  until f;
  SetColor(0);
  HideMouse;
  Bar(0, 0, GetMaxX, GetMaxY);
  ShowMouse;
  ShowScreen
end;

procedure ExecuteEMSView;
  var
    c: byte;
begin
  MainList := nil;
  ViewList := nil;
  InsertB(MainList, 'Выбрать страницу', 20, 40, 180, 65, 0);
  InsertB(MainList, 'Просмотр страницы', 20, 80, 180, 105, 1);
  InsertB(MainList, 'Выход', 20, 120, 180, 145, 2);
  InsertB(ViewList, 'Анализ', 440, 380, 550, 405, 0);
  InsertB(ViewList, 'Закрыть', 440, 420, 550, 445, 1);
  SaveState;
  ShowScreen;
  repeat
    c := ExMain;
    case c of
      0: ChangePage;
      1: ViewPage;
    end
  until c = 2;
  LoadState;
  DisposeList(MainList);
  DisposeList(ViewList)
end;

begin
  CurPage := 0
end.