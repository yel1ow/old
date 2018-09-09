;101 - Не хватает памяти для новой особой области
;102 - Нет особых областей
;201 - Мышь

.286

code            segment

                public VESAInit,GetModeInfo,GraphResult,VESADone
                public SetColor,PutPixel,Line,GetMaxX,GetMaxY
                public OutText,Bar,PutImage
                public GetImage,ImageSize,SetDACRegister,ReadDACRegister
                public SetDACBlock,ReadDACBlock,GrayScale,_VXMouseInit
                public VXMouseDone,SetAnimSequence,ShowMouse,HideMouse

                public ResetMyMouseCursor2,ResetMyMouseCursor,ResetMouseCursor,ResetHand,ResetRepair,ResetSold
                public ResetArrowUp,ResetArrowDown,ResetArrowLeft,ResetArrowRight,ResetNoScroll,ResetChronoCur

                public MouseX,MouseY,MouseButton,ChangeCursor
                public SetAnimDelay,AddSpecialArea,DelSpecialArea,NumOfSpecialAreas
                public SetHotSpotX,SetHotSpotY,SavePalette,SetMouseArea
                public RestorePalette,SetStdPalette,SetWriteMode,SetMouseArea
                public SetWSize,MouseIdle,ResetMouseAC

; --------------Special functions----------------------
                public LinkEms,SetTexture,SetWorkScreen,SetMapSize
                public SetMapBorder,SetMapVal,SetMapTexture,SetMapPos
                public GetMapVal,SetMatrFont,SetDinamic
                public LoadSprite, AddSprBlock, DelSprBlock
                public Refresh, OutBackGround, SetDisplayStart
                public SetVisualPage, SetActivePage, MirrorPage, PutSprite
                public PutSpriteS
                public SetUserCursor

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
ScreenY         dw ?
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

BackGrPg1       dw 0           ; Textures
BackGrPg2       dw 0           ; Textures
BackGrPg3       dw 0           ; Ages offset and
BackGrPg4       dw 0           ; map contains
BackGrPg5       dw 0           ; Second plane
BackGrPg6       dw 0           ; images (with empty color)

tmp1            dw 0
tmp2            dw 0

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

                assume cs:code

Error           proc
                ;input  : ds:dx - ErrMsg
                mov  ax,00003h
                int  10h
                mov  ah,09h
                int  21h
                ret
Error           endp


PutSpriteS proc far
                ; procedure PutSprite(x,y:integer;p:pointer)
                ;                    +0Ch +0Ah      +6
                push    bp
                mov     bp,sp
                push    ds es
                lds     si,[bp+6]
                call    testpointer
                TestRegister  ds,si
                ; ds:si - sprite
                mov     ax,[si]
                mov     cs:tmp1,ax
                mov     ax,[si+2]
                mov     cs:tmp2,ax
                add     si,4
                mov     cx,[bp+0Ch]
                mov     bx,cs:tmp1
                mov     ax,cs:_VMinX
                sub     ax,[bp+0Ch]
                jle     PutSpr_Ok1_
                ;       _VMinX>Left Border of sprite
                add     si,ax
                sub     bx,ax                   ; bx - how point to print
                mov     cx,cs:_VMinX
PutSpr_Ok1_:
                mov     ax,[bp+0Ch]
                add     ax,cs:tmp1              ; cx - right border
                sub     ax,cs:_VMaxX
                jle     PutSpr_Ok2_
                ;       _VMaxX<Right Border of sprite
                sub     bx,ax
PutSpr_Ok2_:
                mov     [bp+0Ch],cx
                mov     cx,bx
                push    cx
                mov     cx,[bp+0Ah]
                mov     bx,cs:tmp2
                mov     ax,cs:_VMinY
                sub     ax,[bp+0Ah]
                jle     PutSpr_Ok3_
                ;       _VMinY>Higest border of sprite
                sub     bx,ax
                mul     word ptr cs:tmp1
                add     si,ax
                mov     cx,cs:_VMinY
PutSpr_Ok3_:
                mov     ax,[bp+0Ah]
                add     ax,cs:tmp2
                sub     ax,cs:_VMaxY
                jle     PutSpr_Ok4_
                sub     bx,ax
PutSpr_Ok4_:
                mov     [bp+0Ah],cx
                pop     cx
                mov     ax,[bp+0Ah]
                imul    word ptr cs:ScreenX
                add     ax,[bp+0Ch]
                adc     dx,0
                mov     es,cs:StartSegA
                mov     di,ax
                call    SwitchGran

                ;       cx - point per line
                ;       bx - line on sprite
                cmp     cx,0
                jle     xx112
                cmp     bx,0
                jg      mm1mm
xx112:          jmp     PutSpr_exit_
mm1mm:          mov     ax,cs:tmp1
                sub     ax,cx
                ;       ax - point per all line to addition
PutSpr_Loop_:
                push    di
                add     di,cx
                jc      PutSpr_YesSw_
                pop     di

                push    ax
                push    cx
                cld
@@@l3:
                lodsb
                or      al,al
                jz      @@@l1
                mov     al,es:[di]
                call    ConvAL
                stosb
@@@l2:
                loop    @@@l3
                jmp     @@@l4
@@@l1:
                inc     di
                loop    @@@l3
@@@l4:
                pop     cx
                pop     ax


                add     si,ax
                ;sub     di,ax
                sub     di,cx
                add     di,cs:ScreenX
                jnc     PutSpr_NonSw_
                inc     dx
                call    SwitchGran
PutSpr_NonSw_:
                dec     bx
                jnz     PutSpr_Loop_
                jmp     PutSpr_exit_
PutSpr_YesSw_:
                mov     bp,di
                pop     di
                push    cx
                sub     cx,bp

                push    ax
                push    cx
                cld
@@@@l3:
                lodsb
                or      al,al
                jz      @@@@l1
                mov     al,es:[di]
                call    ConvAL
                stosb
@@@@l2:
                loop    @@@@l3
                jmp     @@@@l4
@@@@l1:
                inc     di
                loop    @@@@l3
@@@@l4:
                pop     cx
                pop     ax

                inc     dx
                call    SwitchGran
                mov     cx,bp
                jcxz    PutSpr_NonSw1_

                push    ax
                push    cx
                cld
@@_l3:
                lodsb
                or      al,al
                jz      @@_l1
                mov     al,es:[di]
                call    ConvAL
                stosb
@@_l2:
                loop    @@_l3
                jmp     @@_l4
@@_l1:
                inc     di
                loop    @@_l3
@@_l4:
                pop     cx
                pop     ax

PutSpr_NonSw1_:
                pop     cx
                sub     di,cx
                add     di,cs:ScreenX
                jmp     PutSpr_NonSw_
PutSpr_exit_:
                pop     es ds bp
                retf    8
PutSpriteS  endp



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

LinePixel       proc
                ;draw pixel on the screen with mode switching
                ;ah - color
                cmp  cs:_WriteMode,0
                jnz  LP0
                mov  es:[di],ah
                jmp  LPExit
LP0:            cmp  cs:_WriteMode,1
                jnz  LP1
                xor  es:[di],ah
                jmp  LPExit
LP1:            cmp  cs:_WriteMode,2
                jnz  LP2
                or   es:[di],ah
                jmp  LPExit
LP2:
                cmp  cs:_WriteMode,3
                jnz  LP3
                and  es:[di],ah
                jmp  LPExit
LP3:            cmp  cs:_WriteMode,4
                jnz  LP4
                or   ah,ah
                jz   @LPExit
                mov  es:[di],ah
                jmp  LPExit
LP4:            cmp  cs:_WriteMode,5
                jnz  LP5
                cmp  ah,0
                jz   @LPExit
                mov  ah,es:[di]
                push si
                push ax
                xchg al,ah
                xor  ah,ah
                mov  si,offset ShadowColors
                add  si,ax
                mov  al,cs:[si]
                mov  es:[di],al
                pop  ax
                pop  si
                jmp  LPExit
LP5:            cmp  cs:_WriteMode,6
                jnz  LP6
                push ax bx
                xor  bh,bh
                mov  al,ah
                xor  ah,ah
                mov  bl,es:[di]
                Call GetInGlas
                mov  es:[di],al
                pop  bx ax
                jmp  LPExit
LP6:            cmp  cs:_WriteMode,7
                jnz  LP7
                push ax
                call GetTextDot
                mov  es:[di],ah
                pop  ax
@LPExit:
                jmp  LPExit
LP7:
                cmp  cs:_Writemode,8
                jnz  LPExit
                push bx cx dx si ds
                mov  ds,cs:BitImage
                mov  dl,80h
                mov  cx,di
                and  cx,07h
                jcxz @LP7_1
                shr  dl,cl              ; dx - mask
@LP7_1:
                mov  bx,di
                shr  bx,3
                mov  cx,cs:_GranUnit
                shl  cx,13
                or   bx,cx
                test [bx],dx
                jnz  @LP7_2
                mov  es:[di],ah
@LP7_2:
                pop  ds si dx cx bx
                jmp  LPExit
LPExit:         ret
LinePixel       endp


testpointer     proc
                push    ax
                mov     ax,ds
                and     ax,0F000h
                cmp     ax,0F000h
                jnz     testpoint_1
                mov     ax,ds
                push    bx
                mov     bx,ax
                and     bx,0FFFh
                call    alloc1
                mov     ds,cs:EMSFrame
                pop     bx
testpoint_1:
                pop     ax
                ret
testpointer     endp


LinePixel1      proc
                ;draw pixel on the screen with mode switching
                ;al - color
                push  ax
                xchg  ah,al
                call  LinePixel
                pop   ax
                ret

                cmp  cs:_WriteMode,0
                jnz  LP01
                mov  es:[di],al
                jmp  LPExit1
LP01:           cmp  cs:_WriteMode,1
                jnz  LP11
                xor  es:[di],al
                jmp  LPExit1
LP11:           cmp  cs:_WriteMode,2
                jnz  LP21
                or   es:[di],al
                jmp  LPExit1
LP21:           cmp  cs:_WriteMode,3
                jnz  LP31
                and  es:[di],al
                jmp  LPExit1
LP31:           cmp  cs:_WriteMode,4
                jnz  LPExit1
                or   ah,ah
                jz   LPExit1
                mov  es:[di],ah
LPExit1:        ret
LinePixel1      endp


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
                call FindShadow
                call FindGlases
                call FillSprBlock
                ; prepare information for second page
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

SetColor        proc far
                arg NewColor:byte=ArgSize
                push bp
                mov  bp,sp
                mov  al,NewColor
                mov  _Color,al
                pop  bp
                ret  ArgSize
SetColor        endp

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


CalcX           proc
                ;Input  : AX - x1
                ;         BX - y1
                ;         CX - x2
                ;         DX - y2
                ;         DI - y
                ;Output : SI - x
                push ax bx cx dx di
                sub  cx,ax ; cx = x2-x1
                xchg ax,cx ; cx = x1      ax = x2-x1
                sub  di,bx ; di = y-y1
                sub  dx,bx ; dx = y2-y1
                mov  bx,dx ; bx = y2-y1   dx = y2-y1
                imul di   ; dx ax = (y-y1)*(x2-x1)
                idiv bx   ; ax = ((y-y1)*(x2-x1)) div (y2-y1)
                add  ax,cx ; ax = ((y-y1)*(x2-x1)) div (y2-y1) + x1
                mov  si,ax
                pop  di dx cx bx ax
                ret
CalcX           endp

CalcY           proc
                ;Input  : AX - x1
                ;         BX - y1
                ;         CX - x2
                ;         DX - y2
                ;         SI - x
                ;Output : DI - y
                push ax bx cx dx si
                sub  dx,bx ; dx = y2-y1
                sub  cx,ax ; cx = x2-x1
                sub  si,ax ; si = x-x1
                mov  ax,si ; ax = x-x1
                imul dx    ; dx ax = (x-x1)*(y2-y1)
                idiv cx   ; ax = ((x-x1)*(y2-y1)) div (x2-x1)
                add  ax,bx ; ax = ((x-x1)*(y2-y1)) div (x2-x1) + y1
                mov  di,ax
                pop  si dx cx bx ax
                ret
CalcY           endp

Between         proc
                arg  x,x2,x1:word=ArgSize
                push bp
                mov  bp,sp
                push ax bx cx dx
                mov  ax,x1
                mov  bx,x2
                cmp  ax,bx
                jz   BtwFalse
                mov  cx,x
                mov  dx,ax
                sub  dx,bx
                jge  BtwSkip0
                neg  dx
BtwSkip0:       sub  ax,cx
                jge  BtwSkip1
                neg  ax
BtwSkip1:       sub  bx,cx
                jge  BtwSkip2
                neg  bx
BtwSkip2:       add  ax,bx
                cmp  ax,dx
                jz   BtwTrue
BtwFalse:       pop  dx cx bx ax bp
                clc
                ret  ArgSize
BtwTrue:        pop  dx cx bx ax bp
                stc
                ret  ArgSize
Between         endp

Line            proc far
                arg y2,x2,y1,x1:word=ArgSize
                push bp
                mov  bp,sp
                push ax bx cx dx si di ds es
                mov  ax,x1
                mov  bx,y1
                mov  cx,x2
                mov  dx,y2
                mov  si,_VMinX
                push ax cx si
                call Between
                jnc  L64MaxXCalc  ; если по одну сторону
                call CalcY        ; проверяем пересечение с левой границей
                cmp  ax,_VMinX    ; заменять x1?
                jge  L64MinX2     ; нет
                mov  ax,si        ; да ax = x
                mov  bx,di        ;    bx = y
                mov  x1,ax        ;    x1 = x
                mov  y1,bx        ;    y1 = y
                jmp  L64MaxXCalc
