Data Segment
    n equ 10
    x  db 5, 3, 1, 4, 2, 0, 7, 6, 9, 8
    z  dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax
     mov es,ax

     mov cx,n
     mov si,offset x
     mov di,si
     mov bx,offset z -1
     cld
m1:    lodsb
       xchg al,x[bx]
       dec bx
       stosb
     loop m1
     mov ax,4c00h
     int 21h
Code ends
     End Start