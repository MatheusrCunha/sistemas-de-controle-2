clc
clear
 
% Período de amostragem
T = 0.2;

% função de transferência da planta
Gp=tf(1,[1 2 0]);
Gz=c2d(Gp,T);

% polo desejado
zeta=0.6;
wn=4;
s1=-zeta*wn+1i*wn*sqrt(1-zeta^2);
z1=exp(s1*T);

% Controlador
% Gd(z) = Kc*(z+alfa)/(z+beta)

% considalfaerando que o zero do controlador (alfa) cancela um polo da planta
polos = pole(Gz); % retorna os polos  a planta
alfa = -polos(2); %Seleciona o segundo polo

G2z=minreal(tf([1 alfa],1,T)*Gz); %Multiplica o compensador (z + alfa) pela planta Gz
[n2,d2]=tfdata(G2z,'v');

% fi2 é o ângulo de G2z quando z=z1
fi2=angle(polyval(n2,z1)/polyval(d2,z1));
% fi1 é o ângulo de G1z quando z=z1
fi1=-pi-fi2;
beta=(imag(z1)-real(z1)*tan(-fi1))/tan(-fi1);

G1z = tf(1,[1 beta],T);

FTMA = G1z*G2z;

[n,d]=tfdata(FTMA,'v');
k=1/abs(polyval(n,z1)/polyval(d,z1));

Cz=tf([1 alfa],[1 beta],T)*k;

FTMA=minreal(Cz*Gz);
FTMF=minreal(feedback(Cz*Gz,1));
pole(FTMF)

aux = tf([1 -1],[1 0],T);

[n,d] = tfdata(minreal(aux*FTMA/T),'v');
kv = polyval(n,1)/polyval(d,1);
ess=1/kv;