L64MinX2:       cmp  cx,_VMinX
                jge  L64MaxXCalc
                mov  cx,si
                mov  dx,di
                mov  x2,cx
                mov  y2,dx
L64MaxXCalc:    mov  si,_VMaxX
                push ax cx si
                call Between
                jnc  L64MinYCalc  ; если по одну сторону
                call CalcY        ; проверяем пересечение с правой границей
                cmp  ax,_VMaxX    ; заменять x1?
                jle  L64MaxX2     ; нет
                mov  ax,si        ; да
                mov  bx,di
                mov  x1,ax
                mov  y1,bx
                jmp  L64MinYCalc
L64MaxX2:       cmp  cx,_VMaxX
                jle  L64MinYCalc
                mov  cx,si
                mov  dx,di
                mov  x2,cx
                mov  y2,dx
L64MinYCalc:    mov  di,_VMinY
                push bx dx di
                call Between
                jnc  L64MaxYCalc  ; если по одну сторону
                call CalcX        ; проверяем пересечение с верхней границей
                cmp  bx,_VMinY    ; заменять y1?
                jge  L64MinY2     ; нет
                mov  ax,si        ; да ax = x
                mov  bx,di        ;    bx = y
                mov  x1,ax        ;    x1 = x
                mov  y1,bx        ;    y1 = y
                jmp  L64MaxYCalc
L64MinY2:       cmp  dx,_VMinY
                jge  L64MaxYCalc
                mov  cx,si
                mov  dx,di
                mov  x2,cx
                mov  y2,dx
L64MaxYCalc:    mov  di,_VMaxY
                push bx dx di
                call Between
                jnc  L64CalcExit  ; если по одну сторону
                call CalcX        ; проверяем пересечение с нижней границей
                cmp  bx,_VMaxY    ; заменять y1?
                jle  L64MaxY2     ; нет
                mov  ax,si        ; да
                mov  bx,di
                mov  x1,ax
                mov  y1,bx
                jmp  L64CalcExit
L64MaxY2:       cmp  dx,_VMaxY
                jle  L64CalcExit
                mov  cx,si
                mov  dx,di
                mov  x2,cx
                mov  y2,dx
L64CalcExit:    jmp  L64RangeChk
L64RCDone:
                mov  ax,y1
                mov  bx,y2
                cmp  ax,bx
                jle  L64NoXYSwap
                mov  y1,bx
                mov  y2,ax
                mov  ax,x1
                mov  bx,x2
                mov  x1,bx
                mov  x2,ax
L64NoXYSwap:
                mov  ax,0A000h
                mov  es,ax
                mov  ax,y1
                mov  bx,ScreenX
                mul  bx
                add  ax,x1
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
                call SwitchGran   ; dx - Gran es:[di] - Addr

                mov  _LDXBelow0,0
                mov  cx,x2
                sub  cx,x1        ; cx = dx
                jge  L64dxPos
L64dxNeg:       neg  cx
                mov  _LDXBelow0,255
L64dxPos:       mov  bx,y1
                sub  bx,y2        ; bx = dy
                jge  L64dyPos
L64dyNeg:       neg  bx
L64dyPos:       xor  si,si
                cmp  cx,bx
                jnc  L64dxGreater
                mov  si,bx
                shr  si,1
                neg  si
                sub  si,cx
                mov  ah,_Color
                call LinePixel
                jmp  L64DrawStart
L64dxGreater:   mov  si,cx
                shr  si,1
                neg  si
                sub  si,bx        ; si = Error

L64DrawStart:   mov  ah,_Color
                mov  _LDX,cx
                mov  _LDY,bx
                mov  bx,x1        ; bx = CurX
                mov  cx,y1        ; cx = CurY
L64ExWhile:     cmp  bx,x2
                jnz  L64EWGo
                cmp  cx,y2
                jnz  L64EWGo
                jmp  L64AllDoneOK
L64EWGo:        add  si,_LDY
L64InWhile:     cmp  si,0
                jle  L64EWCont
                cmp  bx,x2
                jnz  L64IWGo
                cmp  cx,y2
                jz   L64EWCont
L64IWGo:        inc  cx
                add  di,ScreenX
                pushf
                cmp  WinGran,64
                jnz  L64IWN64
                popf
                adc  dx,0
                jmp  L64IWCont
L64IWN64:       popf
                cmp  di,_GranSize
                jc   L64IWCont
                inc  dx
                sub  di,_GranSize
L64IWCont:      call SwitchGran
                sub  si,_LDX
                jle  L64InWhile
                call LinePixel
                jmp  L64InWhile
L64EWCont:      cmp  bx,x2
                jnz  L64EWCont1
                cmp  cx,y2
                jz   L64AllDoneOK
L64EWCont1:     call LinePixel

                cmp  _LDXBelow0,255
                jnz  L64DXAbove0
L64DXBelow0:    sub  bx,1
                sub  di,1
                pushf
                cmp  WinGran,64
                jnz  L64EWBN64
L64EWB64:       popf
                sbb  dx,0
                call SwitchGran
                jmp  L64ExWhile
L64EWBN64:      popf
                jc   L64EWBN64_
                jmp  L64ExWhile
L64EWBN64_:     add  di,_GranSize
                dec  dx
                call SwitchGran
                jmp  L64ExWhile
L64DXAbove0:    add  bx,1
                add  di,1
                pushf
                cmp  WinGran,64
                jnz  L64EWAN64
L64EWA64:       popf
                adc  dx,0
                call SwitchGran
                jmp  L64ExWhile
L64EWAN64:      popf
                cmp  di,_GranSize
                jnc  L64EWAN64_
                jmp  L64ExWhile
L64EWAN64_:     sub  di,_GranSize
                inc  dx
                call SwitchGran
                jmp  L64ExWhile

L64AllDoneOK:   call LinePixel
L64AllDone:     pop  es ds di si dx cx bx ax
                pop  bp
                ret  ArgSize

L64RangeChk:    cmp  ax,_VMinX
                jl  L64AllDone
                cmp  ax,_VMaxX
                jg   L64AllDone
                cmp  cx,_VMinX
                jl   L64AllDone
                cmp  cx,_VMaxX
                jg   L64AllDone
                cmp  bx,_VMinY
                jl   L64AllDone
                cmp  bx,_VMaxY
                jg   L64AllDone
                cmp  dx,_VMinY
                jl   L64AllDone
                cmp  dx,_VMaxY
                jg   L64AllDone
                jmp  L64RCDone

Line            endp

GetMaxX         proc far
                mov  ax,ScreenX
                dec  ax
                ret
GetMaxX         endp

GetMaxY         proc far
                mov  ax,ScreenY
                dec  ax
                retF
GetMaxY         endp


OutText         proc far
                arg MsgOfs,MsgSeg,y,x:word=ArgSize
                push bp
                mov  bp,sp
                push ds es si di
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
                call SwitchGran
                mov  si,MsgOfs
                mov  ds,MsgSeg
                xor  ax,ax
                mov  al,ds:[si]
                shl  ax,3
                mov  cx,ScreenX
                sub  cx,ax
                shr  ax,3
                push cx
                mov  cx,ax
                mov  ax,16
                inc  si
                push si
OTXYMainLoop:   pop  si
                push si
                mov  cl,ds:[si-1]
                xor  ch,ch
OTXYFullLine:   xor  bh,bh
                mov  bl,ds:[si]
                inc  si
                shl  bx,4
                add  bx,16
                sub  bx,ax
                mov  bh,cs:[bx+offset StandardFont]
                mov  bl,_Color
                push cx
                mov  cx,8
OTXYOneLetter:  shl  bh,1
                jnc  OTXYNoPixel
                push ax
                mov  ah,bl
                call LinePixel
                pop  ax
OTXYNoPixel:    add  di,1
                CheckNext
                loop OTXYOneLetter
                pop  cx
                loop OTXYFullLine
                pop  si
                pop  bx
                add  di,bx
                CheckNext
                push bx
                push si
                dec  ax
                jnz  OTXYMainLoop
                pop  cx bx di si es ds bp
                ret  ArgSize
OutText         endp

Bar             proc far
                arg y2,x2,y1,x1:word=ArgSize
                push bp
                mov  bp,sp
                push es di si
BBarStart:      mov  ax,x1
                mov  bx,x2
                cmp  bx,ax
                jnc  BNoSwap1
                xchg ax,bx
BNoSwap1:       cmp  ax,_VMinX
                jge  BOK0
                mov  ax,_VMinX
BOK0:           cmp  ax,_VMaxX
                jle  BOK1
                mov  ax,_VMaxX
BOK1:           cmp  bx,_VMinX
                jge  BOK2
                mov  bx,_VMinX
BOK2:           cmp  bx,_VMaxX
                jle  BOK3
                mov  bx,_VMaxX
BOK3:           mov  x1,ax
                mov  x2,bx
                sub  bx,ax
                inc  bx
                push bx
                mov  ax,y1
                mov  si,y2
                cmp  si,ax
                jnc  BNoSwap2
                xchg ax,si
BNoSwap2:       cmp  ax,_VMinY
                jge  BOK4
                mov  ax,_VMinY
BOK4:           cmp  ax,_VMaxY
                jle  BOK5
                mov  ax,_VMaxY
BOK5:           cmp  si,_VMinY
                jge  BOK6
                mov  si,_VMinY
BOK6:           cmp  si,_VMaxY
                jle  BOK7
                mov  si,_VMaxY
BOK7:           mov  y1,ax
                mov  y2,si
                sub  si,ax
                inc  si
                mov  ax,0A000h
                mov  es,ax
                mov  ax,y1
                mov  bx,ScreenX
                mul  bx
                add  ax,x1
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
                call SwitchGran
                mov  al,_Color
                mov  bp,ScreenX
                pop  bx
                sub  bp,bx
BLoopY:         mov  cx,bx
BLoopX:         call LinePixel1
                add  di,1
                CheckNext
BAllOk:         loop BLoopX
                add  di,bp
                CheckNext
                dec  si
                jnz  BLoopY
                pop  si di es bp
                ret  ArgSize
Bar             endp

PutImage        proc far
                arg Op:byte,POfs,PSeg,y,x:word=ArgSize
                push bp
                mov  bp,sp
                push ds es si di
                mov  ax,x
                mov  _CurX,ax
                mov  ax,y
                mov  _CurY,ax
PIStart:        mov  ds,PSeg
                mov  si,POfs
                call testpointer
                TestRegister ds,si
                mov  cx,ds:[si]
                inc  si
                inc  si
                mov  bx,ds:[si]
                inc  si
                inc  si
                mov  ax,x
                cmp  ax,0
                jg   PIT1
                neg  ax
                cmp  ax,cx
                jc   PIT1
                jmp  PIAllDone
PIT1:           mov  ax,y
                cmp  ax,0
                jg   PINoAlign
                neg  ax
                cmp  ax,bx
                jc   PIC0
                jmp  PIAllDone
PIC0:           mul  cx
                add  si,ax
                add  bx,y
                mov  y,0
                mov  _CurY,0
PINoAlign:      push cx bx
                mov  ax,0A000h
                mov  es,ax
                mov  ax,y
                mov  bx,ScreenX
                mul  bx
                mov  di,x
                cmp  di,0
                jg   PIPlus
                xchg ax,di
                neg  ax
                sub  di,ax
                jnc  PIAddrDone
                dec  dx
                jmp  PIAddrDone
PIPlus:         add  ax,di
                adc  dx,0
PIContAddr:     mov  bx,0400h
                div  bx
                mov  cx,dx
                xor  dx,dx
                mov  bx,WinGran
                div  bx
                shl  dx,10
                add  cx,dx
                mov  dx,ax
                mov  di,cx
PIAddrDone:     call SwitchGran
                pop  bx cx
                push dx
                mov  dx,ScreenX
                sub  dx,cx
                mov  _XAdd,dx
                pop  dx
                push cx
PILoopY:        pop  cx
                push cx
PILoopX:        mov  al,ds:[si]
                cmp  _CurX,0
                jl   PISkipPixel
                cmp  _CurY,0
                jl   PISkipPixel
                push ax
                mov  ax,ScreenX
                cmp  _CurX,ax
                jc   PIDontNeedSkip0
                pop  ax
                jmp  PISkipPixel
PIDontNeedSkip0:
                mov  ax,ScreenY
                cmp  _CurY,ax
                jc   PIDontNeedSkip1
                pop  ax
                jmp  PISkipPixel
PIDontNeedSkip1:
                pop  ax
                call PIOpSelector
PISkipPixel:    inc  _CurX
                inc  si
                add  di,1
                CheckNext
PIAllOk:        loop PILoopX
                inc  _CurY
                mov  ax,x
                mov  _CurX,ax
                add  di,_XAdd
                CheckNext
                dec  bx
                jz   PIC1
                jmp  PILoopY
PIC1:           pop  cx
PIAllDone:      pop  di si es ds bp
                ret  ArgSize
PIOpSelector:   cmp  Op,0                       ;NormalPut
                jnz  PIOpSel0
                mov  es:[di],al
                retn
PIOpSel0:       cmp  Op,1                       ;XORPut
                jnz  PIOpSel1
                xor  es:[di],al
                retn
PIOpSel1:       cmp  Op,2                       ;ORPut
                jnz  PIOpSel2
                or   es:[di],al
                retn
PIOpSel2:       cmp  Op,3                       ;ANDPut
                jnz  PIOpSel3
                and  es:[di],al
                retn
PIOpSel3:       cmp  Op,4                       ;X0Put
                jnz   PIC4
PIC2:           cmp  al,0
                jnz  PIC3
                retn
