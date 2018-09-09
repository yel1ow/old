Data Segment
    x  dw 5789h
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax
     mov bx,x
     xor cx,cx

m1:  inc cx
     xor dx,dx
     rcr bx,1
     rcl dl,1
     add dl,'0'
     push dx
     cmp bx,0
     jne m1

m2:  pop dx
     mov ah,2
     int 21h
     loop m2
     mov ax,4c00h
     int 21h
Code ends
     End Start