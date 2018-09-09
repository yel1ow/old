{$A+,B-,D+,E-,F-,G-,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
program readprog;
uses vesa,windos,dos,objects,crt,polsk,option;
const CurDel=1000;

type pLoad=^tLoad;
     tLoad=record
             name:str_15;
             next,prev:pLoad
           end;

     pZnach=^tZnach;
     tZnach=record
              typ:Ident;
              case f:boolean of
              true:(i:integer;
                    s:str_15;
                    c:char);
              false:(p:integer);{если f=true, то k хранит число}
            end;                 {если f=false, то p хранит номер в массиве переменных}

     pNode=^tNode;
     tNode=record
             next:pNode;
             case typ:Ident of
             cmIf:(where:str_15;
                  what:integer;
                  NotPrep:boolean;
                  op1,op2:pZnach;
                  then_,else_:pNode;
                  Operation:Ident );
             cmWhile:(whereW:str_15;
                      whatW:integer;
                      NotPrepW:boolean;
                      op1W,op2W:pZnach;
                      operationW:ident;
                      bodyW:pNode);
             cmFor:(ForI:integer;
                    f:boolean;
                    Body:pNode);
             cmIdent:(Name:str_15;
                      TypAss:ident;
                      WhatAssign:string);
             end;

const MaxLex=40;
      MainLex:array[ident] of str_15=('ПРОГРАММА','НАЧАЛО','КОНЕЦ','ЦИКЛ','ПОКА','ПЕРЕМЕННЫЕ','ПРЕП',
                                      'ЕСЛИ','ТО','ИНАЧЕ','ВПЕРЕД','ВПРАВО','ВЛЕВО','ВЗЯТЬ','ПОЛОЖИТЬ','ПЕРЕДВИНУТЬ','ЧТО',
                                      'НЕТ_ПРЕП','','#',#39,'ЦЕЛ','СТР','СИМ',';',':',',','.','(',')','>','<','=','<>','>=',
                                      '<=','+','-','*','/','');
var prog,stat:text;

    ch:ident;
    last,last_,first,pp:pNode;
    eyes,LexNum:integer;
    LexIdent,LexStr:str_15;
    numbV:integer;
    st,lex,name:string;
    post,stg:integer;
    cursor,nach:tbeg;
    cursor_,nach_:tbeg;
    ErBegEnd:integer;
    c:char;

    Geting:boolean;
    GetObj:byte;

    x,y,posX,posY,offset:integer;
    CurColor:byte;
    CurDel_:integer;
    f:text;
    Fsave,Fload:boolean;
    refresh:boolean;
    Nsave,Nload:string;
    sLoad,NowLoad,NachLoad:pLoad;
    Xsave,Xload:integer;
    Tsave:boolean;
    code:char;

    ex,WTime:byte;
{    PGoth, pTexture1,Old8 : pointer;}
    SBP,SSp,Ses,SSi,sdi,AddrRet:word;

procedure Return;
begin
  asm
    cli
    mov sp,Ssp
    mov bp,sbp
    mov es,Ses
    mov si,Ssi
    mov di,Sdi
    mov ax,AddrRet
    push cs
    push ax
    sti
    retf
  end
end;

procedure error(s:string);      {сообщения об ошибках при компиляции}
var xs,ys,len:integer;
    k:integer;
begin
  k:=-35;
  if s[1] in ['а'..'п']
  then s[1]:=chr(ord(s[1])-ord('а')+ord('А'))
  else if s[1] in ['р'..'я']
       then s[1]:=chr(ord(s[1])-ord('р')+ord('Р'));
  sound(1000);
  delay(1000);
  setcolor(15);
  drawwindow(0+45,440+k,250+45,475+k);
  setcolor(4);
  bar(10+45,450+k,240+45,465+k);
  bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
  setcolor(14);
  Len:=length(s);
  xs:=(55+285-Len*8) div 2;
  ys:=(415+430-16) div 2+1;
  outtextxy(xs,ys,s);
  outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
  nosound;
  repeat
  until keypressed;
  setcolor(0);
  bar(0+45,440+k,250+45,475+k);
  setcolor(80);
  bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
  setcolor(14);
  outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
  return;
end;

procedure EndProg(s:string);      {сообщения об окончании программы}
var k:integer;
    xs,ys:integer;
    len:integer;
begin
  k:=-35;
  sound(1000);
  delay(1000);
  setcolor(15);
  drawwindow(0+45,440+k,250+45,475+k);
  setcolor(green);
  bar(10+45,450+k,240+45,465+k);
  setcolor(14);
  Len:=length(s);
  xs:=(55+285-Len*8) div 2;
  ys:=(415+430-16) div 2+1;
  outtextxy(xs,ys,s);
  nosound;
  repeat
  until keypressed;
  setcolor(0);
  bar(0+45,440+k,250+45,475+k);
  setcolor(80);
  return;
end;

procedure OtherError(s:string);      {сообщения об других ошибках}
var k:integer;
    xs,ys:integer;
    len:integer;
begin
  k:=-35;
  sound(1000);
  delay(1000);
  setcolor(15);
  drawwindow(0+45,440+k,250+45,475+k);
  setcolor(red);
  bar(10+45,450+k,240+45,465+k);
  setcolor(14);
  Len:=length(s);
  xs:=(55+285-Len*8) div 2;
  ys:=(415+430-16) div 2+1;
  outtextxy(xs,ys,s);
  nosound;
  repeat
  until keypressed;
  setcolor(0);
  bar(0+45,440+k,250+45,475+k);
  setcolor(80);
  return;
end;

procedure WriteTextProg(tz:tbeg;num:integer);
var
  s:string;
  i:integer;
begin
  i:=1;
  setcolor(14);
  while tz<>nil do
    begin
      outtextxy(358,num,tz^.strok);
      num:=num+15;
      i:=i+1;
      tz:=tz^.next;
      if (i>28) or (num>=460)
      then tz:=nil
    end;
end;

procedure InsAfter(var cursor:tbeg);
var q:tbeg;
begin
  new(q);
  q^.prev:=cursor;
  q^.next:=cursor^.next;
  if cursor^.next<>nil
  then q^.next^.prev:=q;
  cursor^.next:=q;
  cursor:=cursor^.next;
  cursor^.strok:='';
  posX:=1;
  posY:=posY+1;
end;

procedure ReadFileProg(name:string);
var
  c:string;
  i:integer;
begin
  i:=0;
  assign(f,name);
  {$I-}
  reset(f);
  {$I+}
  if IOresult<>0
  then OtherError('Файл не найден');
  new(beg);
  cursor:=beg;
  beg^.next:=nil;
  beg^.prev:=nil;
  while not(eof(f)) do
  begin
    insafter(cursor);
    readln(f,c);
    cursor^.strok:=c;
    inc(i);
  end;
  close(f);
  WriteTextProg(beg^.next,10);
end;

procedure DelAfter;
var tz:tbeg;
begin
    tz:=cursor;
    tz^.prev^.next:=tz^.next;
    tz^.next^.prev:=tz^.prev;
    cursor:=cursor^.next;
    dispose(tz);
end;

procedure DelBefore(var cursor:tbeg);
var tz:tbeg;
begin
    tz:=cursor;
    tz^.prev^.next:=tz^.next;
    tz^.next^.prev:=tz^.prev;
    cursor:=cursor^.prev;
    dispose(tz);
end;

procedure del(k:integer);
var s1,s2:string;
begin
    s1:=copy(cursor^.strok,1,k-1);
    s2:=copy(cursor^.strok,k+1,length(cursor^.strok));
    cursor^.strok:=s1+s2;
end;

procedure ins(k:integer;c:char);
var s1,s2:string;
begin
    s1:=copy(cursor^.strok,1,k-1);
    s2:=copy(cursor^.strok,k,length(cursor^.strok));
    cursor^.strok:=s1+c+s2;
end;

{================================}
procedure UpString(var st:string);    {переход на заглавные буквы}
var i:integer;
begin
    for i:=1 to length(st) do
    if st[i] in ['а'..'п']
    then st[i]:=chr(ord(st[i])-ord('а')+ord('А'))
    else if st[i] in ['р'..'я']
    then st[i]:=chr(ord(st[i])-ord('р')+ord('Р'))
end;
{===============================}
function GetLex:ident;     {чтение очередного слова из файла}
var c:char;
    i,code:integer;
    ii:ident;
    cchh:Ident;
begin
    i:=1;
    while st[i]=' ' do
          inc(i);
    delete(st,1,i-1);
    post:=post+i-1;
    while (st='')and(not eof(prog)) do
    begin
       readln(prog,st);
       cursor:=cursor^.next;
       posY:=posY+1;
       if posY>28
       then begin
              offset:=offset+1;
              nach:=nach^.next;
              {bar(358,11,629,430);
              WriteTextProg(nach,10);}
            end;
       post:=0;
    end;
    UpString(st);
    i:=1;
    while st[i]=' ' do
          inc(i);
    delete(st,1,i-1);
    post:=post+i-1;
    case st[1] of
      '>','<':begin
              if st[2] in ['>','=']
              then i:=2
              else i:=1;
              Lex:=copy(st,1,i);
              delete(st,1,i);
              post:=post+i-1
            end;
      '0'..'9':begin
               while st[i] in ['0'..'9','.'] do
                     inc(i);
               Lex:=copy(st,1,i-1);
               val(Lex,LexNum,code);
               delete(st,1,i-1);
               Lex:='';
               post:=post+i-1
               end;
      ',',';',':','=','.','(',')':begin
                              Lex:=copy(st,1,1);
                              delete(st,1,1);
                              post:=post+1;
                            end;
      '-','+','*','/':begin
                        Lex:=copy(st,1,1);
                        delete(st,1,1);
                        post:=post+1;
                      end;
      #39:begin
            LexIdent:=''; i:=1;
            delete(st,1,1);
            while st[i]<>#39 do
              begin
                LexIdent:=LexIdent+st[i];
                inc(i);
                if i>15
                then error('слишком длинная строка');
              end;
            delete(st,1,i);
            if length(LexIdent)=1
            then Lex:='#'
            else Lex:=#39;
          end;
      '{':begin
            i:=1;
            while st[i]<>'}' do
              begin
                if i>=length(st)
                then if not(eof(prog))
                     then begin
                            readln(prog,st);
                            UpString(st);
                            i:=0;
                          end
                     else error('нет конца программы');
                inc(i);
              end;
            delete(st,1,i);
            ch:=GetLex;
            GetLex:=ch;
            exit;
          end;
    else begin
           i:=1;
           if st[1] in ['А'..'п','р'..'я','_']
           then begin
                  while st[i] in ['А'..'п','р'..'я','_'] do
                        inc(i);
                  Lex:=copy(st,1,i-1);
                  delete(st,1,i-1);
                  post:=post+i-1
                end
           else error('неизвестный символ');
         end;
    end;
    ii:=cmProg;
    while (MainLex[ii]<>Lex)and(byte(ii)<MaxLex) do
          inc(ii);
    if byte(ii)=MaxLex
    then begin
           LexIdent:=Lex;
           GetLex:=cmIdent;
         end
    else GetLex:=ii;
end;
{============================}
procedure End_(var last:pNode);
var node:pNode;
begin
     last^.next:=nil;
     ErBegEnd:=ErBegEnd-1;
end;
{==============================}
procedure progr;            {раздел начала программы}
var node:pNode;
begin
     ch:=GetLex;
     if ch<>cmProg
     then error('требуется слово "ПРОГРАММА"')
     else begin
            ch:=GetLex;
            if ch<>cmIdent
            then error('требуется "имя" программы');
          end;
end;
{=======================}
function Seek_Dubl_In_Var(key:string;i:integer):boolean;
var f:boolean;
    k:integer;
begin
  k:=1;
  while (MainVar[k].name<>key)and(k<i)do
    inc(k);
  Seek_Dubl_In_Var:=(k<i);
end;

procedure Var_;
var i,k,j:integer;
begin
     i:=0;
     j:=1;
     ch:=GetLex;
     repeat
        repeat
           i:=i+1;
           if i>MaxVar
           then error('Слишком много переменных');
           if ch<>cmIdent
           then error('требуется имя переменной')
           else if Seek_Dubl_In_Var(LexIdent,i)
                then error('Двойной идентификатор')
                else MainVar[i].name:=LexIdent;
           ch:=GetLex;
           if (ch<>cmTT)and(ch<>cmZZ)
           then error('требуется ":"')
           else if ch<>cmTT
                then ch:=GetLex;
        until ch=cmTT;
        ch:=GetLex;
        if ch in [cmInteg,cmChar,cmString]
        then for k:=j to i do
             begin
                  MainVar[k].typ:=ch;
                  case ch of
                  cmInteg:MainVar[k].i:=0;
                  cmChar:MainVar[k].c:=#0;
                  cmString:MainVar[k].s:='';
                  end;
             end
        else error('требуется тип переменной');
        j:=k+1;
        ch:=GetLex;
        if ch<>cmTZ
        then error('требуется ";"')
        else ch:=GetLex;
     until ch=cmBegin;
end;

function Seek(key:str_15):integer;
var i:integer;
begin
  i:=1;
  while (MainVar[i].name<>key)and(i<MaxVar+1) do
    inc(i);
  if i>MaxVar
  then error('незвестная переменная')
  else Seek:=i;
end;

procedure InitCodeProg;
var p:pNode;
begin
  new(p);
  p^.next:=nil;
  last:=p;
  first:=p;
end;

procedure NewAdd(typ:ident);
var p:pNode;
begin
  new(p);
  p^.typ:=typ;
  p^.next:=nil;
  last^.next:=p;
  last:=p;
end;

procedure Assign_;                 {оператор присваивания}
var PMU:ident;
    typ:integer;
    s,nnn:string;
begin
     s:='';
     NewAdd(cmIdent);
     last^.WhatAssign:='';
     last^.TypAss:=MainVar[Seek(LexIdent)].typ;
     last^.Name:=LexIdent;
     ch:=GetLex;
     if ch<>cmEqu
     then error('требуется "="');
     ch:=GetLex;
     if ch=cmTZ
     then error('ошибка в построении');
     PMU:=cmPlus;
     while ch in [cmIdent,cmNumber,cmStr,cmCh,cmPlus,cmMinus,cmUmnog,cmDel,cmSL,cmSR] do
       begin
         case ch of
         cmIdent:begin
                   if last^.TypAss<>MainVar[seek(LexIdent)].typ
                   then error('несоответствие типов');
                   s:=s+LexIdent;
                 end;
         cmNumber:begin
                    if last^.TypAss<>cmInteg
                    then error('несоответствие типов');
                    str(LexNum,nnn);
                    s:=s+nnn;
                  end;
         cmStr:begin
                 if last^.TypAss<>cmString
                 then error('несоответствие типов');
                 s:=s+LexIdent;
               end;
         cmCh:begin
                if last^.TypAss<>cmChar
                then error('несоответствие типов');
                s:=s+LexIdent[1];
              end;
         cmPlus:begin
                  s:=s+'+';
                end;
         cmMinus:begin
                   s:=s+'-';
                 end;
         cmUmnog:begin
                   s:=s+'*';
                 end;
         cmSL:begin
                s:=s+'(';
              end;
         cmSR:begin
                s:=s+')';
              end;
         cmDel:begin
                 s:=s+'/';
               end;
         end;
         ch:=GetLex;
       end;
     if ch<>cmTZ
     then error('требуется ";"');
     last^.WhatAssign:=PushStrInPol(s);
     if not correct
     then error('Выражение некорректно');
end;
{================================}
procedure Operator;
begin
     repeat
       ch:=GetLex;
       case ch of
         cmForw:begin
                  NewAdd(cmForw);
                  ch:=GetLex;
                end;
         cmRight:begin
                   NewAdd(cmRight);
                   ch:=GetLex;
                 end;
         cmLeft:begin
                  NewAdd(cmLeft);
                  ch:=GetLex;
                end;
         cmGet:begin
                 NewAdd(cmGet);
                 ch:=GetLex;
               end;
         cmPut:begin
                 NewAdd(cmPut);
                 ch:=GetLex;
               end;
         cmMove:begin
                  NewAdd(cmMove);
                  ch:=GetLex;
                end;
         cmIdent:begin
                   Assign_;
                 end;
         end;
         if (ch<>cmTZ)and(ch<>cmEnd)
         then error('требуется ";"');
     until ch=cmEnd;
     ErBegEnd:=ErBegEnd-1;
     ch:=GetLex;
     if ch<>cmTZ
     then error('требуется ";"')
end;
{===============================}
procedure SimplOper;
begin
     case ch of
       cmForw:begin
                NewAdd(cmForw);
                ch:=GetLex;
              end;
       cmRight:begin
                 NewAdd(cmRight);
                 ch:=GetLex;
               end;
       cmLeft:begin
                NewAdd(cmLeft);
                ch:=GetLex;
              end;
       cmGet:begin
               NewAdd(cmGet);
               ch:=GetLex;
             end;
       cmPut:begin
               NewAdd(cmPut);
               ch:=GetLex;
             end;
       cmMove:begin
                NewAdd(cmMove);
                ch:=GetLex;
              end;
       cmIdent:begin
                 Assign_;
               end;
       end;
       if (ch<>cmTZ)and(ch<>cmEnd)
       then error('требуется ";"');
end;
{==============================}
procedure InitBody;
var p:pNode;
begin
  new(p);
  p^.next:=nil;
  last_^.body:=p;
  last:=p;
end;

procedure For_;
var
 tmp:pNode;
begin
  NewAdd(cmFor);
  ch:=GetLex;
  if (ch<>cmNumber)and(ch<>cmIdent)
  then error('Требуется счетчик')
  else if (ch=cmIdent)and(MainVar[seek(LexIdent)].typ<>cmInteg)
       then error('Несоответствие типов');
  if ch=cmIdent
  then begin
         last^.f:=false;
         last^.ForI:=seek(LexIdent)
       end
  else begin
         last^.f:=true;
         last^.ForI:=LexNum;
       end;
  ch:=GetLex;
  last_:=last;
  last^.body:=nil;
  InitBody;
  case ch of
  cmBegin:begin
            ErBegEnd:=ErBegEnd+1;
            Operator;
          end;
  else SimplOper;
  end;
  last:=last_;
end;
{=============================}
procedure operat1W;
begin
  if (ch<>cmIdent)and(ch<>cmNumber)and(ch<>cmStr)and(ch<>cmCh)
  then error('требуется операнд');
  case ch of
  cmIdent:begin
            new(last^.op1W);
            last^.op1W^.f:=false;
            last^.op1W^.p:=Seek(LexIdent);
            last^.op1W^.typ:=MainVar[last^.op1W^.p].typ
          end;
  cmNumber:begin
             new(last^.op1W);
             last^.op1W^.f:=true;
             last^.op1W^.i:=LexNum;
             last^.op1W^.typ:=cmInteg;
           end;
  cmStr:begin
          new(last^.op1W);
          last^.op1W^.f:=true;
          last^.op1W^.s:=LexIdent;
          last^.op1W^.typ:=cmString;
        end;
  cmCh:begin
         new(last^.op1W);
         last^.op1W^.f:=true;
         last^.op1W^.c:=LexIdent[1];
         last^.op1W^.typ:=cmChar;
       end;
  end;
end;

procedure Operat2W;
begin
  if (ch<>cmIdent)and(ch<>cmNumber)and(ch<>cmStr)and(ch<>cmCh)
  then error('требуется операнд');
  case ch of
  cmIdent:begin
            new(last^.op2W);
            last^.op2W^.f:=false;
            last^.op2W^.p:=Seek(LexIdent);
            last^.op2W^.typ:=MainVar[last^.op2W^.p].typ;
            if last^.op1W^.typ<>last^.op2W^.typ
            then error('Несоответствие типов');
          end;
  cmNumber:begin
             new(last^.op2W);
             last^.op2W^.f:=true;
             last^.op2W^.i:=LexNum;
             last^.op2W^.typ:=cmInteg;
             if last^.op1W^.typ<>last^.op2W^.typ
             then error('Несоответствие типов');
           end;
  cmStr:begin
          new(last^.op2W);
          last^.op2W^.f:=true;
          last^.op2W^.s:=LexIdent;
          last^.op2W^.typ:=cmString;
          if last^.op1W^.typ<>last^.op2W^.typ
          then error('Несоответствие типов');
        end;
  cmCh:begin
         new(last^.op2W);
         last^.op2W^.f:=true;
         last^.op2W^.c:=Lexident[1];
         last^.op2W^.typ:=cmChar;
         if last^.op1W^.typ<>last^.op2W^.typ
         then error('Несоответствие типов');
       end;
  end;
end;

procedure Uslovie_W;
begin
  last^.NotPrepW:=false;
  operat1W;
  ch:=GetLex;
  if ch in [cmMore,cmLess,cmEqu,cmMoreEqu,cmLessEqu]
  then last^.operationW:=ch
  else error('требуется операция');
  ch:=GetLex;
  operat2W;
end;

procedure Quest_W;
type
  tlet=set of 'А'..'Я';
const
  let:tlet=['А'..'Я'];
begin
  last^.op1W:=nil;
  last^.op2W:=nil;
  last^.NotPrepW:=false;
  ch:=GetLex;
  if ch<>cmSL
  then error('требуется "("');
  ch:=GetLex;
  if (LexIdent<>'СПРАВА')and(LexIdent<>'СЛЕВА')and(LexIdent<>'ВПЕРЕДИ')
  then error('неизвестное слово');
  last^.whereW:=LexIdent;
  ch:=GetLex;
  if ch<>cmSR
  then error('требуется ")"');
  ch:=GetLex;
  if (ch<>cmEqu)and(ch<>cmNotEqu)
  then error('требуется "=" или "<>"');
  last^.operationW:=ch;
  ch:=GetLex;
  if ((LexIdent[1] in let)and(Length(LexIdent)=1))or(LexIdent='СТЕНА')or(LexIdent='ЗВЕЗДА')
  then begin
         if LexIdent='СТЕНА'
         then last^.whatW:=3
         else if LexIdent='ЗВЕЗДА'
              then last^.whatW:=1
              else if LexIdent[1] in ['А'..'П']
                   then last^.whatW:=ord(LexIdent[1])+32
                   else last^.whatW:=ord(LexIdent[1])+80;
       end
  else error('некорректная операция')
end;

procedure NotPrep_W;
begin
  last^.NotPrepW:=true;
  last^.whereW:='';
  last^.whatW:=0;
  last^.op1W:=nil;
  last^.op2W:=nil;
end;

procedure InitBodyW;
var p:pNode;
begin
  new(p);
  p^.next:=nil;
  last_^.bodyW:=p;
  last:=p;
end;

procedure While_;
begin
  NewAdd(cmWhile);
  ch:=GetLex;
  case ch of
  cmIdent,cmNumber,cmStr,cmCh:Uslovie_W;
  cmQuest:Quest_W;
  cmNotPrep:NotPrep_W;
  end;
  ch:=GetLex;
  if (ch<>cmIdent)and(LexIdent<>'ДЕЛАТЬ')
  then error('Требуется "ДЕЛАТЬ"');
  ch:=GetLex;
  last_:=last;
  last^.bodyW:=nil;
  InitBodyW;
  case ch of
  cmBegin:begin
            ErBegEnd:=ErBegEnd+1;
            Operator;
          end;
  else SimplOper;
  end;
  last:=last_;
end;

procedure Quest_;
type
  tlet=set of 'А'..'Я';
const
  let:tlet=['А'..'Я'];
begin
    last^.op1:=nil;
    last^.op2:=nil;
    last^.NotPrep:=false;
    ch:=GetLex;
    if ch<>cmSL
    then error('требуется "("');
    ch:=GetLex;
    if (LexIdent<>'СПРАВА')and(LexIdent<>'СЛЕВА')and(LexIdent<>'ВПЕРЕДИ')
    then error('неизвестное слово');
    last^.where:=LexIdent;
    ch:=GetLex;
    if ch<>cmSR
    then error('требуется ")"');
    ch:=GetLex;
    if (ch<>cmEqu)and(ch<>cmNotEqu)
    then error('требуется "=" или "<>"');
    last^.operation:=ch;
    ch:=GetLex;
    if ((LexIdent[1] in let)and(Length(LexIdent)=1))or(LexIdent='СТЕНА')or(LexIdent='ЗВЕЗДА')
    then begin
           if LexIdent='СТЕНА'
           then last^.what:=3
           else if LexIdent='ЗВЕЗДА'
                then last^.what:=1
                else if LexIdent[1] in ['А'..'П']
                     then last^.what:=ord(LexIdent[1])+32
                     else last^.what:=ord(LexIdent[1])+80;
         end
    else error('некорректная операция')
end;
{====================================}
procedure operat1;
var i:integer;
begin
     if (ch<>cmIdent)and(ch<>cmNumber)and(ch<>cmStr)and(ch<>cmCh)
     then error('требуется операнд');
     case ch of
     cmIdent:begin
               new(last^.op1);
               last^.op1^.f:=false;
               last^.op1^.p:=Seek(LexIdent);
               last^.op1^.typ:=MainVar[last^.op1^.p].typ
             end;
     cmNumber:begin
                new(last^.op1);
                last^.op1^.f:=true;
                last^.op1^.i:=LexNum;
                last^.op1^.typ:=cmInteg;
              end;
     cmStr:begin
             new(last^.op1);
             last^.op1^.f:=true;
             last^.op1^.s:=LexIdent;
             last^.op1^.typ:=cmString;
           end;
     cmCh:begin
            new(last^.op1);
            last^.op1^.f:=true;
            last^.op1^.c:=LexIdent[1];
            last^.op1^.typ:=cmChar;
          end;
     end;
end;
{===========================}
procedure operat2;
var i:integer;
begin
     if (ch<>cmIdent)and(ch<>cmNumber)and(ch<>cmStr)and(ch<>cmCh)
     then error('требуется операнд');
     case ch of
     cmIdent:begin
               new(last^.op2);
               last^.op2^.f:=false;
               last^.op2^.p:=Seek(LexIdent);
               last^.op2^.typ:=MainVar[last^.op2^.p].typ;
               if last^.op1^.typ<>last^.op2^.typ
               then error('Несоответствие типов');
             end;
     cmNumber:begin
                new(last^.op2);
                last^.op2^.f:=true;
                last^.op2^.i:=LexNum;
                last^.op2^.typ:=cmInteg;
                if last^.op1^.typ<>last^.op2^.typ
                then error('Несоответствие типов');
              end;
     cmStr:begin
             new(last^.op2);
             last^.op2^.f:=true;
             last^.op2^.s:=LexIdent;
             last^.op2^.typ:=cmString;
             if last^.op1^.typ<>last^.op2^.typ
             then error('Несоответствие типов');
           end;
     cmCh:begin
            new(last^.op2);
            last^.op2^.f:=true;
            last^.op2^.c:=Lexident[1];
            last^.op2^.typ:=cmChar;
            if last^.op1^.typ<>last^.op2^.typ
            then error('Несоответствие типов');
          end;
     end;
end;
{==============================}
procedure Uslovie;
var i:integer;
begin
  last^.NotPrep:=false;
  operat1;
  ch:=GetLex;
  if ch in [cmMore,cmLess,cmEqu,cmMoreEqu,cmLessEqu]
  then last^.operation:=ch
  else error('требуется операция');
  ch:=GetLex;
  operat2;
end;

{===============================}
procedure NotPrep_;
begin
  last^.NotPrep:=true;
  last^.where:='';
  last^.what:=0;
  last^.op1:=nil;
  last^.op2:=nil;
end;

procedure InitThen;
var p:pNode;
begin
  New(p);
  p^.next:=nil;
  last_^.then_:=p;
  last:=p;
end;

procedure InitElse;
var p:pNode;
begin
  New(p);
  p^.next:=nil;
  last_^.else_:=p;
  last:=p;
end;

procedure if_;
begin
  NewAdd(cmIf);
  ch:=GetLex;
  case ch of
  cmIdent,cmNumber,cmStr,cmCh:Uslovie;
  cmQuest:Quest_;
  cmNotPrep:NotPrep_;
  end;
  ch:=GetLex;
  if ch<>cmThen
  then error('требуется "то"');
  ch:=GetLex;
  last_:=last;
  last^.then_:=nil;
  InitThen;
  case ch of
  cmBegin:begin
            ErBegEnd:=ErBegEnd+1;
            Operator;
          end;
  else SimplOper;
  end;
  last:=last_;
  ch:=GetLex;
  if ch=cmElse
  then begin
         ch:=GetLex;
         last_:=last;
         last^.else_:=nil;
         InitElse;
         case ch of
         cmBegin:begin
                   ErBegEnd:=ErBegEnd+1;
                   Operator;
                 end;
         else SimplOper;
         end;
         last:=last_;
       end
  else begin
         last^.else_:=nil;
       end;
end;

procedure compiler;
label no_if;
begin
  ErBegEnd:=0;
  st:='';
  posY:=0;posX:=1;offset:=0;
  cursor_:=cursor;
  nach_:=nach;
  cursor:=beg;
  nach:=beg^.next;
  InitCodeProg;
  assign(prog,'swap.swp');
  reset(prog);
  progr;
  ch:=GetLex;
  if ch<>cmTZ
  then begin
         error('требуется ";"');;
         readln;
         exit;
      end
  else ch:=GetLex;
  if ch=cmVar
  then Var_;
  if ch<>cmBegin
  then begin
         error('требуется "НАЧАЛО"');
         readln;
         exit;
       end
  else begin
         ErBegEnd:=ErBegEnd+1;
         repeat
           ch:=GetLex;
no_if:     case ch of
           cmBegin:begin
                     ErBegEnd:=ErBegEnd+1;
                   end;
           cmIf:begin
                  If_;
                  goto no_if
                end;
           cmFor:begin
                   For_
                 end;
           cmWhile:begin
                     While_
                   end;
           cmForw:begin
                    NewAdd(cmForw);
                    ch:=GetLex;
                  end;
           cmRight:begin
                     NewAdd(cmRight);
                     ch:=GetLex;
                   end;
           cmLeft:begin
                    NewAdd(cmLeft);
                    ch:=GetLex;
                  end;
           cmGet:begin
                   NewAdd(cmGet);
                   ch:=GetLex;
                 end;
           cmPut:begin
                   NewAdd(cmPut);
                   ch:=GetLex;
                 end;
           cmMove:begin
                    NewAdd(cmMove);
                    ch:=GetLex;
                  end;
           cmIdent:begin
                     Assign_;
                   end;
           end;
           if ErBegEnd<0
           then error('ошибка в операторе');
           if (ch<>cmTZ)and(ch<>cmEnd)
           then error('требуется ";"');
         until ch=cmEnd;
         ErBegEnd:=ErBegEnd-1;
         if ErBegEnd<>0
         then error('ошибка в операторе');
         ch:=GetLex;
         if ch<>cmT
         then error('требуется "."')
       end;
  close(prog);
  assign(prog,'swap.swp');
  rewrite(prog);
  close(prog);
end;
{====================================}
function SeekChud:boolean;
var i,j:integer;
    f:boolean;
begin
  f:=false;
  for i:=1 to 10 do
    for j:=1 to 10 do
      if pole[i,j]=2
      then begin
             Xchud:=i;
             Ychud:=j;
             f:=true;
           end;
  SeekChud:=f;
end;
{===================}
procedure FindChud;
var i,j:integer;
begin
  for i:=1 to 10 do
    for j:=1 to 10 do
      if pole[i,j]=2
      then begin
             Xchud:=i;
             Ychud:=j;
           end;
end;
{===================}

function DispToArr(disp:integer):integer;
begin
  disptoarr:=(disp-10) div 32+1;
end;

function Npole(i:integer):integer;
begin
  Npole:=11+(DispToArr(i)-1)*32;
end;
{========================}
procedure Letter(x,y:integer;c:char);
begin
  LoadStrokedFont('goth.chr');
  SetStrokedFontScale(1,1);
  SetActiveFont(afStroked);
  Bar(10+32*x-31,10+32*y-31,10+32*x-1,10+32*y-1);
  rectangle(10+32*x-30,10+32*y-30,10+32*x-2,10+32*y-2,0,0);
  rectangle(10+32*x-31,10+32*y-31,10+32*x-1,10+32*y-1,100,100);
  PutImage(10+32*x-30,10+32*y-30,pic[8],NormalPut);
{  DrawLabel(10+32*x-30,10+32*y-30,10+32*x-2,10+32*y-2,'');}
  Setcolor(0);
  OutTextXY(10+32*x-26,10+32*y-28,c);
  Setcolor(12);
  OutTextXY(8+32*x-26,8+32*y-28,c);
  setcolor(100);
  SetActiveFont(afRaster);
end;

procedure RedactorPole;
var x,y:integer;
    xm,ym,i,j:integer;
    objec:integer;
    chud:boolean;
    dx,dy,ox,oy:integer;
begin
  code:=#0;
  x:=10;
  y:=10;
  objec:=0;
  ox:=1;
  oy:=1;
  chud:=false;
  rectangle(74,353,107,386,15,0);
  rectangle(127,353,160,386,15,0);
  rectangle(180,353,213,386,15,0);
  rectangle(233,353,266,386,15,0);
  rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
  showmouse;
  repeat
    if MouseButton=1
    then begin
           xm:=mouseX;
           ym:=mouseY;
           rectangle(74,353,107,386,15,0);
           rectangle(127,353,160,386,15,0);
           rectangle(180,353,213,386,15,0);
           rectangle(233,353,266,386,15,0);
           if (ym>=353)and(ym<=386)
           then case xm of
                74..107:begin
                          hidemouse;
                          rectangle(74,353,107,386,0,15);
                          showmouse;
                          objec:=1;
                        end;
                127..160:begin
                           hidemouse;
                           rectangle(127,353,160,386,0,15);
                           showmouse;
                           objec:=2;
                         end;
                180..213:begin
                           hidemouse;
                           rectangle(180,353,213,386,0,15);
                           showmouse;
                           objec:=3;
                         end;
                233..266:begin
                           hidemouse;
                           rectangle(233,353,266,386,0,15);
                           showmouse;
                           objec:=4;
                         end;
                else objec:=0;
                end;
                While mousebutton=1 do;
         end;
     if objec<>0
     then begin
            while MouseButton<>LeftButton do
              begin
               if MouseButton=RightButton
               then begin
                      if (mouseX<330)and(mouseY<330)
                      then begin
                             xm:=npole(mouseX);
                             ym:=npole(mouseY);
                             i:=DispToArr(xm);
                             j:=DispToArr(ym);
                             if pole[i,j]=0
                             then begin
                                    hidemouse;
                                    case objec of
                                    2:begin
                                        FindChud;
                                        setcolor(100);
                                        bar(11+(Xchud-1)*32,11+(Ychud-1)*32,9+Xchud*32,9+Ychud*32);
                                        pole[Xchud,Ychud]:=0;
                                        PutImage(xm,ym,pic[objec],NormalPut);
                                        pole[i,j]:=2;
                                      end;
                                    else begin
                                           if objec<>4
                                           then begin
                                                  pole[i,j]:=objec;
                                                  PutImage(xm,ym,pic[objec],NormalPut);
                                                end;
                                         end;
                                    end;
                                    showmouse;
                                  end
                             else if (objec=4)and(pole[i,j]<>2)
                                  then begin
                                         hidemouse;
                                         setcolor(100);
                                         bar(xm,ym,xm+30,ym+30);
                                         pole[i,j]:=0;
                                         showmouse;
                                       end;
                           end;
                    end;
            end;
          end;
    if keypressed
    then begin
           code:=readkey;
           case code of
           #72:begin
                 hidemouse;
                 oy:=oy-1;
                 if (oy>=1)and(oy<=10)
                 then begin
                        rectangle(10+32*ox-31,10+32*(oy+1)-31,10+32*ox-1,10+32*(oy+1)-1,100,100);
                        rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
                      end
                 else oy:=1;
                 showmouse;
               end;
           #75:begin
                 hidemouse;
                 ox:=ox-1;
                 if (ox>=1)and(ox<=10)
                 then begin
                        rectangle(10+32*(ox+1)-31,10+32*oy-31,10+32*(ox+1)-1,10+32*oy-1,100,100);
                        rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
                      end
                 else ox:=1;
                 showmouse;
               end;
           #77:begin
                 hidemouse;
                 ox:=ox+1;
                 if (ox>=1)and(ox<=10)
                 then begin
                        rectangle(10+32*(ox-1)-31,10+32*oy-31,10+32*(ox-1)-1,10+32*oy-1,100,100);
                        rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
                      end
                 else ox:=10;
                 showmouse;
               end;
           #80:begin
                 hidemouse;
                 oy:=oy+1;
                 if (oy>=1)and(oy<=10)
                 then begin
                        rectangle(10+32*ox-31,10+32*(oy-1)-31,10+32*ox-1,10+32*(oy-1)-1,100,100);
                        rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
                      end
                 else oy:=10;
                 showmouse;
               end;
           #83:begin
                 hidemouse;
                 setcolor(100);
                 bar(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1);
                 pole[ox,oy]:=0;
                 rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
                 showmouse;
               end;
           'а'..'п',
           'р'..'я':begin
                      hidemouse;
                      if pole[ox,oy]=0
                      then begin
                             setcolor(15);
                             Letter(ox,oy,code);
                             rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,15,15);
                             pole[ox,oy]:=ord(code);
                           end;
                      if pole[ox,oy]=2
                      then begin
                             pole[ox,oy]:=ord(code)-100;
                           end;
                      showmouse;
                    end;
           ' ':begin
                 hidemouse;
                 if pole[ox,oy]=0
                 then begin
                        SeekChud;
                        setcolor(100);
                        bar(10+Xchud*32-31,10+Ychud*32-31,10+Xchud*32-1,10+Ychud*32-1);
                        pole[Xchud,Ychud]:=0;
                        putimage(10+ox*32-31,10+oy*32-31,pic[2],NormalPut);
                        pole[ox,oy]:=2;
                        Xchud:=ox;
                        Ychud:=oy;
                      end;
                 showmouse;
               end;
           #13:begin
                 hidemouse;
                 if pole[ox,oy]=0
                 then begin
                        putimage(10+ox*32-31,10+oy*32-31,pic[1],NormalPut);
                        pole[ox,oy]:=1;
                      end;
                 showmouse;
               end;
           end;
         end;
    objec:=0;
    if ox<=0
    then ox:=1;
    if ox>10
    then ox:=10;
    if oy<=0
    then oy:=1;
    if oy>10
    then oy:=10;
  until (code=#27)or(code=#60)or(code=#62)or(code=#63)or(code=#64)or(code=#67);
  rectangle(10+32*ox-31,10+32*oy-31,10+32*ox-1,10+32*oy-1,100,100);
  hidemouse;
end;
{===========================}
procedure ReadFilePole(name:string);
var
 f:file of byte;
 i,j:integer;
begin
  assign(f,name);
  {$I-}
  reset(f);
  {$I+}
  if IOresult<>0
  then OtherError('Файл не найден');
  setcolor(15);
  for i:=1 to 10 do
    for j:=1 to 10 do
      begin
        read(f,pole[i,j]);
        case pole[i,j] of
        1,2,3,4,5,6,7:PutImage(11+(i-1)*32,11+(j-1)*32,pic[pole[i,j]],NormalPut);
        160..175,224..239:Letter(i,j,chr(pole[i,j]));
        end;
      end;
 close(f);
end;
{=================================}
{========================}
{========================}
{========================}
{========================}
procedure ispol(ins:pNode);

procedure Right;
begin
    if eyes=2
    then eyes:=5
    else if eyes=7
         then eyes:=2
         else eyes:=eyes+1;
end;

procedure Left;
begin
  if eyes=2
  then eyes:=7
  else if eyes=5
       then eyes:=2
       else eyes:=eyes-1;
end;

procedure Forw;
var n:integer;
begin
  case eyes of
  2:begin
      if (Xchud+1<=10)and(pole[Xchud+1,Ychud]=0)
      then begin
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*(Xchud+1)+10-31,32*Ychud+10-31,32*(Xchud+1)+9,32*Ychud+9);
                 setcolor(0);
                 line(32*Xchud+10,32*Ychud+10-31,32*Xchud+10,32*Ychud+10);
                 setcolor(100);
                 putimage(32*Xchud+10-31+n,32*Ychud+10-31,pic[eyes],NormalPut);
                 delay(500);
               end;
             Xchud:=Xchud+1;
           end
      else begin
             OtherError('не могу исполнить');
             exit;
           end;
    end;
  5:begin
      if (Ychud+1<=10)and(pole[Xchud,Ychud+1]=0)
      then begin
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*Xchud+10-31,32*(Ychud+1)+10-31,32*Xchud+9,32*(Ychud+1)+9);
                 setcolor(0);
                 line(32*Xchud+10-31,32*Ychud+10,32*Xchud+9,32*Ychud+10);
                 setcolor(100);
                 putimage(32*Xchud+10-31,32*Ychud+10-31+n,pic[eyes],NormalPut);
                 delay(500);
               end;
             Ychud:=Ychud+1;
           end
      else begin
             OtherError('не могу исполнить');
             exit;
           end;
    end;
  6:begin
      if (Xchud-1>=1)and(pole[Xchud-1,Ychud]=0)
      then begin
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*(Xchud-1)+10-31,32*Ychud+10-31,32*(Xchud-1)+9,32*Ychud+9);
                 setcolor(0);
                 line(32*Xchud+10-32,32*Ychud+10-31,32*Xchud+10-32,32*Ychud+9);
                 setcolor(100);
                 putimage(32*Xchud+10-31-n,32*Ychud+10-31,pic[eyes],NormalPut);
                 delay(500);
               end;
             Xchud:=Xchud-1;
           end
      else begin
             OtherError('не могу исполнить');
             exit;
           end;
    end;
  7:begin
     if (Ychud-1>=1)and(pole[Xchud,Ychud-1]=0)
     then begin
            for n:=1 to 32 do
              begin
                bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                bar(32*Xchud+10-31,32*(Ychud-1)+10-31,32*Xchud+9,32*(Ychud-1)+9);
                setcolor(0);
                line(32*Xchud+10-31,32*Ychud+10-32,32*Xchud+9,32*Ychud+10-32);
                setcolor(100);
                putimage(32*Xchud+10-31,32*Ychud+10-31-n,pic[eyes],NormalPut);
                delay(500);
              end;
            Ychud:=Ychud-1;
          end
     else begin
            OtherError('не могу исполнить');
            exit;
          end;
    end;
  end;
