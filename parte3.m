% Projeto do observador de ordem plena
clc;
clear;
close all;
format long;

NT=23;
R1=2000*NT;
R2=18000;
C1=100*10^-9;
C2=680*10^-9;

A=[0 1/C1;-1/(R1*R2*C2) (-1/(R1*C2))+(-1/(R2*C2))];
B=[0;1/(R1*R2*C2)];
C=[1 0];
D=0;

% Informacoes de Projeto
Mp = 0.07;
ts5 = 0.23;                     

% Calculo do zeta
syms zeta
zeta = solve(Mp == exp(-pi*(zeta/sqrt(1-zeta^2))), zeta);
zeta = eval(zeta(1));

% Calculo da frequencia natutral nao amortecida (Wn), dos polos dominantes
% de malha fechada.
wn = 3/(zeta*ts5);

% Calculo da frequencia natural amortecida (Wd).
wd = wn*sqrt(1-zeta^2);

s1=-zeta*wn+1i*wn*sqrt(1-zeta^2);
s2=-zeta*wn-1i*wn*sqrt(1-zeta^2);
s3=-10*abs(s1);   % Autovalor adicional para o projeto, valor mais alto que a parte real de s1 para maior estabilidade.

% Autovalores (polos de malha fechada desejados)
p1=s1;
p2=s2;

%Projeto do observador de ordem plena
PO = 1.8.*[real(p1) real(p2)];
Ke = acker(A',C',PO)';
eig(A-Ke*C)

AO = [A zeros(length(A)); Ke*C A-Ke*C];
BO = [B;B];
CO = eye(2*length(A));
DO = zeros(2*length(A),1);
ax = gca;
ax.YLim = [0 1.5];
hold on
so = step(AO,BO,CO,DO,1,t);
plot(t,so(:,1),'ko')
step(AA,BB,CC,DD,1,t);
sori = step(A,B,C,D,1,t);
plot(t,sori,'r','LineWidth',2),legend('Observador','Controlado','Sem controle');
hold off