PIC3:           mov  es:[di],al
                retn
PIC4:           cmp  al,0
                jnz  PIC5
                retn
PIC5:           mov  al,es:[di]
                call ConvAL
                mov  es:[di],al
                retn
PutImage        endp

End_ db 42,68,90,113,,136,157,180,203,219
Offs equ 3

ConvAL proc near
    push cx si
    xor si,si
    cmp al,15
    jbe EX_
    mov cx,9
mmm:cmp al,cs:END_[si]
    ja Next_
    add al,offs
    cmp al,cs:end_[si]
    jbe ex_
    mov al,cs:end_[si]
    jmp short ex_
Next_:
      inc si
    loop mmm
EX_:
    pop si cx
    retn
ConvAL EndP




GetImage        proc far
                arg POfs,PSeg,y2,x2,y1,x1:word=ArgSize
                push bp
                mov  bp,sp
                push ds es si di
                mov  ax,x1
                mov  bx,x2
                cmp  bx,ax
                jg   GIC4
                mov  x1,bx
                mov  x2,ax
GIC4:           mov  ax,y1
                mov  bx,y2
                cmp  bx,ax
                jg   GIC5
                mov  y1,bx
                mov  y2,ax
GIC5:           mov  ax,x1
                mov  _CurX,ax
                mov  ax,y1
                mov  _CurY,ax
                mov  ds,PSeg
                mov  si,POfs
                mov  ax,x2
                sub  ax,x1
                inc  ax
                mov  ds:[si],ax
                mov  cx,ax
                inc  si
                inc  si
                mov  ax,y2
                sub  ax,y1
                inc  ax
                mov  ds:[si],ax
                mov  bx,ax
                inc  si
                inc  si
                mov  ax,x1
                cmp  ax,0
                jg   GIT1
                neg  ax
                cmp  ax,cx
                jc   GIT1
                jmp  GIAllDone
GIT1:           mov  ax,y1
                cmp  ax,0
                jg   GINoAlign
                neg  ax
                cmp  ax,bx
                jc   GIC0
                jmp  GIAllDone
GIC0:           mul  cx
                add  si,ax
                add  bx,y1
                mov  y1,0
                mov  _CurY,0
GINoAlign:      push cx bx
                mov  ax,0A000h
                mov  es,ax
                mov  ax,y1
                mov  bx,ScreenX
                mul  bx
                mov  di,x1
                cmp  di,0
                jg   GIPlus
                xchg ax,di
                neg  ax
                sub  di,ax
                jnc  GIAddrDone
                dec  dx
                jmp  GIAddrDone
GIPlus:         add  ax,di
                adc  dx,0
GIContAddr:     mov  bx,0400h
                div  bx
                mov  cx,dx
                xor  dx,dx
                mov  bx,WinGran
                div  bx
                shl  dx,10
                add  cx,dx
                mov  dx,ax
                mov  di,cx
GIAddrDone:     call SwitchGran
                pop  bx cx
                push dx
                mov  dx,ScreenX
                sub  dx,cx
                mov  _XAdd,dx
                pop  dx
                push cx
GILoopY:        pop  cx
                push cx
GILoopX:        mov  al,es:[di]
                cmp  _CurX,0
                jl   GISkipPixel
                cmp  _CurY,0
                jl   GISkipPixel
                push ax
                mov  ax,ScreenX
                cmp  _CurX,ax
                jc   GIDontNeedSkip0
                pop  ax
                jmp  GISkipPixel
GIDontNeedSkip0:
                mov  ax,ScreenY
                cmp  _CurY,ax
                jc   GIDontNeedSkip1
                pop  ax
                jmp  GISkipPixel
GIDontNeedSkip1:
                pop  ax
                mov  ds:[si],al
GISkipPixel:    inc  _CurX
                inc  si
                add  di,1
                CheckNext
GIAllOk:        loop GILoopX
                inc  _CurY
                mov  ax,x1
                mov  _CurX,ax
                add  di,_XAdd
                CheckNext
                dec  bx
                jz   GIC1
                jmp  GILoopY
GIC1:           pop  cx
GIAllDone:      pop  di si es ds bp
                ret  ArgSize
GetImage        endp

ImageSize       proc far
                arg y2,x2,y1,x1:word=ArgSize
                push bp
                mov  bp,sp
                mov  ax,x2
                sub  ax,x1
                cmp  ax,0
                jg   ISC0
                neg  ax
ISC0:           inc  ax
                mov  bx,y2
                sub  bx,y1
                cmp  bx,0
                jg   ISC1
                neg  bx
ISC1:           inc  bx
                mul  bx
                add  ax,4
                adc  dx,0
                cmp  dx,0
                jz   ISExit
                xor  ax,ax
                mov  _Result,2
ISExit:         pop  bp
                ret  ArgSize
ImageSize       endp

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

GrayScale       proc far
                arg Count,Start:word=ArgSize
                push bp
                mov  bp,sp
                mov  ax,101Bh
                mov  bx,Start
                mov  cx,Count
                int  10h
                pop  bp
                ret  ArgSize
GrayScale       endp

DrawMouseSwap   proc
                push ax bx cx dx bp ds es si di
                jmp  DMSStart
DMSSwitchGran:  cmp  dx,_TmpGran
                jz   DMSSGNoSwitch
                push ax bx dx
                mov  _TmpGran,dx
                mov  ax,dx
                add  ax,cs:MouseBankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                xor  bx,bx
;                mov  ax,4F05h
;                int  10h
                call dword ptr cs:WPosPtr
                pop  dx bx ax
DMSSGNoSwitch:  retn
DMSStart:       mov  dx,_GranUnit
                mov  _TmpGran,dx
                push dx
                push ax
                mov  ax,dx
                add  ax,cs:MouseBankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                pop  ax
                xor  bx,bx
;                mov  ax,4F05h
;                int  10h
                call dword ptr cs:WPosPtr
                pop  dx
                mov  ax,_MouseX
                xor  bx,bx
                mov  bl,_HotSpotX
                sub  ax,bx
                mov  MCurX,ax
                mov  MXCopy,ax
                mov  ax,_MouseY
                xor  bx,bx
                mov  bl,_HotSpotY
                sub  ax,bx
                mov  MCurY,ax
                mov  si,offset _MouseSwap
                mov  cx,32
                mov  bx,32
                mov  ax,MCurX
                cmp  ax,0
                jg   DMST1
                neg  ax
                cmp  ax,cx
                jc   DMST1
                jmp  DMSAllDone
DMST1:          mov  ax,MCurY
                cmp  ax,0
                jg   DMSNoAlign
                neg  ax
                cmp  ax,bx
                jc   DMSC0
                jmp  DMSAllDone
DMSC0:          shl  ax,5
                add  si,ax
                add  bx,MCurY
                mov  MCurY,0
                mov  MCurY,0
DMSNoAlign:     push cx bx
                mov  ax,0A000h
                mov  es,ax
                mov  ax,MCurY
                mov  bx,ScreenX
                mul  bx
                mov  di,MCurX
                cmp  di,0
                jg   DMSPlus
                xchg ax,di
                neg  ax
                sub  di,ax
                jnc  DMSAddrDone
                dec  dx
                jmp  DMSAddrDone
DMSPlus:        add  ax,di
                adc  dx,0
DMSContAddr:    mov  bx,0400h
                div  bx
                mov  cx,dx
                xor  dx,dx
                mov  bx,WinGran
                div  bx
                shl  dx,10
                add  cx,dx
                mov  dx,ax
                mov  di,cx
DMSAddrDone:    call DMSSwitchGran
                pop  bx cx
                push dx
                mov  dx,ScreenX
                sub  dx,cx
                mov  MXAdd,dx
                pop  dx
                push cx
DMSLoopY:       pop  cx
                push cx
DMSLoopX:       mov  al,cs:[si]
                cmp  MCurX,0
                jl   DMSSkipPixel
                cmp  MCurY,0
                jl   DMSSkipPixel
                push ax
                mov  ax,MCurX
                mov  ax,ScreenX
                cmp  MCurX,ax
                jc   DMSDontNeedSkip0
                pop  ax
                jmp  DMSSkipPixel
DMSDontNeedSkip0:
                mov  ax,MCurY
                mov  ax,ScreenY
                cmp  MCurY,ax
                jc   DMSDontNeedSkip1
                pop  ax
                jmp  DMSSkipPixel
DMSDontNeedSkip1:
                pop  ax
                mov  es:[di],al
DMSSkipPixel:   inc  MCurX
                inc  si
                add  di,1
                CheckNextM DMS
DMSAllOk:       loop DMSLoopX
                inc  MCurY
                mov  ax,MXCopy
                mov  MCurX,ax
                add  di,MXAdd
                CheckNextM DMS
                dec  bx
                jz   DMSC1
                jmp  DMSLoopY
DMSC1:          pop  cx
DMSAllDone:     mov  dx,_GranUnit
                xor  bx,bx
                push ax
                mov  ax,dx
                add  ax,cs:BankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                pop  ax
;                mov  ax,4F05h
;                int  10h
                call dword ptr cs:WPosPtr
                pop  di si es ds bp dx cx bx ax
                ret
DrawMouseSwap   endp

DrawMouseCursor proc
                push ax bx cx dx bp ds es si di
                jmp  DMCStart
DMCSwitchGran:  cmp  dx,_TmpGran
                jz   DMCSGNoSwitch
                push ax bx dx
                mov  _TmpGran,dx
                mov  ax,dx
                add  ax,cs:MouseBankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                xor  bx,bx
;                mov  ax,4F05h
;                int  10h
                call dword ptr cs:WPosPtr
                pop  dx bx ax
DMCSGNoSwitch:  retn
DMCStart:       ;mov  ax,3
                ;int  33h
                ;mov  _MouseX,cx
                ;mov  _MouseY,dx
                mov  dx,_GranUnit
                mov  _TmpGran,dx
                push dx
                push ax
                mov  ax,dx
                add  ax,cs:MouseBankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                pop  ax
                xor  bx,bx
;                mov  ax,4F05h
;                int  10h
                call dword ptr cs:WPosPtr
                pop  dx
                mov  ax,_MouseX
                xor  bx,bx
                mov  bl,_HotSpotX
                sub  ax,bx
                mov  MCurX,ax
                mov  MXCopy,ax
                mov  ax,_MouseY
                xor  bx,bx
                mov  bl,_HotSpotY
                sub  ax,bx
                mov  MCurY,ax
                mov  ds,word ptr cs:[_CurAnimPtr+2]
                mov  si,word ptr cs:[_CurAnimPtr]
                mov  bp,offset _MouseSwap
                mov  cx,32
                mov  bx,32
                mov  ax,MCurX
                cmp  ax,0
                jg   DMCT1
                neg  ax
                cmp  ax,cx
                jc   DMCT1
                jmp  DMCAllDone
DMCT1:          mov  ax,MCurY
                cmp  ax,0
                jg   DMCNoAlign
                neg  ax
                cmp  ax,bx
                jc   DMCC0
                jmp  DMCAllDone
DMCC0:          shl  ax,5
                add  si,ax
                add  bp,ax
                add  bx,MCurY
                mov  MCurY,0
                mov  MCurY,0
DMCNoAlign:     push cx bx
                mov  ax,0A000h
                mov  es,ax
                mov  ax,MCurY
                mov  bx,ScreenX
                mul  bx
                mov  di,MCurX
                cmp  di,0
                jg   DMCPlus
                xchg ax,di
                neg  ax
                sub  di,ax
                jnc  DMCAddrDone
                dec  dx
                jmp  DMCAddrDone
DMCPlus:        add  ax,di
                adc  dx,0
DMCContAddr:    mov  bx,0400h
                div  bx
                mov  cx,dx
                xor  dx,dx
                mov  bx,WinGran
                div  bx
                shl  dx,10
                add  cx,dx
                mov  dx,ax
                mov  di,cx
DMCAddrDone:    call DMCSwitchGran
                pop  bx cx
                push dx
                mov  dx,ScreenX
                sub  dx,cx
                mov  MXAdd,dx
                pop  dx
                push cx
DMCLoopY:       pop  cx
                push cx
DMCLoopX:       mov  al,ds:[si]
                cmp  MCurX,0
                jl   DMCSkipPixel
                cmp  MCurY,0
                jl   DMCSkipPixel
                push ax
                mov  ax,ScreenX
                cmp  MCurX,ax
                jc   DMCDontNeedSkip0
                pop  ax
                jmp  DMCSkipPixel
DMCDontNeedSkip0:
                mov  ax,ScreenY
                cmp  MCurY,ax
                jc   DMCDontNeedSkip1
                pop  ax
                jmp  DMCSkipPixel
DMCDontNeedSkip1:
                pop  ax
                mov  ah,es:[di]
                mov  cs:[bp],ah
                cmp  al,0
                jz   DMCSkipPixel
                mov  es:[di],al
DMCSkipPixel:   inc  MCurX
                inc  si
                inc  bp
                add  di,1
                CheckNextM DMC
DMCAllOk:       loop DMCLoopX
                inc  MCurY
                mov  ax,MXCopy
                mov  MCurX,ax
                add  di,MXAdd
                CheckNextM DMC
DMCAllOk2:      dec  bx
                jz   DMCC1
                jmp  DMCLoopY
DMCC1:          pop  cx
DMCAllDone:     mov  dx,_GranUnit
                xor  bx,bx
                push ax
                mov  ax,dx
                add  ax,cs:BankAdder
                mul  cs:GranPerBank
                mov  dx,ax
                pop  ax
;                mov  ax,4F05h
;                int  10h
                call dword ptr cs:WPosPtr
                pop  di si es ds bp dx cx bx ax
                ret
