.286
code segment
     assume cs:code,ds:code
     buffer = 0

base    dw 0
hand    dw 0
emmhand dw 0
buf     db 16384 dup (0)
tabl    db 8192  dup (0)
swpname db 'swp$$swp.swp',0
manname db 'EMMXXXX0',0
NAMEH   db 'MYEMSTPU'

public      initems
public      doneems
public      getpage
public      freepage
public      map
public      getframe
public      emmstat

initems     proc
            ;initialization
            push  ax bx cx dx si di bp ds es
            push  cs
            pop   ds
            mov   ah,41h
            int   67h
            mov   cs:base,bx
            mov   ah,42h
            int   67h
            dec   bx
            mov   si,offset tabl
            xor   ax,ax
            mov   cx,bx
            jcxz  init_5
init_1:
            mov   [si],ax
            mov   word ptr [si+2],0h
            add   si,4
            inc   ax
            loop  init_1
init_5:
            mov   cx,2048
            sub   cx,bx
            xor   ax,ax
init_2:
            mov   [si],ax
            mov   word ptr [si+2],0A000h
            add   si,4
            inc   ax
            loop  init_2
            mov   ah,43h
            int   67h
            mov   cs:emmhand,dx
            mov   si,offset NAMEH
            mov   ax,5301h
            int   67h
            mov   dx,offset swpname
            mov   ah,3Ch
            xor   cx,cx
            int   21h
            mov   cs:hand,ax
            pop   es ds bp di si dx cx bx ax
            retf
initems     endp

doneems     proc
            ;done
            push   ax bx dx ds
            mov    dx,cs:emmhand
            mov    ah,45h
            int    67h
            mov    bx,cs:hand
            mov    ah,3Eh
            int    21h
            push   cs
            pop    ds
            mov    dx,offset swpname
            mov    ah,41h
            int    21h
            pop    ds dx bx ax
            retf
doneems     endp

getpage     proc
            ;ax=>handler
            push   bx cx
            mov    bx,offset tabl
            mov    cx,2048
getp_1:
            test   word ptr cs:[bx+2],4000h
            jz     getp_3
            add    bx,4
            loop   getp_1
            mov    ax,0FFFFh
            jmp    getp_2
getp_3:
            mov    ax,bx
            sub    ax,offset tabl
            shr    ax,2
            or     word ptr cs:[bx+2],4000h
getp_2:
            pop    cx bx
            retf
getpage     endp

freepage    proc
            ;free page
            push  bp
            mov   bp,sp
            push  ax bx
            mov   bx,offset tabl
            mov   ax,[bp+6]
            shl   ax,2
            add   bx,ax
            and   word ptr cs:[bx+2],0A000h
            pop   bx ax
            pop   bp
            retf  2
freepage    endp

mapems      proc
            ;bx-number,al-phisical page
            push  ax bx dx
            mov   ah,44h
            mov   dx,cs:emmhand
            int   67h
            pop   dx bx ax
            ret
mapems      endp

findfreeems     proc
                ;find free emm's pages
                ;=>carry if present,si-offset of structure
                push  cx
                mov   si,offset tabl
                mov   cx,2048
ffems_2:
                test  word ptr cs:[si+2],0C000h
                jz    ffems_1
                add   si,4
                loop  ffems_2
                clc
                jmp   ffems_3
ffems_1:
                stc
ffems_3:
                pop   cx
                ret
findfreeems     endp


findminems      proc
                ;find minimum uses page
                ;=>si-offset of structure
                push  ax bx cx dx
                mov   si,offset tabl
                mov   cx,2047
                mov   bx,0FFFFh
                mov   dx,cs:[si+2]
                and   dx,1FFFh
fmems_2:
                test  word ptr cs:[si+2],8000h
                jnz    fmems_1
                cmp    bx,0FFFFh
                jnz    fmems_3
                mov    bx,si
fmems_3:
                mov    ax,cs:[si+2]
                and    ax,1FFFh
                cmp    ax,dx
                jnc    fmems_1
                mov    dx,ax
                mov    bx,si
fmems_1:
                add   si,4
                loop  fmems_2
                mov   si,bx
                pop   dx cx bx ax
                ret
findminems      endp

readpage        proc
                ;read page from disk to buffer
                ;[bx]-number of page
                push    ax bx cx dx ds
                test    word ptr cs:[bx+2],2000h
                jnz     rpage_1
                mov     cx,cs:[bx]
                xor     dx,dx
                clc
                rcr     cx,1
                rcr     dx,1
                clc
                rcr     cx,1
                rcr     dx,1
                mov     ax,4200h
                mov     bx,cs:hand
                int     21h
                push    cs
                pop     ds
                mov     dx,offset buf
                mov     cx,16384
                mov     ah,3Fh
                int     21h
