unit XMS;
interface

var
  EMBSize: word;

procedure CopyEMB(Offset: longint);
procedure CopyEMBRev(Offset: longint);
procedure DoneXMS;
procedure InitXMS;
procedure SetCopyParams(Buf: pointer; Size: longint);
procedure SetHeaderParams(Header: pointer; Size: longint);
procedure CopyHeader(Offset: longint);
procedure CopyHeaderRev(Offset: longint);

implementation

type
  TExtMemMoveStruc = record
                       Length: longint;
                       SourceHandle: word;
                       SourceOffset: longint;
                       DestHandle: word;
                       DestOffset: longint;
                     end;

var
  Mem: boolean;
  HMMEntry: pointer;
  EMBHandle: word;
  OldExitProc: pointer;
  ExtMemMoveStruc, ExtMemMoveStrucRev: TExtMemMoveStruc;
  HeaderStruc, HeaderStrucRev: TExtMemMoveStruc;
  Name, Name1: string;

procedure Error(Message: string);
begin
  WriteLn('Ошибка: ', Message);
  if Mem
  then
    DoneXMS;
  Halt(1)
end;

procedure CopyEMB(Offset: longint);
  var
    ErByte: byte;
begin
  if HMMEntry = nil
  then
    Error('не найдена точка входа HMM');
  ErByte := 0;
  ExtMemMoveStruc.SourceOffset := Offset + 1024;
  asm
    mov         ax,0B00h
    mov         si,offset ExtMemMoveStruc
    xor         bx,bx
    call        dword ptr HMMEntry
    cmp         ax,0001h
    jz          @CopyOk1
    mov         byte ptr ErByte,1
  @CopyOk1:
    and         bl,80h
    jz          @CopyOk2
    mov         byte ptr ErByte,1
  @CopyOk2:
  end;
  if ErByte <> 0
  then
    Error('ошибка при использовании функции HMM');
end;

procedure CopyEMBRev(Offset: longint);
  var
    ErByte: byte;
begin
  if HMMEntry = nil
  then
    Error('не найдена точка входа HMM');
  ErByte := 0;
  ExtMemMoveStrucRev.DestOffset := Offset + 1024;
  asm
    mov         ax,0B00h
    mov         si,offset ExtMemMoveStrucRev
    xor         bx,bx
    call        dword ptr HMMEntry
    cmp         ax,0001h
    jz          @CopyOk1
    mov         byte ptr ErByte,1
  @CopyOk1:
    and         bl,80h
    jz          @CopyOk2
    mov         byte ptr ErByte,1
  @CopyOk2:
  end;
  if ErByte <> 0
  then
    Error('ошибка при использовании функции HMM');
end;

procedure CopyHeader(Offset: longint);
  var
    ErByte: byte;
begin
  if HMMEntry = nil
  then
    Error('не найдена точка входа HMM');
  ErByte := 0;
  HeaderStruc.SourceOffset := Offset + 1024;
  asm
    mov         ax,0B00h
    mov         si,offset HeaderStruc
    xor         bx,bx
    call        dword ptr HMMEntry
    cmp         ax,0001h
    jz          @CopyOk1
    mov         byte ptr ErByte,1
  @CopyOk1:
    and         bl,80h
    jz          @CopyOk2
    mov         byte ptr ErByte,1
  @CopyOk2:
  end;
  if ErByte <> 0
  then
    Error('ошибка при использовании функции HMM');
end;

procedure CopyHeaderRev(Offset: longint);
  var
    ErByte: byte;
begin
  if HMMEntry = nil
  then
    Error('не найдена точка входа HMM');
  ErByte := 0;
  HeaderStrucRev.DestOffset := Offset + 1024;
  asm
    mov         ax,0B00h
    mov         si,offset HeaderStrucRev
    xor         bx,bx
    call        dword ptr HMMEntry
    cmp         ax,0001h
    jz          @CopyOk1
    mov         byte ptr ErByte,1
  @CopyOk1:
    and         bl,80h
    jz          @CopyOk2
    mov         byte ptr ErByte,1
  @CopyOk2:
  end;
  if ErByte <> 0
  then
    Error('ошибка при использовании функции HMM');
end;

procedure SetHeaderParams(Header: pointer; Size: longint);
begin
  if (Size <= 0) or (Size mod 2 = 1)
  then
    Error('некорректный размер локального буфера');
  HeaderStruc.DestHandle := 0;
  HeaderStruc.DestOffset := longint(Header);
  HeaderStruc.Length := Size;
  HeaderStruc.SourceHandle := EMBHandle;
  HeaderStrucRev.SourceHandle := 0;
  HeaderStrucRev.SourceOffset := longint(Header);
  HeaderStrucRev.Length := Size;
  HeaderStrucRev.DestHandle := EMBHandle;
end;

