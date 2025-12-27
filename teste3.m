% Representação do Sistema no Espaço de Estados
clc;
clear;
close all;
format long;

R1=40000;
R2=18000;
C1=100*10^-9;
C2=680*10^-9;

A=[0 1/C1;-1/(R1*R2*C2) (-1/(R1*C2))+(-1/(R2*C2))];
B=[0;1/(R1*R2*C2)];
C=[1 0];
D=0;

% Resposta ao degrau da função original
sistema=ss(A,B,C,D)

figure(1)
step(sistema)

[Y,t,X] = step(sistema);
% Separando as partes
figure(2)
subplot(2,2,1)
plot(t,X(:,1))
hold on
title('Vc1')
xlabel('Tempo (s)')
ylabel('Vc1 (V)')
subplot(2,2,2)
plot(t,X(:,2))
hold on
title('Ic1')
xlabel('Tempo (s)')
ylabel('Ic1 (A)')
subplot(2,2,3)
plot(t,Y)
hold on
title('y')
xlabel('Tempo (s)')
ylabel('y (V)')

% Especificações do projeto
Mp = 0.16;
ts5 = 0.020;                     

% Calculo do zeta e wn
syms zeta wn
zeta = solve(Mp == exp(-pi*(zeta/sqrt(1-zeta^2))), zeta);
zeta = eval(zeta(1))
wn = 3/(zeta*ts5)

% Polos de malha fechada
s1=-zeta*wn+j*wn*sqrt(1-zeta^2)
s2=-zeta*wn-j*wn*sqrt(1-zeta^2)
s3=-10*abs(s1)   

% Matriz de Controlabilidade
M=ctrb(A,B)
% Teste de controlabilidade
rank(M)  

% Projeto do controlador / servosistema
A_chapeu = [A zeros(2,1);-C 0];
B_chapeu = [B;0];

% Matriz de ganhos do controlador K_chapeu = [k1 k2 -ki]
K_chapeu=acker(A_chapeu,B_chapeu,[s1 s2 s3])

% Verificando
eig(A_chapeu-B_chapeu*K_chapeu);

K = [K_chapeu(1) K_chapeu(2)];
Ki = -K_chapeu(3);
AA = [A-B*K B*Ki;-C 0];
BB = [0;0;1];
CC = [1 0 0];
DD = 0;

% Resposta ao degrau do controlador e original
figure(3)
step(sistema)
hold on
step(AA,BB,CC,DD)
title('Resposta ao Degrau da Planta Original e Controlador')
legend('Planta Original', 'Controlador')
hold off