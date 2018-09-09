Data Segment

Data Ends
Code Segment
     assume cs:code,ds:data,ss:mystack
     include io.asm
Start:
  mov ax,data
  mov ds,ax
  mov ax,mystack
  mov ss,ax
  mov sp,offset endstack
  xor bp,bp
m1:inc bp
  cmp bp,65000
  jb m2
  xor bp,bp
mov ah,0eh
  mov al,13
  int 10h

  mov ah,2ch
  int 21h

  mov al,ch
  mov ah,00h
  call writeint
  mov ah,0eh
  mov al,':'
  int 10h
  mov al,cl
  mov ah,00h
  call writeint
  mov ah,0eh
  mov al,':'
  int 10h
  mov al,dh
  mov ah,00h
  call writeint
  mov ah,0eh
  mov al,':'
  int 10h
  mov al,dl
  mov ah,00h
  call writeint
  mov ax,0e20h
  int 10h

m2:mov ah,01h
  int 16h
  jz m1


  mov ax,4c00h
  int 21h
  code ends
  mystack segment
  db 1000 dup(?)
  endstack db(?)
  mystack ends
end start
