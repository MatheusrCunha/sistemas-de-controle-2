clear
clc

T=0.15;

Gs=tf(1,[1 4]);
Gz=c2d(Gs,T);

zeta=0.7;
wn=3;
beta1 = -1;
s1=-zeta*wn+1i*wn*sqrt(1-zeta^2);
z1=exp(s1*T);
zpk(Gz)
zplane(z1)

polos = pole(Gz); %polo a ser cancelado
alfa = -polos(1);

G2z = minreal(tf([1 alfa], 1, T) * Gz);
[n2,d2]=tfdata(G2z,'v');

% fi2 é o ângulo de G2z quando z=z1
fi2=angle(polyval(n2,z1)/polyval(d2,z1));
% fi1 é o ângulo de G1z quando z=z1
fi1=-pi-fi2;

% Polo do controlador
beta2=(imag(z1)-real(z1)*tan(-fi1))/tan(-fi1);

% Funcao de transferencia pulsada para o controlador, sem considerar o K
G1z=tf(1,[1 beta2],T);
FTMA = G1z*G2z;


% fi2=angle(polyval(n2,z1)/polyval(d2,z1));
% fi1=-pi-fi2;
% beta=(imag(z1)-real(z1)*tan(-fi1))/tan(-fi1);
% 
% G1z=tf(1,[1 beta],T);
% FTMA = G1z*G2z;
% 
% [n,d]=tfdata(FTMA,'v');
% K = 1/ abs(polyval(n,z1)/polyval(d,z1));
% 
% Cz = tf([1 alfa],[1 beta-1 -beta],T)*K;
% 
% FTMF = minreal(feedback(Cz*Gz,1));
% pole(FTMF)
% figure(1)
% step(FTMF)
% 
% FTMA=minreal(Cz*Gz);
% 
% figure(2)
% rlocus(FTMA)

