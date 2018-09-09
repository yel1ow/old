program ez;
var c:char;
    n,s,e,w:integer;
function max(a,b:integer):integer;
begin
  if a>b then max:=a
  else max:=b;
end;
begin
  assign(input,'input.txt');
  reset(input);
  assign(output,'output.txt');
  rewrite(output);
  while not seekeof do
  begin
  read(c);
  case c of
  'N':inc(n);
  'E':inc(e);
  'W':inc(w);
  'S':inc(s);
  end;
  end;
  write(max(n,s)+1,' ',max(w,e)+1);
  close(output);
end.