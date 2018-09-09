; VESA.ASM - version 4.0
.386

Code    Segment   Use16
        assume    cs:Code,ds:Code

        Public    VESAInit_,PutPixel,SetActivePage,SetVisualPage
        Public    PutSprite_,SetWSize,SetPalette,SetColor,Bar,PutImage_
        Public    InitMouse,DoneMouse,ShowMouse,HideMouse,MouseX,MouseY
        Public    MouseButton,GetMaxX,GetMaxY,Line,GetImage_,SetStandartPalette
        Public    GetColor,GetPixel,OutText,SetUserCursor,SetStandartCursor
        Public    WaitVBL,SetShadowMode, GetPalette, GetWSize, SetMousePosition
        public    PutSprite__,PutImage__,GetImage__
        public    SetMouseArea,SetUserRasterFont, SetStandartRasterFont

        Extrn     ModeAttrs
        Extrn     MouseFlag: byte
        Extrn     GetArea: far

        Include   VESA.Pal
        Include   VESA.Mac
        Include   VESA.Cur
        Include   VESA.Fnt

ChangeBankProc    dw    ?,?
WinX1             dw    0
WinX2             dw    ?
WinY1             dw    0
WinY2             dw    ?
MouseWinX1        dw    0
MouseWinY1        dw    0
MouseWinX2        dw    ?
MouseWinY2        dw    ?
GranPerBank       dw    ?
W                 dw    ?
CurrentBank       dw    0
ActivePage        dw    0
VideoBuffer       dw    0A000h
SizeY             dw    ?
SizeX             dw    ?
AddForNextLine    dw    ?
AddForSI          dw    ?
ActiveColor       db    15
Old10h            dw    ?,?
Old33h            dw    ?,?
UwinPos           dw    ?
Offs              dw    ?
Buffer            dw    offset Buffer1
OldBuffer         dw    ?
Buffer1           db    2000    dup     (0)
Buffer2           db    2000    dup     (0)
XC                dw    0
YC                dw    0
OldXC             dw    0
OldYC             dw    0
NewXC             dw    ?
NewYC             dw    ?
CurBank           dw    ?
ScanLine          dw    0
OldScanLine       dw    0
Show              db    0
Active10          db    0
OldBank           dw    ?
OldOffs           dw    ?
TempBank          dw    ?
TempOffs          dw    ?
SizeMouseX        dw    ?
SizeMouseY        dw    ?
AddForMouseLine   dw    ?
AddForMouseSI     dw    ?
MouseIsActive     db    ?
TempX             dw    ?
TempY             dw    ?
TempX1            dw    ?
TempY1            dw    ?
CurrentX          dw    ?
CurrentY          dw    ?
ModeTable         dw    offset NormalMode
                  dw    offset AndMode
                  dw    offset XorMode
                  dw    offset OrMode
                  dw    offset ShadowMode
_ModeTable        dw    offset _NormalMode
                  dw    offset _AndMode
                  dw    offset _XorMode
                  dw    offset _OrMode
                  dw    offset _ShadowMode

MouseCursor       dd    ?
Palette           dw    ?,?
ColorTable        db    4096   dup     (0)
Shadow            db    3

Max               db    ?
ColorR            db    ?
ColorG            db    ?
ColorB            db    ?
BestColor         db    ?
FontPointer       dw    offset StandartFont,?

WhatIsAFuckingAss Proc                  ;Переключить банк (DX)
        push      bx dx
        mov       byte ptr cs:Active10,1
        mov       word ptr cs:CurrentBank,dx
        xor       bx,bx
        call      dword ptr cs:ChangeBankProc
        mov       bx,0001h
        mov       dx,word ptr cs:CurrentBank
        call      dword ptr cs:ChangeBankProc
        mov       byte ptr cs:Active10,0
        pop       dx bx
        ret
WhatIsAFuckingAss EndP

WaitVBL          Proc  Far
        push      ax dx
        mov       dx,3DAh
WV1:
        in        al,dx
        and       al,8
        jnz       WV1
WV2:
        in        al,dx
        and       al,8
        jz        WV2
        pop       dx ax
        ret
WaitVBL          EndP

BuildColorTable   Proc
        push      es bx ax cx si di
        mov       bx,0
        mov       es,word ptr cs:Palette+2
BCTLoop:
        mov       ax,bx
        mov       cl,8
        shr       ax,cl
        and       al,00001111b
        shl       al,1
        shl       al,1
        mov       byte ptr cs:ColorR,al
        mov       ax,bx
        mov       cl,4
        shr       ax,cl
        and       al,00001111b
        shl       al,1
        shl       al,1
        mov       byte ptr cs:ColorG,al
        mov       al,bl
        and       al,00001111b
        shl       al,1
        shl       al,1
        mov       byte ptr cs:ColorB,al
        mov       byte ptr cs:Max,0FFh
        mov       si,0
        mov       di,word ptr cs:Palette
BCTLoop1:
        mov       al,byte ptr es:[di]
        sub       al,byte ptr cs:ColorR
        jnc       BCT1
        neg       al
BCT1:
        mov       dl,al
        inc       di
        inc       si
        mov       al,byte ptr es:[di]
        sub       al,byte ptr cs:ColorG
        jnc       BCT2
        neg       al
BCT2:
        add       dl,al
        inc       di
        inc       si
        mov       al,byte ptr es:[di]
        sub       al,byte ptr cs:ColorB
        jnc       BCT3
        neg       al
BCT3:
        add       dl,al
        cmp       dl,byte ptr cs:Max
        jae       BCT4
        mov       byte ptr cs:Max,dl
        mov       ax,si
        mov       cl,3
        div       cl
        mov       byte ptr cs:BestColor,al
BCT4:
        inc       si
        inc       di
        cmp       si,768
        jnz       BCTLoop1

        push      bx
        add       bx,offset ColorTable
        mov       al,byte ptr cs:BestColor
        mov       byte ptr cs:[bx],al
        pop       bx

        inc       bx
        cmp       bx,4096
        jz        BCTExit
        jmp       BCTLoop
BCTExit:
        pop       di si cx ax bx es
        ret
BuildColorTable   EndP

VESAInit_         Proc  Far
        push      bp
        mov       ax,word ptr ModeAttrs+0Ch
        mov       word ptr cs:ChangeBankProc,ax
        mov       ax,word ptr ModeAttrs+0Eh
        mov       word ptr cs:ChangeBankProc+2,ax

        mov       ax,word ptr ModeAttrs+12h
        mov       word ptr cs:SizeX,ax
        dec       ax
        mov       word ptr cs:WinX2,ax
        mov       word ptr cs:MouseWinX2,ax
        mov       ax,word ptr ModeAttrs+14h
        mov       word ptr cs:SizeY,ax
        dec       ax
        mov       word ptr cs:WinY2,ax
        mov       word ptr cs:MouseWinY2,ax
        xor       dx,dx
        mov       ax,word ptr ModeAttrs+06h
        div       word ptr ModeAttrs+04h
        mov       word ptr cs:GranPerBank,ax
        mov       ax,word ptr ModeAttrs+10h
        mov       word ptr cs:W,ax

        xor       bx,bx
        mov       cx,256
        push      cs
        pop       es
        mov       dx,offset StandartPalette
        mov       ax,1012h
        int       10h
        mov       ax,4F07h
        xor       bx,bx
        xor       cx,cx
        xor       dx,dx
        int       10h
        xor       dx,dx
        call WhatIsAFuckingAss
        push      cs
        pop       word ptr cs:MouseCursor+2
        mov       word ptr cs:MouseCursor,offset Cursor
        push      cs
        pop       word ptr cs:Palette+2
        mov       word ptr cs:Palette,offset StandartPalette
        call      BuildColorTable
        mov       word ptr cs:FontPointer+2,cs
        pop       bp
        ret