DrawMouseCursor endp

ChangeCursor    proc
                ;input  : es:di - NewCursor
                push bp ax ds
                mov bp,sp
                mov  byte ptr _08Idle,0
                mov  byte ptr _0CIdle,0
                cmp  _MouseVisible,0
                jle  CCNoSwap
                call DrawMouseSwap
CCNoSwap:       mov  al,es:[di]
                mov  _MaxFrame,al
                mov  _CurFrame,0
                mov  al,es:[di+1]
                mov  _MouseDelay,al
                mov  _CurDelay,0
                mov  al,es:[di+2]
                mov  _HotSpotX,al
                mov  al,es:[di+3]
                mov  _HotSpotY,al
                mov  word ptr cs:[_MouseAnimPtr+2],es
                mov  word ptr cs:[_MouseAnimPtr],di
                add  word ptr cs:[_MouseAnimPtr],4
                adc  word ptr cs:[_MouseAnimPtr+2],0
                mov  word ptr cs:[_CurAnimPtr+2],es
                mov  word ptr cs:[_CurAnimPtr],di
                add  word ptr cs:[_CurAnimPtr],4
                adc  word ptr cs:[_CurAnimPtr+2],0
                cmp  _MouseVisible,0
                jle  CCNoCursor
                call DrawMouseCursor
CCNoCursor:     mov  byte ptr _08Idle,1
                mov  byte ptr _0CIdle,1
                pop  si ax bp
                ret
ChangeCursor    endp

SelectArea      proc
                push cx dx si di es
                mov  si,offset _Areas
                mov  cx,_MouseX
                mov  dx,_MouseY
                ;mov  ax,3
                ;int  33h
SASelStart:     cmp  cx,cs:[si]
                jc   SASelNext
                cmp  cx,cs:[si+4]
                ja   SASelNext
                cmp  dx,cs:[si+2]
                jc   SASelNext
                cmp  dx,cs:[si+6]
                ja   SASelNext
                mov  es,cs:[si+10]
                mov  di,cs:[si+8]
                call ChangeCursor
                jmp  SAExit
SASelNext:      add  si,12
                jmp  SASelStart
SAExit:         pop  es di si dx cx
                ret
SelectArea      endp

SelectArea2     proc
                push ax bx si di es
                mov  si,offset _Areas
                mov  ax,_MouseX
                mov  bx,_MouseY
S2SelStart:     cmp  ax,cs:[si]
                jc   S2SelNxt
                cmp  ax,cs:[si+4]
                ja   S2SelNxt
                cmp  bx,cs:[si+2]
                jc   S2SelNxt
                cmp  bx,cs:[si+6]
                ja   S2SelNxt
                mov  es,cs:[si+10]
                mov  di,cs:[si+8]
                jmp  S2Skip
S2SelNxt:       jmp  S2SelNext
S2Skip:         mov  ax,cs:[si+10]
                mov  bx,cs:[si+8]
                add  bx,4
                adc  ax,0
                cmp  ax,word ptr [_MouseAnimPtr+2]
                jnz  S2ChangeStart
                cmp  bx,word ptr [_MouseAnimPtr]
                jnz  S2ChangeStart
                jmp  S2Exit

S2ChangeStart:  push ax ds
                mov  al,es:[di]
                mov  _MaxFrame,al
                mov  _CurFrame,0
                mov  al,es:[di+1]
                mov  _MouseDelay,al
                mov  _CurDelay,0
                mov  al,es:[di+2]
                mov  _HotSpotX,al
                mov  al,es:[di+3]
                mov  _HotSpotY,al
                mov  word ptr cs:[_MouseAnimPtr+2],es
                mov  word ptr cs:[_MouseAnimPtr],di
                add  word ptr cs:[_MouseAnimPtr],4
                adc  word ptr cs:[_MouseAnimPtr+2],0
                mov  word ptr cs:[_CurAnimPtr+2],es
                mov  word ptr cs:[_CurAnimPtr],di
                add  word ptr cs:[_CurAnimPtr],4
                adc  word ptr cs:[_CurAnimPtr+2],0
                pop  si ax

                jmp  S2Exit
S2SelNext:      add  si,12
                jmp  S2SelStart
S2Exit:         pop  es di si bx ax
                ret
SelectArea2     endp

Int08Handler    proc
                pushf
                db   9Ah
_Old08Ofs:      dw   ?
_Old08Seg:      dw   ?
                push ax cx dx
                inc  word ptr _MouseIdle         ;увеличить счетчик простоя
                cmp  _MaxFrame,0
                jnz  I8HCont1
                jmp  I8HExit
I8HCont1:       mov  cl,_CurDelay
                cmp  cl,_MouseDelay              ;надо ли следующий кадр?
                jz   I8HNextFrame                ;да
                inc  _CurDelay                   ;подождем еще
                jmp  I8HExit                     ;и выходим
I8HNextFrame:   mov  _CurDelay,0                 ;сбросим счетчик
                inc  _CurFrame                   ;следующий кадр
                mov  cl,_MaxFrame
                cmp  _CurFrame,cl
                jbe  I8HNoZeroing                ;не надо обнулять
                mov  _CurFrame,0                 ;иначе обнулим
                jmp  I8HNewCycle                 ;и переинициализируем
I8HNoZeroing:                                    ;иначе - следующий кадр
                mov  dx,word ptr cs:[_CurAnimPtr+2]
                mov  cx,word ptr cs:[_CurAnimPtr]
                add  cx,1024
                adc  dx,0
                mov  word ptr cs:[_CurAnimPtr+2],dx
                mov  word ptr cs:[_CurAnimPtr],cx
                jmp  I8HCont
I8HNewCycle:    mov  dx,word ptr cs:[_MouseAnimPtr+2]
                mov  cx,word ptr cs:[_MouseAnimPtr]
                mov  word ptr cs:[_CurAnimPtr+2],dx
                mov  word ptr cs:[_CurAnimPtr],cx
I8HCont:        cmp  _MouseVisible,0
                jle  I8HExit
                cmp  byte ptr _0CIdle,1
                jnz  I8HExit
                mov  byte ptr _08Idle,0
                mov  dx,03DAh
I8Wait:         in   al,dx
                test al,00001000b
                jz   I8Wait
                call DrawMouseSwap
                call DrawMouseCursor
                mov  byte ptr _08Idle,1
I8HExit:        pop  dx cx ax
                iret
Int08Handler    endp

Int0CHandler    proc
;                pushf
;                db   9Ah                         ;вызвали старый обработчик
;_Old0COfs:      dw   ?
;_Old0CSeg:      dw   ?
                push ax bx cx dx bp si di ds es
                cmp  byte ptr _MouseVisible,0    ;если мышь не видна
                jg   ICHStillHere
                mov  cs:_MouseX,cx               ; сохраняем положение !!!
                mov  cs:_MouseY,dx               ; БЛИН, ДИМА !!!
                jmp  ICHOut                      ;то выходим
ICHStillHere:   mov  word ptr _MouseIdle,0       ;мышь передвинута
;                mov  ax,3
;                int  33h
                cmp  cx,_MouseX
                jnz  ICHMMoved
                cmp  dx,_MouseY
                jnz  ICHMMoved
                jmp  ICHOut
ICHMMoved:      mov  word ptr _NewMouseX,cx
                mov  word ptr _NewMouseY,dx
                cmp  byte ptr _08Idle,1
                jz   ICH8Idle
                jmp  ICHOut
ICH8Idle:       mov  byte ptr _0CIdle,0          ;устанавливаем блокировку
                call DrawMouseSwap               ;стираем курсор
                mov  cx,_NewMouseX
                mov  dx,_NewMouseY
                mov  word ptr _MouseX,cx         ;и запомним
                mov  word ptr _MouseY,dx         ;их
                mov  si,offset _Areas            ;выберем область
                mov  ax,_MouseX
                mov  bx,_MouseY
ICHSelStart:    cmp  ax,cs:[si]
                jc   ICHSelNext
                cmp  ax,cs:[si+4]
                ja   ICHSelNext
                cmp  bx,cs:[si+2]
                jc   ICHSelNext
                cmp  bx,cs:[si+6]
                ja   ICHSelNext
                mov  es,cs:[si+10]
                mov  di,cs:[si+8]
                jmp  ICHSelDone
ICHSelNext:     add  si,12
                jmp  ICHSelStart
                                                 ;выбрали в es:[di]
ICHSelDone:     mov  dx,es
                add  di,4                        ;пропустим NF, D, HSX, HSY
                adc  dx,0
                cmp  dx,word ptr cs:[_MouseAnimPtr+2]
                jnz  ICHSelCursor
                cmp  di,word ptr cs:[_MouseAnimPtr]
                jnz  ICHSelCursor
                jmp  ICHDraw                     ;если курсор не сменился, рисуем
ICHSelCursor:   push dx
                mov  dx,es
                sub  di,4                        ;вернемся в начало
                sbb  dx,0
                mov  es,dx
                pop  dx
                mov  al,es:[di]
                mov  _MaxFrame,al                ;установим NF
                mov  _CurFrame,0
                mov  al,es:[di+1]
                mov  _MouseDelay,al              ;установим D
                mov  _CurDelay,0
                mov  al,es:[di+2]
                mov  _HotSpotX,al                ;установим HSX
                mov  al,es:[di+3]
                mov  _HotSpotY,al                ;установим HSY
                mov  word ptr cs:[_MouseAnimPtr+2],es
                mov  word ptr cs:[_MouseAnimPtr],di
                add  word ptr cs:[_MouseAnimPtr],4
                adc  word ptr cs:[_MouseAnimPtr+2],0
                mov  word ptr cs:[_CurAnimPtr+2],es
                mov  word ptr cs:[_CurAnimPtr],di
                add  word ptr cs:[_CurAnimPtr],4
                adc  word ptr cs:[_CurAnimPtr+2],0
ICHDraw:        call DrawMouseCursor
                mov  byte ptr _0CIdle,1                   ;снимаем блокировку
ICHOut:         pop  es ds di si bp dx cx bx ax
                retf
Int0CHandler    endp

ShowMouse       proc far
                push ax cx dx
                inc  _MouseVisible
                cmp  _MouseVisible,1
                jnz  SMExit
                cli
                ;mov  ax,_NewMouseX
                ;mov  _MouseX,ax
                ;mov  ax,_NewMouseY
                ;mov  _MouseY,ax
                mov  byte ptr _0CIdle,0
                mov  byte ptr _08Idle,0
                mov  ax,3
                int  33h
                mov  _MouseX,cx
                mov  _MouseY,dx
                call SelectArea2
                call DrawMouseCursor
                mov  byte ptr _0CIdle,1
                mov  byte ptr _08Idle,1
                sti
SMExit:         pop  dx cx ax
                ret
ShowMouse       endp

ShowMouse1      proc far
                push ax cx dx
                inc  _MouseVisible
                cmp  _MouseVisible,1
                jz   SMExit1
                cli
                mov  byte ptr _0CIdle,0
                mov  byte ptr _08Idle,0
                mov  ax,3
                int  33h
                mov  _MouseX,cx
                mov  _MouseY,dx
                call SelectArea2
                call DrawMouseCursor
                mov  byte ptr _0CIdle,1
                mov  byte ptr _08Idle,1
                sti
SMExit1:        pop  dx cx ax
                ret
ShowMouse1      endp


HideMouse       proc far
                dec  _MouseVisible
                cmp  _MouseVisible,0
                jnz  HMExit
                cli
                mov  byte ptr _0CIdle,0
                mov  byte ptr _08Idle,0
                call DrawMouseSwap
                mov  byte ptr _0CIdle,1
                mov  byte ptr _08Idle,1
                sti
HMExit:         ret
HideMouse       endp

Int33Handler    proc
                cmp  ax,04h                      ;move pointer shape
                jz   I33Exit
                cmp  ax,09h                      ;set graph pointer shape
                jz   I33Exit
                cmp  ax,0Ah                      ;set text pointer mask
                jz   I33Exit
                cmp  ax,0Dh                      ;enable lightpen emulation
                jz   I33Exit
                cmp  ax,0Eh                      ;disable lightpen emulation
                jz   I33Exit
                cmp  ax,10h                      ;set exclusion area
                jz   I33Exit
                cmp  ax,16h                      ;save mouse status
                jz   I33Exit
                cmp  ax,17h                      ;restore mouse status
                jz   I33Exit
                cmp  ax,1Ch                      ;set mouse interrupt rate
                jz   I33Exit
                cmp  ax,1Dh                      ;set display page
                jz   I33Exit
                cmp  ax,1Eh                      ;query active display page
                jz   I33Exit
                cmp  ax,1Fh                      ;deactivate mouse driver
                jz   I33Exit
                cmp  ax,20h                      ;activate mouse driver
                jz   I33Exit
                cmp  ax,21h                      ;reset mouse driver
                jz   I33Exit

                cmp  ax,1
                jnz  I33Chk02
                call ShowMouse
                jmp  I33Exit
I33Chk02:       cmp  ax,2
                jnz  I33Old
I33AX02:        call HideMouse
                jmp  I33Exit
I33Old:         pushf
                db   9Ah                         ;вызвали старый обработчик
_Old33Ofs:      dw   ?
_Old33Seg:      dw   ?
I33Exit:        iret
Int33Handler    endp

_VXMouseInit     proc far
                push ax bx cx dx di ds es
                mov  ax,0
                int  33h
                cmp  ax,0FFFFh
                jz   VXMIOK0
                ErrorI 201
                jmp  VXMIExit
