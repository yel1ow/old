Program Filling;
Uses Graph,Crt;
Const max=6500;
Type tQue=array[1..max]of record
                            x,y:word
                          end;
Var Q:tQue;
    h,t,l:integer;
Procedure PutQ(x,y:word);
  begin
    if l=max
    then outtextxy(320,240,'figa')
    else begin
           t:=(t mod max)+1;
           Q[t].x:=x;
           Q[t].y:=y;
           inc(l)
         end;

  end;
Procedure GetQ(var x,y:word);
  begin
    if l=0
    then outtextxy(320,240,'figa')
    else begin
           x:=q[h].x;
           y:=q[h].y;
           h:=(h mod max)+1;
           dec(l)
         end;
  end;
Procedure Fill(a,b,c:word);
  var x,y:word;
  begin
    putq(a,b);
    putpixel(a,b,c);
    while l>0 do
      begin
        getq(x,y);
        if (x+1<640) and (x-1>0)
        then
        begin
          if getpixel(x+1,y)=0
          then
            begin
              putpixel(x+1,y,c);
              putq(x+1,y)
            end;
          if getpixel(x-1,y)=0
          then
            begin
              putpixel(x-1,y,c);
              putq(x-1,y)
            end;
        end;
        if (y+1<480)and(y-1>0)
        then
        begin
           if getpixel(x,y-1)=0
           then begin
                  putpixel(x,y-1,c);
                  putq(x,y-1)
                end;
           if getpixel(x,y+1)=0
           then begin
                  putpixel(x,y+1,c);
                  putq(x,y+1)
                end;
           end;
        end;
  end;
Procedure Init;
  var gd,gm:integer;
  begin
    gd:=vga;
    gm:=vgahi;
    InitGraph(gd,gm,'c:\tools\tp7\bgi');
    h:=1;
    t:=0;
    l:=0;
  end;
Begin
  Init;
  setcolor(4);
  circle(320,240,800);
  Fill(320,240,5);
  ReadKey;
  CloseGraph;
End.