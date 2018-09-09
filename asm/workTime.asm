Data Segment
       tab db '/|\-'
       num equ 4
       tekpos dw 0
       maxdel equ 4
       del db maxdel
       old1c dd ?
       old9 dd ?
Data Ends
Code Segment
     assume cs:code,ds:data,ss:mystack
     include io.asm

vert proc far
  push ds es ax bx
  mov ax,data
  mov ds,ax


  ;
  dec byte ptr ds:del
  jnz no
  mov byte ptr ds:del,maxdel
  mov ax,0b800h
  mov es,ax
  mov bx,tekpos
  mov al,tab[bx]
  inc byte ptr ds:tekpos
  cmp byte ptr ds:tekpos,num
  jb video
  mov byte ptr ds:tekpos,0
vodeo:
  mov byte ptr es:[0],al
no:
  pop bx ax es ds
  iret
vert endp

move proc far
  push ax bx es ds
  mov ax,data
  mov ds,ax
  ;







  ;
  pop ds es bx ax
  iret
vert endp


Start:
  mov ax,data
  mop ds,ax
  mov ax,mystack
  mov ss,ax
  mov sp,offset endstack



  mov ax,351ch
  int 21h
  mov word ptr ds:old1c,bx
  mov word ptr ds:[old1c+2],es
  push cs
  pop ds
  mov dx,offset vert
  mov ax,251ch
  int 21h

  mov ax,3509h
  int 21h
  mov word ptr ds:old9,bx
  mov word ptr ds:[old9+2],es
  push cs
  pop ds
  mov dx,offset move
  mov ax,2509h
  int 21h

gg:mov ax,data
  mov ds,ax
  cmp f,1
  jne gg






  mov ax,data
  mov ds,ax
  mov ax,2509h
  lds dx,ds:old9
  int 21h

  mov ax,data
  mov ds,ax
  mov ax,251ch
  lds dx,ds:old1c
  int 21h

  mov ax,4c00h
  int 21h
  code ends
  mystack segment
  db 1000 dup(?)
  endstack db(?)
  mystack ends
end start