VXMIOK0:        mov  _LastArea,offset _Areas
                mov  di,_LastArea
                mov  word ptr cs:[di],0
                mov  word ptr cs:[di+2],0
                mov  ax,ScreenX
                dec  ax
                mov  word ptr cs:[di+4],ax
                mov  ax,ScreenY
                dec  ax
                mov  word ptr cs:[di+6],ax
                mov  word ptr cs:[di+8],offset StandardCursor
                mov  word ptr cs:[di+10],cs
                mov  _NAreas,1
                mov  _MouseDelay,0
                mov  byte ptr _0CIdle,1
                mov  byte ptr _08Idle,1
                mov  word ptr _MouseIdle,0
                mov  ax,ScreenX
                shr  ax,1
                mov  cx,ax
                mov  ax,ScreenY
                shr  ax,1
                mov  dx,ax
                mov  _MouseX,cx
                mov  _MouseY,dx
                mov  ax,4
                int  33h                         ;курсор в центр экрана
                mov  dx,ScreenX
                dec  dx
                mov  cx,0
                mov  ax,7
                int  33h                         ;установили MinX, MaxX
                mov  dx,ScreenY
                dec  dx
                mov  cx,0
                mov  ax,8
                int  33h                         ;установили MinY, MaxY
                mov  _MaxFrame,0
                mov  _CurFrame,0
                push cs
                pop  es
                mov  di,offset StandardCursor
                call ChangeCursor
                mov  ax,350Ch
                int  21h
;                mov  word ptr cs:[_Old0CSeg],es
;                mov  word ptr cs:[_Old0COfs],bx
                mov  dx,offset Int0CHandler;ICHOut__;
                push cs
                pop  es
; mouse routenues
                mov  ax,0Ch
                mov  cx,3Fh
                int  33h
;                mov  ax,250Ch
;                int  21h
                mov  ax,3508h
                int  21h
                mov  word ptr cs:[_Old08Ofs],bx
                mov  word ptr cs:[_Old08Seg],es
                mov  dx,offset Int08Handler
                push cs
                pop  ds
                mov  ax,2508h
                int  21h
                mov  ax,3533h
                int  21h
                mov  word ptr cs:[_Old33Ofs],bx
                mov  word ptr cs:[_Old33Seg],es
                mov  dx,offset Int33Handler
                push cs
                pop  ds
                mov  ax,2533h
                int  21h
VXMIExit:       pop  es ds di dx cx bx ax
                retf
_VXMouseInit     endp

VXMouseDone     proc far
                push ax dx ds
                cmp  _MouseVisible,0
                jle  VXMDNoSwap
                call DrawMouseSwap
VXMDNoSwap:     cli
;                mov  ds,word ptr cs:[_Old0CSeg]
;                mov  dx,word ptr cs:[_Old0COfs]
;                mov  ax,250Ch
;                int  21h
                mov  ax,0Ch
                xor  cx,cx
                int  33h
                mov  ds,word ptr cs:[_Old08Seg]
                mov  dx,word ptr cs:[_Old08Ofs]
                mov  ax,2508h
                int  21h
                mov  ds,word ptr cs:[_Old33Seg]
                mov  dx,word ptr cs:[_Old33Ofs]
                mov  ax,2533h
                int  21h
                pop  ds dx ax
                sti
                retf
VXMouseDone     endp

SetAnimSequence proc far
                arg _oArr,_sArr:word=ArgSize
                push bp
                mov  bp,sp
                push si di es
                mov  es,_sArr
                mov  di,_oArr
                mov  si,_LastArea
                mov  cs:[si+8],di
                mov  cs:[si+10],es
                call SelectArea
                pop  es di si bp
                ret  ArgSize
SetAnimSequence endp


MouseX          proc far
                push cx dx
                mov  ax,3
                int  33h
                mov  ax,cx
                ;mov  ax,_MouseX
                pop  dx cx
                ret
MouseX          endp

MouseY          proc far
                push cx dx
                mov  ax,3
                int  33h
                mov  ax,dx
                ;mov  ax,_MouseY
                pop  dx cx
                ret
MouseY          endp

MouseButton     proc far
                push cx dx
                mov  ax,3
                int  33h
                mov  ax,bx
                pop  dx cx
                ret
MouseButton     endp

GetLastArea     proc
                ;output : es:di - LastAnim
                push si
                mov  si,_LastArea
                mov  di,cs:[si+8]
                mov  es,cs:[si+10]
                pop  si
                ret
GetLastArea     endp

ResetMouseCursor proc far
                 push di es cs
                 pop  es
                 mov  di,offset StandardCursor
                 call ChangeCursor
                 mov  si,_LastArea
                 mov  cs:[si+8],di
                 mov  cs:[si+10],es
                 call SelectArea
                 pop  es di
                 ret
ResetMouseCursor endp

ResetMyMouseCursor proc far
                     push di es cs
                     pop  es
                     mov  di,offset MyCursor
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetMyMouseCursor endp

ResetHand        proc far
                     push di es cs
                     pop  es
                     mov  di,offset Hand
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetHand        endp

ResetChronoCur   proc far
                     push di es cs
                     pop  es
                     mov  di,offset ChronoCur
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetChronoCur   endp

ResetArrowUp        proc far
                     push di es cs
                     pop  es
                     mov  di,offset ArrowUp
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetArrowUp        endp

ResetNoScroll        proc far
                     push di es cs
                     pop  es
                     mov  di,offset NoScroll
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetNoScroll        endp

ResetArrowDown      proc far
                     push di es cs
                     pop  es
                     mov  di,offset ArrowDown
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetArrowDown      endp

ResetArrowLeft      proc far
                     push di es cs
                     pop  es
                     mov  di,offset ArrowLeft
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetArrowLeft      endp

ResetArrowRight     proc far
                     push di es cs
                     pop  es
                     mov  di,offset ArrowRight
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetArrowRight     endp

ResetRepair        proc far
                     push di es cs
                     pop  es
                     mov  di,offset Repair
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetRepair        endp

ResetSold        proc far
                     push di es cs
                     pop  es
                     mov  di,offset Sold
                     call ChangeCursor
                     mov  si,_LastArea
                     mov  cs:[si+8],di
                     mov  cs:[si+10],es
                     call SelectArea
                     pop  es di
                     ret
ResetSold        endp

ResetMyMouseCursor2 proc far
                      push di es cs
                      pop  es
                      mov  di,offset MyCursor2
                      call ChangeCursor
                      mov  si,_LastArea
                      mov  cs:[si+8],di
                      mov  cs:[si+10],es
                      call SelectArea
                      pop  es di
                      ret
ResetMyMouseCursor2 endp

SetAnimDelay    proc far
                arg _NewDelay:byte=ArgSize
                push bp
                mov  bp,sp
                push ax di es
                mov  al,_NewDelay
                call GetLastArea
                mov  byte ptr es:[di+1],al
                call SelectArea
                pop  es di ax bp
                ret ArgSize
SetAnimDelay    endp

SetHotSpotX     proc far
                arg _NewHSX:byte=ArgSize
                push bp
                mov  bp,sp
                push ax di es
                mov  al,_NewHSX
                call GetLastArea
                mov  byte ptr es:[di+2],al
                call SelectArea
                pop  es di ax bp
                ret ArgSize
SetHotSpotX     endp

SetHotSpotY     proc far
                arg _NewHSY:byte=ArgSize
                push bp
                mov  bp,sp
                push ax di es
                mov  al,_NewHSY
                call GetLastArea
                mov  byte ptr es:[di+3],al
                call SelectArea
                pop  es di ax bp
                ret ArgSize
SetHotSpotY     endp

AddSpecialArea  proc far
                arg oSpec,sSpec,y2,x2,y1,x1:word=ArgSize
                push bp
                mov  bp,sp
                mov  _Result,0
                cmp  _NAreas,64
                jc   ASAAllOk
                jmp  ASAError
ASAAllOk:       push ax bx cx si di ds es
                mov  si,_LastArea
                mov  di,si
                add  di,12
                push cs cs
                pop  ds es
                mov  cx,6
                cld
                rep  movsw
                mov  si,_LastArea
                mov  bx,x1
                mov  cs:[si],bx
                mov  bx,y1
                mov  cs:[si+2],bx
                mov  bx,x2
                mov  cs:[si+4],bx
                mov  bx,y2
                mov  cs:[si+6],bx
                mov  bx,oSpec
                mov  cs:[si+8],bx
                mov  bx,sSpec
                mov  cs:[si+10],bx
                add  _LastArea,12
                inc  _NAreas
                call SelectArea
                pop  es ds di si cx bx ax
                jmp  ASAExit
ASAError:       mov  _Result,101
ASAExit:        pop  bp
                ret  ArgSize
AddSpecialArea  endp

DelSpecialArea  proc far
                arg Num:byte=ArgSize
                push bp
                mov  bp,sp
                mov  _Result,0
                push ax si di ds es
                mov  al,Num
                cmp  al,_NAreas
                jnc  DSAError
                cmp  al,0
                jz   DSAError
                mov  ah,12
                mul  ah
                mov  si,offset _Areas
                add  si,ax
                mov  di,si
                sub  di,12
                push cs cs
                pop  es ds
                mov  cx,_LastArea
                sub  cx,di
                shr  cx,1
                cld
                rep  movsw
                dec  _NAreas
                sub  _LastArea,12
                call SelectArea
                jmp  DSAExit
DSAError:       mov  _Result,102
DSAExit:        pop  es ds di si ax bp
                ret  ArgSize
DelSpecialArea  endp

NumOfSpecialAreas       proc far
                        mov  al,_NAreas
                        dec  al
                        ret
NumOfSpecialAreas       endp

SavePalette     proc far
                push es
                mov  ax,1017h
                xor  bx,bx
                mov  cx,256
                push cs
                pop  es
                mov  dx,offset _OldPalette
                int  10h
                pop  es
                ret
SavePalette     endp

RestorePalette  proc far
                push es
                mov  ax,1012h
                xor  bx,bx
                mov  cx,256
                push cs
                pop  es
                mov  dx,offset _OldPalette
                int  10h
                pop  es
                ret
RestorePalette  endp

SetStdPalette   proc far
                push es
                mov  ax,1012h
                xor  bx,bx
                mov  cx,256
                push cs
                pop  es
                mov  dx,offset StandardPalette
                int  10h
                pop  es
                ret
SetStdPalette   endp

SetWriteMode    proc far
                arg  NewMode:byte=ArgSize
                push bp
                mov  bp,sp
                mov  al,NewMode
                mov  _WriteMode,al
                pop  bp
                ret  ArgSize
SetWriteMode    endp

SetMouseArea    proc far
                arg  NewY2, NewX2, NewY1, NewX1 : word = ArgSize
                push bp
                mov  bp,sp
                push ax
                mov  ax,0007h
                mov  cx,NewX1
                mov  dx,NewX2
                int  33h
                mov  ax,0008h
                mov  cx,NewY1
                mov  dx,NewY2
                pop  ax bp
                ret  ArgSize
SetMouseArea    endp

SetWSize        proc far
                arg  NewY2, NewX2, NewY1, NewX1 : word = ArgSize
                push bp
                mov  bp,sp
                push ax
                mov  ax,NewX1
                mov  _VMinX,ax
                mov  ax,NewX2
                mov  _VMaxX,ax
                mov  ax,NewY1
                mov  _VMinY,ax
                mov  ax,NewY2
                mov  _VMaxY,ax
                pop  ax bp
                ret  ArgSize
SetWSize        endp

MouseIdle       proc far
                mov  ax,_MouseIdle
                ret
MouseIdle       endp

ResetMouseAC    proc far
                mov  word ptr _MouseIdle,0
                ret
ResetMouseAC    endp

GetPage         proc
                ; => ax - EMS handler
                pusha
                call dword ptr cs:_EMSGet
                mov  cs:EMSTMP,ax
                popa
                mov  ax,cs:EMSTMP
                ret
GetPage         endp

FreePage        proc
                ; ax - EMSHandler
                pusha
                push  ax
                call  dword ptr cs:_EMSFree
                popa
                ret
FreePage        endp

Map             proc
                ; ax - EMSHandler, bx - frame
                pusha
                mov   si,bx
                shl   si,1
                add   si,offset EMSP1
                cmp   cs:[si],ax
                jz    MapNO
                mov   cs:[si],ax
                push  ax
                push  bx
                call  dword ptr cs:_EMSMap
MapNO:
                popa
                ret
Map             endp

GetFrame        proc
                ; => ax - EMS handler
                pusha
                call dword ptr cs:_EMSFrame
                mov  cs:EMSFrame,ax
                popa
                ret
GetFrame        endp

SqrNumSubst     proc
                ; => ax := Sqr(al-ah)
                cmp  al,ah
                jnc  SqrNum_1
                xchg ah,al
SqrNum_1:
                sub  al,ah
                mov  ah,al
                mul  ah
                ret
SqrNumSubst     endp

SumSqr          proc
                ; ax = Sqr(ax) + Sqr(bx) + Sqr(cx)
                push   bx cx
                call   SqrNumSubst
                xchg   bx,ax
                call   SqrNumSubst
                add    bx,ax
                mov    ax,cx
                call   SqrNumSubst
                add    ax,bx
                pop    cx bx
                ret
SumSqr          endp

FindNear        proc
                ; this function find most near color for defined in
                ; ah - Red, bh - Green, ch - blue
                ; => al
                push    ax bx cx dx si di bp ds
                push    cs
                pop     ds
                mov     si,offset StandardPalette
                mov     dx,0FFFFh
                mov     di,224
                mov     bp,si
FindN_1:
                push    ax
                mov     al,byte ptr [si]
                mov     bl,byte ptr [si+1]
                mov     cl,byte ptr [si+2]
                call    SumSqr
                cmp     ax,dx
                jnc     FindN_2
                mov     dx,ax
                mov     bp,si
