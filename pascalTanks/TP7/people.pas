uses crt;
var
  i,j:word;
  n:real;
  m,m1,x:longint;
  c:char;
begin
  i:=1999;
  j:=0;
  n:=0.016363636;
  m:=5500000;
  m1:=m;
  clrscr;
  writeln(i,' год, ','население- ',m,', прирост- ',round(m*n));
  repeat
     inc(i);
     inc(j);
     m:=m+round(m*n);
     writeln(i,' год, ','население- ',m,', прирост- ',round(m*n));
     if (j mod 23)=0 then
     begin
          c:=readkey;
          c:=readkey;
          delay(100);
     end;
  until (c=#27)or(c=#13){or(m>m1*2)};
end.