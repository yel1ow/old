program Pentium2Bug;

const BufSize = 1024;
      Mask: array [0..4] of Byte = ($B9, $37, $00, $F7, $F1);
      NewByte: array [0..1] of Byte = ($B4, $10);

var F: File;
    Buf: array [0..BufSize - 1] of Byte;
    Count, Pos: LongInt;
    i, n: Integer;
    Res: Word;
    Flag: Boolean;

begin
  WriteLn('Borland Pascal`s programs patch. Copyright (c) by I.Gavrichenkov, 1997');
   if ParamCount <> 1 then
    begin
      WriteLn('Usage: bp_patch.exe <program to patch>');
      Halt;
    end;
  Assign(F, ParamStr(1));
  Reset(F, 1);
  Flag := False;
  Count := 0;
  n := 0;
   repeat
     BlockRead(F, Buf, SizeOf(Buf), Res);
      for i := 0 to Res do
       if Buf[i] = Mask[n] then
        begin
           if n = 4 then
            begin
              Pos := Count + i - 1;
              Flag := True;
            end;
          Inc(n);
        end
       else n := 0;
     Inc(Count, Res);
   until (Res = 0) or Flag;
   if Flag then
    begin
      Write('WoW! Bug found at position ', Pos, ' - ');
      Seek(F, Pos);
      BlockWrite(F, NewByte, SizeOf(NewByte), Res);
       if Res = 2 then WriteLn('patched.') else WriteLn('failed.');
    end
   else WriteLn('No Bug found! Take it easy!');
  Close(F);
  WriteLn('Have a nice DOS or nice Win32.');
end.