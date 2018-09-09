Data Segment
       sm dw ?
       s db 'mama mila ramy?~!111'
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
  mov sm,60
m1:mov ah,0eh
  mov al,13
  int 10h
  dec sm
  cmp sm,0
  jne m5
  mov sm,59
m5:mov cx,sm
  mov al,20h
  mov ah,0eh
m2:int 10h
  loop m2

  mov cx,60
  sub cx,sm
  mov si,offset s
m3:mov al,[si]
  mov ah,0eh
  int 10h
  inc si
  loop m3
  
  mov ah,01h
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