VESAInit_         EndP

PutPixel          Proc  Far
        arg       Color:byte,y:word,x:word=ArgSize
        mov       byte ptr cs:Active10,1
        push      bp
        mov       bp,sp

        mov       ax,y
        sub       ax,word ptr cs:WinY1
        jl        PPExit
        mov       ax,x
        sub       ax,word ptr cs:WinX1
        jl        PPExit
        mov       ax,word ptr cs:WinY2
        sub       ax,y
        jl        PPExit
        mov       ax,word ptr cs:WinX2
        sub       ax,x
        jl        PPExit

        mov       ax,y
        add       ax,word ptr cs:ActivePage
        mov       cx,x
        GetBankAndOffset
        cmp       dx,word ptr cs:CurrentBank
        jz        PPNotChangeBank
        call WhatIsAFuckingAss
PPNotChangeBank:
        mov       es,word ptr cs:VideoBuffer
        mov       al,Color
        cld
        stosb
PPExit:
        pop       bp
        mov       byte ptr cs:Active10,0
        ret       ArgSize
PutPixel          EndP

GetPixel          Proc  Far
        arg       y:word,x:word=ArgSize
        mov       byte ptr cs:Active10,1
        push      bp
        mov       bp,sp
        push      ds cs
        pop       ds
        mov       ax,y
        add       ax,word ptr ActivePage
        mov       cx,x
        GetBankAndOffset
        mov       si,di
        cmp       dx,word ptr CurrentBank
        jz        GPNotChangeBank
        call WhatIsAFuckingAss
GPNotChangeBank:
        mov       ds,word ptr cs:VideoBuffer
        cld
        lodsb
        pop       ds
        pop       bp
        mov       byte ptr cs:Active10,0
        ret       ArgSize
GetPixel          EndP

SetActivePage     Proc  Far
        arg       APage:word=ArgSize
        push      bp
        mov       bp,sp
        mov       ax,APage
        mul       word ptr cs:SizeY
        mov       word ptr cs:ActivePage,ax
        pop       bp
        ret       ArgSize
SetActivePage     EndP

SetVisualPage     Proc  Far
        arg       VPage:word=ArgSize
        push      bp
        mov       bp,sp
        mov       ax,VPage
        mul       word ptr cs:SizeY
        cmp       ax,word ptr cs:ScanLine
        je        SVPExit
        mov       dx,ax
        mov       ax,4F07h
        xor       bx,bx
        xor       cx,cx
        int       10h
SVPExit:
        pop       bp
        ret       ArgSize
SetVisualPage     EndP

PutSprite_        Proc  Far
        arg       Addr:dword,y:word,x:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds

        lds       si,Addr
        mov       bx,word ptr [si+2]
        mov       cx,word ptr [si]
        mov       word ptr cs:AddForSI,0
        add       si,4

        mov       ax,word ptr cs:WinY1
        sub       ax,y
        jle       PS1
        add       y,ax
        sub       bx,ax
        mul       cx
        add       si,ax
PS1:
        mov       ax,word ptr cs:WinX1
        sub       ax,x
        jle       PS2
        add       x,ax
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
        add       si,ax
PS2:
        mov       ax,x
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:WinX2
        jle       PS3
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
PS3:
        mov       ax,y
        add       ax,bx
        dec       ax
        sub       ax,word ptr cs:WinY2
        jle       PS4
        sub       bx,ax
PS4:
        cmp       cx,0
        jg        PSOk
        jmp       PSExit
PSOk:
        cmp       bx,0
        jg        PSVivod
        jmp       PSExit
PSVivod:
        mov       ax,y
        add       ax,word ptr cs:ActivePage
        push      cx
        mov       cx,x
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr cs:CurrentBank
        jz        PSNotChangeBank
        call WhatIsAFuckingAss
PSNotChangeBank:
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        mov       es,word ptr cs:VideoBuffer

PSMain:
        push      di
        add       di,cx
        jc        PSOverflow
        pop       di
        WriteLine
        add       di,word ptr cs:AddForNextLine
        jnc       PSNotOverflow
        add       dx,word ptr cs:GranPerBank
        call WhatIsAFuckingAss
PSNotoverflow:
        add       si,word ptr cs:AddForSI
        dec       bx
        jnz       PSMain
        jmp short PSExit
PSOverflow:
        mov       bp,di
        pop       di
        push      cx
        sub       cx,bp
        WriteLine
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        call WhatIsAFuckingAss
        or        cx,cx
        jz        PSNotGluk
        WriteLine
PSNotGluk:
        pop       cx
        add       di,word ptr cs:AddForNextLine
        add       si,word ptr cs:AddForSI
        dec       bx
        jz        PSExit
        jmp       PSMain

PSExit:
        pop       ds
        pop       bp
        ret       ArgSize
PutSprite_        EndP

XMSOffset         dd    ?
RealSize          dd    ?
BufferSize        dw    ?
BufferOffs        dw    ?
XMSBuffer         dd    ?
SaveDS            dw    ?

GetAreaASM        proc
        pusha
        push      ds es
        push      cs:SaveDS
        pop       ds
        push      word ptr cs:XMSOffset+2
        push      word ptr cs:XMSOffset
        xor       ax,ax
        push      ax
        push      cs:BufferSize
        push      cs
        mov       ax,offset XMSBuffer
        push      ax
        push      cs
        mov       ax,offset RealSize
        push      ax
        call      far ptr GetArea
        pop       es ds
        popa
        ret
GetAreaASM        endp

NextXMS           proc
        push      ax
        mov       ax,word ptr cs:RealSize
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,0
        and       si,7FFFh
        add       si,cs:BufferOffs
        call      GetAreaASM
        pop       ax
        ret
NextXMS           endp

NextXMSGet        proc
        push      ax
        mov       ax,word ptr cs:RealSize
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,0
        and       di,7FFFh
        add       di,cs:BufferOffs
        call      GetAreaASM
        pop       ax
        ret
NextXMSGet        endp

PutSprite__       Proc  Far
        arg       BufOffs:word,BufSize:word,XMSOffs:dword,Addr:dword,y:word,x:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds ds
        pop       cs:SaveDS

        mov       ax,BufSize
        mov       cs:BufferSize,ax
        mov       ax,BufOffs
        mov       cs:BufferOffs,ax
        mov       ax,word ptr XMSOffs
        mov       word ptr cs:XMSOffset,ax
        mov       ax,word ptr XMSOffs+2
        mov       word ptr cs:XMSOffset+2,ax
        lds       si,Addr
        mov       bx,word ptr [si+2]
        mov       cx,word ptr [si]
        mov       word ptr cs:AddForSI,0
        add       word ptr cs:XMSOffset,4
        adc       word ptr cs:XMSOffset+2,0

        mov       ax,word ptr cs:WinY1
        sub       ax,y
        jle       PS_1
        add       y,ax
        sub       bx,ax
        mul       cx
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,dx
PS_1:
        mov       ax,word ptr cs:WinX1
        sub       ax,x
        jle       PS_2
        add       x,ax
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,0
PS_2:
        mov       ax,x
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:WinX2
        jle       PS_3
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
PS_3:
        mov       ax,y
        add       ax,bx
        dec       ax
        sub       ax,word ptr cs:WinY2
        jle       PS_4
        sub       bx,ax
