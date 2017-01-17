param napokszama;
set Napok:=1..napokszama;

param szabadido{n in Napok};
param ping{n in Napok};

set Jatekok;
param versenyszint{j in Jatekok};
param minjatekido{j in Jatekok};
param online{j in Jatekok};


var jatek{n in Napok, j in Jatekok}, binary;


s.t.egy_nap_egy_jatek{n in Napok}:
sum{j in Jatekok} jatek[n,j]<=1;


s.t. max_2nap_lehet_ugyanazt_jatszani{n in Napok,j in Jatekok: n>=3}:
jatek [n,j] + jatek [n-1,j]+ jatek[n-2, j] <=2; 




s.t. online_jatek_csak_akkor_ha_nincs_ping_LoL {n in Napok,  j in Jatekok: ping[n] == 1 && online[j] ==1}:
jatek[n,j] =0;



s.t. legyen_eleg_minjatekidore{n in Napok, j in Jatekok: minjatekido[j]>szabadido[n]}:
jatek[n,j]=0;

s.t.versenyszint_meglegyen{j in Jatekok}:
sum{n in Napok} jatek[n,j]*szabadido[n] >= versenyszint[j];



maximize LoL:
sum{n in Napok} szabadido[n]*jatek[n,'LoL'] ;


var CoD_jatekido;
var LoL_jatekido;
var GTA_jatekido;
var HS_jatekido;
var AoE_jatekido;

s.t.CoD_jatekido_Constraint:
CoD_jatekido=sum{n in Napok} jatek[n,'CoD']*szabadido[n];

s.t.LoL_jatekido_Constraint:
LoL_jatekido=sum{n in Napok} jatek[n,'LoL']*szabadido[n];

s.t.GTA_jatekido_Constraint:
GTA_jatekido=sum{n in Napok} jatek[n,'GTA']*szabadido[n];

s.t.HS_jatekido_Constraint:
HS_jatekido=sum{n in Napok} jatek[n,'HS']*szabadido[n];

s.t.AoE_jatekido_Constraint:
AoE_jatekido=sum{n in Napok} jatek[n,'AOE']*szabadido[n];

solve; 

printf "\n\n";
printf "\tCoD:\t%d\n",  CoD_jatekido;
printf "\tLoL:\t%d\n",  LoL_jatekido;
printf "\tGTA:\t%d\n",  GTA_jatekido;
printf "\tHS:\t%d\n",  HS_jatekido;
printf "\tAoE:\t%d\n\n\n",  AoE_jatekido;

printf "p?|nap|jatek\n\n";

for{ n in Napok}
 {
  printf"%s%2d: ",if (ping[n]=1) then "*" else " ", n;
 for {j in Jatekok: jatek[n,j]=1}
 printf"%s\n",j;

 }
 printf "\n\n";

end;
