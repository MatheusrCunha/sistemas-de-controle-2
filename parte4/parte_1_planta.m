% Representação do Sistema no Espaço de Estados
clc;
clear;
close all;
format long;

R1=46000;
R2=18000;
C1=100*10e-9;
C2=680*10e-9;

A=[0 1/C1;-1/(R1*R2*C2) (-1/(R1*C2))+(-1/(R2*C2))];
B=[0;1/(R1*R2*C2)];
C=[1 0];
D=0;

[NUM,DEN] = ss2tf(A,B,C,D);
% convertendo para função de tranferência com a utilização da função do
% Matlab
[n,d] = ss2tf(A,B,C,D);
G2 = tf(n,d);

% Resposta ao degrau da função original
sistema=ss(A,B,C,D);
figure()
step(sistema)
[Y,t,X] = step(sistema);
title('Resposta ao Degrau da Planta Original')
% Separando as partes
figure()
subplot(2,1,1)
plot(t,X(:,1))
title('x1')
subplot(2,1,2)
plot(t,X(:,2))
title('x2')

% % Matriz de Controlabilidade
M=ctrb(A,B);
% % Teste de controlabilidade
rank(M)  
n = size(A,1); %número de estados do sistema

% Matriz de observabilidade
O = obsv(A, C);

% Teste de observabilidade
n = size(A,1);   % número de estados
rank(O)
