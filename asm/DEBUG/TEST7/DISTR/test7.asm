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

     mov cx,n
m1:    xor dx,dx
       push cx
       mov cx,n-1
m2:      mov al,x[bx]
         cmp x[bx+1],al
         ja m3
         xchg x[bx+1],al
         xchg x[bx],al
         inc dx
m3:      inc bx
       loop m2
     pop cx
     or dx,dx
  loopnz m1
     mov ax,4c00h
     int 21h
Code ends
     End Start