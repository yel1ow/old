{$F+}
unit SpeedTst;
interface
Procedure SetSpeed(var Tmp,Trs:word;Temp,Tr:real);
implementation
Procedure SetSpeed(var Tmp,Trs:word;Temp,Tr:real);
begin
  Tmp:=Round(3100/Temp);
  Trs:=Round(200*Tr);
end;
end.
