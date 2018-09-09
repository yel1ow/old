Data Segment
    max  db 20
    len  db ?
    S    db 20 dup(?)
    Inp  db 'Введите строку:$'
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax
     mov dx,offset Inp
     mov ah,9
     int 21h
     mov ah,0Ah
     mov dx,offset Max
     int 21h
     mov ah,02h
     mov dl,10
     int 21h

     mov cl,len
     xor ch,ch
     mov al,32
     xor di,di
m1:  cmp s[di],al
     jnz Next
       dec dl
       mov cl,len
       xor ch,ch
       sub cx, di
       mov bx,di
m2:    mov ah,s[bx+1]
       mov s[bx],ah
       inc bx
       loop m2
       pop cx
       dec cx
Next: inc di
    loop m1
    mov s[di],'$'
    mov dx, offset s
    mov ah,9
    int 21h
     mov ax,4c00h
     int 21h
Code ends
     End Start