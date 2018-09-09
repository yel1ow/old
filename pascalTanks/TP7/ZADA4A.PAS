program ez;
const vihod=239;
      BKN=240;
      BSN=241;
      BLD=242;
      BFZ=243;
      WKN=250;
      WSN=251;
      WLD=252;
      WFZ=253;
      knx:array[0..7] of shortint=(2,1,-1,-2,-2,-1,1,2);
      kny:array[0..7] of shortint=(1,2,2,1,-1,-2,-2,-1);
      snx:array[0..3] of shortint=(1,-1,-1,1);
      sny:array[0..3] of shortint=(-1,-1,1,1);
      ldx:array[0..3] of shortint=(1,0,-1,0);
      ldy:array[0..3] of shortint=(0,-1,0,1);
      fzx:array[0..7] of shortint=(1,1,0,-1,-1,-1,0,1);
      fzy:array[0..7] of shortint=(0,-1,-1,-1,0,1,1,1);
type ekr=array [0..9,0..9] of byte;
var s,t:string;
    i,x,n:integer;
    a:ekr;
procedure zak(r,x,y:integer;var a:ekr);
var i,j:integer;
begin
  case r of
  bkn:begin
      i:=x;
      j:=y;
      repeat

      until
      end;
  bsn:begin
      end;
  bld:begin
      end;
  bfz:begin
      end;
  end;
end;
begin
  assign(input,'input.txt');
  reset(input);
  assign(output,'output.txt');
  rewrite(output);
  fillchar(a,sizeof(a),0);
  for i:=0 to 9 do
  begin
  a[0,i]:=255;
  a[i,0]:=255;
  a[9,i]:=255;
  a[i,9]:=255;
  end;
  readln(s);
  a[ord(s[1])-ord('A')+1,ord(s[2])-ord('0')]:=vihod;
  readln(n);
  for i:=1 to n do
  begin
  readln(s);
  case s[2] of
  'k':if s[1]='b' then a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=bkn
  else a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=wkn;
  's':if s[1]='b' then a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=bsn
  else a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=wsn;
  'l':if s[1]='b' then a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=bld
  else a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=wld;
  'f':if s[1]='b' then a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=bfz
  else a[ord(s[5])-ord('A')+1,ord(s[6])-ord('0')]:=wfz;
  end;
  end;

  close(output);
end.