end;

procedure Fo;
var n:integer;
begin
  case ins^.f of
  true:for n:=1 to ins^.forI do
         Ispol(ins^.body);
  false:for n:=1 to MainVar[ins^.ForI].i do
          ispol(ins^.body);
  end;
end;

procedure Get;
type
  tlet=set of 160..239;
const
  let:tlet=[160..175,224..239];
begin
  case eyes of
  2:if (pole[Xchud+1,Ychud]=1)or(pole[Xchud+1,Ychud] in let)
    then if  Geting
         then OtherError('предмет уже есть')
         else begin
                Geting:=true;
                GetObj:=pole[Xchud+1,Ychud];
                pole[Xchud+1,Ychud]:=0;
                setcolor(100);
                putimage(32*(Xchud+1)-21,32*Ychud-21,pic[eyes],NormalPut);
                Forw;
              end
    else begin
           OtherError('нечего брать');
           exit;
         end;
  5:if (pole[Xchud,Ychud+1]=1)or(pole[Xchud,Ychud+1] in let)
    then if Geting
         then OtherError('предмет уже есть')
         else begin
                Geting:=true;
                GetObj:=pole[Xchud,Ychud+1];
                pole[Xchud,Ychud+1]:=0;
                setcolor(100);
                putimage(32*Xchud-21,32*(Ychud+1)-21,pic[eyes],NormalPut);
                Forw;
              end
    else begin
           OtherError('нечего брать');
           exit;
         end;
  6:if (pole[Xchud-1,Ychud]=1)or(pole[Xchud-1,Ychud] in let)
    then if Geting
         then OtherError('предмет уже есть')
         else begin
                Geting:=true;
                GetObj:=pole[Xchud-1,Ychud];
                pole[Xchud-1,Ychud]:=0;
                setcolor(100);
                putimage(32*(Xchud-1)-21,32*Ychud-21,pic[eyes],NormalPut);
                Forw;
              end
    else begin
           OtherError('нечего брать');
           exit;
         end;
  7:if (pole[Xchud,Ychud-1]=1)or(pole[Xchud,Ychud-1] in let)
    then if Geting
         then OtherError('предмет уже есть')
         else begin
                Geting:=true;
                GetObj:=pole[Xchud,Ychud-1];
                pole[Xchud,Ychud-1]:=0;
                setcolor(100);
                putimage(32*Xchud-21,32*(Ychud-1)-21,pic[eyes],NormalPut);
                Forw;
              end;
    else begin
           OtherError('нечего брать');
           exit;
         end
  end;
