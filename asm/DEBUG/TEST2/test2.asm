Data Segment
    a  db 5, 2, 7, 9, 0, 1, 3, 8, 4, 6
    y  dw 20h
    z dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax
     mov cx,10
     xor bx,bx
m1:  mov bl,a[bx]
     loop m1
     mov ax,4c00h
     int 21h
Code ends
     End Start