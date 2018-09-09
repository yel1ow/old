;101 - Не хватает памяти для новой особой области
;102 - Нет особых областей
;201 - Мышь

.286

code            segment

                public VESAInit,GetModeInfo,GraphResult,VESADone,putpixel,setactivepage
                public setdacregister,readdacregister,setdacblock,readdacblock,setvisualpage

ModeAttrs       dw ?
WinAAttrs       db ?
WinBAttrs       db ?
WinGran         dw ?
WinSize         dw ?
StartSegA       dw ?
StartSegB       dw ?
WPosPtr         dd ?
ByteInLine      dw ?
ScreenX         dw ?
ScreenY         dw 640
CharWidth       db ?
CharHeight      db ?
MemPlanes       db ?
BitsPerPixel    db ?
Banks           db ?
MemModel        db ?
BankSize        db ?
ImagePages      db ?
RestOfBuffer    db 236 dup (?)
GranPerBank     dw 1
_Result         db ?
_GranSize       dw ?
_GranUnit       dw ?
_Color          db ?
_XAdd           dw ?
_CurX           dw ?
_CurY           dw ?
_MouseAnimPtr   dd ?
_MouseVisible   db ?
_MouseX         dw ?
_MouseY         dw ?
_NewMouseX      dw ?
_NewMouseY      dw ?
_CurAnimPtr     dd ?
_MouseSwap      db 1024 dup (?)
_HotSpotX       db 0
_HotSpotY       db 0
_CurFrame       db ?
_MaxFrame       db ?
_DeltaX         db ?
_DeltaY         db ?
_TmpGran        dw ?
MCurX           dw ?
MCurY           dw ?
MXCopy          dw ?
MXAdd           dw ?
_CtrlByte       db ?
_MouseDelay     db ?
_CurDelay       db ?
_CommonCursor   dd ?
_SpecialArea    dw 64 dup (?)
_0CIdle         db ?
_08Idle         db ?
_Areas          dw 384 dup (?)
_LastArea       dw ?
_NAreas         db ?
_ProtTmp        db ?
_OldPalette     db 768 dup (?)
_WriteMode      db ?
_VMinX          dw ?
_VMinY          dw ?
_VMaxX          dw ?
_VMaxY          dw ?
_LDX            dw ?
_LDY            dw ?
_LDXBelow0      db ?
_MouseIdle      dw ?
_EMSGet         dd ?
_EMSFree        dd ?
_EMSMap         dd ?
_EMSFrame       dd ?
EMSTMP          dw ?
EMSFrame        dw ?
Error1          db 'Ошибка : функция или режим не поддерживается VESA!',0Ah,0Dh,'$'
Error2          db 'Ошибка : режим не поддерживается модулем VX!',0Ah,0Dh,'$'
Error201        db 'Ошибка : драйвер мыши не найден или не работает!',0Ah,0Dh,'$'
ShadowColors    db 256 dup (0)
glases1         dw 0
glases2         dw 0
Texture         dd 0
TextLeng        dw 0
TextHigh        dw 0
MapStart        dw 0
MapBank         dw 0
XWinSize        dw 0
YWinSize        dw 0
YWinSize_       dw 0
XMap            dw 0
YMap            dw 0
XSizeMap        dw 0
YSizeMap        dw 0
XDop            dw 0
BitImage        dw 0
List            dw 0
FirstElem       dw 0
CurPage         dw 0
CurOffs         dw 0
CurP            dw 0
CurO            dw 0
SprTable        dw 256 dup (0)
OldDS           dw 0
OldSI           dw 0
OldDI           dw 0
OldBP           dw 0
CurXC           dw 0
CurYC           dw 0
CurXSize        dw 0
CurYSize        dw 0
XAdd_           dw 0
XScrAdd         dw 0
MaskAdd         dw 0
MaskOld         db 80h
TMPX            dw 0
TMPY            dw 0
CLEARSW         db 0
SecondPageBank  dw 0
BankAdder       dw 0
MouseBankAdder  dw 0
CurXPage        dw 0
CurYPage        dw 0
VPage           db 0
APage           db 0
EmsP1           dw 0
EmsP2           dw 0
EmsP3           dw 0
EmsP4           dw 0

                include vx.mac
                include cursor.asm
                include cur.asm
                include cur2.asm
                include Hand.asm
                include RepCur.asm
                include Sold.asm

                include ChronCur.asm
                include Arrowu.asm
                include Arrowd.asm
                include Arrowr.asm
                include Arrowl.asm
                include NoScroll.asm
                include font.asm
                include palette.asm