end;
procedure Put;
begin
  case eyes of
  2:if not Geting
    then begin
           OtherError('нечего положить');
           exit;
         end
    else if pole[Xchud+1,Ychud]<>0
         then OtherError('некуда положить')
         else begin
                Geting:=false;
                pole[Xchud+1,Ychud]:=GetObj;
                case pole[Xchud+1,Ychud] of
                1:putimage(32*(Xchud+1)-21,32*Ychud-21,pic[1],NormalPut);
                else Letter(Xchud+1,Ychud,chr(GetObj));
                end;
              end;
  5:if not Geting
    then begin
           OtherError('нечего положить');
           exit;
         end
    else if pole[Xchud,Ychud+1]<>0
         then OtherError('некуда положить')
         else begin
                Geting:=false;
                pole[Xchud,Ychud+1]:=GetObj;
                case pole[Xchud,Ychud+1] of
                1:putimage(32*Xchud-21,32*(Ychud+1)-21,pic[1],NormalPut);
                else Letter(Xchud,Ychud+1,chr(GetObj));
                end;
              end;
  6:if not Geting
    then begin
           OtherError('нечего положить');
           exit;
         end
    else if pole[Xchud-1,Ychud]<>0
         then OtherError('некуда положить')
         else begin
                Geting:=false;
                pole[Xchud-1,Ychud]:=GetObj;
                case pole[Xchud-1,Ychud] of
                1:putimage(32*(Xchud-1)-21,32*Ychud-21,pic[1],NormalPut);
                else Letter(Xchud-1,Ychud,chr(GetObj));
                end;
              end;
  7:if not Geting
    then begin
           OtherError('нечего положить');
           exit;
         end
    else if pole[Xchud,Ychud-1]<>0
         then OtherError('некуда положить')
         else begin
                Geting:=false;
                pole[Xchud,Ychud-1]:=GetObj;
                case pole[Xchud,Ychud-1] of
                1:putimage(32*Xchud-21,32*(Ychud-1)-21,pic[1],NormalPut);
                else Letter(Xchud,Ychud-1,chr(GetObj));
                end;
              end;
  end;