procedure SetCopyParams(Buf: pointer; Size: longint);
begin
  if (Size <= 0) or (Size mod 2 = 1)
  then
    Error('некорректный размер локального буфера');
  ExtMemMoveStruc.DestHandle := 0;
  ExtMemMoveStruc.DestOffset := longint(Buf);
  ExtMemMoveStruc.Length := Size;
  ExtMemMoveStruc.SourceHandle := EMBHandle;
  ExtMemMoveStrucRev.SourceHandle := 0;
  ExtMemMoveStrucRev.SourceOffset := longint(Buf);
  ExtMemMoveStrucRev.Length := Size;
  ExtMemMoveStrucRev.DestHandle := EMBHandle;
end;

function GetMaxEMBSize: word;
  var
    ErByte: byte;
    Size: word;
begin
  if HMMEntry = nil
  then
    Error('не найдена точка входа HMM');
  asm
    mov         ax,0800h
    call        dword ptr HMMEntry
    mov         ErByte,bl
    mov         Size,ax
  end;
  if ErByte <> 0
  then
    Error('ошибка при использовании функции HMM');
  GetMaxEMBSize := Size;
end;

function DriverInstalled: boolean; assembler;
asm
  mov           ax,4300h
  int           2Fh
  cmp           al,80h
  jnz           @DINotInstalled
  mov           ax,1
  jmp           @DIExit
@DINotInstalled:
  xor           ax,ax
@DIExit:
end;

function SeekHandler(var Handler, EMBSize: word): boolean;
  var
    h, Size: word;
    Res: byte;
begin
  h := Handler;
  Res := 0; Size := 0;
  asm
    mov         dx,h
  @NextHandler:
    push        dx
    mov         ax,0E00h
    call        dword ptr HMMEntry
    cmp         ax,1
    jnz         @ErrorHandler
    test        bl,80h
    jnz         @ErrorHandler
    cmp         dx,64
    jb          @ErrorHandler
    mov         byte ptr Res,1
    mov         Size,dx
    pop         dx
    mov         h,dx
    jmp         @Find
  @ErrorHandler:
    pop         dx
    inc         dx
    jnz         @NextHandler
  @Find:
  end;
  SeekHandler := boolean(Res);
  Handler := h;
  EMBSize := Size;
end;

function FindBlock(var Handler: word; var EMBSize: word): boolean;
  var
    f, Ok: boolean;
begin
  Handler := 0;
  Ok := false;
  repeat
    f := SeekHandler(Handler, EMBSize);
    if f
    then
      begin
        SetCopyParams(Addr(Name1), 256);
        CopyEMB(-1024);
        Ok := Name = Name1;
        if not Ok
        then
          begin
            if Handler = 65535
            then
              f := false
            else
              Inc(Handler);
          end;
      end;
  until (not f) or Ok;
  FindBlock := Ok;
end;

procedure InitXMS;
  var
    MaxEMBSize: word;
    ErByte: byte;
begin
  if not DriverInstalled
  then
    Error('драйвер не установлен');
  asm
    mov         ax,4310h
    int         2Fh
    mov         word ptr HMMEntry,bx
    mov         word ptr HMMEntry+2,es
  end;
  if not FindBlock(EMBHandle, EMBSize)
  then
    begin
      MaxEMBSize := GetMaxEMBSize;
      if MaxEMBSize < 64
      then
        Error('недостаточно памяти');
      if MaxEMBSize > 16 * 1024
      then
        EMBSize := 16 * 1024
      else
        EMBSize := MaxEMBSize;
      ErByte := 0;
      asm
        mov         ax,0900h
        mov         dx,EMBSize
        xor         bx,bx
        call        dword ptr HMMEntry
        mov         EMBHandle,dx
        cmp         ax,0001h
        jz          @Ok1
        mov         byte ptr ErByte,1
      @Ok1:
        and         bl,80h
        jz          @Ok2
        mov         byte ptr ErByte,1
      @Ok2:
      end;
      if ErByte <> 0
      then
        Error('ошибка при использовании функции HMM');
      SetCopyParams(Addr(Name), 256);
      CopyEMBRev(-1024);
    end;
  Dec(EMBSize);
  Mem := true;
end;

procedure DoneXMS;
begin
  if Mem and (HMMEntry <> nil)
  then
    begin
      asm
        mov     ax,0A00h
        mov     dx,EMBHandle
        call    dword ptr HMMEntry
      end;
      Mem := false;
    end;
end;

procedure ExitProcedure; far;
begin
  ExitProc := OldExitProc;
  DoneXMS;
end;

begin
  OldExitProc := ExitProc;
  ExitProc := Addr(ExitProcedure);
  Mem := false;
  HMMEntry := nil;
  Name := 'Extended memory manager v4.0  № Kuznetsov Sergey 2004';
end

.