PS_4:
        cmp       cx,0
        jg        PS_Ok
        jmp       PS_Exit
PS_Ok:
        cmp       bx,0
        jg        PS_Vivod
        jmp       PS_Exit
PS_Vivod:
        mov       ax,y
        add       ax,word ptr cs:ActivePage
        push      cx
        mov       cx,x
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr cs:CurrentBank
        jz        PS_NotChangeBank
        call WhatIsAFuckingAss
PS_NotChangeBank:
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        mov       es,word ptr cs:VideoBuffer
        call      GetAreaASM
        mov       si,word ptr cs:XMSBuffer

PS_Main:
        push      di
        add       di,cx
        jc        PS_Overflow
        pop       di
        WriteLine_
        add       di,word ptr cs:AddForNextLine
        jnc       PS_NotOverflow
        add       dx,word ptr cs:GranPerBank
        call WhatIsAFuckingAss
PS_Notoverflow:
        add       si,word ptr cs:AddForSI
        jns       PS_NotOtr1
        call      NextXMS
PS_NotOtr1:
        dec       bx
        jnz       PS_Main
        jmp short PS_Exit
PS_Overflow:
        mov       bp,di
        pop       di
        push      cx
        sub       cx,bp
        WriteLine_
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        call WhatIsAFuckingAss
        or        cx,cx
        jz        PS_NotGluk
        WriteLine_
PS_NotGluk:
        pop       cx
        add       di,word ptr cs:AddForNextLine
        add       si,word ptr cs:AddForSI
        jns       PS_NotOtr2
        call      NextXMS
PS_NotOtr2:
        dec       bx
        jz        PS_Exit
        jmp       PS_Main

PS_Exit:
        pop       ds
        pop       bp
        ret       ArgSize
PutSprite__       EndP

SetWSize          Proc  Far
        arg       y2:word,x2:word,y1:word,x1:word=ArgSize
        push      bp
        mov       bp,sp
        mov       ax,x1
        mov       word ptr cs:WinX1,ax
        mov       ax,x2
        mov       word ptr cs:WinX2,ax
        mov       ax,y1
        mov       word ptr cs:WinY1,ax
        mov       ax,y2
        mov       word ptr cs:WinY2,ax
        pop       bp
        ret       ArgSize
SetWSize          EndP

GetWSize          proc  far
        arg       y2: dword, x2: dword, y1: dword, x1: dword = ArgSize
        push      bp
        mov       bp, sp
        push      es bx ax
        les       bx, x1
        mov       ax, cs:WinX1
        mov       es:[bx], ax
        les       bx, x2
        mov       ax, cs:WinX2
        mov       es:[bx], ax
        les       bx, y1
        mov       ax, cs:WinY1
        mov       es:[bx], ax
        les       bx, y2
        mov       ax, cs:WinY2
        mov       es:[bx], ax
        pop       ax bx es
        pop       bp
        ret       ArgSize
GetWSize          endp

SetPalette        Proc  Far
        arg       PalettePointer:dword=ArgSize
        push      bp
        mov       bp,sp
        xor       bx,bx
        mov       cx,256
        les       dx,PalettePointer
        mov       word ptr cs:Palette+2,es
        mov       word ptr cs:Palette,dx
        mov       ax,1012h
        int       10h
        call      BuildColorTable
        pop       bp
        ret       ArgSize
SetPalette        EndP
GetPalette        Proc  Far
        arg       PalettePointer:dword=ArgSize
        push      bp
        mov       bp,sp
        push      es ds cx
        les       di, PalettePointer
        push      cs
        pop       ds
        mov       si, offset StandartPalette
        mov       cx,768
        cld
        rep movsb
        pop       cx ds es
        pop       bp
        ret       ArgSize
GetPalette        EndP

SetStandartPalette Proc Far
        push      cs
        pop       es
        mov       dx,offset StandartPalette
        mov       word ptr cs:Palette+2,es
        mov       word ptr cs:Palette,dx
        xor       bx,bx
        mov       cx,256
        mov       ax,1012h
        int       10h
        call      BuildColorTable
        ret
SetStandartPalette EndP

SetColor          Proc  Far
        arg       Color:byte=ArgSize
        push      bp
        mov       bp,sp
        pushf
        pusha
        mov       al,Color
        mov       byte ptr cs:ActiveColor,al
        popa
        popf
        pop       bp
        ret       ArgSize
SetColor          EndP
GetColor          Proc  Far
        mov       al,byte ptr cs:ActiveColor
        ret
GetColor          EndP

Bar               Proc  Far
        arg       y2:word,x2:word,y1:word,x1:word=ArgSize
        push      bp
        mov       bp,sp
        pushf
        pusha

        mov       ax,word ptr cs:WinX1
        sub       ax,x1
        jle       B1
        add       x1,ax
B1:
        mov       ax,word ptr cs:WinY1
        sub       ax,y1
        jle       B2
        add       y1,ax
B2:
        mov       ax,x2
        sub       ax,word ptr cs:WinX2
        jle       B3
        sub       x2,ax
B3:
        mov       ax,y2
        sub       ax,word ptr cs:WinY2
        jle       B4
        sub       y2,ax
B4:
        mov       cx,x2
        inc       cx
        sub       cx,x1
        jg        BOk
        jmp       BExit
BOk:
        mov       bx,y2
        inc       bx
        sub       bx,y1
        jg        BVivod
        jmp       BExit
BVivod:
        mov       ax,y1
        add       ax,word ptr cs:ActivePage
        push      cx
        mov       cx,x1
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr cs:CurrentBank
        jz        BNotChangeBank
        call WhatIsAFuckingAss
BNotChangeBank:
        mov       si,word ptr cs:W
        sub       si,cx
        mov       es,word ptr cs:VideoBuffer
        mov       al,byte ptr cs:ActiveColor
        cld

BMain:
        push      di
        add       di,cx
        jc        BOverflow
        pop       di
        push      cx
        rep stosb
        pop       cx
        add       di,si
        jnc       BNotOverflow
        add       dx,word ptr cs:GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
BNotOverflow:
        dec       bx
        jnz       BMain
        jmp short BExit
BOverflow:
        mov       bp,di
        pop       di
        push      cx
        sub       cx,bp
        rep stosb
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
        or        cx,cx
        jz        BNotGluk
        rep stosb
BNotGluk:
        pop       cx
        add       di,si
        dec       bx
        jnz       BMain

BExit:
        popa
        popf
        pop       bp
        ret       ArgSize
Bar               EndP

PIWriteLine       Proc
        push      cx
        cld
PIM1:
        lodsb
        or        al,al
        jz        PIM2
ChooseMode:
        jmp short NormalMode
PIM2:
        inc       di
        loop      PIM1
PIM3:
        pop       cx
        ret

NormalMode:
        stosb
        loop      PIM1
        jmp short PIM3
AndMode:
        and       byte ptr es:[di],al
        inc       di
        loop      PIM1
        jmp short PIM3
XorMode:
        xor       byte ptr es:[di],al
        inc       di
        loop      PIM1
        jmp short PIM3
OrMode:
        or        byte ptr es:[di],al
        inc       di
        loop      PIM1
        jmp short PIM3
