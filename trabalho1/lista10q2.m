clc
clear

T=0.1;

%rampa = T * tf([1 0], [1 -2 1], T);

Gs=tf(1, [1 1]);

Gz=c2d(Gs, T);

Hs=tf(1, [1 0]);

Hz=c2d(Hs, T);

FTMA = Gz;

FTMF = feedback(FTMA, Hz);
step(FTMF)

aux=minreal(tf([1 -1],[1 0],T)*FTMA);  % onde tf([1 -1],[1 0],T) = (z-1)/z = 1-z^-1
[n,d]=tfdata(aux,'v');
kv=(polyval(n,1)/polyval(d,1))/T;  % substituindo 1 em aux
ess=1/kv;

