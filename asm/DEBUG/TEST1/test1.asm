Data Segment
    x  dw 10h
    y  dw 20h
    z dw ?
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,data
     mov ds,ax
     mov ax,mystack
     mov ss,ax
     mov sp,offset endstack
     mov ax,x
     mov bx,y
     add ax,bx
     mov z,ax
     mov ax,4c00h
     int 21h
Code ends
     mystack segment
     db 1000 dup(?)
     endstack db(?)
     mystack ends
End Start