ShadowMode:
        push      ds bx cx dx
        mov       al,byte ptr es:[di]
        mov       cl,3
        mul       cl
        add       ax,word ptr cs:Palette
        mov       bx,ax

        mov       ax,word ptr cs:Palette+2
        mov       ds,ax
        mov       cl,byte ptr cs:Shadow
        mov       al,byte ptr ds:[bx]
        shr       al,cl
        mov       cl,8
        xor       ah,ah
        shl       ax,cl
        mov       dx,ax
        mov       al,byte ptr ds:[bx+1]
        mov       cl,byte ptr cs:Shadow
        shr       al,cl
        xor       ah,ah
        mov       cl,4
        shl       ax,cl
        add       dx,ax
        mov       al,byte ptr ds:[bx+2]
        mov       cl,byte ptr cs:Shadow
        shr       al,cl
        xor       ah,ah
        add       dx,ax
        add       dx,offset ColorTable
        mov       bx,dx
        mov       al,byte ptr cs:[bx]
        stosb
        pop       dx cx bx ds
        dec       cx
        jz        PIM3
        jmp       PIM1
PIWriteLine       EndP

PutImage_         Proc  Far
        arg       Reg:word,Addr:dword,y:word,x:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds

        mov       bx,Reg
        mov       ax,word ptr cs:ModeTable[bx]
        sub       ax,offset ChooseMode
        sub       al,2
        mov       byte ptr cs:[offset ChooseMode+1],al

        lds       si,Addr
        mov       bx,word ptr [si+2]
        mov       cx,word ptr [si]
        mov       word ptr cs:AddForSI,0
        add       si,4

        mov       ax,word ptr cs:WinY1
        sub       ax,y
        jle       PI1
        add       y,ax
        sub       bx,ax
        mul       cx
        add       si,ax
PI1:
        mov       ax,word ptr cs:WinX1
        sub       ax,x
        jle       PI2
        add       x,ax
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
        add       si,ax
PI2:
        mov       ax,x
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:WinX2
        jle       PI3
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
PI3:
        mov       ax,y
        add       ax,bx
        dec       ax
        sub       ax,word ptr cs:WinY2
        jle       PI4
        sub       bx,ax
PI4:
        cmp       cx,0
        jg        PIOk
        jmp       PIExit
PIOk:
        cmp       bx,0
        jg        PIVivod
        jmp       PIExit
PIVivod:
        mov       ax,y
        add       ax,word ptr cs:ActivePage
        push      cx
        mov       cx,x
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr cs:CurrentBank
        jz        PINotChangeBank
        call      WhatIsAFuckingAss
PINotChangeBank:
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        mov       es,word ptr cs:VideoBuffer

PIMain:
        push      di
        add       di,cx
        jc        PIOverflow
        pop       di
        call      PIWriteLine
        add       di,word ptr cs:AddForNextLine
        jnc       PINotOverflow
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
PINotoverflow:
        add       si,word ptr cs:AddForSI
        dec       bx
        jnz       PIMain
        jmp short PIExit
PIOverflow:
        mov       bp,di
        pop       di
        push      cx
        sub       cx,bp
        call      PIWriteLine
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
        or        cx,cx
        jz        PINotGluk
        call      PIWriteLine
PINotGluk:
        pop       cx
        add       di,word ptr cs:AddForNextLine
        add       si,word ptr cs:AddForSI
        dec       bx
        jz        PIExit
        jmp       PIMain

PIExit:
        pop       ds
        pop       bp
        ret       ArgSize
PutImage_         EndP

PI_WriteLine       Proc
        push      cx
        cld
PI_M1:
        lodsb
        test      si,8000h
        jz        PI_M4
        call      NextXMS
        cld
PI_M4:
        or        al,al
        jz        PI_M2
_ChooseMode:
        jmp short _NormalMode
PI_M2:
        inc       di
        loop      PI_M1
PI_M3:
        pop       cx
        ret

_NormalMode:
        stosb
        loop      PI_M1
        jmp short PI_M3
_AndMode:
        and       byte ptr es:[di],al
        inc       di
        loop      PI_M1
        jmp short PI_M3
_XorMode:
        xor       byte ptr es:[di],al
        inc       di
        loop      PI_M1
        jmp short PI_M3
_OrMode:
        or        byte ptr es:[di],al
        inc       di
        loop      PI_M1
        jmp short PI_M3
_ShadowMode:
        push      ds bx cx dx
        mov       al,byte ptr es:[di]
        mov       cl,3
        mul       cl
        add       ax,word ptr cs:Palette
        mov       bx,ax

        mov       ax,word ptr cs:Palette+2
        mov       ds,ax
        mov       cl,byte ptr cs:Shadow
        mov       al,byte ptr ds:[bx]
        shr       al,cl
        mov       cl,8
        xor       ah,ah
        shl       ax,cl
        mov       dx,ax
        mov       al,byte ptr ds:[bx+1]
        mov       cl,byte ptr cs:Shadow
        shr       al,cl
        xor       ah,ah
        mov       cl,4
        shl       ax,cl
        add       dx,ax
        mov       al,byte ptr ds:[bx+2]
        mov       cl,byte ptr cs:Shadow
        shr       al,cl
        xor       ah,ah
        add       dx,ax
        add       dx,offset ColorTable
        mov       bx,dx
        mov       al,byte ptr cs:[bx]
        stosb
        pop       dx cx bx ds
        dec       cx
        jz        PI_M3
        jmp       PI_M1
PI_WriteLine       EndP

PutImage__        Proc  Far
        arg       BufOffs:word,BufSize:word,XMSOffs:dword,Reg:word,Addr:dword,y:word,x:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds ds
        pop       cs:SaveDS

        mov       ax,BufSize
        mov       cs:BufferSize,ax
        mov       ax,BufOffs
        mov       cs:BufferOffs,ax
        mov       ax,word ptr XMSOffs
        mov       word ptr cs:XMSOffset,ax
        mov       ax,word ptr XMSOffs+2
        mov       word ptr cs:XMSOffset+2,ax

        mov       bx,Reg
        mov       ax,word ptr cs:_ModeTable[bx]
        sub       ax,offset _ChooseMode
        sub       al,2
        mov       byte ptr cs:[offset _ChooseMode+1],al

        lds       si,Addr
        mov       bx,word ptr [si+2]
        mov       cx,word ptr [si]
        mov       word ptr cs:AddForSI,0
        add       word ptr cs:XMSOffset,4
        adc       word ptr cs:XMSOffset+2,0

        mov       ax,word ptr cs:WinY1
        sub       ax,y
        jle       PI_1
        add       y,ax
        sub       bx,ax
        mul       cx
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,dx
PI_1:
        mov       ax,word ptr cs:WinX1
        sub       ax,x
        jle       PI_2
        add       x,ax
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,0
PI_2:
        mov       ax,x
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:WinX2
        jle       PI_3
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
PI_3:
        mov       ax,y
        add       ax,bx
        dec       ax
        sub       ax,word ptr cs:WinY2
        jle       PI_4
        sub       bx,ax
PI_4:
        cmp       cx,0
        jg        PI_Ok
        jmp       PI_Exit
PI_Ok:
        cmp       bx,0
        jg        PI_Vivod
        jmp       PI_Exit
PI_Vivod:
        mov       ax,y
        add       ax,word ptr cs:ActivePage
        push      cx
        mov       cx,x
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr cs:CurrentBank
        jz        PI_NotChangeBank
        call      WhatIsAFuckingAss
