unit mousem;
interface
type trec=^rec;
     rec=record
          x,y:byte;
          pic:byte;
     end;
     tAdres=array[1..20] of pointer;
     tmas=record
           x,y:byte;
           pic:pointer;
          end;
     tsmas=record
            col:byte;
            mas:array[1..20] of tmas;
           end;

var
 MX,MY:integer;
 Mask:byte;
 mas:tsmas;
  procedure ShowMouse;
  procedure HideMouse;
  procedure ReadMouse;
  procedure AnimCur(kol:integer;adres:tAdres);

implementation
  procedure ShowMouse;
   begin
     asm
       mov ax,01
       int 33h
     end;
   end;
  procedure HideMouse;
   begin
     asm
       mov ax,02
       int 33h
     end;
   end;

  procedure ReadMouse;
   begin
     asm
       mov ax,03
       int 33h
       mov MX,cx
       mov MY,dx
       mov Mask,bl
     end;
   end;

   procedure AnimCur;
   type
    tx=array[1..20] of byte;
   var
    pp:trec;
    j,i:integer;
    x,y:tx;
    p:array[1..20] of pointer;
   begin
        for i:=1 to kol do
        begin
         pp:=adres[i];
         x[i]:=pp^.x;
         y[i]:=pp^.y;
         p[i]:=addr(pp^.pic);
        end;
        mas.col:=kol;
        for i:=1 to kol do
        begin
         mas.mas[i].x:=x[i];
         mas.mas[i].y:=y[i];
         mas.mas[i].pic:=p[i];
        end;
         asm
          mov ax,ds
          mov es,ax
          mov bx,offset mas
          mov ax,0fdh
          int 33h
          mov ax,0fbh
          mov cl,1
          int 33h
        end;
   end;
begin
end.