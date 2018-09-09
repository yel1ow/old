unit supervga;

interface
uses dos;

type
  str10=string[10];

  mmods=(_text,
         _text2,
         _text4,
         _pl2 ,   {plain mono, 8 pixels per byte}
         _pl2e,   {mono odd/even, 8 pixels per byte, two planes}
         _herc,   {Hercules mono, 4 "banks" of 8kbytes}
         _cga2,   {CGA 2 color, 2 "banks" of 16kbytes}
         _cga4,   {CGA 4 color, 2 "banks" of 16kbytes}
         _pl4 ,   {4 color odd/even planes}
         _pk4 ,   {4 color "packed" pixels 4 pixels per byte}
         _pl16,   {std EGA/VGA 16 color: 4 planes, 8 pixels per byte}
         _pk16,   {ATI mode 65h two 16 color pixels per byte}
         _p256,   {one 256 color pixel per byte}
         _p32k,   {Sierra 15 bit}
         _p64k,   {Sierra 16bit/XGA}
         _p16m);  {RGB 3bytes per pixel}

  modetype=record
             md,xres,yres,bytes:word;
             memmode:mmods;
           end;

  CHIPS=(__EGA,__VGA,__chips451,__chips452,__chips453,__paradise,__video7
        ,__tseng3,__tseng4,__tridBR,__tridCS,__trid89,__everex,__ati1,__ati2
        ,__genoa,__oak,__cirrus,__aheadA,__aheadB,__ncr,__yamaha,__poach
        ,__s3,__al2101,__acumos,__mxic,__vesa,__realtek,__p2000,__cirrus54
        ,__none);