PI_NotChangeBank:
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        mov       es,word ptr cs:VideoBuffer
        call      GetAreaASM
        mov       si,word ptr cs:XMSBuffer

PI_Main:
        push      di
        add       di,cx
        jc        PI_Overflow
        pop       di
        call      PI_WriteLine
        add       di,word ptr cs:AddForNextLine
        jnc       PI_NotOverflow
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
PI_Notoverflow:
        add       si,word ptr cs:AddForSI
        jns       PI_NotOtr1
        call      NextXMS
PI_NotOtr1:
        dec       bx
        jnz       PI_Main
        jmp short PI_Exit
PI_Overflow:
        mov       bp,di
        pop       di
        push      cx
        sub       cx,bp
        call      PI_WriteLine
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
        or        cx,cx
        jz        PI_NotGluk
        call      PI_WriteLine
PI_NotGluk:
        pop       cx
        add       di,word ptr cs:AddForNextLine
        add       si,word ptr cs:AddForSI
        jns       PI_NotOtr2
        call      NextXMS
PI_NotOtr2:
        dec       bx
        jz        PI_Exit
        jmp       PI_Main

PI_Exit:
        pop       ds
        pop       bp
        ret       ArgSize
PutImage__        EndP

Line              Proc  Far
        arg       y2:word,x2:word,y1:word,x1:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds cs
        pop       ds

        cmp       x1,0
        jge       LNotLess1
        mov       x1,0
LNotLess1:
        cmp       y1,0
        jge       LNotLess2
        mov       y1,0
LNotLess2:

        KindOfLine
        jnc       LSimpleLine
        jmp       LCompleteLine

LSimpleLine:
        mov       ax,x1
        cmp       ax,x2
        jle       L01
        mov       bx,x2
        mov       x2,ax
        mov       x1,bx
L01:
        mov       ax,y1
        cmp       ax,y2
        jle       L02
        mov       bx,y2
        mov       y2,ax
        mov       y1,bx
L02:

        mov       ax,x2
        sub       ax,x1
        inc       ax
        cmp       ax,0
        jg        LOk1_
        jmp       LExit_
LOk1_:
        mov       word ptr TempX,ax
        mov       ax,y2
        sub       ax,y1
        inc       ax
        cmp       ax,0
        jg        LOk2_
        jmp       LExit_
LOk2_:
        mov       word ptr TempY,ax
        mov       ax,word ptr TempX
        mov       cx,word ptr TempY
        cmp       ax,word ptr TempY
        ja        LA
        mov       ax,word ptr TempY
        mov       cx,word ptr TempX
LA:
        mov       si,word ptr TempX
        mul       cx
        mov       word ptr TempX,dx
        mov       bx,ax
        push      cx
        mov       ax,y1
        mov       word ptr CurrentY,ax
        add       ax,word ptr ActivePage
        mov       cx,x1
        mov       word ptr CurrentX,cx
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr CurrentBank
        jz        LNotChange
        call      WhatIsAFuckingAss
LNotChange:
        mov       bp,word ptr TempY
        push      bx dx
        mov       bx,2
        mov       ax,si
        dec       ax
        xor       dx,dx
        div       bx
        mov       word ptr TempX1,ax
        mov       ax,bp
        dec       ax
        xor       dx,dx
        div       bx
        mov       word ptr TempY1,ax
        pop       dx bx
        mov       es,word ptr VideoBuffer
        mov       al,byte ptr ActiveColor
        cld

LMain:
        PixelInWindow
        jc        LNotShow
        stosb
        jmp short LB
LNotShow:
        inc       di
LB:
        inc       word ptr CurrentX
        sub       bx,cx
        jz        LExit
        sbb       word ptr TempX,0
        add       word ptr TempX1,cx
        cmp       word ptr TempX1,bp
        jb        LOk1
        sub       word ptr TempX1,bp
        cmp       di,0
        jnz       LNotOverflow1
        add       dx,word ptr GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
LNotOverflow1:
        jmp short LY
LOk1:
        dec       di
        dec       word ptr CurrentX
LY:
        add       word ptr TempY1,cx
        cmp       word ptr TempY1,si
        jb        LOk2
        sub       word ptr TempY1,si
        inc       word ptr CurrentY
        add       di,word ptr W
        jnc       LNotOverflow2
        add       dx,word ptr GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
LNotOverflow2:
LOk2:
        jmp       LMain

LExit:
        cmp       word ptr TempX,0
        jz        LExit_
        jmp       LMain
LExit_:
        pop       ds
        pop       bp
        ret       ArgSize

LCompleteLine:
        mov       ax,x1
        cmp       ax,x2
        jle       L_01
        mov       bx,x2
        mov       x2,ax
        mov       x1,bx
        mov       bx,y2
        mov       ax,y1
        mov       y2,ax
        mov       y1,bx
L_01:
        mov       ax,x2
        sub       ax,x1
        inc       ax
        cmp       ax,0
        jg        L_Ok1_
        jmp       L_Exit_
L_Ok1_:
        mov       word ptr TempX,ax
        mov       ax,y1
        sub       ax,y2
        inc       ax
        cmp       ax,0
        jg        L_Ok2_
        jmp       L_Exit_
L_Ok2_:
        mov       word ptr TempY,ax
        mov       ax,word ptr TempX
        mov       cx,word ptr TempY
        cmp       ax,word ptr TempY
        ja        L_A
        mov       ax,word ptr TempY
        mov       cx,word ptr TempX
L_A:
        mov       si,word ptr TempX
        mul       cx
        mov       word ptr TempX,dx
        mov       bx,ax
        push      cx
        mov       ax,y1
        mov       word ptr CurrentY,ax
        add       ax,word ptr ActivePage
        mov       cx,x1
        mov       word ptr CurrentX,cx
        GetBankAndOffset
        pop       cx
        cmp       dx,word ptr CurrentBank
        jz        L_NotChange
        call      WhatIsAFuckingAss
L_NotChange:
        mov       bp,word ptr TempY
        push      bx dx
        mov       bx,2
        mov       ax,si
        dec       ax
        xor       dx,dx
        div       bx
        mov       word ptr TempX1,ax
        mov       ax,bp
        dec       ax
        xor       dx,dx
        div       bx
        mov       word ptr TempY1,ax
        pop       dx bx
        mov       es,word ptr VideoBuffer
        mov       al,byte ptr ActiveColor
        cld

L_Main:
        PixelInWindow
        jc        L_NotShow
        stosb
        jmp short L_B
L_NotShow:
        inc       di
L_B:
        inc       word ptr CurrentX
        sub       bx,cx
        jz        L_Exit
        sbb       word ptr TempX,0
        add       word ptr TempX1,cx
        cmp       word ptr TempX1,bp
        jb        L_Ok1
        sub       word ptr TempX1,bp
        cmp       di,0
        jnz       L_NotOverflow1
        add       dx,word ptr GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
L_NotOverflow1:
        jmp short L_Y
L_Ok1:
        dec       di
        dec       word ptr CurrentX
L_Y:
        add       word ptr TempY1,cx
        cmp       word ptr TempY1,si
        jb        L_Ok2
        sub       word ptr TempY1,si
        dec       word ptr CurrentY
        sub       di,word ptr W
        jnc       L_NotOverflow2
        sub       dx,word ptr GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
L_NotOverflow2:
L_Ok2:
        jmp       L_Main

