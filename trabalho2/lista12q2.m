clc
clear
 
% Período de amostragem
T = 0.5;

Gz=tf(1,[1 -0.5],T);
Hz=tf([1 0],[1 -1],T);
GHz=minreal(Gz*Hz);

z1=0.5 + 1i*0.25;

alfa = -0.5;

G2z=minreal(tf([1 alfa],1,T)*GHz);
[n2,d2]=tfdata(G2z,'v');


% fi2 é o ângulo de G2z quando z=z1
fi2=angle(polyval(n2,z1)/polyval(d2,z1));
% fi1 é o ângulo de G1z quando z=z1
fi1=-pi-fi2;
beta=(imag(z1)-real(z1)*tan(-fi1))/tan(-fi1);