const
  colbits:array[mmods] of integer=
               (0,0,0,1,1,1,1,2,2,2,4,4,8,15,16,24);
  modecols:array[mmods] of longint=
               (0,0,0,2,2,2,2,4,4,4,16,16,256,32768,65536,16777216);

  mdtxt:array[mmods] of string[210]=('Text','2 color Text','4 color Text'
                ,'Monochrome','2 colors planar','Hercules','CGA 2 color','CGA 4 color'
                ,'4 colors planar','4 colors packed','16 colors planar','16 colors packed'
                ,'256 colors packed','32768 colors','65536 colors'
                ,'16777216 colors');

  mmodenames:array[mmods] of string[4]=('TXT ','TXT2','TXT4','PL2 ','PL2E','HERC'
              ,'CGA2','CGA4','PL4 ','PK4 ','PL16','PK16','P256','P32K','P64K','P16M');


  header:array[CHIPS] of string[14]=
         ('EGA','VGA','Chips&Tech','Chips&Tech','Chips&Tech'
         ,'Paradise','Video7','ET3000','ET4000'
         ,'Trident','Trident','Trident','Everex','ATI','ATI'
         ,'Genoa','Oak','Cirrus','Ahead','Ahead','NCR'
         ,'Yamaha','Poach','S3','AL2101','Acumos','MXIC'
         ,'VESA','Realtek','PRIMUS','Cirrus54','');


  novgamodes=10;
  stdmodetbl:array[1..novgamodes] of modetype=
            ((md: 4;xres:320;yres:200;bytes: 80;memmode:_cga4)
            ,(md: 5;xres:320;yres:200;bytes: 80;memmode:_cga4)
            ,(md: 6;xres:640;yres:200;bytes: 80;memmode:_cga2)
            ,(md:13;xres:320;yres:200;bytes: 40;memmode:_pl16)
            ,(md:14;xres:640;yres:200;bytes: 80;memmode:_pl16)
            ,(md:15;xres:640;yres:350;bytes: 80;memmode:_pl2)
            ,(md:16;xres:640;yres:350;bytes: 80;memmode:_pl16)
            ,(md:17;xres:640;yres:480;bytes: 80;memmode:_pl2)
            ,(md:18;xres:640;yres:480;bytes: 80;memmode:_pl16)
            ,(md:19;xres:320;yres:200;bytes:320;memmode:_p256));



  _dac0     =0;   {No DAC (MDA/CGA/EGA ..}
  _dac8     =1;   {Std VGA DAC 256 cols.}
  _dac15    =2;   {Sierra 32k DAC}
  _dac16    =3;   {Sierra 64k DAC}
  _dacss24  =4;   {Sierra?? 24bit RGB DAC}
  _dacatt   =5;   {ATT 20c491/2  15/16/24 bit DAC}
  _dacADAC1 =6;   {Acumos ADAC1  15/16/24 bit DAC}




  vesa:word=0;



var
  rp:registers;

  memmode:mmods;   {current memory mode}
  vseg:word;       {Video buffer base segment}
  video:string[5];
  mm:word;         {Video memory in kilobytes}
  CHIP:CHIPS;
  dacname:string[20];
  dactype:word;
  crtc:word;       {I/O address of CRTC registers}
  _crt:string[20];
  secondary:string[20];
  extra:string[80];
  name:string[40];

  curmode:word;    {Current mode number}
  pixels:word;     {Pixels in a scanline in current mode}
  lins:word;       {lines in current mode}
  bytes:longint;   {bytes in a scanline}
  planes:word;     {number of video planes}


  nomodes:word;
  modetbl:array[1..30] of modetype;


  vesarec:record
            attr:word;
            wina,winb:byte;
            gran,winsiz,sega,segb:word;
            pagefunc:pointer;
            bytes,width,height:word;
            charw,charh,planes,bits,nbanks,model,banks:byte;
            x:array[byte] of byte;    {might get trashed by 4F01h}
          end;


  dotest:array[CHIPS] of boolean;





function strip(s:string):string;       {strip leading and trailing spaces}
function upstr(s:string):string;       {convert a string to upper case}
function istr(w:longint):str10;
function hex2(w:word):str10;
function hex4(w:word):str10;


procedure vio(ax:word);         {INT 10h reg ax=AX. other reg. set from RP
                                 on return rp.ax=reg AX}

function inp(reg:word):byte;     {Reads a byte from I/O port REG}

procedure outp(reg,val:word);    {Write the low byte of VAL to I/O port REG}

function rdinx(pt,inx:word):word;       {read register PT index INX}

procedure wrinx(pt,inx,val:word);       {write VAL to register PT index INX}

procedure modinx(pt,inx,mask,nwv:word);  {In register PT index INX sets
                                          the bits in MASK as in NWV
                                          the other are left unchanged}

procedure setbank(bank:word);

procedure setvstart(l:longint);       {Set the display start address}

function setmode(md:word):boolean;

procedure vesamodeinfo(md:word);

procedure dactocomm;

procedure dactopel;

procedure findvideo;


implementation


const
  mmmask :array[0..8] of byte=(0,0,0,0,1,3,3,7,15);

  hx:array[0..15] of char='0123456789ABCDEF';






var

  atireg:word;    {ATI extended registers}

  old,curbank:word;

  biosseg:word;
  vgran:word;



function strip(s:string):string;       {strip leading and trailing spaces}
begin
  while s[length(s)]=' ' do dec(s[0]);
  while copy(s,1,1)=' ' do delete(s,1,1);
  strip:=s;
end;

function upstr(s:string):string;       {convert a string to upper case}
var x:word;
begin
  for x:=1 to length(s) do
    s[x]:=upcase(s[x]);
  upstr:=s;
end;

function istr(w:longint):str10;
var s:str10;
begin
  str(w,s);
  istr:=s;
end;

function hex2(w:word):str10;
begin
  hex2:=hx[(w shr 4) and 15]+hx[w and 15];
end;

function hex4(w:word):str10;
begin
  hex4:=hex2(hi(w))+hex2(lo(w));
end;



procedure vio(ax:word);         {INT 10h reg ax=AX. other reg. set from RP
                                 on return rp.ax=reg AX}
begin
  rp.ax:=ax;
  intr(16,rp);
end;

function inp(reg:word):byte;     {Reads a byte from I/O port REG}
begin
  reg:=port[reg];
  inp:=reg;
end;

procedure outp(reg,val:word);    {Write the low byte of VAL to I/O port REG}
begin
  port[reg]:=val;
end;


function rdinx(pt,inx:word):word;       {read register PT index INX}
var x:word;
begin
  if pt=$3C0 then x:=inp($3DA);    {If Attribute Register then reset Flip-Flop}
  outp(pt,inx);
  rdinx:=inp(pt+1);
end;

procedure wrinx(pt,inx,val:word);       {write VAL to register PT index INX}
begin
  outp(pt,inx);
  outp(pt+1,val);
end;

procedure modinx(pt,inx,mask,nwv:word);  {In register PT index INX sets
                                          the bits in MASK as in NWV
                                          the other are left unchanged}
var temp:word;
begin
  temp:=(rdinx(pt,inx) and not mask)+(nwv and mask);
  wrinx(pt,inx,temp);
end;


function getbios(offs,lnn:word):string;
var s:string;
begin
  s[0]:=chr(lnn);
  move(mem[biosseg:offs],s[1],lnn);
  getbios:=s;
end;

function tstrg(pt,msk:word):boolean;       {Returns true if the bits in MSK
                                            of register PT are read/writable}
var old,nw1,nw2:word;
begin
  old:=inp(pt);
  outp(pt,old and not msk);
  nw1:=inp(pt) and msk;
  outp(pt,old or msk);
  nw2:=inp(pt) and msk;
  outp(pt,old);
  tstrg:=(nw1=0) and (nw2=msk);
end;

function testinx2(pt,rg,msk:word):boolean;   {Returns true if the bits in MSK
                                              of register PT index RG are
                                              read/writable}
var old,nw1,nw2:word;
begin
  old:=rdinx(pt,rg);
  wrinx(pt,rg,old and not msk);
  nw1:=rdinx(pt,rg) and msk;
  wrinx(pt,rg,old or msk);
  nw2:=rdinx(pt,rg) and msk;
  wrinx(pt,rg,old);
  testinx2:=(nw1=0) and (nw2=msk);
end;

function testinx(pt,rg:word):boolean;     {Returns true if all bits of
                                           register PT index RG are
                                           read/writable.}
var old,nw1,nw2:word;
begin
  testinx:=testinx2(pt,rg,$ff);
end;

procedure dactopel;    {Force DAC back to PEL mode}
begin
  if inp($3c8)=0 then;
end;

var
  daccomm:word;

procedure dactocomm;    {Enter command mode of HiColor DACs}
var x:word;
begin
  dactopel;
  x:=inp($3c6);
  x:=inp($3c6);
  x:=inp($3c6);
  daccomm:=inp($3c6);
end;




  (*  Set memory bank  *)

procedure setbank(bank:word);
var x:word;
begin
  vseg:=$a000;
  if bank=curbank then exit;   {Only set bank if diff. from current value}
  case chip of
    __acumos:modinx($3ce,9,$f0,bank shl 4);
    __aheadA:begin
               wrinx($3ce,13,bank shr 1);
               x:=inp($3cc) and $df;
               if odd(bank) then inc(x,32);
               outp($3c2,x);
             end;
    __aheadB:wrinx($3ce,13,bank*17);
    __al2101:outp($3d7,bank);
      __ati1:modinx(atireg,$b2,$1e,bank shl 1);
      __ati2:modinx(atireg,$b2,$ee,bank*$22);
  __chips451:wrinx(crtc+2,11,bank);
  __chips452:wrinx(crtc+2,16,bank shl 2);
  __chips453:wrinx(crtc+2,16,bank shl 4);
    __everex:begin
               x:=inp($3cc) and $df;
               if (bank and 2)>0 then inc(x,32);
               outp($3c2,x);
               modinx($3c4,8,$80,bank shl 7);
             end;
     __genoa:wrinx($3c4,6,bank*9+64);
      __mxic:wrinx($3c4,$c5,bank*17);
       __ncr:begin
               if memmode<=_pl16 then bank:=bank shl 2;
               wrinx($3c4,$18,bank shl 2);
             end;
       __oak:wrinx($3de,17,bank*17);
  __paradise:wrinx($3ce,9,bank shl 4);

     __p2000,
   __realtek:begin
               outp($3d6,bank);
               outp($3d7,bank);
             end;
        __s3:begin
               wrinx(crtc,$38,$48);
               modinx(crtc,$31,9,9);
               if memmode=_pl16 then bank:=bank*4;
               modinx(crtc,$35,$f,bank);
               wrinx(crtc,$38,0);
             end;
    __tridBR:;
    __tridCS,__poach,__trid89
            :begin
               wrinx($3c4,11,0);
               if rdinx($3c4,11)=0 then;
               modinx($3c4,14,$f,bank xor 2);
             end;
    __tseng3:outp($3cd,bank*9+64);
    __tseng4:outp($3cd,bank*17);
    __video7:begin
               x:=inp($3cc) and $df;
               if (bank and 2)>0 then inc(x,32);
               outp($3c2,x);
               modinx($3c4,$f9,1,bank);
               modinx($3c4,$f6,$80,(bank shr 2)*5);

             end;
  __cirrus54:wrinx($3CE,9,bank*16);
      __vesa:begin
               rp.bx:=0;
               rp.dx:=bank*longint(64) div vgran;
               vio($4f05);
               rp.bx:=1;
               vio($4f05);
             end;
  end;
  curbank:=bank;
end;


procedure vesamodeinfo(md:word);
begin
  rp.cx:=md;
  rp.es:=seg(vesarec);
  rp.di:=ofs(vesarec);
  vio($4f01);
  vgran:=vesarec.gran;
  bytes:=vesarec.bytes;
  pixels:=vesarec.width;
  lins:=vesarec.height;
  case vesarec.bits of
    4:memmode:=_pl16;
    8:memmode:=_p256;
   15:memmode:=_p32k;
   16:memmode:=_p64k;
   24:memmode:=_p16m;
  end;
end;

function safemode(md:word):boolean;
var x,y:word;
begin                 {Checks if we entered a Graph. mode}
  vio(3);
  vio(lo(md));
  y:=rdinx($3ce,6);
  safemode:=odd(y);
end;

function tsvio(ax,bx:word):boolean;   {Tseng 4000 Hicolor mode set}
begin
  rp.bx:=bx;
  vio(ax);
  tsvio:=rp.ax=16;
end;

function setmode(md:word):boolean;
var x:word;
begin
  setmode:=true;
  curmode:=md;
  case chip of
__ati1,__ati2:begin
                rp.bx:=$5506;
                rp.bp:=$ffff;
                rp.si:=0;
                vio($1200+md);
                if rp.bp=$ffff then setmode:=false
                else vio(md);
              end;
   __chips451:begin
                setmode:=safemode(md);
                x:=inp($46e8);
                outp($46e8,x or 16);
                outp($103,inp($103) or $80);
                outp($46e8,x and $ef);
                modinx(crtc+2,4,4,4);
                modinx(crtc+2,11,3,1);
              end;
   __chips452,__chips453:
              begin
                setmode:=safemode(md);
                x:=inp($46e8);
                outp($46e8,x or 16);
                outp($103,inp($103) or $80);
                outp($46e8,x and $ef);
                modinx(crtc+2,4,4,4);
                modinx(crtc+2,11,3,1);
                wrinx(crtc+2,12,0);
              end;
     __everex:begin
                rp.bl:=md;
                vio($70);
              end;
   __paradise:begin
                setmode:=safemode(md);
                modinx($3ce,15,$17,5);
                wrinx(crtc,$29,$85);
                modinx($3ce,$b,8,0);
                modinx(crtc,$2f,$62,0);
              end;
        __ncr:begin
                setmode:=safemode(md);
                wrinx($3c4,5,5);
                wrinx($3c4,$18,0);
                wrinx($3c4,$19,0);
                wrinx($3c4,$1a,0);
                wrinx($3c4,$1b,0);

                modinx($3c4,$1e,$1c,$18);
              end;
     __video7:begin
                rp.bl:=md;
                vio($6f05);
              end;
       __mxic:begin
                setmode:=safemode(md);
                wrinx($3c4,$a7,$87);    {enable extensions}
              end;
       __vesa:begin
                rp.bx:=md;
                vio($4f02);
                if rp.ax<>$4f then setmode:=false
                else begin
                  vesamodeinfo(md);
                  chip:=__vesa;
                end;
              end;
     __acumos:begin
                vio(md);
                wrinx($3c4,6,$12);
              end;
     __tseng3:begin
                vio(md);
                modinx($3c4,4,2,2);
              end;
     __tseng4:case hi(md) of
                0:setmode:=safemode(md);
                1:if tsvio($10e0,lo(md)) then
                  begin
                    {Diamond SpeedStar 24 does not clear memory}
                    for x:=0 to 15 do         {clear memory}
                    begin
                      setbank(x);
                      mem[$a000:0]:=0;
                      fillchar(mem[$a000:1],65535,0);
                    end;
                  end else setmode:=false;
                2:if tsvio($10f0,md shl 8+$ff) then
                  begin
                    outp($3bf,3);
                    outp(crtc+4,$a0);   {enable Tseng 4000 Extensions}
                    wrinx(crtc,$13,0);
                    modinx(crtc,$3f,$80,$80);
               {     outp(crtc+4,$29);
                    outp($3bf,1);      do we need these ? }
                    wrinx(crtc,$13,0);
                    modinx(crtc,$3f,$80,$80);
                  end else setmode:=false;
                3:if not tsvio($10f0,lo(md)) then setmode:=false;
                4:if tsvio($10f0,lo(md)) then
                  begin
                    dactocomm;
                    x:=inp($3c6);
                    outp($3c6,x or 64);  {set DAC to 64K colors}
                    dactopel;
                  end else setmode:=false;
              end;
         __s3:if md<$100 then setmode:=safemode(md)
              else begin
                rp.bx:=md;
                vio($4f02);
                if rp.ax=$4f then
                begin
                  if md<$200 then vesamodeinfo(md);
                end
                else setmode:=false;
              end;
      __p2000:begin
                setmode:=safemode(md);
                if memmode=_p64k then
                begin
                  dactocomm;
                  outp($3c6,$c0);
                end;
         (*       if memmode=_p16m then
                begin            {This can trick a ATT20c492 into 24bit mode}
                  dactocomm;
                  outp($3c6,$e0);
                  bytes:=1600;
                  pixels:=530;
                end;  *)
              end;
  else setmode:=safemode(md)
  end;
  curbank:=$ffff;    {Set curbank invalid }
  case memmode of
  _pl2e,_pl4:planes:=2;
    _pl16:planes:=4;
  else planes:=1;
  end;
  for x:=1 to mm div 64 do
  begin
    setbank(x-1);
    mem[$a000:$ffff]:=0;
    fillchar(mem[$a000:0],$ffff,0);
  end;
  modinx($3c4,4,2,2);    {Set "more than 64K" flag}
  vseg:=$a000;
end;

procedure checkmem(mx:word);
var
  fail:boolean;
  ma:array[0..99] of byte;
  x:word;
begin
  memmode:=_p256;

  fail:=true;
  while (mx>1) and fail do
  begin
    setbank(mx-1);
    move(mem[$a000:0],ma,100);
    for x:=0 to 99 do
      mem[$a000:x]:=ma[x] xor $aa;
    setbank(mx-1);
    fail:=false;
    for x:=0 to 99 do
      if mem[$a000:x]<>ma[x] xor $aa then fail:=true;
    move(ma,mem[$a000:0],100);
    if not fail then
    begin
      setbank((mx shr 1)-1);
      for x:=0 to 99 do
        mem[$a000:x]:=ma[x] xor $55;
      setbank(mx-1);
      fail:=true;
      for x:=0 to 99 do
        if mem[$a000:x]<>ma[x] xor $55 then fail:=false;
      move(ma,mem[$a000:0],100);
    end;
    mx:=mx shr 1;
  end;
  mm:=mx*128;
end;


procedure setvstart(l:longint);       {Set the display start address}
var x,y:word;
begin
  if chip<>__vesa then
  begin
    x:=l shr 2;
    y:=(l shr 18) and (pred(mm) shr 8);   {Mask out any "too" high bits}
    wrinx(crtc,13,lo(x));
    wrinx(crtc,12,hi(x));
  end;
  case chip of
    __tseng3:modinx(crtc,$23,2,y shl 1);
    __tseng4:modinx(crtc,$33,3,y);
    __tridcs:modinx(crtc,$1e,32,y shl 5);
    __trid89:begin
               modinx(crtc,$1e,$a0,y shl 5+128);
               wrinx($3c4,11,0);
               modinx($3c4,$e,1,y shr 1);
             end;
    __video7:modinx($3c4,$f6,$70,(y shl 4) and $30);
  __paradise:modinx($3ce,$d,$18,y shl 3);
  __chips452,__chips453:
             begin
               wrinx($3d6,12,y);
               modinx($3d6,4,4,4);
             end;
     __ncr:begin
             modinx(crtc,$31,$f,y);
           end;
    __ati1:modinx(atireg,$b0,$40,y shl 6);
    __ati2:modinx(atireg,$b0,$c0,y shl 6);
  __aheadb:modinx($3ce,$1c,3,y);
    __vesa:begin
             rp.bx:=0;
             rp.cx:=l mod 320;
             rp.dx:=l div 320;
             vio($4f07);
             if rp.ax=0 then;
           end;
      __s3:begin
             wrinx(crtc,$38,$48);
             modinx(crtc,$31,$30,y shl 4);
             wrinx(crtc,$38,0);
           end;
__cirrus54:begin
             if y>1 then inc(y,2);
             modinx(crtc,$1b,5,y);
           end;
   __p2000:modinx($3ce,$21,$7,y);
  end;
end;


procedure UNK(chp:string;id:word);
begin
  name:='Unknown '+chp+' chip ('+istr(id)+')';
end;

   (*  Tests for various adapters  *)


function _chipstech:boolean;
begin
  _chipstech:=false;
  if dotest[__CHIPS451] then
  begin
    vio($5f00);
    if rp.al=$5f then
    begin
      _chipstech:=true;
      case rp.bl shr 4 of
        0:name:='Chips & Tech 82c451';
        1:name:='Chips & Tech 82c452';
        2:name:='Chips & Tech 82c455';
        3:name:='Chips & Tech 82c453';
        5:name:='Chips & Tech 82c456';
        6:name:='Chips & Tech 82c457';
        7:name:='Chips & Tech F65520';
        8:name:='Chips & Tech F65530';
      else UNK('Chips & Tech',rp.bl shr 4);
      end;
      case rp.bl shr 4 of
        1:CHIP:=__chips452;
        3:CHIP:=__chips453;
      else chip:=__chips451;
      end;
      case rp.bh of
        1:mm:=512;
        2:mm:=1024;
      end;
    end;
  end;
end;

function _paradise:boolean;
var old,old1,old2:word;
begin
  _paradise:=false;
  if dotest[__PARADISE] then
  begin
    old:=rdinx($3ce,15);
    modinx($3ce,15,$17,0);   {Lock registers}

    if not testinx2($3ce,9,$7f) then
    begin
      wrinx($3ce,15,5);      {Unlock them again}
      if testinx2($3ce,9,$7f) then
      begin
        _paradise:=true;
        old2:=rdinx(crtc,$29);
        name:='Paradise ';
        modinx(crtc,$29,$8f,$85);   {Unlock WD90Cxx registers}
        if not testinx(crtc,$2b) then name:=name+'PVGA1A'
        else begin
          old1:=rdinx($3c4,6);
          wrinx($3c4,6,$48);
          if not testinx2($3c4,7,$f0) then name:=name+'WD90C00'
          else if not testinx($3c4,16) then
          begin
            name:=name+'WD90C2x';
            wrinx(crtc,$34,$a6);
            if (rdinx(crtc,$32) and 32)<>0 then wrinx(crtc,$34,0);
          end
          else if testinx2($3c4,20,15) then
               begin
                 if rdinx(crtc,$37)=$31 then name:=name+'WD90C31'
                                        else name:=name+'WD90C30';
               end
               else if not testinx2($3c4,16,4) then name:=name+'WD90C10'
                                               else name:=name+'WD90C11';

          wrinx($3c4,6,old1);
        end;
        case rdinx($3ce,11) shr 6 of
           2:mm:=512;
           3:mm:=1024;
        end;
        wrinx(crtc,$29,old2);
        chip:=__paradise;
      end;
    end;
    wrinx($3ce,15,old);
  end;
end;

function _video7:boolean;
begin
  _video7:=false;
  if dotest[__video7] then
  begin
    vio($6f00);
    if rp.bx=$5637 then
    begin
      _video7:=true;
      vio($6f07);
      case rp.bl of
        $80..$ff:name:='Video7 VEGA VGA';
        $70..$7f:name:='Video7 FASTWRITE/VRAM';
        $50..$5f:name:='Video7 Version 5';
        $41..$4f:name:='Video7 1024i';
      end;
      case rp.ah and 127 of
        2:mm:=512;
        4:mm:=1024;
      end;
      chip:=__video7;
    end
  end;
end;

function _genoa:boolean;
var ad:word;
begin
  _genoa:=false;
  if dotest[__genoa] then
  begin
    ad:=memw[biosseg:$37];
    if (memw[biosseg:ad+2]=$6699) and (mem[biosseg:ad]=$77) then
    begin
      _genoa:=true;
      case mem[biosseg:ad+1] of
        0:name:='Genoa 62/300';
      $11:begin
            name:='Genoa 64/500';
            mm:=512;
          end;
      $22:name:='Genoa 6100';
      $33:name:='Genoa 51/5200 (Tseng 3000)';
      $55:begin
            name:='Genoa 53/5400 (Tseng 3000)';
            mm:=512;
          end;
      end;
      if mem[biosseg:ad+1]<$33 then chip:=__genoa else chip:=__tseng3;
    end
  end;
end;

function _tseng:boolean;
var x,vs:word;
begin
  _tseng:=false;
  if dotest[__TSENG3] or dotest[__TSENG4] then
  begin
    outp($3bf,3);
    outp($3d8,$a0);    {Enable Tseng 4000 extensions}
    if tstrg($3cd,$3f) then
    begin
      _tseng:=true;
      if testinx2(crtc,$33,$f) then
      begin
        name:='Tseng ET4000';
        case rdinx(crtc,$37) and 11 of
         3,9:mm:=256;
          10:mm:=512;
          11:mm:=1024;
        end;
    (*    vio($10f1);
        if (rp.ax=$10) then
          case rp.bl of
            1:name:=name+' /w Sierra RAMDAC';
            2:name:=name+' /w SS24 RAMDAC';
          end; *)
        chip:=__tseng4;
      end
      else begin
        name:='Tseng ET3000';
        chip:=__tseng3;
        if setmode($13) then;
        x:=port[$3da];
        x:=rdinx($3c0,$36);
        port[$3c0]:=x or 16;
        case (rdinx($3ce,6) shr 2) and 3 of
         0,1:vs:=$a000;
           2:vs:=$b000;
           3:vs:=$b800;
        end;

        meml[vs:1]:=$12345678;
        if memw[vs:2]=$3456 then mm:=512;

        wrinx($3c0,$36,x);     {reset value and reenable DAC}
      end;
    end;
  end;
end;

function _trident:boolean;
var chp,old,val:word;
begin
  _trident:=false;
  if dotest[__tridBR] or dotest[__trid89] or dotest[__tridCS] then
  begin
    wrinx($3c4,11,0);
    chp:=inp($3c5);
    old:=rdinx($3c4,14);
    outp($3c5,0);
    val:=inp($3c5);
    outp($3c5,old);
    if (val and 15)=2 then
    begin
      _trident:=true;
      case chp of
        1:name:='Trident 8800BR';
        2:name:='Trident 8800CS';
        3:name:='Trident 8900';
        4:name:='Trident 8900C';
      $13:name:='Trident 8900C';
      $23:name:='Trident 9000';
      $83:name:='Trident LX9200';
      $93:name:='Trident LCD9100';
      else UNK('Trident',chp);
      end;
      case chp and 15 of
        1:chip:=__tridbr;
        2:chip:=__tridCS;
        3:chip:=__trid89;
      end;
      if (pos('Zymos Poach 51',getbios(0,255))>0) or
         (pos('Zymos Poach 51',getbios(230,255))>0) then
      begin
        name:=name+' (Zymos Poach)';
        chip:=__poach;
      end;
      if (chp>=3) then
      begin
        case rdinx(crtc,$1f) and 3 of
          0:mm:=256;
          1:mm:=512;
          2:mm:=768;
          3:mm:=1024;
        end;
      end
      else
      if (rdinx(crtc,$1f) and 2)>0 then mm:=512;

    end;
  end;
end;

function _oak:boolean;
begin
  _oak:=false;
  if dotest[__oak] then
  begin
    if testinx2($3de,$d,$38) then
    begin
      _oak:=true;
      name:='OAK 037C';
      if testinx($3DE,$11) then
      begin
        if rdinx($3DE,$B)=5 then name:='OAK 077'
                            else name:='OAK 067';
      end;
      case rdinx($3de,13) shr 6 of
        2:mm:=512;
      1,3:mm:=1024;    {1 might not give 1M??}
      end;
      chip:=__oak;
    end;
  end;
end;

function _cirrus:boolean;
var old,eagle:word;
begin
  _cirrus:=false;
  if dotest[__cirrus] then
  begin
    old:=rdinx(crtc,12);
    outp(crtc+1,0);
    eagle:=rdinx(crtc,$1f);
    wrinx($3c4,6,lo(eagle shr 4) or lo(eagle shl 4));
    if inp($3c5)=0 then
    begin
      outp($3c5,eagle);
      if inp($3c5)=1 then
      begin
        _cirrus:=true;
        case eagle of
          $EC:name:='Cirrus 510/520';
          $CA:name:='Cirrus 610/620';
          $EA:name:='Cirrus Video 7 OEM'
        else UNK('Cirrus',eagle);
        end;
        chip:=__cirrus;
      end;
    end;
    wrinx(crtc,12,old);
  end;
end;


function _cirrus54:boolean;
var x,old:word;
begin
  _cirrus54:=false;
  if dotest[__cirrus54] then
  begin
    old:=rdinx($3C4,6);
    wrinx($3c4,6,$12);
    if (rdinx($3C4,6)=$12) and testinx2($3C4,$1E,$3F) and testinx2(crtc,$1B,$ff) then
    begin
      x:=rdinx(crtc,$27);
      case x of
          $8A:name:='Cirrus 54xx typ 2';
     $8C..$8F:name:='Cirrus 54xx typ 3';
     $90..$93:name:='Cirrus 54xx typ 5';
     $94..$97:name:='Cirrus 54xx typ 4';
      else UNK('Cirrus54',x);
      end;
      case rdinx($3C4,$F) and $18 of
        0:mm:=0;
        8:mm:=512;
       16:mm:=1024;
      end;
      _cirrus54:=true;
      chip:=__cirrus54;
    end
    else wrinx($3C4,6,old);
  end;
end;

function _ahead:boolean;
var old:word;
begin
  _ahead:=false;
  if dotest[__aheadA] or dotest[__aheadB] then
  begin
    old:=rdinx($3ce,15);
    wrinx($3ce,15,0);
    if not testinx2($3ce,12,$FB) then
    begin
      wrinx($3ce,15,$20);
      if testinx2($3ce,12,$FB) then
      begin
        _ahead:=true;
        case rdinx($3ce,15) and 15 of
          0:begin
              name:='Ahead A';
              chip:=__aheadA;
            end;
          1:begin
              name:='Ahead B';
              chip:=__aheadB;
            end;
        end;
      end;
    end;
    wrinx($3ce,15,old);
  end;
end;

function _everex:boolean;
var x:word;
begin
  _everex:=false;
  if dotest[__everex] then
  begin
    rp.bx:=0;
    vio($7000);
    if rp.al=$70 then
    begin
      x:=rp.dx shr 4;
      if  (x<>$678) and (x<>$236)
      and (x<>$620) and (x<>$673) then     {Some Everex boards use Trident chips.}
      begin
        _everex:=true;
        case rp.ch shr 6 of
          0:mm:=256;
          1:mm:=512;
          2:mm:=1024;
          3:mm:=2048;
        end;
        name:='Everex Ev'+hx[x shr 8]+hx[(x shr 4) and 15]+hx[x and 15];
        chip:=__everex;
      end;
    end;
  end;
end;

function _ati:boolean;
var w:word;
begin
  _ati:=false;
  if dotest[__ATI1] or dotest[__ati2] then
  begin
    if getbios($31,9)='761295520' then
    begin
      _ati:=true;
      case memw[biosseg:$40] of
       $3133:begin
               atireg:=memw[biosseg:$10];
               name:='ATI VGA Wonder';
               w:=rdinx(atireg,$bb);
               case w and 15 of
                 0:_crt:='EGA';
                 1:_crt:='Analog Monochrome';
                 2:_crt:='Monochrome';
                 3:_crt:='Analog Color';
                 4:_crt:='CGA';
                 6:_crt:='';
                 7:_crt:='IBM 8514/A';
               else _crt:='Multisync';
               end;
               chip:=__ati2;
               case chr(mem[biosseg:$43]) of
                '1':begin
                      name:=name+' (18800)';
                      chip:=__ati1;
                    end;
                '2':name:=name+' (18800-1)';
                '3':name:=name+' (28800-2)';
                '4':name:=name+' (28800-4)';
                '5':begin
                      name:=name+' (28800-5)';
                      if (mem[biosseg:$44] and 128)<>0 then
                        name:=name+' /w HICOLOR DAC';
                    end;
               end;
               case chr(mem[biosseg:$43]) of
                 '1','2':if (rdinx(atireg,$bb) and 32)<>0 then mm:=512;
                     '3':if (rdinx(atireg,$b0) and 16)<>0 then mm:=512;
                 '4','5':case rdinx(atireg,$b0) and $18 of
                             0:mm:=256;
                           $10:mm:=512;
                         8,$18:mm:=1024;
                         end;
               end;
             end;
       $3233:begin
               name:='ATI EGA Wonder';
               video:='EGA';
               chip:=__ega;
             end;
      end;
    end;
  end;
end;

function _s3:boolean;
var x:word;
begin
  _s3:=false;
  if dotest[__s3] then
  begin
    wrinx(crtc,$38,0);
    if not testinx2(crtc,$35,$f) then
    begin
      wrinx(crtc,$38,$48);
      if testinx2(crtc,$35,$f) then
      begin
        _s3:=true;
        chip:=__s3;
        x:=rdinx(crtc,$30);
        case x of
          $81:name:='S3 86c911';
          $82:name:='S3 86c911A';  {Whats the diff?}
        else UNK('S3',x);
        end;
        if (rdinx(crtc,$41) and $10)<>0 then mm:=1024
                                        else mm:=512;
      end;
    end;
  end;
end;

function _al2101:boolean;
begin
  _al2101:=false;
  if dotest[__al2101] then
  begin
    if tstrg($8286,$ff) and testinx2(crtc,$1f,$3b)
       and testinx2($3ce,13,15) then
    begin
      _al2101:=true;
      name:='Avance Logic 2101';
      chip:=__al2101;
      case rdinx(crtc,$1e) and 3 of
        0:mm:=256;
        1:mm:=512;
        2:mm:=1024;
        3:mm:=2048;
      end;
    end;
  end;
end;

function _vesa:boolean;
begin
  _vesa:=false;
  if dotest[__vesa] then
  begin
    vio($4f03);
    if rp.al=$4f then
    begin
      _vesa:=true;
      name:='VESA';
      chip:=__vesa;
      vesa:=1;
    end;
  end;
end;

function _yamaha:boolean;
begin
  _yamaha:=false;
  if dotest[__yamaha] then
  begin
    if testinx2($3d4,$7c,$7c) then
    begin
      _yamaha:=true;
      name:='Yamaha 6388'
    end;
  end;
end;

function _ncr:boolean;
var x:word;
begin
  _ncr:=false;
  if dotest[__ncr] then
  begin
    if testinx2($3c4,5,5) then
    begin
      wrinx($3c4,5,0);        {Disable extended registers}
      if not testinx2($3c4,16,$ff) then
      begin
        wrinx($3c4,5,1);        {Enable extended registers}
        if testinx2($3c4,16,$ff) then
        begin
          _ncr:=true;
          chip:=__ncr;
          x:=rdinx($3c4,8) shr 4;
          case x of
            0:name:='NCR 77C22';
            1:name:='NCR 77C21';
            2:name:='NCR 77C22E';
        8..15:name:='NCR 77C22E+';
          else UNK('NCR',x);
          end;
          name:=name+' Rev. '+istr(rdinx($3c4,8) and 15);
          if setmode($13) then;
          checkmem(64);
        end;
      end;
    end;
  end;
end;

function _acumos:boolean;
var old:word;
begin
  _acumos:=false;
  if dotest[__acumos] then
  begin
    old:=rdinx($3c4,6);
  {  wrinx($3c4,6,0);
    if not testinx2($3ce,9,$f0) then }
    begin
      wrinx($3c4,6,$12);
      if testinx2($3ce,9,$30) then
      begin
        _acumos:=true;
        name:='Acumos AVGA2';
        chip:=__acumos;
        case rdinx($3c4,$a) and 3 of
          0:mm:=256;
          1:mm:=512;
          2:mm:=1024;
        end;
      end;
    end;
    wrinx($3c4,6,old);
  end;
end;

function _mxic:boolean;
begin
  _mxic:=false;
  if dotest[__mxic] then
  begin
    old:=rdinx($3c4,$a7);
    wrinx($3c4,$a7,0);       {disable extensions}
    if not testinx($3c4,$c5) then
    begin
      wrinx($3c4,$a7,$87);   {enable extensions}
      if testinx($3c4,$c5) then
      begin
        _mxic:=true;
        chip:=__mxic;
        name:='MX 86010';
        case (rdinx($3c4,$c2)  shr 2) and 3 of
          0:mm:=256;
          1:mm:=512;
          2:mm:=1024;
        end;
      end;
    end;
    wrinx($3c4,$a7,old);
  end;
end;

function _p2000:boolean;
begin
  _p2000:=false;
  if dotest[__p2000] then
  begin
    if testinx2($3CE,$3d,$3f) and tstrg($3d6,$1f) and tstrg($3d7,$1f) then
    begin
      _p2000:=true;
      name:='Primus P2000';
      chip:=__p2000;
      if setmode($13) then;
      checkmem(32);
    end;
  end;
end;

function _realtek:boolean;
var x:word;
begin
  _realtek:=false;
  if dotest[__realtek] then
  begin
    if testinx2(crtc,$1f,$3f) and tstrg($3d6,$f) and tstrg($3d7,$f) then
    begin
      chip:=__realtek;
      name:='Realtek';
      _realtek:=true;
      x:=rdinx(crtc,$1a) shr 6;
      case x of
     0..2:name:='Realtek version '+istr(x);
      else UNK('Realtek',x);
      end;
      case rdinx(crtc,$1e) and 15 of
        0:mm:=256;
        1:mm:=512;
        2:if x=0 then mm:=768  else mm:=1024;
        3:if x=0 then mm:=1024 else mm:=2048;
      end;
    end;
  end;
end;



function testdac:string;      {Test for type of DAC}
var
  x,y,z,v,oldcommreg,oldpelreg:word;

begin
  IF chip=__al2101 then    (* Special case -- weird DAC *)
  begin
    dactype:=_dac16;
    testdac:='AVL DAC 16';
    exit;
  end;
  testdac:='Normal';
  dactype:=_dac8;
  dactopel;
  x:=inp($3c6);
  repeat
    y:=x;         {wait for the same value twice}
    x:=inp($3c6);
  until (x=y);
  z:=x;
  dactocomm;
  if daccomm<>$8e then
  begin                      {If command register=$8e, we've got an SS24}
    y:=8;
    repeat
      x:=inp($3c6);
      dec(y);
    until (x=$8e) or (y=0);
  end
  else x:=daccomm;
  if x=$8e then
  begin
    dactype:=_dacss24;
    testdac:='SS24';
    dactopel;
  end
  else begin

    dactocomm;
    oldcommreg:=inp($3c6);
    dactopel;
    oldpelreg:=inp($3c6);
    x:=oldcommreg xor 255;
    outp($3c6,x);
    dactocomm;
    v:=inp($3c6);
    if v<>x then
    begin
      dactocomm;
      x:=oldcommreg xor $60;
      outp($3c6,x);
      dactocomm;
      v:=inp($3c6);
      testdac:='Sierra SC11486';
      dactype:=_dac15;

      if (x and $e0)=(v and $e0) then
      begin
        x:=inp($3c6);
        dactopel;
        testdac:='Sierra 32k/64k';
        dactype:=_dac15;             (* Can't tell the difference *)

        if x=inp($3c6) then
        begin
          testdac:='ATT 20c491/2';
          dactype:=_dacatt;
          dactocomm;
          outp($3c6,255);
          dactocomm;
          x:=inp($3c6);
          if x<>255 then
          begin
            testdac:='Acumos ADAC';
            dactype:=_dacadac1;
          end;
        end;
      end;

      dactocomm;
      outp($3c6,oldcommreg);
    end;
    dactopel;
    outp($3c6,oldpelreg);
  end;
end;


procedure findbios;     {Finds the most likely BIOS segment}
var
  score:array[0..7] of byte;
  x,y:word;
begin
  biosseg:=$c000;
  for x:=0 to 6 do score[x]:=1;
  for x:=0 to 7 do
  begin
    rp.bh:=x;
    vio($1130);
    if (rp.es>=$c000) and ((rp.es and $7ff)=0) then
      inc(score[(rp.es-$c000) shr 11]);
  end;

  for x:=0 to 6 do
  begin
    y:=$c000+(x shl 11);
    if (memw[y:0]<>$aa55) or (mem[y:2]<48) then
      score[x]:=0;                       {fail if no rom}
  end;
  for x:=6 downto 0 do
    if score[x]>0 then
      biosseg:=$c000+(x shl 11);
end;


procedure findvideo;
begin
  dactype:=_dac0;
  extra:='';
  _crt:='';
  chip:=__none;
  secondary:='';
  name:='';
  video:='none';
  rp.ah:=18;
  rp.bx:=$1010;
  intr(16,rp);
  if rp.bh<=1 then
  begin
    video:='EGA';
    chip:=__ega;
    if odd(inp($3cc)) then crtc:=$3d4
                      else crtc:=$3b4;

    mm:=rp.bl;
    vio($1a00);
    if rp.al=$1a then
    begin
      if (rp.bl<4) and (rp.bh>3) then
      begin
        old:=rp.bl;
        rp.bl:=rp.bh;
        rp.bh:=old;
      end;
      video:='MCGA';
      case rp.bl of
        2,4,6,10:_crt:='TTL Color';
        1,5,7,11:_crt:='Monochrome';
        8,12:_crt:='Analog Color';
      end;
      case rp.bh of
        1:secondary:='Monochrome';
        2:secondary:='CGA';
      end;
      findbios;
      if (getbios($31,9)='') and (getbios($40,2)='22') then
      begin
        video:='EGA';       {@#%@  lying ATI EGA Wonder !}
        name:='ATI EGA Wonder';

      end else
      if (rp.bl<10) or (rp.bl>12) then
      begin
        video:='VGA';
        chip:=__vga;
        mm:=256;
        if _vesa then extra:=extra+'VESA ';
        if _chipstech then
        else if _paradise then
        else if _video7 then
        else if _genoa then
        else if _everex then
        else if _trident then
        else if _ati then
        else if _ahead then
        else if _ncr then
        else if _s3 then
        else if _al2101 then
        else if _mxic then
        else if _cirrus54 then
        else if _acumos then
        else if _tseng then
        else if _realtek then
        else if _p2000 then
        else if _yamaha then
        else if _oak then
        else if _cirrus then;

        dacname:=testdac;

      end;
    end;
  end;
end;

begin
end.