L_Exit:
        cmp       word ptr TempX,0
        jz        L_Exit_
        jmp       L_Main
L_Exit_:
        pop       ds
        pop       bp
        ret       ArgSize
Line              EndP

GetImage_         Proc  Far
        arg       Addr:dword,y2:word,x2:word,y1:word,x1:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds

        les       di,Addr
        mov       bx,y2
        sub       bx,y1
        inc       bx
        mov       cx,x2
        sub       cx,x1
        inc       cx
        mov       word ptr es:[di],cx
        mov       word ptr es:[di+2],bx
        mov       word ptr cs:AddForSI,0
        add       di,4

        mov       ax,word ptr cs:WinY1
        sub       ax,y1
        jle       GI1
        add       y1,ax
        sub       bx,ax
        mul       cx
        add       di,ax
GI1:
        mov       ax,word ptr cs:WinX1
        sub       ax,x1
        jle       GI2
        add       x1,ax
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
        add       di,ax
GI2:
        mov       ax,x1
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:WinX2
        jle       GI3
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
GI3:
        mov       ax,y1
        add       ax,bx
        dec       ax
        sub       ax,word ptr cs:WinY2
        jle       GI4
        sub       bx,ax
GI4:
        cmp       cx,0
        jg        GIOk
        jmp       GIExit
GIOk:
        cmp       bx,0
        jg        GIVivod
        jmp       GIExit
GIVivod:
        mov       ax,y1
        add       ax,word ptr cs:ActivePage
        push      cx di
        mov       cx,x1
        GetBankAndOffset
        mov       si,di
        pop       di cx
        cmp       dx,word ptr cs:CurrentBank
        jz        GINotChangeBank
        call      WhatIsAFuckingAss
GINotChangeBank:
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        mov       ds,word ptr cs:VideoBuffer

GIMain:
        push      si
        add       si,cx
        jc        GIOverflow
        pop       si
        GetLine
        add       si,word ptr cs:AddForNextLine
        jnc       GINotOverflow
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
GINotoverflow:
        add       di,word ptr cs:AddForSI
        dec       bx
        jnz       GIMain
        jmp short GIExit
GIOverflow:
        mov       bp,si
        pop       si
        push      cx
        sub       cx,bp
        GetLine
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
        or        cx,cx
        jz        GINotGluk
        GetLine
GINotGluk:
        pop       cx
        add       si,word ptr cs:AddForNextLine
        add       di,word ptr cs:AddForSI
        dec       bx
        jz        GIExit
        jmp       GIMain

GIExit:
        pop       ds
        pop       bp
        ret       ArgSize
GetImage_         EndP

GetImage__        Proc  Far
        arg       BufOffs:word,BufSize:word,XMSOffs:dword,Addr:dword,y2:word,x2:word,y1:word,x1:word=ArgSize
        push      bp
        mov       bp,sp
        push      ds ds
        pop       cs:SaveDS

        mov       ax,BufSize
        mov       cs:BufferSize,ax
        mov       ax,BufOffs
        mov       cs:BufferOffs,ax
        mov       ax,word ptr XMSOffs
        mov       word ptr cs:XMSOffset,ax
        mov       ax,word ptr XMSOffs+2
        mov       word ptr cs:XMSOffset+2,ax

        les       di,Addr
        mov       bx,y2
        sub       bx,y1
        inc       bx
        mov       cx,x2
        sub       cx,x1
        inc       cx
        mov       word ptr es:[di],cx
        mov       word ptr es:[di+2],bx
        mov       word ptr cs:AddForSI,0
        add       word ptr cs:XMSOffset,4
        adc       word ptr cs:XMSOffset+2,0

        mov       ax,word ptr cs:WinY1
        sub       ax,y1
        jle       GI_1
        add       y1,ax
        sub       bx,ax
        mul       cx
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,dx
GI_1:
        mov       ax,word ptr cs:WinX1
        sub       ax,x1
        jle       GI_2
        add       x1,ax
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
        add       word ptr cs:XMSOffset,ax
        adc       word ptr cs:XMSOffset+2,0
GI_2:
        mov       ax,x1
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:WinX2
        jle       GI_3
        sub       cx,ax
        add       word ptr cs:AddForSI,ax
GI_3:
        mov       ax,y1
        add       ax,bx
        dec       ax
        sub       ax,word ptr cs:WinY2
        jle       GI_4
        sub       bx,ax
GI_4:
        cmp       cx,0
        jg        GI_Ok
        jmp       GI_Exit
GI_Ok:
        cmp       bx,0
        jg        GI_Vivod
        jmp       GI_Exit
GI_Vivod:
        mov       ax,y1
        add       ax,word ptr cs:ActivePage
        push      cx di
        mov       cx,x1
        GetBankAndOffset
        mov       si,di
        pop       di cx
        cmp       dx,word ptr cs:CurrentBank
        jz        GI_NotChangeBank
        call      WhatIsAFuckingAss
GI_NotChangeBank:
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        mov       ds,word ptr cs:VideoBuffer
        call      GetAreaASM
        mov       di,word ptr cs:XMSBuffer

GI_Main:
        push      si
        add       si,cx
        jc        GI_Overflow
        pop       si
        GetLine_
        add       si,word ptr cs:AddForNextLine
        jnc       GI_NotOverflow
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
GI_Notoverflow:
        add       di,word ptr cs:AddForSI
        jns       GI_NotOtr1
        call      NextXMSGet
GI_NotOtr1:
        dec       bx
        jnz       GI_Main
        jmp short GI_Exit
GI_Overflow:
        mov       bp,si
        pop       si
        push      cx
        sub       cx,bp
        GetLine_
        mov       cx,bp
        add       dx,word ptr cs:GranPerBank
        call      WhatIsAFuckingAss
        or        cx,cx
        jz        GI_NotGluk
        GetLine_
GI_NotGluk:
        pop       cx
        add       si,word ptr cs:AddForNextLine
        add       di,word ptr cs:AddForSI
        jns       GI_NotOtr2
        call      NextXMSGet
GI_NotOtr2:
        dec       bx
        jz        GI_Exit
        jmp       GI_Main

GI_Exit:
        pop       ds
        pop       bp
        ret       ArgSize
GetImage__        EndP

GetMaxX           Proc  Far
        mov       ax,word ptr cs:SizeX
        dec       ax
        ret
GetMaxX           EndP
GetMaxY           Proc  Far
        mov       ax,word ptr cs:SizeY
        dec       ax
        ret
GetMaxY           EndP

SaveCurrentX      dw    ?

OutText           Proc  Far
        arg       Addr:dword,y:word,x:word=ArgSize
        push      bp
        mov       bp,sp
        pushf
        pusha
        push      ds

        mov       ax,y
        mov       word ptr cs:CurrentY,ax
        add       ax,word ptr cs:ActivePage
        mov       cx,x
        mov       word ptr cs:CurrentX,cx
        mov       word ptr cs:SaveCurrentX,cx
        GetBankAndOffset
        cmp       dx,word ptr cs:CurrentBank
        jz        OTNotChange
        call      WhatIsAFuckingAss
OTNotChange:
        mov       es,word ptr cs:VideoBuffer
        lds       si,Addr
        xor       ch,ch
        mov       cl,byte ptr [si]
        push      cx
        shl       cx,1
        shl       cx,1
        shl       cx,1
        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForNextLine,ax
        pop       cx
        inc       si
        mov       bp,0
        mov       bx,word ptr cs:FontPointer
        cld