end;
procedure Move;
var n:integer;
    _t:integer;
begin
  case eyes of
  2:begin {вправо}
      if Xchud<9
      then begin
             if pole[Xchud+1,Ychud]=0
             then OtherError('нечего передвигать');
             _t:=pole[Xchud+1,Ychud];
             pole[Xchud+1,Ychud]:=0;
             if pole[Xchud+2,Ychud]<>0
             then OtherError('не могу выполнить');
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*(Xchud+1)+10-31,32*Ychud+10-31,32*(Xchud+1)+9,32*Ychud+9);
                 bar(32*(Xchud+2)+10-31,32*Ychud+10-31,32*(Xchud+2)+9,32*Ychud+9);
                 setcolor(0);
                 line(32*Xchud+10,32*Ychud+10-31,32*Xchud+10,32*Ychud+10);
                 line(32*(Xchud+1)+10,32*Ychud+10-31,32*(Xchud+1)+10,32*Ychud+10);
                 setcolor(100);
                 putimage(32*Xchud+10-31+n,32*Ychud+10-31,pic[eyes],NormalPut);
                 putimage(32*(Xchud+1)+10-31+n,32*Ychud+10-31,pic[_t],NormalPut);
                 delay(500);
               end;
             Xchud:=Xchud+1;
             pole[Xchud+1,Ychud]:=_t;
           end
      else OtherError('не могу выполнить');
    end;
  5:begin   {вниз}
      if Ychud<9
      then begin
             if pole[Xchud,Ychud+1]=0
             then OtherError('нечего передвигать');
             _t:=pole[Xchud,Ychud+1];
             if pole[Xchud,Ychud+2]<>0
             then OtherError('не могу выполнить');
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*Xchud+10-31,32*(Ychud+1)+10-31,32*Xchud+9,32*(Ychud+1)+9);
                 bar(32*Xchud+10-31,32*(Ychud+2)+10-31,32*Xchud+9,32*(Ychud+2)+9);
                 setcolor(0);
                 line(32*Xchud+10-31,32*Ychud+10,32*Xchud+9,32*Ychud+10);
                 line(32*Xchud+10-31,32*(Ychud+1)+10,32*Xchud+9,32*(Ychud+1)+10);
                 setcolor(100);
                 putimage(32*Xchud+10-31,32*Ychud+10-31+n,pic[eyes],NormalPut);
                 putimage(32*Xchud+10-31,32*(Ychud+1)+10-31+n,pic[_t],NormalPut);
                 delay(500);
               end;
             Ychud:=Ychud+1;
             pole[Xchud,Ychud+1]:=_t;
           end
      else OtherError('не могу выполнить');
    end;
  6:begin     {влево}
      if Xchud>2
      then begin
             if pole[Xchud-1,Ychud]=0
             then OtherError('нечего передвигать');
             _t:=pole[Xchud-1,Ychud];
             if pole[Xchud-2,Ychud]<>0
             then OtherError('не могу выполнить');
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*(Xchud-1)+10-31,32*Ychud+10-31,32*(Xchud-1)+9,32*Ychud+9);
                 bar(32*(Xchud-2)+10-31,32*Ychud+10-31,32*(Xchud-2)+9,32*Ychud+9);
                 setcolor(0);
                 line(32*Xchud+10-32,32*Ychud+10-31,32*Xchud+10-32,32*Ychud+9);
                 line(32*(Xchud-1)+10-32,32*Ychud+10-31,32*(Xchud-1)+10-32,32*Ychud+9);
                 setcolor(100);
                 putimage(32*Xchud+10-31-n,32*Ychud+10-31,pic[eyes],NormalPut);
                 putimage(32*(Xchud-1)+10-31-n,32*Ychud+10-31,pic[_t],NormalPut);
                 delay(500);
               end;
             Xchud:=Xchud-1;
             pole[Xchud-1,Ychud]:=_t;
           end
      else OtherError('не могу выполнить');
    end;
  7:begin       {вверх}
      if Ychud>2
      then begin
             if pole[Xchud,Ychud-1]=0
             then OtherError('нечего передвигать');
             _t:=pole[Xchud,Ychud-1];
             if pole[Xchud,Ychud-2]<>0
             then OtherError('не могу выполнить');
             for n:=1 to 32 do
               begin
                 bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                 bar(32*Xchud+10-31,32*(Ychud-1)+10-31,32*Xchud+9,32*(Ychud-1)+9);
                 bar(32*Xchud+10-31,32*(Ychud-2)+10-31,32*Xchud+9,32*(Ychud-2)+9);
                 setcolor(0);
                 line(32*Xchud+10-31,32*Ychud+10-32,32*Xchud+9,32*Ychud+10-32);
                 line(32*Xchud+10-31,32*(Ychud-1)+10-32,32*Xchud+9,32*(Ychud-1)+10-32);
                 setcolor(100);
                 putimage(32*Xchud+10-31,32*Ychud+10-31-n,pic[eyes],NormalPut);
                 putimage(32*Xchud+10-31,32*(Ychud-1)+10-31-n,pic[_t],NormalPut);
                 delay(500);
               end;
             Ychud:=Ychud-1;
             pole[Xchud,Ychud-1]:=_t;
           end
      else OtherError('не могу выполнить');
    end;
  end;
