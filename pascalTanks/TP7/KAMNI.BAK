program ez;
type mas=array[1..5] of word;
var x,y,k,i,p,min,max,u:integer;
    z:longint;
    m:mas;
    f:boolean;
    otv:array[1..1000] of longint;
procedure rec(n:byte;l:integer;m:mas);
var s:longint;
    i:integer;                            tt:boolean;
begin
  s:=0;
  for i:=1 to k do
  s:=s+m[i];
  if s>=z then begin
                 if not f then begin
                               f:=true;
                               write(abs(n-1)+1,' ');
                               end;
                 inc(p);
                 otv[p]:=l;
               end
  else  begin
  tt:=false;
  for i:=1 to k do
       begin
       for i:=1 to k do
       m[i]:=m[i]+x;
       rec(abs(n-1),l+1,m);
       m[i]:=m[i]-x;
       m[i]:=m[i]*y;
       s:=0;
       for i:=1 to k do
       s:=s+m[i];
       if s>=z then begin rec(abs(n-1),l+1,m); tt:=true;end;
       m[i]:=m[i] div y;
       end;
       for i:=1 to k do
       m[i]:=m[i]+x;
       rec(abs(n-1),l+1,m);
       m[i]:=m[i]-x;
       end;
end;
begin
  assign(input,'input.txt');
  reset(input);
  assign(output,'output.txt');
  rewrite(output);
  readln(k);
  f:=false;
  p:=0;
  for i:=1 to k do
  read(m[i]);
  read(x,y,z);
  rec(0,0,m);
  min:=32000;
  max:=0;
  i:=1;
  while otv[i]<>0 do
  begin
  if otv[i]<min then min:=otv[i];
  if otv[i]>max then max:=otv[i];
  inc(i);
  end;
  write(max,' ',min);
  close(output);
end.