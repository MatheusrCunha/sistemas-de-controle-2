clc;
clear;

T = 0.2; 
gs=tf(1, [1 4]);
gz = c2d(gs, T);
r = tf([1 0], [1 -1], T);

cz = tf(0.1813, [1 -0.8187],T);

FTMA = cz*gz;
FTMF = feedback(cz*gz,1);
step(FTMF);
Ck = FTMF*r;

[n2,d2] = tfdata(minreal(FTMA),'v'); 
Kp = polyval(n2,1)/polyval(d2,1);
ess = 1/(1+Kp);

