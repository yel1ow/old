Data Segment
       old9 dd ?
       f db 0
       k db ?
Data Ends
Code Segment
     assume cs:code,ds:data,ss:mystack
     include io.asm

organ proc far
  push ax bx cx dx
  mov ax,data
  mov ds,ax
  in al,60h
  test al,10000000b
  jnz m3

  cmp al,1
  je nex

  out 42h,al
  out 42h,al
  in al,61h
  or al,00000011b
  out 61h,al
  jmp short ne
m3:in al,61h
  and al,11111100b
  out 61h,al
  and al,11111111b
  jmp short ne

nex:mov f,1

ne:mov al,20h
  out 20h,al
pop dx cx bx ax
iret
organ endp


Start:
  mov ax,data
  mov ds,ax
  mov ax,mystack
  mov ss,ax
  mov sp,offset endstack

  mov ax,3509h
  int 21h
  mov word ptr ds:old9,bx
  mov word ptr ds:[old9+2],es
  push cs
  pop ds
  mov dx,offset organ
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

  mov ax,4c00h
  int 21h
  code ends
  mystack segment
  db 1000 dup(?)
  endstack db(?)
  mystack ends
end start
