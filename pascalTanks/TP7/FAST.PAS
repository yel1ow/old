program ez;
type txD=record
          s:string;
          b:byte;
          g:longint;
          dec:longint;
        end;
     ttxd=array[1..100] of txD;
var n,i,code:integer;
    l:longint;
    s,t:string;
    xD:ttxd;
procedure perevod(b,g:longint;var d:longint);
var i,v,j:integer;
    u:longint;
begin
  i:=0;
  d:=0;
  while g>0 do
  begin
  v:=g mod 10;
  if i=0 then d:=v
  else begin
       for j:=1 to i do u:=u*u;
       d:=d+v*u;
       end;
  g:=g div 10;
  inc(i);
  end;
end;
procedure sort(var xD:ttxd);
var b:txd;z,i,j:integer;
    f:boolean;
begin
  z:=n;
  repeat
  f:=true;
  for i:=1 to z-1 do
  if xD[i].dec>xD[i+1].dec
  then begin
         b:=xD[i];xd[i]:=xd[i+1];xd[i+1]:=b;f:=false;
       end;
  dec(z);
  until f;
end;
begin
  assign(input,'input.txt');
  reset(input);
  assign(output,'output.txt');
  rewrite(output);
  readln(n);
  for i:=1 to n do
  read(xD[i].b,xD[i].g);
  reset(input);
  readln;
  for i:=1 to n do
  readln(xD[i].s);
  for i:=1 to n do
  perevod(xD[i].b,xD[i].g,xD[i].dec);
  sort(xD);
  for i:=1 to n do
  writeln(xD[i].s);
  close(output);
end.