PROGRAM Demo2;


{*******************************************************
 **                                                   **
 **    DEMO2: Just some wild drawing...               **
 **                                                   **
 *******************************************************}


USES
  Crt,
  VESA256;


PROCEDURE ExitRoutine;
{leave demo}
BEGIN
  ScrollToPage(0,1.0);
  HALT;
END; {ExitRoutine}


PROCEDURE WaitForUser;
{returns the moment something changes (mouse buttons and keyboard)}
BEGIN
  ShowMouse;
  REPEAT
    MoveMouse
  UNTIL NOT IsMouseButtonDown;
  REPEAT
    MoveMouse;
    IF KeyPressed THEN
    BEGIN
      IF ReadKey = #27 THEN ExitRoutine ELSE BREAK;
    END;
  UNTIL IsMouseButtonDown;
  HideMouse;
END; {WaitForUser}

PROCEDURE DrawSomething;
{a truly random drawing routine}
VAR Color,Pattern,
    Width,BitBlit,
    Index,Routine :BYTE;
    X,Y           :ARRAY[1..4] OF INTEGER;
    S             :PCHAR;
BEGIN
{style first}
  Color   := Random(256);
  BitBlit := Random(8);
  IF Random > 0.5 THEN
  BEGIN
    Pattern := Random(8);
    Width   := Random(3);
    SetLineMode(Color,Pattern,Width,BitBlit);
  END
  ELSE
  BEGIN
    Pattern := Random(14);
    SetFillMode(Color,Pattern,BitBlit);
  END;
{random coordinates}
  FOR Index := 1 TO 4 DO
  BEGIN
    X[Index] := Random(GetScreenWidth);
    Y[Index] := Random(GetScreenHeight);
  END;
{finally some kind of drawing routine}
  Routine := Random(8);
  CASE Routine OF
    0 : Line(X[1],Y[1],X[2],Y[2]);
    1 : Box(X[1],Y[1],X[2],Y[2]);
    2 : Circle(X[1],Y[1],Random(150));
    3 : Bezier(X[1],Y[1],X[2],Y[2],X[3],Y[3],X[4],Y[4]);
    4 : Ellipse(X[1],Y[1],Random(150),Random(150));
    5 : Bleed(X[1],Y[1],Color);
    6 : CopyBox(X[1],Y[1],X[2],Y[2],Random(150),Random(150),BitBlit);
    7 : PutText(X[1],Y[1],'Just a piece of Text',BOOLEAN(Random(2)),
                Random(62),Color,Random(256),BitBlit);
  END;
{tell what it was}
  CASE Routine OF
    0 : S := ' A Line         ';
    1 : S := ' A Box          ';
    2 : S := ' A Circle       ';
    3 : S := ' A Bezier Curve ';
    4 : S := ' An Ellipse     ';
    5 : S := ' A Bleed Fill   ';
    6 : S := ' Copying a Box  ';
    7 : S := ' A Text         ';
  END;
  PutText(10,10,S,FALSE,1,Yellow,Black,CopyBlit);
END; {DrawSomething}


BEGIN
  Randomize;
  TextColor(Yellow);
  WriteLn;
  WriteLn('Welcome to this simple VESA256 DEMO.');
  WriteLn;
  WriteLn('Simply push a key or a mouse button to continue the demo...');
  WriteLn;
  WriteLn('And press [Esc] to stop...');
  WaitForUser;
  IF StartVESA256(VESA640x480,Black) THEN
  BEGIN
    SetActivePage(1);
    ClearGraphics(Black);
    SetVisualPage(1);
    SetMousePointers(0,0,'BIG.PCX','BIG.PCX','BIG.PCX');
    REPEAT
      DrawSomething;
      WaitForUser;
    UNTIL FALSE;
  END
  ELSE WriteLn('Your video card does not support VESA640x480.');
END.



