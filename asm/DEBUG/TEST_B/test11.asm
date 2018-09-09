;Name "Ловушка"
Data Segment
    n equ 10
    k equ 4
    x  db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
Data Ends

Code segment
     assume cs:Code,ds:data
Start:
     mov ax,Data
     mov ds,ax

     mov cx,k
m1:
     mov dl,x[bx]
     mov cl,n-1
     mov di,offset x
     mov si,di
     inc si
     cld
     rep movsb
     mov x[n-1],dl

  loop m1
Quit:
     mov ax,4c00h
     int 21h
Code ends
     End Start