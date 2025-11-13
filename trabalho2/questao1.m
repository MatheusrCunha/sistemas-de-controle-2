clc
clear
 
% Período de amostragem
T = 0.15;

Cz = tf([5.175 -4.455],[1 -0.5388],T);
Gs=tf(1,[1 1]);
Gz=c2d(Gs,T);

Hs=tf(1,[1 0]);
Hz=c2d(Gs,T);

GHz = c2d(Gs*Hs, T);

k = 0:25;       % kmax = 25

% Entrada: Rampa Unitária
r = k*T;


