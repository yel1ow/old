Data Segment
    n equ 10
    x  db 5, 3, 5, 4, 2, 3, 7, 5, 3, 5
    z  dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax
     xor bx,bx
     mov dx,n
m2:  mov al,x[bx]
     test al,00000001b
     jnz m1
     shr x[bx],1
     jmp short m3
m1:  shl x[bx],1
m3:  inc bx
     loop m2
     mov ax,4c00h
     int 21h
Code ends
     End Start