BackGrPg1       dw 0           ; Textures
BackGrPg2       dw 0           ; Textures
BackGrPg3       dw 0           ; Ages offset and
BackGrPg4       dw 0           ; map contains
BackGrPg5       dw 0           ; Second plane
BackGrPg6       dw 0           ; images (with empty color)

tmp1            dw 0
tmp2            dw 0


                assume cs:code

Error           proc
                ;input  : ds:dx - ErrMsg
                mov  ax,00003h
                int  10h
                mov  ah,09h
                int  21h
                ret
Error           endp


SwitchGran      proc
                ;input  : dx - NewGran
                cmp  dx,_GranUnit
                jz   SGNoSwitch
                push ax bx dx
                mov  _GranUnit,dx
                mov  ax,dx
                add  ax,cs:BankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                xor  bx,bx
                call dword ptr cs:WPosPtr
                pop  dx bx ax
SGNoSwitch:     ret
SwitchGran      endp


GetModeInfo     proc far
                arg Mode:word=ArgSize
                push bp
                mov  bp,sp
                push es
                mov  _Result,0
                mov  ax,04F01h
                mov  cx,Mode
                push cs
                pop  es
                mov  di,offset ModeAttrs
                int  10h
                cmp  ax,0004Fh
                jz   GMIOk
                ErrorI 1
GMIOk:          pop  es
                pop  bp
                ret  ArgSize
GetModeInfo     endp

VESAInit        proc far
                arg Mode:word=ArgSize
                push bp
                mov  bp,sp
                push ax bx cx dx ds es
                mov  _Result,0
                mov  ax,Mode
                push ax
                call GetModeInfo
                mov  ax,WinGran
                cmp  ax,0041h                    ;WinGran>64
                jc   VINxtChk                    ;нет
                jmp  VISomeErr1                  ;да
VINxtChk:       cmp  ax,0004h                    ;WinGran<4
                jc   VISomeErr1                  ;да
                mov  ax,64
                jmp  VIOk2                       ;нет
VISomeErr1:
                ErrorI 2                         ;ОШИБКА!
                jmp  VIExit
VIOk2:          shl  ax,10                       ;умножим на 1024
                mov  _GranSize,ax                ;и запомним в _GranSize
                xor  dx,dx
                mov  ax,cs:WinSize
                cmp  ax,40h
                jnz  VISomeErr1
                div  cs:WinGran
                mov  GranPerBank,ax
                mov  word ptr cs:WinGran,64
                mov  _VMinX,0
                mov  _VMinY,0
                mov  ax,ScreenX
                dec  ax
                mov  _VMaxX,ax
                mov  ax,ScreenY
                dec  ax
                mov  _VMaxY,ax                   ;задали границы
                mov  ax,04F02h
                mov  bx,Mode
                int  10h                         ;пытаемся перейти в режим
                cmp  ax,0004Fh
                jz   VIOk0                       ;удалось
                ErrorI 1                         ;не удалось
                jmp  VIExit
VIOk0:          mov  ax,04F05h
                xor  bx,bx
                xor  dx,dx
                int  10h                         ;устанавливаем 0-й Gran
                mov  _GranUnit,0
                cmp  ax,0004Fh                   ;а вдруг не получилось?
                jz   VIOk1                       ;все в порядке
                ErrorI 1                         ;ОШИБКА!
                jmp  VIExit
VIOk1:          cmp  MemModel,4                  ;та ли модель памяти?
                jz   VIOk3                       ;да
                ErrorI 2                         ;нет
                jmp  VIExit
VIOk3:          mov  ax,1017h
                xor  bx,bx
                mov  cx,256
                push cs
                pop  es
                mov  dx,offset _OldPalette
                int  10h                         ;возьмем старую палитру
                mov  ax,1012h
                xor  bx,bx
                mov  cx,256
                push cs
                pop  es
                mov  dx,offset StandardPalette
                int  10h                         ;установим стандартную палитру
                mov  byte ptr _Color,15
                mov  byte ptr _WriteMode,0
                mov  ax,cs:ScreenY
                mov  bx,cs:ScreenX
                mul  bx
                inc  dx
                mov  cs:SecondPageBank,dx
                xor  ax,ax
                div  bx
                mov  cs:CurYPage,ax
                ;inc  dx  ;???
                mov  cs:CurXPage,dx
                mov  word ptr cs:BankAdder,0
VIExit:         pop  es ds dx cx bx ax bp
                ret  ArgSize
VESAInit        endp

GraphResult     proc far
                mov  al,_Result
                ret
GraphResult     endp

VESADone        proc far
                mov  ax,00003h
                int  10h
                ret
