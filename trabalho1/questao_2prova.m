clc
clear

T=0.2;

degrau=tf([1 0],[1 -1], T);

Gs=tf(1, [1 5]);

Gz=c2d(Gs, T);

Cz=tf(0.1813, [1 -0.8187], T);

FTMA = Gz*Cz;

FTMF = feedback(FTMA, 1);
step(FTMA)

Czf=FTMF*degrau;

[n2,d2] = tfdata(minreal(FTMA),'v'); 
Kp = polyval(n2,1)/polyval(d2,1);
ess = 1/(1+Kp);

