ReadINT proc Near; Выход: ax- Целое число.
   push ds si bx cx dx cs
   pop ds
   mov dx,offset max
   mov ah,0Ah
   int 21h
   mov cl,byte ptr cs:len
   mov ch,0
   mov bh,ch
   xor si,si
   mov ax,si
@m_: mov bl,byte ptr cs:st_[si]
     sub bl,'0'
     mov dx,10
     mul dx
     add ax,bx
     inc si
   loop @m_
   push ax
   mov ah,2
   mov dl,10
   int 21h
   pop ax
   pop dx cx bx si ds
   ret
   max db 6
   len db ?
   St_ db 6 dup(?)
ReadINT EndP

WriteInt Proc Near ;Вход: ax-выводимое число
   push dx cx bx
   xor cx,cx
   mov bx,10
@x_:
   xor dx,dx
   div bx
   add dl,'0'
   push dx
   inc cx
   cmp ax,0
   jne @x_
@x_2:
   pop dx
   mov ah,2
   int 21h
   loop @x_2
   pop bx cx dx
   ret
WriteInt EndP