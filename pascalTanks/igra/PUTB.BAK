program qq;
uses crt;
type tekr=array[1..40,1..40] of byte;
pobject=^tobject;
tObject=record
               next:pObject;
               vid:boolean;
               tip:byte;
               x,y:integer;
               oldx,oldy:array[0..1] of integer;
               hp:integer;
               dx,dy,tx,ty:integer;
               vect:integer;
               offs:integer;
               action:word;
               delm,dels:byte;
               sost:byte;
               gabar:integer;
               attackobj:pobject;
            end;
var xs,ys,xf,yf:integer;
    tx,ty:shortint;
    ekr:tekr;
    j,k:word;
    tz:pobject;

Procedure nextstep(tz:pobject);
Const Max=500;
Type Node=record
           St:word;
           OlDx,Oldy,x,y,w:byte;
          end;
     QUEUE=array[0..Max-1] of node;
     tOffs=array[0..7] of ShortInt;
     tmin=record
            dal:word;
            vect:byte;
          end;
Var q:QUEUE;
    G,h,l,i,lmax:word;
    d:Node;
    x,y,w:byte;
    ox,oy:shortint;
    Work:boolean;
    mat:tekr;
    min:tmin;
Const dx:tOffs=(1, 1, 0,-1,-1,-1,0,1);
      dy:tOffs=(0,-1,-1,-1, 0, 1,1,1);
Procedure PutQ(d:node);
begin
  if l>lmax then lMax:=l;
  if l=Max
  then Writeln('Очередь переполнена'#7#7#7)
  else begin
         inc(l);
         h:=(h+1) mod max;
         q[h]:=d;
       end;
end;
Procedure GetQ(var d:node);
var Min,Nm,j,i:word;
begin
  if l=0
  then Writeln('Очередь пуста '#7#7#7)
  else begin
         dec(l);
         Min:=q[g].st;Nm:=g;j:=g;
         for i:=1 to l do
          begin
          if q[j].St<Min
          then begin
                 Min:=q[j].St;Nm:=j
               end;
          j:=(j+1) mod max;
         end;
        d:=q[nm];q[nm]:=q[g];g:=(g+1) mod max;
       end
end;
Function Calc(x,y:byte):word;
begin
  Calc:=(xf-x)*(xf-x)+(yf-y)*(yf-y)+mat[y,x]*2
end;
begin
  xs:=tz^.x;ys:=tz^.y;
  xf:=tz^.tx;yf:=tz^.ty;
  {mat:=ekr;}
  for i:=1 to 40 do
  for j:=1 to 40 do
  if ekr[i,j]<>0
  then mat[i,j]:=255
  else mat[i,j]:=0;
  g:=1;h:=0;l:=0;
  x:=xs;y:=ys;
  Work:=true;
  mat[y,x]:=1;
  d.x:=x;d.y:=y;
  d.OldX:=x; d.OldY:=y;
  d.St:=Calc(x,y);
  d.w:=1;
  PutQ(d);
  While Work and (l<>0) do
    begin
      GetQ(d);
      w:=d.w;
      x:=d.x;y:=d.y;
      if (x=xf)and(y=yf)
      then Work:=false;
      For i:=0 to 7 do
       begin
         if (mat[y+dy[i],x+dx[i]]<>255) and (mat[y+dy[i],x+dx[i]]=0)
         then begin
             mat[y+dy[i],x+dx[i]]:=w+1;
             d.x:=x+dx[i];d.y:=y+dy[i];
             d.OldX:=x; d.OldY:=y;
             d.w:=w+1;
             d.St:=Calc(d.x,d.y);
             PutQ(d);
           end;
       end;
    end;
    while (xf<>xs) or (yf<>ys) do
    begin
      min.dal:=32000;
      for i:=0 to 7 do
        if (mat[yf,xf]>mat[yf+dy[i],xf+dx[i]]) and (mat[yf+dy[i],xf+dx[i]]<>0)
        then if (sqr(xf+dx[i]-xs)+sqr(yf+dy[i]-ys))<min.dal
        then begin
               min.dal:=sqr(xf+dx[i]-xs)+sqr(yf+dy[i]-ys);
               min.vect:=i;
             end;
      ox:=xf;
      oy:=yf;
      xf:=xf+dx[min.vect];
      yf:=yf+dy[min.vect];
    end;
      tz^.dx:=ox-xf;
      tz^.dy:=oy-yf;
      for j:=1 to 20 do
      begin
      for k:=1 to 20 do
      write(mat[j,k]:3);
      writeln;
      end;
end;
begin
  clrscr;
  tz^.x:=3;tz^.y:=3;
  tz^.tx:=3;tz^.ty:=5;
  nextstep(tz);
  writeln;
  write(tz^.dx,' ',tz^.dy);
  readln;
end.