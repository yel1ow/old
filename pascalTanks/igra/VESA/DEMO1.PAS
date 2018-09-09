PROGRAM Demo1;


{*******************************************************
 **                                                   **
 **    DEMO1: Show mouse in text and graphics modes   **
 **                                                   **
 *******************************************************}


USES
  Crt,
  VESA256;


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
      ReadKey;
      BREAK;
    END;
  UNTIL IsMouseButtonDown;
  HideMouse;
END; {WaitForUser}


BEGIN
  TextColor(Yellow);
  WriteLn;
  WriteLn('Welcome to this simple VESA256 DEMO.');
  WriteLn;
  WriteLn('Notice that the mouse is already working');
  WriteLn;
  WriteLn('Simply push a key or a mouse button to continue the demo...');
  WaitForUser;
  IF StartVESA256(VESA640x480,Black) THEN
  BEGIN
    PutText(100,100,'And the mouse works here too....',
            TRUE,1,Yellow,Black,CopyBlit);
    WaitForUser;
    IF StartVESA256(VESA800x600,Black) THEN
    BEGIN
      PutText(200,200,'And the mouse still works....',
              TRUE,1,Yellow,Black,CopyBlit);
      WaitForUser;
    END
    ELSE WriteLn('Your video card does not support VESA800x600.');
  END
  ELSE WriteLn('Your video card does not support VESA640x480.');
  FinishVESA256;
  TextColor(Yellow);
  WriteLn;
  WriteLn('And back in text mode we still have a mouse....');
  WriteLn;
  WaitForUser;
END.



