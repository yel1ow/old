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
  mov ax,200
m1:pop ax
  add ax,50
  cmp ax,1000
  jna m2
  mov ax,12000
m2:out 42h,al
  mov al,ah
  out 42h,al
  push ax
  in al,61h
  or al,00000011b
  out 61h,al
  mov cx,50
m3:push cx
  mov cx,0
m4:nop
  loop m4
  pop cx
  loop m3
  mov ah,01h
  int 16h
  jz m1


  in al,61h
  and al,11111100b
  out 61h,al

  mov ax,4c00h
  int 21h
  code ends
  mystack segment
  db 1000 dup(?)
  endstack db(?)
  mystack ends
end start