VESADone        endp

PutPixel        proc far
                arg Color:byte,y,x:word=ArgSize
                push bp
                mov  bp,sp
                push di es
                mov  ax,0A000h
                mov  es,ax
                mov  ax,y
                mov  bx,ScreenX
                mul  bx
                add  ax,x
                adc  dx,0
                mov  bx,0400h
                div  bx
                mov  cx,dx
                xor  dx,dx
                mov  bx,WinGran
                div  bx
                shl  dx,10
                add  cx,dx
                mov  dx,ax
                mov  di,cx
                cmp  dx,_GranUnit
                jz   PPNoSwitch
                mov  _GranUnit,dx
              ;  push ax
                mov  bx,ax      ;моя вставка
                mov  ax,dx
                add  ax,cs:BankAdder
                mul  cs:GranPerBank
                mov  dx,ax
             ;   pop  ax
                mov  ax,bx      ;моя вставка
                xor  bx,bx
                call dword ptr cs:WPosPtr
PPNoSwitch:     mov  ah,Color
                call LinePixel
                pop  es di bp
                ret  ArgSize
PutPixel        endp
LinePixel       proc
                ;draw pixel on the screen with mode switching
                ;ah - color
                cmp  cs:_WriteMode,0
                mov  es:[di],ah
                ret
LinePixel       endp


SetDACRegister  proc far
                arg _Blue:byte,_Green:byte,_Red:byte,Reg:word=ArgSize
                push bp
                mov  bp,sp
                mov  ax,1010h
                mov  bx,Reg
                mov  dh,_Red
                mov  ch,_Green
                mov  cl,_Blue
                int  10h
                pop  bp
                ret  ArgSize
SetDACRegister  endp

ReadDACRegister proc far
                arg _oB,_sB,_oG,_sG,_oR,_sR,Reg:word=ArgSize
                push bp
                mov  bp,sp
                push es
                mov  ax,1015h
                mov  bx,Reg
                int  10h
                mov  es,_sR
                mov  di,_oR
                mov  es:[di],dh
                mov  es,_sG
                mov  di,_oG
                mov  es:[di],ch
                mov  es,_sB
                mov  di,_oB
                mov  es:[di],cl
                pop  es bp
                ret  ArgSize
ReadDACRegister endp

SetDACBlock     proc far
                arg StoreOfs,StoreSeg,Count,Start:word=ArgSize
                push bp
                mov  bp,sp
                push es
                mov  ax,1012h
                mov  bx,Start
                mov  cx,Count
                mov  es,StoreSeg
                mov  dx,StoreOfs
                int  10h
                pop  es bp
                ret  ArgSize
SetDACBlock     endp


ReadDACBlock    proc far
                arg StoreOfs,StoreSeg,Count,Start:word=ArgSize
                push bp
                mov  bp,sp
                push es
                mov  ax,1017h
                mov  bx,Start
                mov  cx,Count
                mov  es,StoreSeg
                mov  dx,StoreOfs
                int  10h
                pop  es bp
                ret  ArgSize
ReadDACBlock    endp
SetActivePage_  proc
                ; this procedure set current modified page
                ; al - page number
                pusha
                mov     cs:APage,al
                mov     cx,cs:SecondPageBank
                or      al,al
                jnz     SActive
                xor     cx,cx
SActive:
                mov     cs:_GranUnit,0FFFFh
                mov     cs:BankAdder,cx
                popa
                ret
SetActivePage_  endp
SetActivePage   proc
                ; procedure SetActivePage (x:word)
                push    bp
                mov     bp,sp
                mov     ax,[bp+6]
                and     ax,1
                call    SetActivePage_
                pop     bp
                retf    2
SetActivePage   endp
SetVisualPage_  proc
                ; this procedure SetVisible Page
                ; al - page number (0 or 1)
                pusha
                cli
                mov     cs:VPage,al
                xor     bx,bx
                mov     cx,cs:CurXPage
                mov     dx,cs:CurYPage
                mov     di,cs:SecondPageBank
                or      al,al
                jnz     SVisual
                xor     cx,cx
                xor     dx,dx
                xor     di,di
SVisual:
                mov     cs:MousebankAdder,di
                mov     cs:_GranUnit,0FFFFh
                sti
                mov     ax,4F07h
                int     10h
                popa
                ret
SetVisualPage_  endp
SetVisualPage   proc
                ; procedure SetVisualPage (x:word)
                push    bp
                mov     bp,sp
                mov     ax,[bp+6]
                and     ax,1
                call    SetVisualPage_
                pop     bp
                retf    2
SetVisualPage   endp

code            ends
                end