FindN_2:
                add     si,3
                pop     ax
                dec     di
                jnz     FindN_1
                sub     bp,offset StandardPalette
                mov     bl,3
                mov     ax,bp
                div     bl
                xor     ah,ah
                mov     EmsTMP,ax
                pop     ds bp di si dx cx bx ax
                mov     ax,cs:EMSTMP
                ret
FindNear        endp

FindShadow      proc
                ; this procedure find shadow color for all colors in standart
                ; palette, result of word put in the array 'ShadowColors'
                pusha
                push    ds
                push    cs
                pop     ds
                mov     dx,256
                mov     di,offset ShadowColors
                mov     si,offset StandardPalette
FindS_1:
                mov     ah,byte ptr [si]
                mov     bh,byte ptr [si+1]
                mov     ch,byte ptr [si+2]
                shr     ah,1
                shr     bh,1
                shr     ch,1
                add     si,3
                call    FindNear
                mov     byte ptr ds:[di],al
                inc     di
                dec     dx
                jnz     FindS_1
                pop     ds
                popa
                ret
FindShadow      endp

MapGlas         proc
                ; this procedure make adresable
                push   ax bx
                mov    ax,cs:Glases1
                mov    bx,0
                call   Map
                mov    ax,cs:Glases2
                mov    bx,1
                call   Map
                pop    bx ax
                ret
MapGlas         endp

PutInGlas       proc
                ;al - i, bl - j, cl - color
                push    ax bx di es
                cmp     al,bl
;                jz      PIG_Exit
                jnc     PIG_1
                xchg    al,bl
PIG_1:
                xor     ah,ah
                xor     bh,bh
                push    bx
                mov     bl,al
;                dec     bl
                mul     bl
                pop     bx
                shr     ax,1
                add     ax,bx
                mov     di,ax
                mov     es,cs:EMSFrame
                mov     es:[di],cl ;al
PIG_Exit:
                pop     es di bx ax
                ret
PutInGlas       endp

GetInGlas       proc
                ;al - i, bl - j => al - color
                call    MapGlas            ;adresing array
                push    bx di es
                cmp     al,bl
;                jz      GIG_Exit
                jnc     GIG_1
                xchg    al,bl
GIG_1:
                xor     ah,ah
                xor     bh,bh
                push    bx
                mov     bl,al
;                dec     bl
                mul     bl
                pop     bx
                shr     ax,1
                add     ax,bx
                mov     di,ax
                mov     es,cs:EMSFrame
                mov     al,es:[di]
GIG_Exit:
                pop     es di bx
                ret
GetInGlas       endp

FindGlases      proc
                ; this procedure find glases colors and store it in teh EMS
                pusha
                push    cs
                pop     ds
                call    GetFrame
                call    GetPage
                mov     Glases1,ax
                call    GetPage
                mov     Glases2,ax
                mov     ax,224
                call    MapGlas            ;adresing array
FGL_2:
                mov     bx,ax
                dec     ax
                push    ax
                mov     cl,3
                mul     cl
                mov     si,ax
                add     si,offset StandardPalette
                pop     ax
FGL_1:
                dec     bx
                push    ax
                mov     al,bl
                mov     cl,3
                mul     cl
                mov     di,ax
                add     di,offset StandardPalette
                pop     ax

                push    ax bx cx
                mov     al,[si]
                mul     byte ptr [di]
                shr     ax,6
                push    ax
                mov     al,[si+1]
                mul     byte ptr [di+1]
                shr     ax,6
                mov     bh,al
                mov     al,[si+2]
                mul     byte ptr [di+2]
                shr     ax,6
                mov     ch,al
                pop     ax
                ;call    FindNear
                mov     dl,al
                pop     cx bx ax
                mov     cl,dl
                ;mov     cl,14
                ;call    PutInGlas

                or      bl,bl
                jnz     FGL_1
                or      al,al
                jnz     FGL_2
                popa
                ret
FindGlases      endp

GetTextDot      proc
                ; this procedure return color of texture dot
                ; _GranUnit:di - curent pozition
                ; => ah - color
                push    bx cx dx di es
                ; encount curent coord
                mov     dx,cs:_GranUnit
                mov     ax,di
                div     word ptr cs:ScreenX
                push    dx
                xor     dx,dx
                div     cs:TextHigh             ; now dx - high offset
                mov     bx,dx
                mov     ax,cs:TextLeng
                mul     bx
                mov     bx,ax
                pop     ax
                xor     dx,dx
                div     cs:TextLeng             ; now dx - leng offset
                add     bx,dx
                les     di,cs:Texture
                mov     ah,es:[di+bx]
                pop     es di dx cx bx
                ret
GetTextDot      endp

SetTexture      proc
                push    bp
                mov     bp,sp
                push    es
                les     di,[bp+6]
                TestRegister es,di
                mov     ax,es:[di]
                mov     cs:TextLeng,ax
                mov     ax,es:[di+2]
                mov     cs:TextHigh,ax
                add     di,4
                mov     word ptr cs:Texture,di
                mov     word ptr cs:Texture+2,es
                pop     es
                pop     bp
                retf    4
SetTexture      endp

LinkEMS         proc
                ; procedure LinkEms(Get,Free,Map,Frame:pointer)
                ;                   +18 +14  +10   +6
                push   bp
                mov    bp,sp
                mov    ax,[bp+6]
                mov    word ptr cs:_EMSFrame,ax
                mov    ax,[bp+8]
                mov    word ptr cs:_EMSFrame+2,ax
                mov    ax,[bp+10]
                mov    word ptr cs:_EMSMap,ax
                mov    ax,[bp+12]
                mov    word ptr cs:_EMSMap+2,ax
                mov    ax,[bp+14]
                mov    word ptr cs:_EMSFree,ax
                mov    ax,[bp+16]
                mov    word ptr cs:_EMSFree+2,ax
                mov    ax,[bp+18]
                mov    word ptr cs:_EMSGet,ax
                mov    ax,[bp+20]
                mov    word ptr cs:_EMSGet+2,ax
                pop    bp
                retf   16
LinkEms         endp

MapingBgr       proc
                ; this procedure make adressable in EMS work array
                pusha
                mov     ax,cs:BackGrPg1
                mov     bx,0
                call    map
                mov     ax,cs:BackGrPg2
                mov     bx,1
                call    map
                mov     ax,cs:BackGrPg3
                mov     bx,2
                call    map
                mov     ax,cs:BackGrPg4
                mov     bx,3
                call    map
                popa
                ret
MapingBgr       endp


SetWorkScreen   proc
                ; procedure SetWorkScreen (x ,y ,leng,high:word);
                ;                          +C +A  +8   +6
                push    bp
                mov     bp,sp
                mov     ax,[bp+0Ah]
                mul     cs:ScreenX
                add     ax,[bp+0Ch]
                adc     dx,0
                mov     cs:MapStart,ax
                mov     cs:MapBank,dx
                mov     bx,[bp+8h]
                mov     ax,cs:ScreenX
                sub     ax,bx
                mov     cs:XDop,ax
                shr     bx,4
                mov     cs:XWinSize,bx
                mov     bx,[bp+6h]
                and     bx,0FFF0h
                mov     cs:YWinSize,bx
                shr     bx,4
                mov     cs:YWinSize_,bx
                mov     ax,[bp+06h]
                add     ax,[bp+0Ah]
                mov     cs:TMPY,ax
                mov     ax,[bp+08h]
                add     ax,[bp+0Ch]
                mov     cs:TMPX,ax
                call    GetPage
                mov     cs:BackGrPg1,ax
                call    GetPage
                mov     cs:BackGrPg2,ax
                call    GetPage
                mov     cs:BackGrPg3,ax
                call    GetPage
                mov     cs:BackGrPg4,ax
                call    GetPage
                mov     cs:BackGrPg5,ax
                call    GetPage
                mov     cs:BackGrPg6,ax
                pop     bp
                retf    8
SetWorkScreen   endp

SetMapVal       proc
                ; procedure SetMapVal(x,y:word; value:byte);
                push    bp
                mov     bp,sp
                push    es
                call    MapingBgr  ; set adressing map array
                mov     es,cs:EMSFrame
                mov     di,8000h + 2048
                mov     ax,[bp+08h]
                mul     cs:XSizeMap
                add     ax,[bp+0Ah]
                adc     dx,0
                or      dx,dx
                jnz     SetMVExit
                add     di,ax
                jc      SetMVExit
                mov     ax,[bp+06h]
                mov     es:[di],al
SetMVExit:
                pop     es
                pop     bp
                retf    6
SetMapVal       endp

GetMapVal       proc
                ; function GetMapVal(x,y:word):byte;
                push    bp
                mov     bp,sp
                push    es
                call    MapingBgr  ; set adressing map array
                mov     es,cs:EMSFrame
                mov     di,8000h + 2048
                mov     ax,[bp+08h]
                mul     cs:XSizeMap
                add     ax,[bp+0Ah]
                adc     dx,0
                or      dx,dx
                jnz     GetMVExit
                add     di,ax
                jc      SetMVExit
                mov     ax,[bp+06h]
                mov     al,es:[di]
GetMVExit:
                pop     es
                pop     bp
                retf    6
GetMapVal       endp


SetMapBorder    proc
                ; procedure SetMapBorder (y,left,right:word);
                push    bp
                mov     bp,sp
                mov     ax,[bp+0Ah]
                cmp     ax,1024
                jnc     SetMBExit

                push    es
                call    MapingBgr
                mov     es,cs:EMSFrame
                mov     di,8000h
                shl     ax,1
                add     di,ax
                mov     ax,[bp+08h]
                and     al,0Eh
                mov     es:[di],al
                mov     ax,[bp+06h]
                and     al,0Eh
                mov     es:[di+1],al
                pop     es
SetMBExit:
                pop     bp
                retf    6
SetMapBorder    endp

SetMapSize      proc
                ; procedure SetMapSize (leng,high:word);
                push    bp
                mov     bp,sp
                mov     ax,[bp+6]
                mov     cs:YSizeMap,ax
                mov     ax,[bp+8]
                mov     cs:XSizeMap,ax
                xor     ax,ax
                mov     cs:XMap,ax
                mov     cs:YMap,ax
                pop     bp
                retf    4
SetMapSize      endp

SetMapTexture   proc
                ; procedure SetMapTexture (Value:word; Texture:pointer);
                push    bp
                mov     bp,sp
                call    MapingBgr
                mov     ax,[bp+0Ah]
                push    ds es
                mov     ah,al
                xor     al,al
                mov     di,ax
                mov     es,cs:EMSFrame
                lds     si,[bp+06h]
                TestRegister ds,si
                add     si,4
                mov     cx,128
                cld
                rep     movsw
                pop     es ds
                pop     bp
                retf    6
SetMapTexture   endp


OutBackGrLine   proc
                ; this procedure Out one BackGround Line
                ; without bank control
                ; ---------------------------
                ; es:di - video buffer offset
                ; ds - ems frame
                ; dx - square counter
                ; bx - offset in map array
                ; bp - offset in border array
                ; si - start offset in the sprite
                push    bx cx dx
                cld
                push    si
OBGL_4:
                mov     cx,si
                mov     ch,[bx]
                mov     si,cx
                push    si
                mov     cx,16
                test    si,8000h
                jz      OBGL_5
                xor     al,al
                rep     stosb
                inc     bp
                inc     bp
                jmp     OBGL_6
OBGL_5:
                lodsb
                db      64h,84h,66h,00h
                jnz     OBGL__1
                mov     es:[di],al
OBGL__1:
                inc     di
                ror     ah,1
                adc     bp,0
                loop    OBGL_5
OBGL_6:
                pop     si
                inc     bx
                dec     dx
                jnz     OBGL_4

                pop     si
                pop     dx cx bx
                ret
OutBackGrLine   endp


OutBackGrLineB  proc
                ; this procedure Out one BackGround Line
                ; with bank control, but some slow
                ; ---------------------------
                ; es:di - video buffer offset
                ; ds - ems frame
                ; dx - square counter
                ; bx - offset in map array
                ; bp - offset in border array
                ; si - start offset in the sprite
                push    bx cx dx
                cld

                push    si
OBGB_4:
                mov     cx,si
                mov     ch,[bx]
                mov     si,cx
                push    si
                mov     cx,16
                test    si,8000h
                jz      OBGB_5
                xor     al,al
OBGB_5_3:
                stosb
                or      di,di
                jnz     OBGB_5_2
                push    dx
                mov     dx,cs:_GranUnit
                inc     dx
                call    SwitchGran
                pop     dx
OBGB_5_2:
                loop    OBGB_5_3
                inc     bp
                inc     bp
                jmp     OBGB_6
OBGB_5:
                lodsb
                db      64h,84h,66h,00h
                jnz     OBGB__1
                mov     es:[di],al
OBGB__1:
                ror     ah,1
                adc     bp,0
                inc     di
                jnz     OBGB_5_1
                push    dx
                mov     dx,cs:_GranUnit
                inc     dx
                call    SwitchGran
                pop     dx
OBGB_5_1:
                loop    OBGB_5
OBGB_6:
                pop     si
                inc     bx
                dec     dx
                jnz     OBGB_4

                pop     si
                pop     dx cx bx
                ret
OutBackGrLineB  endp

