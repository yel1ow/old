Data Segment
       uch struc
        fio db 10 dup(?)
        pol db ?
        rost db ?
       uch ends
m uch <'alexeev   ','m',4h>
uch      <'ivanova   ','d',1h>
uch      <'petuhova  ','d',3h>
uch      <'averyanov ','m',5h>
uch      <'kutuzov   ','m',2h>
s db ?

Data Ends
Code Segment
     assume cs:code,ds:data,ss:mystack
     include io.asm
Start:
  mov ax,data
  mov ds,ax
  mov es,ax
  mov ax,mystack
  mov ss,ax
  mov sp,offset endstack

  xor bx,bx
  xor ax,ax
  mov cx,4

m1:mov al,m[bx].rost
  mov bp,bx
  add bp,type uch
  mov dl,m[bp].rost
  cmp al,dl
  jna m2
  mov cx,12
  lea si,m[bx].fio
  lea di,m[bp].fio
ckl:

  mov al,[si]
  mov ah,[di]
  mov [si],ah
  mov [di],al

  inc si
  inc di
  loop ckl
  mov cx,4
  xor bx,bx

m2:add bx,12
  add bp,12
  loop m1

  xor bx,bx

  lea si,m[bx].fio
  mov cx,5

m3:push cx
  mov cx,10
m4:mov al,[si]
  mov ah,0eh
  int 10h
  inc si
  loop m4
  mov al,[si]
  mov ah,0eh
  int 10h
  inc si
  mov al,[si]
  mov ah,00h
  call writeint
  mov ax,0e20h
  int 10h
  inc si
  pop cx
  loop m3


  mov ax,4c00h
  int 21h
  code ends
  mystack segment
  db 1000 dup(?)
  endstack db(?)
  mystack ends
end start
