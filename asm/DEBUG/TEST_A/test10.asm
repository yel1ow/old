;Name "Ловушка"
Data Segment
    n equ 10
    x  db 5, 1, 0, 4, 13, 8, 150, 60, 0, 8
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax

     mov cx,n
     xor di,di
     cld
     xor ax,ax
     mov dx,ax
     mov si, offset x
m1:  lodsb
     mov bh,1
     mov bl,bh
m2:  mov dl,bl
     add dl,bh
     mov bl, bh
     mov bh, dl
     cmp dx,ax
     jb m2

m3:  cmp dl,al
     jne m4
     mov di,1
m4:
  loop m1
     or di,di   {*}
     jz No
Yes:
     jmp short Quit
No:
Quit:
     mov ax,4c00h
     int 21h
Code ends
     End Start