OutBackGround   proc
                ; procedure OutBackGround;
                push    bp ds es
                mov     di,cs:MapStart
                mov     dx,cs:MapBank
                call    SwitchGran
                call    MapingBgr
                xor     si,si
                mov     bx,8000h+2048
                mov     es,cs:StartSegA
                mov     ds,cs:EMSFrame
                mov     al,byte ptr cs:YMap
                mov     ah,byte ptr cs:XSizeMap
                mul     ah
                add     ax,cs:XMap
                add     bx,ax
                sub     bx,cs:XSizeMap
                xor     si,si
                mov     cx,cs:YWinSize
                mov     ax,cs:BitImage
                db      8Eh,0E0h
                push    cx dx
                mov     dx,cs:_GranUnit
                mov     ax,di
                mov     cx,8
                div     cx
                mov     bp,ax
                mov     cx,dx
                mov     ah,80h
                shr     ah,cl
                pop     dx cx
OBGR_1:
                push    ax
                push    bp
                mov     dx,cs:XWinSize
                and     si,0F0h
                jnz     OBGR_2
                add     bx,cs:XSizeMap
                xor     si,si
OBGR_2:
                push    di
                add     di,cs:ScreenX
                pop     di
                jc      OBGR_4
                call    OutBackGrLine
                jmp     OBGR_5
OBGR_4:
                call    OutBackGrLineB
OBGR_5:
                add     di,cs:XDOP
                jnc     OBGR_3
                push    dx
                mov     dx,cs:_GranUnit
                inc     dx
                call    SwitchGran
                pop     dx
OBGR_3:
                add     si,10h
                pop     bp
                mov     ax,cs:ScreenX
                shr     ax,3
                add     bp,ax
                pop     ax
                loop    OBGR_1
                pop     es ds bp
                retf
OutBackGround   endp


SetMapPos       proc
                ; procedure SetMapPos(x,y:word);
                push    bp
                mov     bp,sp
                mov     ax,[bp+6]
                mov     bx,cs:YSizeMap
                sub     bx,cs:YWinSize_
                cmp     ax,bx
                jc      SetMapPos1
                and     ax,ax
                js      SetMapPos2
                mov     ax,bx
                jmp     SetMapPos1
SetMapPos2:
                xor     ax,ax
SetMapPos1:
                mov     cs:YMap,ax
                mov     ax,[bp+8]
                mov     bx,cs:XSizeMap
                sub     bx,cs:XWinSize
                cmp     ax,bx
                jc      SetMapPos3
                and     ax,ax
                js      SetMapPos4
                mov     ax,bx
                jmp     SetMapPos3
SetMapPos4:
                xor     ax,ax
SetMapPos3:
                mov     cs:XMap,ax
                pop     bp
                retf    4
SetMapPos       endp

SetMatrFont     proc
                ; procedure SetMatrFont (p:pointer);
                push    bp
                mov     bp,sp
                mov     cx,2048
                cld
                push    ds es
                mov     di,offset StandardFont
                push    cs
                pop     es
                lds     si,[bp+6]
                rep     movsw
                pop     es ds
                pop     bp
                retf    4
SetMatrFont     endp

SetDinamic      proc
                ; procedure SetDinamic(a,b:word);
                push    bp
                mov     bp,sp
                mov     ax,[bp+6] ;b - Bit Image Array
                mov     cs:BitImage,ax
                mov     ax,[bp+8] ;a - List Image Array
                mov     cs:List,ax
                pop     bp
                retf    4
SetDinamic      endp

alloc           proc
                push    ax bx
                shl     bx,1

                mov     ax,cs:[offset SprTable+bx]
                push    bx
                or      ax,ax
                jnz     alloc_ok1
                call    getpage
                mov     cs:[offset SprTable+bx],ax
alloc_ok1:
                mov     bx,0
                call    map
                pop     bx

                mov     ax,cs:[offset SprTable+bx+2]
                push    bx
                or      ax,ax
                jnz     alloc_ok2
                call    getpage
                mov     cs:[offset SprTable+bx+2],ax
alloc_ok2:
                mov     bx,1
                call    map
                pop     bx
                mov     ax,cs:[offset SprTable+bx+4]

                push    bx
                or      ax,ax
                jnz     alloc_ok3
                call    getpage
                mov     cs:[offset SprTable+bx+4],ax
alloc_ok3:
                mov     bx,2
                call    map
                pop     bx
                mov     ax,cs:[offset SprTable+bx+6]

                push    bx
                or      ax,ax
                jnz     alloc_ok4
                call    getpage
                mov     cs:[offset SprTable+bx+6],ax
alloc_ok4:
                mov     bx,3
                call    map
                pop     bx

                pop     bx ax
                ret
alloc           endp

alloc1          proc
                push    ax bx
                shl     bx,1

                mov     ax,cs:[offset SprTable+bx]
                push    bx
                mov     bx,0
                call    map
                pop     bx

                mov     ax,cs:[offset SprTable+bx+2]
                push    bx
                mov     bx,1
                call    map
                pop     bx
                mov     ax,cs:[offset SprTable+bx+4]

                push    bx
                mov     bx,2
                call    map
                pop     bx
                mov     ax,cs:[offset SprTable+bx+6]

                push    bx
                mov     bx,3
                call    map
                pop     bx

                pop     bx ax
                ret
alloc1          endp



GetMem          proc
                ; this procedure allocated mem, size - ax; => es:di - memory
                mov     bx,cs:curpage
                mov     cs:curp,bx
                mov     dx,cs:curoffs
                mov     cs:curo,dx
                call    alloc
                mov     es,cs:EMSFrame
                mov     di,dx
                add     dx,ax
                mov     cx,dx
                shr     cx,14
                add     cs:curpage,cx
                and     dx,07FFFh
                mov     cs:curoffs,dx
                ret
GetMem          endp


LoadSprite      proc
                ; function LoadSprite(p:pointer):pointer;
                push    bp
                mov     bp,sp
                push    ds es
                lds     si,[bp+6]
                TestRegister ds,si
                mov     bx,[si]
                mov     ax,[si+2]
                mul     bx
                add     ax,4
                adc     dx,0
                call    getmem
                ; now in ax - sprite size
                mov     cx,ax
                cld
                rep     movsb
                mov     ax,cs:curp
                or      ax,0F000h
                mov     dx,cs:curo
                xchg    dx,ax
                pop     es ds
                pop     bp
                retf    4
LoadSprite      endp

putcxpixels     proc
                ; this procedures fill cx bites in bit buffer,
                ; addressed by es:di with ax mask
@@putcxpixel1:
                 jcxz   @@putcxpixel2
                 or     es:[di],al
                 dec    cx
                 ror    al,1
                 jnc    @@putcxpixel1
                 inc    di
                 jcxz   @@putcxpixel2
                 push   ax cx
                 shr    cx,3
                 mov    al,0FFh
                 cld
                 rep    stosb
                 pop    cx ax
                 and    cx,07h
                 jcxz   @@putcxpixel2
@@putcxpixel3:
                 or     es:[di],al
                 ror    al,1
                 adc    di,0
                 loop   @@putcxpixel3
@@putcxpixel2:
                 ret
putcxpixels     endp

jmpcxpixels     proc
                ; this procedures fill cx bites in bit buffer,
                ; addressed by es:di with ax mask
;@@jmpcxpixel1:
;                ror     al,1
;                jnc     @@jmpcxpixel2
;                inc     di
;@@jmpcxpixel2:
;                loop    @@jmpcxpixel1
                push    bx cx
                mov     bl,al
                shr     cx,3
                add     di,cx
                pop     cx
                and     cx,7h
                ror     al,cl
                cmp     bl,al
                adc     di,0
                pop     bx
                xor     cx,cx
                ret
jmpcxpixels     endp


FillBitBuf      proc
                ; this procedure Fill Default values in the BitImage
                pusha
                push    ds es
                mov     es,cs:BitImage
                xor     di,di           ; es:di - bitbuffer
                mov     cx,32768
                cld
                xor     ax,ax
                rep     stosw
                ; di - again 0
                mov     al,80h
                ;fill up unused line

                mov     cx,cs:MapBank
                jcxz    @@FBit2
@@FBit1:
                push    cx
                mov     cx,32768
                call    putcxpixels
                mov     cx,32768
                call    putcxpixels
                pop     cx
                loop    @@FBit1
@@FBit2:
                mov     cx,cs:MapStart
                jcxz    @@FBit3
                call    putcxpixels
@@FBit3:
                ; fill upper part
                call    mapingbgr
                mov     ds,cs:EMSFrame
                mov     bp,8000h
                mov     bx,8000h+2048           ; bp - offset, bx - map
                push    ax
                mov     al,byte ptr cs:YMap
                mov     ah,byte ptr cs:XSizeMap
                mul     ah
                add     ax,cs:XMap
                add     bx,ax
                sub     bx,cs:XSizeMap
                pop     ax

                xor     dx,dx
                mov     si,bx

@@Fbit4:
                mov     cx,cs:XWinSize
                test    dx,0Fh
                jnz     @@FBit5
                add     si,cs:XSizeMap
                mov     bx,si
@@FBit5:
                test    byte ptr [bx],80h
                jz      @@FBit6
                push    cx
                mov     cx,10h
                call    putcxpixels
                pop     cx
                jmp     @@FBit7
@@Fbit6:
                push    cx
                cmp     cx,cs:XWinSize
                jz      @@FBit6_1
                cmp     cx,1
                jz      @@Fbit6_2
                mov     cx,10h
                call    jmpcxpixels
                jmp     @@Fbit7_2
@@Fbit6_2:
                mov     cx,10h
                sub     cl,ds:[bp+1]
                jcxz    @@FBit6_2_1
                call    jmpcxpixels
@@FBit6_2_1:
                mov     cl,ds:[bp+1]
                jcxz    @@FBit6_2_2
                call    putcxpixels
@@FBit6_2_2:
                jmp     @@Fbit7_2
@@FBit6_1:
                mov     cx,10h
                sub     cl,ds:[bp]
                push    cx
                mov     cl,ds:[bp]
                jcxz    @@FBit7_1
                call    putcxpixels
@@Fbit7_1:
                pop     cx
                jcxz    @@FBit7_2
                call    jmpcxpixels
@@Fbit7_2:
                pop     cx
@@Fbit7:
                inc     bx
                loop    @@FBit5
                mov     bx,si
                mov     cx,cs:ScreenX
                shr     cx,4
                sub     cx,cs:XWinSize
                shl     cx,4
                jz      @@FBit8
                call    putcxpixels
@@Fbit8:
                inc     dx
                inc     bp
                inc     bp
                cmp     dx,cs:YWinSize
                je      @@FBit4_4
                jmp     @@FBit4
@@FBit4_4:
                xor     cx,cx
                sub     cx,di
                shl     cx,3
                call    putcxpixels
                pop     es ds
                popa
                ret
FillBitbuf      endp

OutSprites      proc
                ; procedure OutSprites;
                ; thos procedure Draw Second image plane
                pusha
                push    ds es
                call    FillBitBuf ; Filled Z-Buffer (bit image)

                mov     ds,cs:List
                mov     si,cs:FirstElem
                mov     cs:CurXSize,464
                mov     cs:CurYSize,464
                ;
                ;
                mov     ax,cs:XMap
                shl     ax,4
                mov     cs:CurXC,ax
                mov     ax,cs:YMap
                shl     ax,4
                mov     cs:CurYC,ax
ShwAll_1:
                cmp     si,0FFFEh
                jnc     ShwAll_exit
                push    si
                call    PutSpriteD
                pop     si
                mov     si,[si+4]
                jmp     ShwAll_1
ShwAll_exit:

                pop     es ds
                popa
                retf
OutSprites      endp

FillSprBlock    proc
                ; this procedure CleanUp List of Images
                pusha
                push    ds
                mov     ds,cs:List
                mov     word ptr cs:FirstElem,0FFFFh
                xor     ax,ax
                mov     bx,0FFFFh
                mov     cx,1555h
                xor     si,si
@@FillSprBl1:
                mov     [si],ax
                mov     [si+2],ax
                mov     [si+4],bx
                mov     [si+6],ax
                mov     [si+8],ax
                mov     [si+10],ax
                add     si,12
                loop    @@FillSprBl1
                pop     ds
                popa
                ret
FillSprBlock    endp

GetFreeBlock    proc
                ; this procedure find First Free Block and return it address
                ; in es:di, or di = 0FFFFh -if free blocks absent
                push    cx
                mov     es,cs:List
                xor     di,di
                mov     cx,1555h
@@GetFreeBl1:
                cmp     word ptr es:[di+4],0FFFFh
                jz      @@GetFreeBl2
                add     di,12
                loop    @@GetFreeBl1
                mov     di,0FFFFh
@@GetFreeBl2:
                pop     cx
                ret
GetFreeBlock    endp

AddFillBlock    proc
                ; this procedure set filled block if sorted chain
                ; es:di - new block
                pusha
                push    ds
                cmp     word ptr cs:FirstElem,0FFFFh
                jz      @@AddFillBl1
                mov     si,offset FirstElem-4

                mov     cs:OldDS,cs
                mov     cs:OldSI,si
                mov     ds,cs:List
                mov     si,cs:FirstElem
@@AddFillBl4:
                mov     ax,es:[di+2]
                cmp     ax,[si+2]
                jc      @@AddFillBl3
                jne     @@AddFillBl6
                ; inser to list
                mov     ax,es:[di]
                cmp     ax,[si]
                jc      @@AddFillBL3
@@AddFillBl6:
                mov     es:[di+4],si
                mov     ds,cs:OldDS
                mov     si,cs:OldSI
                mov     [si+4],di
                jmp     @@AddFillBl2
@@AddFillBl3:
                mov     cs:OldSI,si
                mov     cs:OldDS,ds
                cmp     word ptr [si+4],0FFFEh
                jnz     @@AddFillBl5
                mov     [si+4],di
                mov     word ptr es:[di+4],0FFFEh
                jmp     @@AddFillBl2