OTMain:
        push      si
        push      cx
OTAllLine:
        push      bx
        lodsb
        xor       ah,ah
        shl       ax,1
        shl       ax,1
        shl       ax,1
        shl       ax,1
        add       bx,ax
        add       bx,bp
        push      es cx
        mov       cx,word ptr cs:FontPointer+2
        mov       es,cx
        mov       al,byte ptr es:[bx]
        pop       cx es
        pop       bx
        push      cx
        mov       cx,8
OTOneLine:
        shl       al,1
        jnc       OTEmpty
        push      ds cs
        pop       ds
        PixelInWindow
        pop       ds
        jc        OTEmpty
        mov       ah,byte ptr cs:ActiveColor
        mov       byte ptr es:[di],ah
OTEmpty:
        inc       di
        inc       word ptr cs:CurrentX
        or        di,di
        jnz       OTNotOverflow
        add       dx,word ptr cs:GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
OTNotOverflow:
        loop      OTOneLine
        pop       cx
        loop      OTAllLine
        push      ax
        mov       ax,cs:SaveCurrentX
        mov       cs:CurrentX,ax
        inc       word ptr cs:CurrentY
        pop       ax
        add       di,word ptr cs:AddForNextLine
        jnc       OTNotOverflow1
        add       dx,word ptr cs:GranPerBank
        push      ax
        call      WhatIsAFuckingAss
        pop       ax
OTNotOverflow1:
        pop       cx
        pop       si
        inc       bp
        cmp       bp,16
        jz        OTExit
        jmp       OTMain
OTExit:

        pop       ds
        popa
        popf
        pop       bp
        ret       ArgSize
OutText           EndP

;       Mouse     Procedures

InitMouse         Proc  Far
        mov       byte ptr MouseFlag,1
        mov       ax,3510h
        int       21h
        mov       cs:Old10h,bx
        mov       cs:Old10h+2,es
        push      ds
        push      cs
        pop       ds
        mov       ax,2510h
        mov       dx,offset New10h
        int       21h
        pop       ds

        mov       ax,0000h
        int       33h

        mov       cx,00111111b
        mov       dx,offset MouseHandler
        push      es cs
        pop       es
        mov       ax,000Ch
        int       33h
        pop       es
        mov       ax,0007h
        mov       cx,0
        mov       dx,word ptr cs:MouseWinX2
        int       33h
        mov       ax,0008h
        mov       cx,0
        mov       dx,word ptr cs:MouseWinY2
        int       33h
        mov       ax,0004h
        mov       cx,0
        mov       dx,0
        int       33h
        ret
InitMouse         EndP

DoneMouse         Proc  Far
        mov       byte ptr MouseFlag,0
        xor       cx,cx
        mov       dx,offset MouseHandler
        push      es cs
        pop       es
        mov       ax,000Ch
        int       33h
        pop       es
        mov       ah,25h
        mov       al,10h
        mov       bx,cs:[offset Old10h+2]
        push      ds
        mov       ds,bx
        mov       dx,cs:[offset Old10h]
        int       21h
        pop       ds
        mov       ax,0007h
        mov       cx,0
        mov       dx,word ptr cs:MouseWinX2
        int       33h
        mov       ax,0008h
        mov       cx,0
        mov       dx,word ptr cs:MouseWinY2
        int       33h
        mov       ax,0004h
        mov       cx,0
        mov       dx,0
        int       33h
        mov       cs:XC,0
        mov       cs:YC,0
        ret
DoneMouse         EndP

MouseHandler      Proc  Far
        pushf
        cmp       byte ptr cs:MouseIsActive,0
        jnz       MExit
        mov       byte ptr cs:MouseIsActive,1
        push      ax bx cx dx es ds si di bp
        push      cs
        pop       ds
        mov       word ptr NewXC,cx
        mov       word ptr NewYC,dx
        cmp       byte ptr Show,1
        jne       _NotShow
        cmp       byte ptr Active10,1
        je        _NotShow
        cmp       byte ptr Active10,2
        je        _Exit
        call      Clear
        call      NewCoords
        call      Perevod
        call      SetMouseBank
        call      NewPutGet
        call      LoadCurrentBank
        jmp short _Exit
_NotShow:
        call      NewCoords
_Exit:
        pop       bp di si ds es dx cx bx ax
        mov       byte ptr cs:MouseIsActive,0
MExit:
        popf
        retf
MouseHandler      EndP

NewCoords         Proc
        mov       ax,word ptr NewXC
        mov       word ptr XC,ax
        mov       ax,word ptr NewYC
        mov       word ptr YC,ax
        ret
NewCoords         EndP

New10h            Proc  Far
        push      ds cs
        pop       ds
        cmp       ax,4F07h
        je        ChangePage
        jmp       NotChangePage
ChangePage:
        mov       byte ptr cs:Active10,1
        push      ax
        mov       ax,word ptr scanline
        mov       word ptr oldscanline,ax
        pop       ax
        mov       word ptr scanline,dx

        cmp       byte ptr Show,1
        jne       NotShow2
        push      ax bx cx dx si di es ds bp
        mov       ax,Buffer
        mov       word ptr OldBuffer,ax
        cmp       ax,offset Buffer1
        jz        Set2
        mov       word ptr Buffer,offset Buffer1
        jmp short Dal
Set2:
        mov       word ptr Buffer,offset Buffer2
Dal:
        mov       ax,UWinPos
        mov       OldBank,ax
        mov       ax,Offs
        mov       OldOffs,ax
        call      Perevod
        call      SetMouseBank
        call      NewPutGet
        call      LoadCurrentBank
        pop       bp ds es di si dx cx bx ax
NotShow2:

        call      WaitVBL
        pushf
        call      dword ptr cs:Old10h
        mov       byte ptr cs:Active10,0
        call      WaitVBL

        cmp       byte ptr Show,1
        jne       NotShow1
        push      ax bx cx dx si di es ds bp
        push      cs
        pop       ds
        push      word ptr UWinPos
        push      word ptr Offs
        mov       ax,word ptr OldBank
        mov       word ptr UWinPos,ax
        mov       ax,word ptr OldOffs
        mov       word ptr Offs,ax
        push      word ptr Buffer
        mov       ax,word ptr OldBuffer
        mov       word ptr Buffer,ax
        call      Clear
        pop       word ptr Buffer
        pop       word ptr Offs
        pop       word ptr UWinPos
        call      LoadCurrentBank
        pop       bp ds es di si dx cx bx ax
NotShow1:
        pop       ds
        iret
NotChangePage:
        pushf
        call      dword ptr cs:old10h
        pop       ds
        iret
New10h            EndP

ShowMouse         Proc  Far
        mov       byte ptr cs:Active10,1
        cmp       byte ptr cs:Show,0
        jnz       SMExit
        push      bp
        push      ds cs
        pop       ds
        mov       byte ptr Show,1
        call      Perevod
        call      SetMouseBank
        call      NewPutGet
        call      LoadCurrentBank
        pop       ds
        pop       bp
SMExit:
        mov       byte ptr cs:Active10,0
        ret
ShowMouse         EndP

HideMouse         Proc  Far
        mov       byte ptr cs:Active10,1
        cmp       byte ptr cs:Show,1
        jnz       HMExit
        push      bp
        push      ds cs
        pop       ds
        mov       byte ptr cs:Show,0
        call      Clear
        call      LoadCurrentBank
        pop       ds
        pop       bp