end;

procedure WhileDo;
begin
  if (ins^.op1W=nil)and(not ins^.NotPrepW)
  then begin
         case eyes of
         2:if (ins^.whereW='ВПЕРЕДИ')and(Xchud<>10)
           then begin
                  case ins^.operationW of
                  cmEqu:begin
                          while (pole[Xchud+1,Ychud]=ins^.whatW)and(Xchud<9)do
                            ispol(ins^.bodyW);
                          if (Xchud=9)and(pole[Xchud+1,Ychud]=ins^.whatW)
                          then ispol(ins^.bodyW);
                        end;
                  cmNotEqu:begin
                             while (pole[Xchud+1,Ychud]<>ins^.whatW)and(Xchud<9)do
                               ispol(ins^.bodyW);
                             if (Xchud=9)and(pole[Xchud+1,Ychud]<>ins^.whatW)
                             then ispol(ins^.bodyW);
                           end;
                  end;
                end
           else begin
                  if (ins^.whereW='СЛЕВА')and(Ychud<>1)
                  then begin
                         case ins^.operationW of
                         cmEqu:begin
                                 while (pole[Xchud,Ychud-1]=ins^.whatW)and(Ychud>2)do
                                   ispol(ins^.bodyW);
                                 if (Ychud=2)and(pole[Xchud,Ychud-1]=ins^.whatW)
                                 then ispol(ins^.bodyW);
                               end;
                         cmNotEqu:begin
                                    while (pole[Xchud,Ychud-1]<>ins^.whatW)and(Ychud>2)do
                                      ispol(ins^.bodyW);
                                    if (Ychud=2)and(pole[Xchud,Ychud-1]<>ins^.whatW)
                                    then ispol(ins^.bodyW);
                                  end;
                         end;
                       end
                  else begin
                         if (ins^.whereW='СПРАВА')and(Ychud<>10)
                         then begin
                                case ins^.operationW of
                                cmEqu:begin
                                        while (pole[Xchud,Ychud+1]=ins^.whatW)and(Ychud<9)do
                                          ispol(ins^.bodyW);
                                        if (Ychud=9)and(pole[Xchud,Ychud+1]=ins^.whatW)
                                        then ispol(ins^.bodyW);
                                      end;
                                cmNotEqu:begin
                                           while (pole[Xchud,Ychud+1]<>ins^.whatW)and(Ychud<9)do
                                             ispol(ins^.bodyW);
                                           if (Ychud=9)and(pole[Xchud,Ychud+1]<>ins^.whatW)
                                           then ispol(ins^.bodyW);
                                         end;
                                end;
                              end
                       end;
                end;
         5:if (ins^.whereW='ВПЕРЕДИ')and(Ychud<>10)
           then begin
                  case ins^.operationW of
                  cmEqu:begin
                          while (pole[Xchud,Ychud+1]=ins^.whatW)and(Ychud<9)do
                            ispol(ins^.bodyW);
                          if (Ychud=9)and(pole[Xchud,Ychud+1]=ins^.whatW)
                          then ispol(ins^.bodyW);
                        end;
                  cmNotEqu:begin
                             while (pole[Xchud,Ychud+1]<>ins^.whatW)and(Ychud<9)do
                               ispol(ins^.bodyW);
                             if (Ychud=9)and(pole[Xchud,Ychud+1]<>ins^.whatW)
                             then ispol(ins^.bodyW);
                           end;
                  end;
                end
           else begin
                  if (ins^.whereW='СЛЕВА')and(Xchud<>10)
                  then begin
                         case ins^.operationW of
                         cmEqu:begin
                                 while (pole[Xchud+1,Ychud]=ins^.whatW)and(Xchud<9)do
                                   ispol(ins^.bodyW);
                                 if (Xchud=9)and(pole[Xchud+1,Ychud]=ins^.whatW)
                                 then ispol(ins^.bodyW);
                               end;
                         cmNotEqu:begin
                                    while (pole[Xchud+1,Ychud]<>ins^.whatW)and(Xchud<9)do
                                      ispol(ins^.bodyW);
                                    if (Xchud=9)and(pole[Xchud+1,Ychud]<>ins^.whatW)
                                    then ispol(ins^.bodyW);
                                  end;
                         end;
                       end
                  else begin
                         if (ins^.whereW='СПРАВА')and(Xchud<>1)
                         then begin
                                case ins^.operationW of
                                cmEqu:begin
                                        while (pole[Xchud-1,Ychud]=ins^.whatW)and(Xchud>2)do
                                          ispol(ins^.bodyW);
                                        if (Xchud=2)and(pole[Xchud-1,Ychud]=ins^.whatW)
                                        then ispol(ins^.bodyW);
                                      end;
                                cmNotEqu:begin
                                           while (pole[Xchud-1,Ychud]<>ins^.whatW)and(Xchud>2)do
                                             ispol(ins^.bodyW);
                                           if (Xchud=9)and(pole[Xchud-1,Ychud]<>ins^.whatW)
                                           then ispol(ins^.bodyW);
                                         end;
                                end;
                              end
                       end;
                end;
         6:if (ins^.whereW='ВПЕРЕДИ')and(Xchud<>1)
           then begin
                  case ins^.operationW of
                  cmEqu:begin
                          while (pole[Xchud-1,Ychud]=ins^.whatW)and(Xchud>2)do
                            ispol(ins^.bodyW);
                          if (Xchud=2)and(pole[Xchud-1,Ychud]=ins^.whatW)
                          then ispol(ins^.bodyW);
                        end;
                  cmNotEqu:begin
                             while (pole[Xchud-1,Ychud]<>ins^.whatW)and(Xchud>2)do
                               ispol(ins^.bodyW);
                             if (Xchud=2)and(pole[Xchud-1,Ychud]<>ins^.whatW)
                             then ispol(ins^.bodyW);
                           end;
                  end;
                end
           else begin
                  if (ins^.whereW='СЛЕВА')and(Ychud<>10)
                  then begin
                         case ins^.operationW of
                         cmEqu:begin
                                 while (pole[Xchud,Ychud+1]=ins^.whatW)and(Ychud<9)do
                                   ispol(ins^.bodyW);
                                 if (Ychud=9)and(pole[Xchud,Ychud+1]=ins^.whatW)
                                 then ispol(ins^.bodyW);
                               end;
                         cmNotEqu:begin
                                    while (pole[Xchud,Ychud+1]<>ins^.whatW)and(Ychud<9)do
                                      ispol(ins^.bodyW);
                                    if (Ychud=9)and(pole[Xchud,Ychud+1]<>ins^.whatW)
                                    then ispol(ins^.bodyW);
                                  end;
                         end;
                       end
                  else begin
                         if (ins^.whereW='СПРАВА')and(Ychud<>1)
                         then begin
                                case ins^.operationW of
                                cmEqu:begin
                                        while (pole[Xchud,Ychud-1]=ins^.whatW)and(Ychud>2)do
                                          ispol(ins^.bodyW);
                                        if (Ychud=2)and(pole[Xchud,Ychud-1]=ins^.whatW)
                                        then ispol(ins^.bodyW);
                                      end;
                                cmNotEqu:begin
                                           while (pole[Xchud,Ychud-1]<>ins^.whatW)and(Ychud>2)do
                                             ispol(ins^.bodyW);
                                           if (Ychud=2)and(pole[Xchud,Ychud-1]<>ins^.whatW)
                                           then ispol(ins^.bodyW);
                                         end;
                                end;
                              end
                       end;
                end;
         7:if (ins^.whereW='ВПЕРЕДИ')and(Ychud<>1)
           then begin
                  case ins^.operationW of
                  cmEqu:begin
                          while (pole[Xchud,Ychud-1]=ins^.whatW)and(Ychud>2)do
                            ispol(ins^.bodyW);
                          if (Ychud=2)and(pole[Xchud,Ychud-1]=ins^.whatW)
                          then ispol(ins^.bodyW);
                        end;
                  cmNotEqu:begin
                             while (pole[Xchud,Ychud-1]<>ins^.whatW)and(Ychud>2)do
                               ispol(ins^.bodyW);
                             if (Ychud=2)and(pole[Xchud,Ychud-1]<>ins^.whatW)
                             then ispol(ins^.bodyW);
                           end;
                  end;
                end
           else begin
                  if (ins^.whereW='СЛЕВА')and(Xchud<>1)
                  then begin
                         case ins^.operationW of
                         cmEqu:begin
                                 while (pole[Xchud-1,Ychud]=ins^.whatW)and(Xchud>2)do
                                   ispol(ins^.bodyW);
                                 if (Xchud=2)and(pole[Xchud-1,Ychud]=ins^.whatW)
                                 then ispol(ins^.bodyW);
                               end;
                         cmNotEqu:begin
                                    while (pole[Xchud-1,Ychud]<>ins^.whatW)and(Ychud>2)do
                                      ispol(ins^.bodyW);
                                    if (Xchud=2)and(pole[Xchud-1,Ychud]<>ins^.whatW)
                                    then ispol(ins^.bodyW);
                                  end;
                         end;
                       end
                  else begin
                         if (ins^.whereW='СПРАВА')and(Xchud<>10)
                         then begin
                                case ins^.operationW of
                                cmEqu:begin
                                        while (pole[Xchud+1,Ychud]=ins^.whatW)and(Xchud<9)do
                                          ispol(ins^.bodyW);
                                        if (Xchud=9)and(pole[Xchud+1,Ychud]=ins^.whatW)
                                        then ispol(ins^.bodyW);
                                      end;
                                cmNotEqu:begin
                                           while (pole[Xchud+1,Ychud]<>ins^.whatW)and(Xchud<9)do
                                             ispol(ins^.bodyW);
                                           if (Xchud=9)and(pole[Xchud+1,Ychud]<>ins^.whatW)
                                           then ispol(ins^.bodyW);
                                         end;
                                end;
                              end
                       end;
                end;

         end;
       end
  else if ins^.NotPrepW
       then begin
              case eyes of
              2:if Xchud<>10
                then begin
                       while (pole[Xchud+1,Ychud]=0)and(Xchud<9)do
                         ispol(ins^.bodyW);
                       if (Xchud=9)and(pole[Xchud+1,Ychud]=0)
                       then ispol(ins^.bodyW);
                     end;
              5:if Ychud<>10
                then begin
                       while (pole[Xchud,Ychud+1]=0)and(Ychud<9)do
                         ispol(ins^.bodyW);
                       if (Ychud=9)and(pole[Xchud,Ychud+1]=0)
                       then ispol(ins^.bodyW);
                     end;
              6:if Xchud<>1
                then begin
                       while (pole[Xchud-1,Ychud]=0)and(Xchud>2)do
                         ispol(ins^.bodyW);
                       if (Xchud=2)and(pole[Xchud-1,Ychud]=0)
                       then ispol(ins^.bodyW);
                     end;
              7:if Ychud<>1
                then begin
                       while (pole[Xchud,Ychud-1]=0)and(Ychud>2)do
                         ispol(ins^.bodyW);
                       if (Ychud=2)and(pole[Xchud,Ychud-1]=0)
                       then ispol(ins^.bodyW);
                     end;
              end;
            end
       else begin
            end;