@@AddFillBl5:
                mov     si,[si+4]      ; go to next element
                loop    @@AddFillBl4
@@AddFillBl1:
                mov     cs:FirstElem,di
@@AddFillBl2:
                pop     ds
                popa
                ret
AddFillBlock    endp

AddSprBlock     proc
                ; procedure AddSprBlock(x,y:word;p:pointer);
                ; this procedure set block of sprite descriptor
                ; p - pointed to sprite (putimage)
                push    bp
                mov     bp,sp
                push    ds es
                lds     si,[bp+6]
                mov     cx,ds
                call    TestPointer
                TestRegister ds,si
                call    GetFreeBlock
                ; ds:si - image , es:di - free block
                mov     ax,[bp+10]
                add     ax,[si+2]
                mov     es:[di+2],ax

                mov     ax,[bp+12]
                add     ax,[si]
                mov     es:[di],ax
                lea     bx,[si+4]
                mov     es:[di+6],bx
                mov     es:[di+8],cx    ; OLD DS
                mov     ax,[si]
                mov     es:[di+10],al
                mov     ax,[si+2]
                mov     es:[di+11],al
                mov     word ptr es:[di+4],0FFFEh
                call    AddFillBlock

                pop     es ds
                pop     bp
                retf    8
AddSprBlock     endp

PutSpriteD      proc
                ; this procedure show sprite, descripted by ds:si
                ; x:word,y:word,next:word,image:pointer,xsize:byte,ysize:byte
                ; CurXC,CurYC-current upper left conner
                ; CurXSize,CurYSize-current screen size
                pusha
                push    ds es
                mov     ax,[si]
                mov     bx,[si+2]
                mov     cl,[si+10]
                xor     ch,ch
                mov     dx,cx
                sub     ax,cx
                mov     cl,[si+11]
                sub     bx,cx
                lds     si,dword ptr [si+6]
                call    testpointer
                ; ax - x, bx - y, ds:si - pointer to sprite
                ; cx - ysize, dx - xsize
                sub     bx,cs:CurYC
                jnc     psd_2
                jz      psd_2
                push    ax
                mov     ax,bx
                imul    dl
                sub     si,ax
                pop     ax
                add     cx,bx
                mov     bx,0
                jz      psd_22
                jns     psd_2
psd_22:
                jmp     psd_exit
psd_2:
                mov     cs:xadd_,dx
                sub     ax,cs:CurXC
                jnc     PSD_1
                jz      psd_1
                sub     si,ax
                add     dx,ax
                mov     ax,0
                jz      psd_23
                jns     psd_1
psd_23:
                jmp     psd_exit
psd_1:
                mov     bp,ax
                add     bp,dx
                sub     bp,cs:CurXSize
                jc      psd_3
                sub     dx,bp
                jz      psd_33
                jnc     psd_3
psd_33:
                jmp     psd_exit
psd_3:
                mov     bp,bx
                add     bp,cx
                sub     bp,cs:CurYSize
                jc      psd_4
                sub     cx,bp
                jz      psd_34
                jnc     psd_4
psd_34:
                jmp     psd_exit
psd_4:
                sub     cs:XAdd_,dx
                mov     ch,dl

                push    cx
                mov     cx,ax
                mov     ax,cs:ScreenX
                mul     bx
                add     ax,cx
                adc     dx,0
                pop     cx

                add     ax,cs:MapStart
                adc     dx,cs:MapBank
                call    SwitchGran
                mov     di,ax
                mov     bx,8
                div     bx
                push    cx
                mov     cx,dx
                mov     bh,80h
                ror     bh,cl
                pop     cx
                mov     bp,ax
                mov     es,cs:StartSegA
                mov     bl,ch
                mov     ax,cs:ScreenX
                push    cx
                xor     cl,cl
                xchg    ch,cl
                sub     ax,cx
                pop     cx
;                add     ax,cs:Xadd_
                mov     cs:XScrAdd,ax
                xor     ch,ch
                mov     dx,cs:_GranUnit
                mov     cs:MaskOld,bh
                mov     ax,cs:ScreenX
                shr     ax,3
                mov     cs:MaskAdd,ax
                db      2Eh,8Eh,26h
                dw      offset BitImage
                cld
                ; ch - xsize, cl - ysize, es:di - video buffer
                ; ds:si - sprite image, bh - mask, bp - offset in mask array
                ; bl - doubling ch; xadd - xsize adder, XScrAdd - xscreen adder
;---------------------------------------
psd_20:
                ;push    bp
                mov     cs:oldbp,bp
                mov     ch,bl
                mov     cs:OldDi,di
                mov     ax,bx
                xor     ah,ah
                add     di,ax
                mov     di,cs:OldDI
                jc      psd_5
psd_7:
                lodsb
                or      al,al
                jz      psd_6
                db      64h,84h,7Eh,0h
                jnz     psd_6
                mov     es:[di],al
                db      64h,08h,7Eh,0h
psd_6:
                ror     bh,1
                adc     bp,0
                inc     di
                dec     ch
                jnz     psd_7
                jmp     psd_18
psd_5:
; out sprite line with bank switching
psd_9:
                lodsb
                or      al,al
                jz      psd_8
                db      64h,84h,7Eh,0h
                jnz     psd_8
                mov     es:[di],al
                db      64h,08h,7Eh,0h
psd_8:
                ror     bh,1
                adc     bp,0
                add     di,1
                jnc     spd_10
                inc     dx
                call    switchgran
spd_10:
                dec     ch
                jnz     psd_9
psd_18:
                ;pop     bp
                mov     bp,cs:OldBP
                add     bp,cs:MaskAdd
                mov     bh,cs:MaskOld
                add     si,cs:XAdd_
                add     di,XScrAdd
                jnc     psd_19
                inc     dx
                call    switchgran
psd_19:
                loop    psd_20
;---------------------------------------
psd_exit:
                pop     es ds
                popa
                ret
PutSpriteD      endp

DelSprBlock     proc    far
                ; procedure DelSprBlock(x,y:word)
                push    bp
                mov     bp,sp
                push    ds es
                mov     ax,[bp+6]  ; y
                mov     bx,[bp+8]  ; x
                push    cs
                pop     es
                mov     di,offset firstelem - 4
                mov     ds,cs:list
                mov     si,cs:firstelem
DelSpr_loop:
                cmp     si,0FFFEh
                jnc     DelSpr_Exit
                mov     dx,[si]
                mov     cl,[si+10]
                xor     ch,ch
                sub     dx,cx
                cmp     dx,bx
                jnz     DelSpr_Next
                mov     dx,[si+2]
                mov     cl,[si+11]
                sub     dx,cx
                cmp     dx,ax
                jnz     DelSpr_Next
                mov     dx,[si+4]
                mov     es:[di+4],dx
                mov     word ptr [si+4],0FFFFh
                jmp     DelSpr_Exit
DelSpr_Next:
                mov     di,si
                push    ds
                pop     es
                mov     si,[si+4]
                jmp     DelSpr_loop
DelSpr_Exit:
                pop     es ds
                pop     bp
                retf    4
DelSprBlock     endp

Refresh         proc
                ; procedure Refresh;
                mov     al,cs:APage
                xor     al,1
                push    ax
                call    SetActivePage_
                push    cs
                call    OutSprites
                push    cs
                call    OutBackGround
;                call    HideMouse
                pop     ax
;                cli
                call    SetVisualPage_
;                call    ShowMouse
;                sti
                retf
Refresh         endp

SetDisplayStart proc
                ; procedure SetDisplayStart(x,y:word);
                ; this procedure define first visible pixel
                push    bp
                mov     bp,sp
                mov     dx,[bp+6]
                mov     cx,[bp+8]
                mov     bl,0h
                mov     ax,4F07h
                int     10h
                pop     bp
                retf    4
SetDisplayStart endp

SetVisualPage_  proc
                ; this procedure SetVisible Page
                ; al - page number (0 or 1)
                pusha
                cli
                call    HideMouse
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
                call    ShowMouse
                sti
                mov     ax,4F07h
                int     10h
                popa
                ret
SetVisualPage_  endp

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

MirrorPage      proc
                ; procedure MirrorPage;
                ; this procedure info from Active to NonActive page
                pusha
                push    ds es
                mov     bx,cs:SecondPageBank
                xor     dx,dx
                mov     al,cs:APage
                cld
MirrorLoop:
                call    SetActivePage_
                mov     cs:_GranUnit,0FFFFh
                call    SwitchGran
                mov     ds,cs:StartSegA
                mov     es,cs:BitImage
                xor     si,si
                xor     di,di
                mov     cx,8000h
                rep     movsw

                xor     al,1
                call    SetActivePage_
                mov     cs:_GranUnit,0FFFFh
                call    SwitchGran
                push    es
                push    ds
                pop     es
                pop     ds
                mov     cx,8000h
                rep     movsw
                xor     al,1
                inc     dx
                dec     bx
                jnz     MirrorLoop

                call    SetActivePage_
                pop     es ds
                popa
                retf
MirrorPage      endp

RemoveToScreen  macro
                local   @@l1,@@l2,@@l3,@@l4
                ; this macro remove ds:si to es:di cx bytes
                ; with ignore zero color
                ; => CX - saved
                push    ax
                push    cx
                cld
@@l3:
                lodsb
                or      al,al
                jz      @@l1
                stosb
@@l2:
                loop    @@l3
                jmp     @@l4
@@l1:
                inc     di
                loop    @@l3
@@l4:
                pop     cx
                pop     ax
                endm


PutSprite       proc
                ; procedure PutSprite(x,y:integer;p:pointer)
                ;                    +0Ch +0Ah      +6
                push    bp
                mov     bp,sp
                push    ds es
                lds     si,[bp+6]
                call    testpointer
                TestRegister  ds,si
                ; ds:si - sprite
                mov     ax,[si]
                mov     cs:tmp1,ax
                mov     ax,[si+2]
                mov     cs:tmp2,ax
                add     si,4
                mov     cx,[bp+0Ch]
                mov     bx,cs:tmp1
                mov     ax,cs:_VMinX
                sub     ax,[bp+0Ch]
                jle     PutSpr_Ok1
                ;       _VMinX>Left Border of sprite
                add     si,ax
                sub     bx,ax                   ; bx - how point to print
                mov     cx,cs:_VMinX
PutSpr_Ok1:
                mov     ax,[bp+0Ch]
                add     ax,cs:tmp1              ; cx - right border
                sub     ax,cs:_VMaxX
                jle     PutSpr_Ok2
                ;       _VMaxX<Right Border of sprite
                sub     bx,ax
PutSpr_Ok2:
                mov     [bp+0Ch],cx
                mov     cx,bx
                push    cx
                mov     cx,[bp+0Ah]
                mov     bx,cs:tmp2
                mov     ax,cs:_VMinY
                sub     ax,[bp+0Ah]
                jle     PutSpr_Ok3
                ;       _VMinY>Higest border of sprite
                sub     bx,ax
                mul     word ptr cs:tmp1
                add     si,ax
                mov     cx,cs:_VMinY
PutSpr_Ok3:
                mov     ax,[bp+0Ah]
                add     ax,cs:tmp2
                sub     ax,cs:_VMaxY
                jle     PutSpr_Ok4
                sub     bx,ax
PutSpr_Ok4:
                mov     [bp+0Ah],cx
                pop     cx
                mov     ax,[bp+0Ah]
                imul    word ptr cs:ScreenX
                add     ax,[bp+0Ch]
                adc     dx,0
                mov     es,cs:StartSegA
                mov     di,ax
                call    SwitchGran

                ;       cx - point per line
                ;       bx - line on sprite
                cmp     cx,0
                jle     PutSpr_exit
                cmp     bx,0
                jle     PutSpr_exit
                mov     ax,cs:tmp1
                sub     ax,cx
                ;       ax - point per all line to addition
PutSpr_Loop:
                push    di
                add     di,cx
                jc      PutSpr_YesSw
                pop     di
                RemoveToScreen
                add     si,ax
                ;sub     di,ax
                sub     di,cx
                add     di,cs:ScreenX
                jnc     PutSpr_NonSw
                inc     dx
                call    SwitchGran
PutSpr_NonSw:
                dec     bx
                jnz     PutSpr_Loop
                jmp     PutSpr_exit
PutSpr_YesSw:
                mov     bp,di
                pop     di
                push    cx
                sub     cx,bp
                RemoveToScreen
                inc     dx
                call    SwitchGran
                mov     cx,bp
                jcxz    PutSpr_NonSw1
                RemoveToScreen
PutSpr_NonSw1:
                pop     cx
                sub     di,cx
                add     di,cs:ScreenX
                jmp     PutSpr_NonSw
PutSpr_exit:
                pop     es ds bp
                retf    8
PutSprite       endp


SetUserCursor   PROC            FAR
                ; Данная процедура настраивает новый курсор
                ; procedure SetUserCursor(Cursor: pointer);
                ; INPUT:
                ;   None
                ; OUTPUT:
                ;   None
                ARG             Cursor: dword = ArgSize
                push            bp
                mov             bp,sp
                push            es

                les             di,Cursor
                mov             si,di
                TestRegister    es,di
                cmp             di,si
                je              @@ItIsAnimationBlock
                mov             word ptr es:[di],0
                mov             word ptr es:[di+2],0
@@ItIsAnimationBlock:
                call            ChangeCursor

                mov             si,_LastArea
                mov             cs:[si+8],di
                mov             cs:[si+10],es
                call            SelectArea

                pop             es
                pop             bp
                retf            ArgSize
SetUserCursor   ENDP


code            ends
                end