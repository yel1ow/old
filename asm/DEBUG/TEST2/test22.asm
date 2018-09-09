Data Segment
    a  db 3, 2, 1, 6, 9, 7, 5, 8, 4, 0
    y  dw 20h
    z dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax
     mov cx,1000
     xor bx,bx
m1:  mov bl,a[bx]
     loop m1
     mov ax,4c00h
     int 21h
Code ends
     End Start