HMExit:
        mov       byte ptr cs:Active10,0
        ret
HideMouse         EndP

SetMousePosition  Proc  Far
        arg       y:word,x:word=ArgSize
        mov       byte ptr cs:Active10,1
        push      bp
        mov       bp,sp

        mov       ax,0004h
        mov       cx,x
        mov       cs:XC,cx
        mov       dx,y
        mov       cs:YC,dx
        int       33h

        pop       bp
        mov       byte ptr cs:Active10,0
        ret       ArgSize
SetMousePosition  EndP

SetMouseArea      proc  far
        arg       y2:word,x2:word,y1:word,x1:word=ArgSize
        mov       byte ptr cs:Active10,1
        push      bp
        mov       bp,sp

        mov       ax,0007h
        mov       cx,x1
        mov       dx,x2
        int       33h
        mov       ax,0008h
        mov       cx,y1
        mov       dx,y2
        int       33h
        mov       ax,0004h
        mov       cx,x1
        mov       cs:XC,cx
        mov       dx,y1
        mov       cs:YC,dx
        int       33h

        pop       bp
        mov       byte ptr cs:Active10,0
        ret       ArgSize
SetMouseArea      endp

LoadCurrentBank   Proc             ;Восстановить текущий банк
        mov       dx,word ptr cs:CurrentBank
        call      WhatIsAFuckingAss
        ret
LoadCurrentBank   EndP

SetMouseBank      Proc
        push      bx dx
        xor       bx,bx
        mov       dx,word ptr cs:UwinPos
        push      dx
        call      dword ptr ChangeBankProc
        pop       dx
        mov       bx,0001h
        call      dword ptr ChangeBankProc
        pop       dx bx
        ret
SetMouseBank      EndP

Clear             Proc
        push      bp
        call      SetMouseBank
        mov       es,word ptr VideoBuffer
        mov       di,word ptr Offs
        mov       si,Buffer
        mov       cx,word ptr [si]
        mov       bp,word ptr [si+2]
        mov       word ptr AddForMouseSI,0
        mov       word ptr AddForMouseLine,0
        add       si,4

        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForMouseLine,ax

CMain:
        push      di
        add       di,cx
        jc        COverflow
        pop       di
        ClearLine
        add       di,word ptr AddForMouseLine
        jnc       CNotOverflow
        call      NextBank
CNotOverflow:
        dec       bp
        jnz       CMain
        jmp short CExit
COverflow:
        mov       dx,di
        pop       di
        push      cx
        sub       cx,dx
        ClearLine
        mov       cx,dx
        call      NextBank
        or        cx,cx
        jz        CNotGluk
        ClearLine
CNotGluk:
        pop       cx
        add       di,word ptr AddForMouseLine
        dec       bp
        jnz       CMain

CExit:
        push      word ptr XC
        pop       word ptr OldXC
        push      word ptr YC
        pop       word ptr OldYC
        pop       bp
        ret
Clear             EndP

Perevod           Proc
        mov       ax,word ptr YC
        add       ax,word ptr ScanLine
        mov       cx,word ptr XC
        GetBankAndOffset
        mov       word ptr Offs,di
        mov       word ptr UWinPos,dx
        ret
Perevod           EndP

NewPutGet         Proc
        mov       es,word ptr VideoBuffer
        mov       di,word ptr Offs
        push      ds bp
        lds       si,cs:MouseCursor
        mov       bp,word ptr [si+2]
        mov       bx,word ptr cs:Buffer
        mov       cx,word ptr [si]
        add       si,4
        mov       word ptr cs:AddForMouseSI,0

        mov       ax,word ptr cs:XC
        add       ax,cx
        dec       ax
        sub       ax,word ptr cs:MouseWinX2
        jle       NPG3
        sub       cx,ax
        add       word ptr cs:AddForMouseSI,ax
NPG3:
        mov       ax,word ptr cs:YC
        add       ax,bp
        dec       ax
        sub       ax,word ptr cs:MouseWinY2
        jle       NPG4
        sub       bp,ax
NPG4:

        mov       word ptr cs:[bx],cx
        mov       word ptr cs:[bx+2],bp
        add       bx,4

        mov       ax,word ptr cs:W
        sub       ax,cx
        mov       word ptr cs:AddForMouseLine,ax

OutCursor:
        push      di
        add       di,cx
        jc        NPGOverflow
        pop       di
        PutGetLine
        add       si,word ptr cs:AddForMouseSI
        add       di,word ptr cs:AddForMouseLine
        jnc       NPGNotOverflow
        call      NextBank
NPGNotOverflow:
        dec       bp
        jnz       OutCursor
        jmp short NPGExit
NPGOverflow:
        mov       dx,di
        pop       di
        push      cx
        sub       cx,dx
        PutGetLine
        mov       cx,dx
        call      NextBank
        or        cx,cx
        jz        NPGNotGluk
        PutGetLine
NPGNotGluk:
        pop       cx
        add       di,word ptr cs:AddForMouseLine
        add       si,word ptr cs:AddForMouseSI
        dec       bp
        jz        NPGExit
        jmp       OutCursor

NPGExit:
        pop       bp ds
        ret
NewPutGet         EndP

NextBank          Proc
        push      bx dx
        xor       bx,bx
        mov       dx,word ptr cs:Uwinpos
        add       dx,word ptr cs:GranPerBank
        push      dx
        call      dword ptr cs:ChangeBankProc
        pop       dx
        mov       bx,0001h
        call      dword ptr cs:ChangeBankProc
        pop       dx bx
        ret
NextBank          EndP

MouseX            Proc  Far
        mov       ax,word ptr cs:XC
        ret
MouseX            EndP
MouseY            Proc  Far
        mov       ax,word ptr cs:YC
        ret
MouseY            EndP
MouseButton       Proc  Far
        mov       ax,0003h
        int       33h
        mov       ax,bx
        ret
MouseButton       EndP
SetUserCursor     Proc  Far
        arg       Addr:dword=ArgSize
        push      bp
        mov       bp,sp
        les       di,Addr
        mov       ax,word ptr es:[di]
        mul       word ptr es:[di+2]
        cmp       ax,2000
        ja        SUCNotSet
        mov       word ptr cs:MouseCursor,di
        mov       word ptr cs:MouseCursor+2,es
SUCNotSet:
        pop       bp
        ret       ArgSize
SetUserCursor     EndP
SetStandartCursor Proc  Far
        push      cs
        pop       word ptr cs:MouseCursor+2
        mov       word ptr cs:MouseCursor,offset Cursor
        ret
SetStandartCursor EndP
SetShadowMode     Proc  Far
        arg       SM:byte=ArgSize
        push      bp
        mov       bp,sp

        mov       al,SM
        mov       byte ptr cs:Shadow,al

        pop       bp
        ret       ArgSize
SetShadowMode     EndP

SetUserRasterFont Proc  Far
        arg       Addr:dword=ArgSize
        push      bp
        mov       bp,sp

        mov       ax,word ptr Addr
        mov       word ptr cs:FontPointer,ax
        mov       ax,word ptr Addr+2
        mov       word ptr cs:FontPointer+2,ax

        pop       bp
        ret       ArgSize
SetUserRasterFont EndP

SetStandartRasterFont proc far
        mov       word ptr cs:FontPointer,offset StandartFont
        mov       word ptr cs:FontPointer+2,cs
        ret
SetStandartRasterFont endp

Code    EndS
End