rpage_1:
                pop     ds dx cx bx ax
                ret
readpage        endp

writpage        proc
                ;write page from buffer to disk
                ;[bx]-number of page
                push    ax bx cx dx ds
                mov     cx,cs:[bx]
                xor     dx,dx
                clc
                rcr     cx,1
                rcr     dx,1
                clc
                rcr     cx,1
                rcr     dx,1
                mov     ax,4200h
                mov     bx,cs:hand
                int     21h
                push    cs
                pop     ds
                mov     dx,offset buf
                mov     cx,16384
                mov     ah,40h
                int     21h
                pop     ds dx cx bx ax
                ret
writpage        endp


map         proc
            ;procedure map (a,b:word)a-handler b-ph. number
            push  bp
            mov   bp,sp;a-bp+8,b-bp+6
            push  ax bx cx dx si ds es
            mov   bx,offset tabl
            mov   ax,[bp+8]
            shl   ax,2
            add   bx,ax
            test  word ptr cs:[bx+2],8000h
            jnz   map_2
            mov   ax,[bp+6]
            push  bx
            mov   bx,cs:[bx]
            call  mapems
            pop   bx
            jmp   map_1
map_2:
            ;needed page on disk now
            ;bx-offset of loaded page
            call  findfreeems
            jnc   map_3 ;no free memory
            call  readpage
            push  bx
            mov   bx,cs:[si]
            mov   ax,[bp+6]
            call  mapems;map free space
            pop   bx
            and   word ptr cs:[bx+2],0B000h;free in disk
            or    word ptr cs:[si+2],4000h;use in memory
            push  cx si di ds es
            cld
            xor   di,di
            mov   cx,[bp+6]
            jcxz  map_4
map_5:
            add   di,16384
            loop  map_5
map_4:
            mov   cx,8192
            push  cs
            pop   ds
            mov   es,cs:base
            mov   si,offset buf
            rep   movsw          ;copy buffer to free page
            pop   es ds di si cx
            jmp   map_1
map_3:
            call  findminems ;si=offset of minimum page, bx=offset needed page
            call  readpage   ;buffer=needed page
            push  bx
            mov   bx,cs:[si]
            mov   ax,[bp+6]
            call  mapems     ;maping minimum page
            pop   bx
            push  ax cx si di ds es
            cld
            xor   di,di
            mov   cx,[bp+6]
            jcxz  map_6
map_7:
            add   di,16384
            loop  map_7
map_6:
            mov   cx,8192
            push  cs
            pop   ds
            mov   es,cs:base
            mov   si,offset buf
map_8:
            mov   ax,[si]
            xchg  ax,es:[di]
            mov   [si],ax
            add   si,2
            add   di,2
            loop  map_8      ;exchange buffer<=>minimum page
            pop   es ds di si cx ax
            call  writpage   ;write buffer to disk
            mov   ax,cs:[si] ;minimum page on disk now
            mov   dx,cs:[si+2] ;needed page on memory now
            xchg  ax,cs:[bx]
            xchg  dx,cs:[bx+2]
            mov   cs:[si],ax
            mov   cs:[si+2],dx
            and   word ptr cs:[bx+2],4000h
            or    word ptr cs:[si+2],8000h
            and   word ptr cs:[si+2],0D000h
map_1:
            mov   ax,cs:[bx+2]
            and   word ptr cs:[bx+2],0E000h
            inc   ax
            and   ax,1FFFh
            or    cs:[bx+2],ax
            pop   es ds si dx cx bx ax
            pop   bp
            retf  4
map         endp

getframe    proc
            mov  ax,cs:base
            retf
getframe    endp

EmmStat        proc
               push     bp ds es
               mov      ax,3D02h
               push     cs
               pop      ds
               mov      dx,offset manname
               int      21h
               jc       stat_err
               mov      bx,ax
               mov      ax,4407h
               int      21h
               jc       stat_err
               or       al,al
               jz       stat_err
               push     cs
               pop      ds
               mov      si,offset NAMEH
               mov      ax,5401h
               int      67h
               or       ah,ah
               jnz      NO_Name
               mov      ah,45h
               int      67h
NO_Name:
               mov      ax,4200h
               int      67h
               cmp      bx,5
               jnc       stat_ok
stat_err:
               xor      ax,ax
               jmp      stat_end
stat_ok:
               mov      ax,1
stat_end:
               pop      es ds bp
               retf
EmmStat        endp

code ends
end