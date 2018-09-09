unit Polsk;

interface

const MaxVar=10;

type Ident=(cmProg,cmBegin,cmEnd,cmFor,cmWhile,cmVar,cmWall,cmIf,cmThen,
            cmElse,cmForw,cmRight,cmLeft,cmGet,cmPut,cmMove,cmQuest,cmNotPrep,cmNumber,cmCh,cmStr,cmInteg,cmString,cmChar,
            cmTZ,cmTT,cmZZ,cmT,cmSL,cmSR,cmMore,cmLess,cmEqu,cmNotEqu,cmMoreEqu,cmLessEqu,cmPlus,cmMinus,cmUmnog,cmDel,
            cmIdent);


     str_15=string[15];
     tMainVar=array[1..MaxVar+1] of record
                                      name:str_15;
                                      case typ:ident of
                                      cmInteg:(i:integer;);
                                      cmString:(s:str_15;);
                                      cmChar:(c:char);
                                    end;

var correct:boolean;
    MainVar:tMainVar;

  function NextChar(var str:string):string;
  function pr(n:string):integer;
  function rang(t:string):integer;
  function PushStrInPol(str:string):string;
  function PopIntegStrInPol(str:string):integer;
  function RangStr(str:string):boolean;

implementation

type
  ts=array [1..30] of string;
var
  s        :ts;
  r        :integer;
  n        :string;
  top      :integer;
  p        :string;
  i        :integer;
  t        :string;

  function RangStr;
  var i,rang:integer;
  begin
    i:=1;rang:=0;
    repeat
      if str[i]='('
      then rang:=rang+1
      else if str[i]=')'
           then rang:=rang-1;
      i:=i+1;
    until (rang<0)or(i>length(str));
    RangStr:=(rang=0);
  end;

  function Seek(key:str_15):integer;
  var i:integer;
  begin
    i:=1;
    while (MainVar[i].name<>key)and(i<MaxVar+1) do
      inc(i);
    Seek:=i;
  end;

  function NextChar;
  var k:integer;
  begin
    if (str[1] in ['€'..'Ÿ'])or(str[1] in ['0'..'9'])
    then begin
           k:=1;
           while (str[k] in ['€'..'Ÿ'])or(str[k] in ['0'..'9']) do
             inc(k);
           NextChar:=copy(str,1,k-1);
           delete(str,1,k-1);
         end
    else begin
           NextChar:=str[1];
           delete(str,1,1);
         end;
  end;

  function pr;
  begin
    case n[1] of
    '+','-':pr:=1;
    '*','/':pr:=2;
    '#','(':pr:=0;
    else pr:=3;
    end;
  end;

  function rang;
  begin
    case t[1] of
    '+','-','*','/':rang:=-1;
    else rang:=1;
    end;
  end;

  function PushStrInPol;
  label 1;
  begin
    if not RangStr(str)
    then correct:=false
    else begin
           str:=str+'#';
           correct:=true;
           top:=1; s[top]:='#';
           r:=0; i:=0;
           p:='';
           n:=NextChar(str);
           while n<>'#' do
             begin
               if n=')'
               then begin
                      while s[top]<>'(' do
                        begin
                          t:=s[top];
                          dec(top);
                          p:=p+t+',';
                          r:=r+rang(t);
                          if r<1
                          then begin
                                 correct:=false;
                                 exit;
                               end;
                        end;
                      dec(top);
                    end
               else if n<>'('
                    then begin
                           while pr(n)<=pr(s[top]) do
                             begin
                               inc(i);
                               t:=s[top];
                               dec(top);
                               p:=p+t+',';
                               r:=r+rang(t);
                               if r<1
                               then begin
                                      correct:=false;
                                      exit;
                                    end;
                             end;
                         end;
               if n<>')'
               then begin
                      inc(top);
                      s[top]:=n;
                    end;
               n:=Nextchar(str);
             end;
           while s[top]<>'#' do
             begin
               inc(i);
               t:=s[top];
               dec(top);
               p:=p+t+',';
               r:=r+rang(t);
               if r<1
               then begin
                      correct:=false;
                      exit;
                    end;
             end;
           if r=1
           then PushStrInPol:=p
           else correct:=false;
         end;
  end;

  function GetIntegElem(Var str:string;var cod:integer):integer;
  var i,k:integer;
      s:string;
      code:integer;
  begin
    i:=1;
    cod:=0;
    while (str[i]<>',')and(i<=length(str)) do
      inc(i);
    s:=copy(str,1,i-1);
    delete(str,1,i);
    case s[1] of
    '0'..'9':begin
               val(s,k,code);
               GetIntegElem:=k;
             end;
    '€'..'Ÿ':begin
               GetIntegElem:=MainVar[seek(s)].i;
             end;
    '+':begin
          cod:=1;
        end;
    '-':begin
          cod:=2;
        end;
    '*':begin
          cod:=3;
        end;
    '/':begin
          cod:=4;
        end;
    end;
  end;

  function PopIntegStrInPol;
  type tst=array [1..30] of integer;
  var st:tst;
      top:integer;
      s:integer;
      cod:integer;
  begin
    top:=0;
    while length(str)>=1 do
      begin
        s:=GetIntegElem(str,cod);
        case cod of
        0:begin
            inc(top);
            st[top]:=s;
          end;
        1:begin
            st[top-1]:=st[top]+st[top-1];
            dec(top);
          end;
        2:begin
            st[top-1]:=st[top-1]-st[top];
            dec(top);
          end;
        3:begin
            st[top-1]:=st[top]*st[top-1];
            dec(top);
          end;
        4:begin
            st[top-1]:=st[top-1] div st[top];
            dec(top);
          end;
        end;
      end;
    PopIntegStrInPol:=st[top];
  end;
end.