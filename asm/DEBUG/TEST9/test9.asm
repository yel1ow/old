Data Segment
    n equ 10
    x  db 5, 0, 0, 4, 0, 0, 0, 6, 0, 8
    z  dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax

     mov cx,n
     xor dx,dx
     mov bx,dx
     cld
     mov si, offset x
m1:  lodsb
     jnz m3
     inc dx
m3:  cmp dx,di
     jbe m4
     mov di,dx
m4:  xor dx,dx
m5:
  loop m1
     mov ax,4c00h
     int 21h
Code ends
     End Start