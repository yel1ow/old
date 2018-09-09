Data Segment
    x  db 5, 3, 5, 4, 2, 3, 7, 5, 3, 5, 0
    z  dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
     include io.asm
Start:
     mov ax,Data
     mov ds,ax
     xor bx,bx
m2:  mov al,x[bx]
     or al,al
     jz M1
     inc bx
     jmp short m2
m1:  mov cx,bx
     mov al,x[bx-1]
m4:  xor bx,bx
     cmp al,x[bx]
     jne m3
     inc z
m3:  inc bx
     inc bx
     loop m4

     mov ax,z
     call writeint

     mov ax,4c00h
     int 21h
Code ends
     End Start