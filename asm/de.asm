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

  mov ax,1190
  out 42h,al
  mov al,ah
  out 42h,al
  in al,61h
  or al,00000011b
  out 61h,al
  xor ax,ax
  int 16h
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