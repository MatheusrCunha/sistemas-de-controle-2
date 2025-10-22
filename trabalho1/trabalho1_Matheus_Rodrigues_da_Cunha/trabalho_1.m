clear
clc

% ------------- Resposta ao degrau unitário -------------
% ***** Digite o numerador e o denominador da função de transferência *****
num = 19316.8821;
den = [1 122.8849 19316.8821];

Gs = tf(num, den);
opt = stepDataOptions('InputOffset',1,'StepAmplitude',.5);
%Gz = c2d(Gs);
% ***** Digite o seguinte comando de resposta ao degrau *****
step(Gs, opt)
% ***** Digite os comandos para inserir a grade e o título do gráfico *****
grid
title (' Resposta ao Degrau Unitário de G(s) =')
figure(1)

%S = stepinfo(Gs); 

%Controlador Plano Z Lugar Raizes
% Informacoes de Projeto
Mp = 0.14;
ts5 = 0.023;                     % Tempo de acomodacao(5%)
Ta = 3.3e-3;
%Calculo Fator de Amortecimento (Zeta)
Zeta=sqrt(log(Mp)^2/(pi^2+log(Mp)^2));

%Calculo Frequência Natural não amortecida (Wn)
Wn=3/(Zeta*ts5);

%Z1 Polo dominante de Malha Fechada desejado
s1=-Zeta*Wn+1j*Wn*sqrt(1-Zeta^2);
z1=exp(s1*Ta);

Gz=c2d(Gs,Ta);
disp('Gz:')
% zpk(Gz)
% zplane(z1)
% figure(2)

[num,den]=tfdata(Gz,'v');
G2z=minreal(tf([num(2) num(3)],[1 -1],Ta));
[n2,d2]=tfdata(G2z,'v');

% fi2 é o ângulo de G2z quando z=z1
fi2=angle(polyval(n2,z1)/polyval(d2,z1));
% fi1 é o ângulo de G1z quando z=z1
fi1=-pi-fi2;

% Polo do controlador
beta=(imag(z1)-real(z1)*tan(-fi1))/tan(-fi1);

% Funcao de transferencia pulsada para o controlador, sem considerar o K
G1z=tf(1,[1 beta],Ta);
FTMA = G1z*G2z;

% Calculo do ganho k
[n,d]=tfdata(FTMA,'v');
K = 1/ abs(polyval(n,z1)/polyval(d,z1));
 
 % Bloco controlador
Cz = tf(den,[1 beta-1 -beta],Ta)*K;

%Função de Tranferencia de malha fechada
FTMF = minreal(feedback(Cz*Gz,1));

% Verificação do polo de malha fechada alcançado
pole(FTMF)

% Degrau de 1 a 1.5
opt = stepDataOptions('InputOffset',1,'StepAmplitude',.5);

figure(4)
step(FTMF, opt)
S = stepinfo(FTMF);
 
 
 
 
 