end;

procedure IfThenElse;
begin
  if (ins^.op1=nil)and(not ins^.NotPrep)
  then begin
         case eyes of
         2:begin
             if (ins^.where='ВПЕРЕДИ')and(Xchud<>10)
             then begin
                    case ins^.operation of
                    cmEqu:if pole[Xchud+1,Ychud]=ins^.what
                          then ispol(ins^.then_)
                          else if ins^.else_<>nil
                               then ispol(ins^.else_);
                    cmNotEqu:if pole[Xchud+1,Ychud]<>ins^.what
                             then ispol(ins^.then_)
                             else if ins^.else_<>nil
                                  then ispol(ins^.else_);
                    end;
                  end
             else if (ins^.where='СЛЕВА')and(Ychud<>1)
                  then begin
                         case ins^.operation of
                         cmEqu:if pole[Xchud,Ychud-1]=ins^.what
                               then ispol(ins^.then_)
                               else if ins^.else_<>nil
                                    then ispol(ins^.else_);
                         cmNotEqu:if pole[Xchud,Ychud-1]<>ins^.what
                                  then ispol(ins^.then_)
                                  else if ins^.else_<>nil
                                       then ispol(ins^.else_);
                         end;
                       end
                  else if (ins^.where='СПРАВА')and(Ychud<>10)
                       then begin
                              case ins^.operation of
                              cmEqu:if pole[Xchud,Ychud+1]=ins^.what
                                    then ispol(ins^.then_)
                                    else if ins^.else_<>nil
                                         then ispol(ins^.else_);
                              cmNotEqu:if pole[Xchud,Ychud+1]<>ins^.what
                                       then ispol(ins^.then_)
                                       else if ins^.else_<>nil
                                            then ispol(ins^.else_);
                              end;
                            end
                       else OtherError('не могу проверить');
           end;
         5:begin
             if (ins^.where='ВПЕРЕДИ')and(Ychud<>10)
             then begin
                    case ins^.operation of
                    cmEqu:if pole[Xchud,Ychud+1]=ins^.what
                          then ispol(ins^.then_)
                          else if ins^.else_<>nil
                               then ispol(ins^.else_);
                    cmNotEqu:if pole[Xchud,Ychud+1]<>ins^.what
                             then ispol(ins^.then_)
                             else if ins^.else_<>nil
                                  then ispol(ins^.else_);
                    end;
                  end
             else if (ins^.where='СЛЕВА')and(Xchud<>10)
                  then begin
                         case ins^.operation of
                         cmEqu:if pole[Xchud+1,Ychud]=ins^.what
                               then ispol(ins^.then_)
                               else if ins^.else_<>nil
                                    then ispol(ins^.else_);
                         cmNotEqu:if pole[Xchud+1,Ychud]<>ins^.what
                                  then ispol(ins^.then_)
                                  else if ins^.else_<>nil
                                       then ispol(ins^.else_);
                         end;
                       end
                  else if (ins^.where='СПРАВА')and(Xchud<>1)
                       then begin
                              case ins^.operation of
                              cmEqu:if pole[Xchud-1,Ychud]=ins^.what
                                    then ispol(ins^.then_)
                                    else if ins^.else_<>nil
                                         then ispol(ins^.else_);
                              cmNotEqu:if pole[Xchud-1,Ychud]<>ins^.what
                                       then ispol(ins^.then_)
                                       else if ins^.else_<>nil
                                            then ispol(ins^.else_);
                              end;
                            end
                       else OtherError('не могу проверить');
           end;
         6:begin
             if (ins^.where='ВПЕРЕДИ')and(Xchud<>1)
             then begin
                    case ins^.operation of
                    cmEqu:if pole[Xchud-1,Ychud]=ins^.what
                          then ispol(ins^.then_)
                          else if ins^.else_<>nil
                               then ispol(ins^.else_);
                    cmNotEqu:if pole[Xchud-1,Ychud]<>ins^.what
                             then ispol(ins^.then_)
                             else if ins^.else_<>nil
                                  then ispol(ins^.else_);
                    end;
                  end
             else if (ins^.where='СЛЕВА')and(Ychud<>10)
                  then begin
                         case ins^.operation of
                         cmEqu:if pole[Xchud,Ychud+1]=ins^.what
                               then ispol(ins^.then_)
                               else if ins^.else_<>nil
                                    then ispol(ins^.else_);
                         cmNotEqu:if pole[Xchud,Ychud+1]<>ins^.what
                                  then ispol(ins^.then_)
                                  else if ins^.else_<>nil
                                       then ispol(ins^.else_);
                         end;
                       end
                  else if (ins^.where='СПРАВА')and(Ychud<>1)
                       then begin
                              case ins^.operation of
                              cmEqu:if pole[Xchud,Ychud-1]=ins^.what
                                    then ispol(ins^.then_)
                                    else if ins^.else_<>nil
                                         then ispol(ins^.else_);
                              cmNotEqu:if pole[Xchud,Ychud-1]<>ins^.what
                                       then ispol(ins^.then_)
                                       else if ins^.else_<>nil
                                            then ispol(ins^.else_);
                              end;
                            end
                       else OtherError('не могу проверить');
           end;
         7:begin
             if (ins^.where='ВПЕРЕДИ')and(Ychud<>1)
             then begin
                    case ins^.operation of
                    cmEqu:if pole[Xchud,Ychud-1]=ins^.what
                          then ispol(ins^.then_)
                          else if ins^.else_<>nil
                               then ispol(ins^.else_);
                    cmNotEqu:if pole[Xchud,Ychud-1]<>ins^.what
                             then ispol(ins^.then_)
                             else if ins^.else_<>nil
                                  then ispol(ins^.else_);
                    end;
                  end
             else if (ins^.where='СЛЕВА')and(Xchud<>1)
                  then begin
                         case ins^.operation of
                         cmEqu:if pole[Xchud-1,Ychud]=ins^.what
                               then ispol(ins^.then_)
                               else if ins^.else_<>nil
                                    then ispol(ins^.else_);
                         cmNotEqu:if pole[Xchud-1,Ychud]<>ins^.what
                                  then ispol(ins^.then_)
                                  else if ins^.else_<>nil
                                       then ispol(ins^.else_);
                         end;
                       end
                  else if (ins^.where='СПРАВА')and(Xchud<>10)
                       then begin
                              case ins^.operation of
                              cmEqu:if pole[Xchud+1,Ychud]=ins^.what
                                    then ispol(ins^.then_)
                                    else if ins^.else_<>nil
                                         then ispol(ins^.else_);
                              cmNotEqu:if pole[Xchud+1,Ychud]<>ins^.what
                                       then ispol(ins^.then_)
                                       else if ins^.else_<>nil
                                            then ispol(ins^.else_);
                              end;
                            end
                       else OtherError('не могу проверить');
           end;
         end;
       end
  else if ins^.NotPrep
       then begin
              case eyes of
              2:if Xchud=10
                then ispol(ins^.else_)
                else if pole[Xchud+1,Ychud]=0
                     then ispol(ins^.then_)
                     else if ins^.else_<>nil
                          then ispol(ins^.else_);
              5:if Ychud=10
                then ispol(ins^.else_)
                else if pole[Xchud,Ychud+1]=0
                     then ispol(ins^.then_)
                     else if ins^.else_<>nil
                          then ispol(ins^.else_);
              6:if Xchud=1
                then ispol(ins^.else_)
                else if pole[Xchud-1,Ychud]=0
                     then ispol(ins^.then_)
                     else if ins^.else_<>nil
                          then ispol(ins^.else_);
              7:if Ychud=1
                then ispol(ins^.else_)
                else if pole[Xchud,Ychud-1]=0
                     then ispol(ins^.then_)
                     else if ins^.else_<>nil
                          then ispol(ins^.else_);
              end;
            end
       else begin    {cmMore,cmLess,cmEqu,cmMoreEqu,cmLessEqu}
              case ins^.operation of
              cmMore:begin
                       if (ins^.op1^.f)and(ins^.op2^.f)
                       then begin
                              if (ins^.op1^.i)>(ins^.op2^.i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                       if (not(ins^.op1^.f))and(ins^.op2^.f)
                       then begin
                              if (MainVar[ins^.op1^.p].i)>(ins^.op2^.i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                       if (ins^.op1^.f)and(not(ins^.op2^.f))
                       then begin
                              if (ins^.op1^.i)>(MainVar[ins^.op2^.p].i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                       if (not(ins^.op1^.f))and(not(ins^.op2^.f))
                       then begin
                              if (MainVar[ins^.op1^.p].i)>(MainVar[ins^.op2^.p].i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                     end;
              cmLess:begin
                       if (ins^.op1^.f)and(ins^.op2^.f)
                       then begin
                              if (ins^.op1^.i)<(ins^.op2^.i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                       if (not(ins^.op1^.f))and(ins^.op2^.f)
                       then begin
                              if (MainVar[ins^.op1^.p].i)<(ins^.op2^.i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                       if (ins^.op1^.f)and(not(ins^.op2^.f))
                       then begin
                              if (ins^.op1^.i)<(MainVar[ins^.op2^.p].i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                       if (not(ins^.op1^.f))and(not(ins^.op2^.f))
                       then begin
                              if (MainVar[ins^.op1^.p].i)<(MainVar[ins^.op2^.p].i)
                              then ispol(ins^.then_)
                              else ispol(ins^.else_);
                            end;
                     end;
              cmEqu:begin
                      if (ins^.op1^.f)and(ins^.op2^.f)
                      then begin
                             if (ins^.op1^.i)=(ins^.op2^.i)
                             then ispol(ins^.then_)
                             else ispol(ins^.else_);
                           end;
                      if (not(ins^.op1^.f))and(ins^.op2^.f)
                      then begin
                             if (MainVar[ins^.op1^.p].i)=(ins^.op2^.i)
                             then ispol(ins^.then_)
                             else ispol(ins^.else_);
                           end;
                      if (ins^.op1^.f)and(not(ins^.op2^.f))
                      then begin
                             if (ins^.op1^.i)=(MainVar[ins^.op2^.p].i)
                             then ispol(ins^.then_)
                             else ispol(ins^.else_);
                           end;
                      if (not(ins^.op1^.f))and(not(ins^.op2^.f))
                      then begin
                             if (MainVar[ins^.op1^.p].i)=(MainVar[ins^.op2^.p].i)
                             then ispol(ins^.then_)
                             else ispol(ins^.else_);
                           end;
                     end;
              cmNotEqu:begin
                         if (ins^.op1^.f)and(ins^.op2^.f)
                         then begin
                                if (ins^.op1^.i)<>(ins^.op2^.i)
                                then ispol(ins^.then_)
                                else ispol(ins^.else_);
                              end;
                         if (not(ins^.op1^.f))and(ins^.op2^.f)
                         then begin
                                if (MainVar[ins^.op1^.p].i)<>(ins^.op2^.i)
                                then ispol(ins^.then_)
                                else ispol(ins^.else_);
                              end;
                         if (ins^.op1^.f)and(not(ins^.op2^.f))
                         then begin
                                if (ins^.op1^.i)<>(MainVar[ins^.op2^.p].i)
                                then ispol(ins^.then_)
                                else ispol(ins^.else_);
                              end;
                         if (not(ins^.op1^.f))and(not(ins^.op2^.f))
                         then begin
                                if (MainVar[ins^.op1^.p].i)<>(MainVar[ins^.op2^.p].i)
                                then ispol(ins^.then_)
                                else ispol(ins^.else_);
                              end;
                     end;
              cmMoreEqu:begin
                          if (ins^.op1^.f)and(ins^.op2^.f)
                          then begin
                                 if (ins^.op1^.i)>=(ins^.op2^.i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                          if (not(ins^.op1^.f))and(ins^.op2^.f)
                          then begin
                                 if (MainVar[ins^.op1^.p].i)>=(ins^.op2^.i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                          if (ins^.op1^.f)and(not(ins^.op2^.f))
                          then begin
                                 if (ins^.op1^.i)>=(MainVar[ins^.op2^.p].i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                          if (not(ins^.op1^.f))and(not(ins^.op2^.f))
                          then begin
                                 if (MainVar[ins^.op1^.p].i)>=(MainVar[ins^.op2^.p].i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                     end;
              cmLessEqu:begin
                          if (ins^.op1^.f)and(ins^.op2^.f)
                          then begin
                                 if (ins^.op1^.i)<=(ins^.op2^.i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                          if (not(ins^.op1^.f))and(ins^.op2^.f)
                          then begin
                                 if (MainVar[ins^.op1^.p].i)<=(ins^.op2^.i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                          if (ins^.op1^.f)and(not(ins^.op2^.f))
                          then begin
                                 if (ins^.op1^.i)<=(MainVar[ins^.op2^.p].i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                          if (not(ins^.op1^.f))and(not(ins^.op2^.f))
                          then begin
                                 if (MainVar[ins^.op1^.p].i)<=(MainVar[ins^.op2^.p].i)
                                 then ispol(ins^.then_)
                                 else ispol(ins^.else_);
                               end;
                     end;
              end;
            end;
end;
procedure Assing;
begin
  case ins^.TypAss of
  cmInteg:MainVar[seek(ins^.name)].i:=PopIntegStrInPol(ins^.WhatAssign);
  cmChar:;
  cmString:;
  end;
end;

begin
  ins:=ins^.next;
  while ins<>nil do
    begin
      bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
      case ins^.typ of
      cmRight:begin
                Right;
              end;
      cmLeft:begin
               Left;
             end;
      cmForw:begin
               Forw;
             end;
      cmFor:begin
              Fo;
            end;
      cmWhile:begin
                WhileDo;
              end;
      cmIf:begin
             IfThenElse;
           end;
      cmGet:begin
              Get;
            end;
      cmPut:begin
              Put;
            end;
      cmMove:begin
               Move;
             end;
      cmIdent:begin
                Assing;
              end;
      end;
      putimage(32*Xchud-21,32*ychud-21,pic[eyes],NormalPut);
      ins:=ins^.next;
      delay(5000);
    end;
end;
{==============================}
procedure InitLoadFile;
begin
  new(sLoad);
  sLoad^.next:=nil;
  sLoad^.prev:=nil;
  sLoad^.name:='. .';
  NowLoad:=sLoad;
  NachLoad:=sLoad;
end;

procedure AddNewName(name:str_15);
var q:pLoad;
begin
  new(q);
  q^.prev:=NowLoad;
  q^.next:=NowLoad^.next;
  NowLoad^.next:=q;
  NowLoad:=NowLoad^.next;
  NowLoad^.name:=name;
end;

procedure LoadNameFile;
Var DirInfo:SearchRec;
Begin
  FindFirst('*.prg',faArchive,DirInfo);
  While DosError = 0 Do
    Begin
      AddNewName(DirInfo.name);
      FindNext(DirInfo);
    End;
  FindFirst('*.foc',faArchive,DirInfo);
  While DosError = 0 Do
    Begin
      AddNewName(DirInfo.name);
      FindNext(DirInfo);
    End;
  NowLoad:=sLoad;
end;

procedure WriteLoadName(p:pLoad);
var i,y:integer;
begin
  y:=150;
  setcolor(14);
  i:=1;
  while (i<=5)and(p<>nil)do
    begin
      outtextxy(230,y,p^.name);
      p:=p^.next;
      y:=y+15;
      inc(i);
    end;
  i:=1;y:=150;
  while (i<=5)and(p<>nil)do
    begin
      outtextxy(345,y,p^.name);
      p:=p^.next;
      y:=y+15;
      inc(i);
    end;
end;

procedure load_prog;
var ras:string[3];
    xLoad,yLoad,i:integer;
    f:boolean;
begin
  drawwindow(180,70,490,310);
  rectangle(190,80,480,300,15,0);
  drawwindow(210,250,310,290);
  rectangle(220,260,300,280,15,0);
  drawwindow(355,250,440,290);
  rectangle(365,260,430,280,15,0);
  setcolor(0);
  bar(330,99,450,116);
  bar(220,140,450,236);
  setcolor(15);
  line(335,150,335,226);
  setcolor(14);
  outtextxy(210,125,'Файлы:   ');
  outtextxy(200,100,'  Загрузить ...');
  outtextxy(225,262,'Загрузить');
  outtextxy(374,262,'Отмена');
  InitLoadFile;
  LoadNameFile;
  WriteLoadName(NowLoad);
  xload:=330;
  yLoad:=150;
  NLoad:='';
  f:=false;
  Fload:=false;
  refresh:=false;
  showmouse;
  repeat
    if keypressed
    then begin
           code:=readkey;
           case code of
           'a'..'z',
           '0'..'9',
                '.':begin
                      setcolor(14);
                      outtextxy(Xload,99,code);
                      Nload:=Nload+code;
                      Xload:=Xload+8;
                    end;
           #8:begin
                if Xload>330
                then begin
                       setcolor(0);
                       bar(Xload-8,99,Xload,116);
                       Xload:=Xload-8;
                       delete(Nload,length(Nload),1);
                     end;
              end;
           #9:begin
                setcolor(12);
                xLoad:=230;
                f:=true;
                outtextxy(xLoad,yLoad,NowLoad^.name);
              end;
           #80:begin
                 if (NowLoad^.next<>nil)and(f)
                 then begin
                        setcolor(14);
                        outtextxy(xLoad,yLoad,NowLoad^.name);
                        if (xLoad=345)and(yLoad=210)
                        then begin
                               for i:=1 to 5 do
                                 NachLoad:=NachLoad^.next;
                               setcolor(0);
                               bar(220,140,450,236);
                               setcolor(15);
                               line(335,150,335,226);
                               WriteLoadName(NachLoad);
                               yLoad:=150;
                               NowLoad:=NowLoad^.next;
                               setcolor(12);
                               outtextxy(xLoad,yLoad,NowLoad^.name);
                             end
                        else if (xLoad=230)and(yLoad=210)
                             then begin
                                    xLoad:=345;yLoad:=150;
                                    NowLoad:=NowLoad^.next;
                                    setcolor(12);
                                    outtextxy(xLoad,yLoad,NowLoad^.name);
                                  end
                             else begin
                                    yLoad:=yLoad+15;
                                    NowLoad:=NowLoad^.next;
                                    setcolor(12);
                                    outtextxy(xLoad,yLoad,NowLoad^.name);
                                  end;
                      end;
                 Nload:=NowLoad^.name;
                 setcolor(0);
                 bar(330,99,450,116);
                 setcolor(14);
                 outtextxy(330,99,NowLoad^.name);
               end;
           #72:begin
                 if (NowLoad^.prev<>nil)and(f)
                 then begin
                        setcolor(14);
                        outtextxy(xLoad,yLoad,NowLoad^.name);
                        if (xLoad=230)and(yLoad=150)
                        then begin
                               for i:=1 to 5 do
                                 NachLoad:=NachLoad^.prev;
                               setcolor(0);
                               bar(220,140,450,236);
                               setcolor(15);
                               line(335,150,335,226);
                               WriteLoadName(NachLoad);
                               yLoad:=210;
                               NowLoad:=NowLoad^.prev;
                               setcolor(12);
                               outtextxy(xLoad,yLoad,NowLoad^.name);
                             end
                        else if (yLoad=150)and(xLoad=345)
                             then begin
                                    xLoad:=230;yLoad:=210;
                                    NowLoad:=NowLoad^.prev;
                                    setcolor(12);
                                    outtextxy(xLoad,yLoad,NowLoad^.name);
                                  end
                             else begin
                                    NowLoad:=NowLoad^.prev;
                                    yLoad:=yLoad-15;
                                    setcolor(12);
                                    outtextxy(xLoad,yLoad,NowLoad^.name);
                                  end;
                      end;
                 Nload:=NowLoad^.name;
                 setcolor(0);
                 bar(330,99,450,116);
                 setcolor(14);
                 outtextxy(330,99,NowLoad^.name);
               end;
           end;
         end;
    if MouseButton=LeftButton
    then begin
           if MouseIn(220,260,300,280)
           then begin
                  Fload:=true;
                  hidemouse;
                  rectangle(220,260,300,280,0,15);
                  showmouse;
                  repeat
                  until MouseButton<>LeftButton;
                end;
           if MouseIn(365,260,430,280)
           then begin
                  refresh:=true;
                  hidemouse;
                  rectangle(365,260,430,280,0,15);
                  showmouse;
                  repeat
                  until MouseButton<>LeftButton;
                end;
         end;
  until (refresh)or(Fload);
  hidemouse;
  _refresh_;
  posX:=1;
  posY:=1;
  setcolor(14);
  outtextxy(358+(posX-1)*8,10+(posY-1)*15,'_');
  cursor:=beg^.next;
  code:=#0;
  if Fload
  then begin
         ras:=copy(Nload,length(Nload)-2,3);
         if (ras='prg')or(ras='PRG')
         then begin
                ReadFileProg(Nload);
                cursor:=beg^.next;
                nach:=cursor;
                posX:=1;posY:=1;
              end
         else if (ras='foc')or(ras='FOC')
              then begin
                     PutXYPole;
                     ReadFilePole(Nload);
                     WriteTextprog(Nach,10);
                   end
              else begin
                     WriteTextprog(beg^.next,10);
                     cursor:=beg^.next;
                     outtextxy(360,10,'_');
                   end;
       end
  else begin
         WriteTextprog(beg^.next,10);
         cursor:=beg^.next;
         outtextxy(360,10,'_');
       end;
end;

procedure WriteCursor;
begin
  setcolor(CurColor);
  outtextxy(358+(posX-1)*8,10+(posY-offset-1)*15,'_');
end;

procedure DelCursor;
begin
  setcolor(80);
  outtextxy(358+(posX-1)*8,10+(posY-offset-1)*15,'_');
end;

procedure SimpleChar(c:char);
begin
  if posX=32
  then begin
         delete(cursor^.strok,32,1);
         cursor^.strok:=cursor^.strok+c;
         setcolor(80);
         bar(358+(posX-1)*8,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
         WriteCursor;
         setcolor(14);
         outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
       end
  else if length(cursor^.strok)<32
       then begin
              ins(posX,c);
              DelCursor;
              setcolor(80);
              bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
              posX:=posX+1;
              WriteCursor;
              setcolor(14);
              outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
            end;
end;
procedure BackSpace;
var s:string;
begin
  if posX=1
  then begin
         if posY<>1
         then begin
                s:=cursor^.strok;
                if cursor=nach
                then begin
                       nach:=nach^.prev;
                       offset:=offset-1;
                     end;
                DelCursor;
                DelBefore(cursor);
                posX:=length(cursor^.strok)+1;
                posY:=posY-1;
                cursor^.strok:=cursor^.strok+s;
                setcolor(80);
                bar(358,10,630,430);
                rectangle(357,9,629,431,15,15);
                WriteCursor;
                WriteTextProg(nach,10);
              end
       end
  else begin
         DelCursor;
         delete(cursor^.strok,posX-1,1);
         setcolor(80);
         bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
         posX:=posX-1;
         WriteCursor;
         setcolor(14);
         outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
       end;
end;

procedure Tab;
var tz:tbeg;
    k:integer;
begin
  if posY<>1
  then begin
         tz:=cursor^.prev;
         k:=posX;
         while tz^.strok[k]=' ' do
           inc(k);
         if k<>posX
         then begin
                DelCursor;
                posX:=k;
                cursor^.strok:=copy(tz^.strok,1,k-1)+cursor^.strok;
                setcolor(80);
                bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
                WriteCursor;
                setcolor(14);
                outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
              end
         else if length(cursor^.strok)<28
              then begin
                     DelCursor;
                     cursor^.strok:=copy(cursor^.strok,1,posX-1)+'    '+copy(cursor^.strok,posX,length(cursor^.strok)-posX);
                     posX:=posX+4;
                     setcolor(80);
                     bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
                     setcolor(14);
                     outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
                     WriteCursor;
                   end;
      end
  else begin
         if length(cursor^.strok)<28
         then begin
                DelCursor;
                cursor^.strok:=copy(cursor^.strok,1,posX-1)+'    '+copy(cursor^.strok,posX,length(cursor^.strok)-posX);
                posX:=posX+4;
                WriteCursor;
              end;
       end;
end;

procedure Left;
begin
  if posX<>1
  then begin
         if posX>length(cursor^.strok)+1
         then begin
                DelCursor;
                delete(cursor^.strok,length(cursor^.strok),1);
                posX:=posX-1;
                WriteCursor;
                outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
              end
         else begin
                DelCursor;
                posX:=posX-1;
                WriteCursor;
                outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
              end;
      end;
end;

procedure Right;
begin
  if posX<>32
  then begin
         if posX>length(cursor^.strok)
         then begin
                DelCursor;
                cursor^.strok:=cursor^.strok+' ';
                posX:=posX+1;
                WriteCursor;
                outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
              end
         else begin
                DelCursor;
                posX:=posX+1;
                WriteCursor;
                outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
              end;
       end;
end;

procedure Up;
var k:integer;
begin
  if posY-offset<>1
  then begin
         k:=length(cursor^.strok);
         while cursor^.strok[k]=' 'do
           begin
             delete(cursor^.strok,k,length(cursor^.strok)-k+1);
             dec(k);
           end;
         DelCursor;
         setcolor(14);
         k:=length(cursor^.strok);
         outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
         if length(cursor^.strok)>length(cursor^.prev^.strok)
         then while length(cursor^.strok)>length(cursor^.prev^.strok)do
                cursor^.prev^.strok:=cursor^.prev^.strok+' ';
         cursor:=cursor^.prev;
         posY:=posY-1;
         WriteCursor;
         outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
       end
  else if posY<>1
       then begin
              k:=length(cursor^.strok);
              while cursor^.strok[k]=' 'do
                begin
                  delete(cursor^.strok,k,length(cursor^.strok)-k+1);
                  dec(k);
                end;
              nach:=nach^.prev;
              offset:=offset-1;
              cursor:=cursor^.prev;
              posY:=posY-1;
              setcolor(80);
              bar(358,11,629,430);
              WriteTextProg(nach,10);
              WriteCursor;
            end;
end;

procedure Down;
var k:integer;
begin
  if cursor^.next<>nil
  then begin
         k:=length(cursor^.strok);
         while cursor^.strok[k]=' 'do
           begin
             delete(cursor^.strok,k,length(cursor^.strok)-k+1);
             dec(k);
           end;
         DelCursor;
         setcolor(14);
         outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
         if length(cursor^.strok)>length(cursor^.next^.strok)
         then while length(cursor^.strok)>length(cursor^.next^.strok)do
                cursor^.next^.strok:=cursor^.next^.strok+' ';
         cursor:=cursor^.next;
         posY:=posY+1;
         if posY-offset>28
         then begin
                nach:=nach^.next;
                offset:=offset+1;
                setcolor(80);
                bar(358,11,629,430);
                WriteTextProg(nach,10);
                WriteCursor;
              end
         else begin
                WriteCursor;
                outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
              end;
       end;
end;

procedure Home;
begin
  DelCursor;
  posX:=1;
  WriteCursor;
  outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
end;

procedure _End_;
var k:integer;
begin
  k:=length(cursor^.strok);
  while cursor^.strok[k]=' 'do
    begin
      delete(cursor^.strok,k,length(cursor^.strok)-k+1);
      dec(k);
    end;
  DelCursor;
  if length(cursor^.strok)=32
  then posX:=32
  else posX:=length(cursor^.strok)+1;
  WriteCursor;
  outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
end;

procedure Delete_;
begin
  DelCursor;
  del(posX);
  setcolor(80);
  bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
  WriteCursor;
  outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
end;

procedure Ctrl_Y;
begin
  if cursor^.next<>nil
  then begin
         DelCursor;
         if cursor=nach
         then nach:=nach^.next;
         DelAfter;
         setcolor(80);
         bar(358,10+(posY-offset-1)*15,628,430);
         WriteTextProg(nach,10);
         posX:=1;
         WriteCursor;
       end
  else begin
         DelCursor;
         cursor^.strok:='';
         posX:=1;
         setcolor(80);
         bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
         WriteTextProg(nach,10);
         WriteCursor;
       end;
end;

procedure Enter;
var s:string;
begin
  DelCursor;
  s:=copy(cursor^.strok,posX,length(cursor^.strok));
  delete(cursor^.strok,posX,length(cursor^.strok));
  setcolor(80);
  bar(358,10+(posY-offset-1)*15,628,24+(posY-offset-1)*15);
  outtextxy(358,10+(posY-offset-1)*15,cursor^.strok);
  InsAfter(cursor);
  cursor^.strok:=s;
  if posY-offset>28
  then begin
         nach:=nach^.next;
         offset:=offset+1;
         bar(358,11,629,430);
         WriteTextProg(nach,10);
       end
  else begin
         setcolor(80);
         bar(358,10+(posY-1)*15,628,430);
         WriteTextProg(nach,10);
       end;
  WriteCursor;
end;

procedure Initprog;
begin
  new(beg);
  new(beg^.next);
  beg^.next^.next:=nil;
  beg^.prev:=nil;
  beg^.strok:='';
  cursor:=beg^.next;
  cursor^.prev:=beg^.next;
  cursor^.strok:='';
end;

procedure redak;
label _ret;
var st:integer;
begin
  setcolor(14);
  InitProg;
{  ReadFileProg('while.prg');}
  cursor:=beg^.next;
  nach:=cursor;
  posX:=1;posY:=1;
  offset:=0;
  CurColor:=14;
  WriteCursor;
  repeat
    if keypressed
    then begin
           code:=readkey;
           case code of
           #33..#59,
           #61,' ',
           #60,#62,
           #68..#70,
           #81..#82,
           #84..#126,
           #128..#175,
           #224..#239:SimpleChar(code); {очередной символ}
                   #8:BackSpace;        {BackSpace}
                   #9:Tab;              {Tab}
                   #75:Left;            {влево}
                   #77:Right;           {вправо}
                   #71:Home;            {Home}
                   #79:_End_;           {End}
                   #72:Up;              {вверх}
                   #80:Down;            {вниз}
                   #83:Delete_;         {delete}
                   #13:Enter;           {Enter}
                   #25:Ctrl_Y;          {Ctrl+Y}
                   #27:begin            {Esc}
                         exit_prog;
                         WriteTextProg(beg^.next,10);
                         posX:=1;
                         posY:=1;
                         offset:=0;
                         WriteCursor;
                         cursor:=beg^.next;
                       end;
                   #63:begin            {F5}
                         PutXYPole;
                         WriteObjectsPole;
                         RedactorPole;
                       end;
                   #65:begin
                         save_prog;
                         WriteTextProg(beg^.next,10);
                         posX:=1;
                         posY:=1;
                         offset:=0;
                         WriteCursor;
                         cursor:=beg^.next;
                       end;
                   #66:begin
                         asm
                            mov Sbp,bp
                            mov Ssp,sp
                            mov Ses,es
                            mov Ssi,si
                            mov Sdi,di
                            mov AddrRet,offset _Ret
                         end;
                         load_prog;
                       end;
                   #67:begin
                         WriteFileProg('swap.swp');
                         seekchud;
                         asm
                            mov Sbp,bp
                            mov Ssp,sp
                            mov Ses,es
                            mov Ssi,si
                            mov Sdi,di
                            mov AddrRet,offset _Ret
                         end;
                         DelCursor;
                         compiler;
                         eyes:=2;
                         pole[Xchud,Ychud]:=0;
                         Geting:=false;
                         setcolor(100);
                         ispol(first);
                         EndProg('Программа выполнена!!!');
                         repeat
                         until keypressed;
_Ret:                    setcolor(100);
                         bar(32*Xchud+10-31,32*Ychud+10-31,32*Xchud+9,32*Ychud+9);
                         putimage(32*Xchud-21,32*ychud-21,pic[2],NormalPut);
                       end
           end;
         end;
  until (f_exit);
end;

begin
  InitAll(M640x480);
  InitHiMem;
  SetMousePosition(320,240);
  assign(prog,'swap.swp');
  rewrite(prog);
  close(prog);
  LoadAllSprite;
  _refresh_;
  ex:=0;
  redak;
  DoneHiMem;
  DoneAll;
end.
