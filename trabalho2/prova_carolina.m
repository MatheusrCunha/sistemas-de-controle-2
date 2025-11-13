clc
clear
 
% Período de amostragem
T = 0.2;

Zeta=0.6;
Wn=4;

%Frequência Natual amortecida (Wd)
Wd=Wn*sqrt(1-Zeta^2);

%Frequência amostragem (Ws)
Ws=2*pi/T;

%Polos de malha fechada
s1=-Zeta*Wn+1i*Wn*sqrt(1-Zeta^2);
z1=exp(s1*T);

gs=tf(1,[1 2]);
ghs=tf(1,[1 0]);

gz=c2d(gs,T);
ghz=c2d(ghs*gs,T);

disp('Gz:')
zpk(ghz)

%considerando o alfa dado
alfa = -0.6;

G2z=minreal(tf([1 alfa],1,T)*ghz);
[n2,d2]=tfdata(G2z,'v');

fi2=angle(polyval(n2,z1)/polyval(d2,z1));
fi1=-pi-fi2;
beta=(imag(z1)-real(z1)*tan(-fi1))/tan(-fi1);

num2=[1 alfa];
den2=[1 beta];
cz=tf(num2,den2,T);

ftma1=minreal(cz*ghz)
disp('FTMA sem K')
zpk(ftma1)