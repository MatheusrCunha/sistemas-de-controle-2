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

% Resposta ao degrau da função original
sistema=ss(A,B,C,D);

% Informacoes de Projeto
Mp = 0.14;
ts5 = 0.023;                     

% Calculo do zeta e wn
syms zeta wn;
zeta = solve(Mp == exp(-pi*(zeta/sqrt(1-zeta^2))), zeta);
zeta = eval(zeta(1));
wn = 3/(zeta*ts5);

% Polos de malha fechada
s1=-zeta*wn+1i*wn*sqrt(1-zeta^2);
s2=-zeta*wn-1i*wn*sqrt(1-zeta^2);
s3=-10*abs(s1); 

eig(A)

% Matriz de Controlabilidade
M=ctrb(A,B);
% Teste de controlabilidade
rank(M)  

% Projeto do controlador / servosistema
A_chapeu = [A zeros(2,1);-C 0];
B_chapeu = [B;0];

% Matriz de ganhos do controlador K_chapeu = [k1 k2 -ki]
K_chapeu=acker(A_chapeu,B_chapeu,[s1 s2 s3]);

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
clear u
T = 1e-4;
k = 0:1:(0.15/T);
r = ones(1,length(k));


x1(1) = 0;
x2(1) = 0;
zeta(1) = 0;

u(1) = Ki*zeta(1);

x1_ponto(1) = B(1)*u(1);
x2_ponto(1) = B(2)*u(1);

y(1) = C(1)*x1(1) + C(2)*x2(1);
zeta_ponto(1) = r(1) - y(1);



x1o(1) = 0;
x2o(1) = 0;
y_o(1) = 0;


for j = 2:length(k)


    x1(j) = T*x1_ponto(j-1) + x1(j-1);
    x2(j) = T*x2_ponto(j-1) + x2(j-1);    
    zeta(j) = T*zeta_ponto(j-1) + zeta(j-1);

    u(j) = -(K(1)*x1(j) + K(2)*x2(j)) + Ki*zeta(j);

    x1_ponto(j) = A(1,1)*x1(j) + A(1,2)*x2(j) + B(1)*u(j);  
    x2_ponto(j) = A(2,1)*x1(j) + A(2,2)*x2(j) + B(2)*u(j); 

    y(j) = C(1)*x1(j) + C(2)*x2(j);
    zeta_ponto(j) = r(j) - y(j);



    u0 = r(j);

    x1o(j) = T*(A(1,1)*x1o(j-1) + A(1,2)*x2o(j-1) + B(1)*u0) + x1o(j-1);
    x2o(j) = T*(A(2,1)*x1o(j-1) + A(2,2)*x2o(j-1) + B(2)*u0) + x2o(j-1);

    y_o(j) = C(1)*x1o(j) + C(2)*x2o(j);

end


subplot(2,2,1)
plot(k*T,x1,'b')
ylabel('x1')
grid on

subplot(2,2,2)
plot(k*T,x2,'b')
ylabel('x2')
grid on

subplot(2,2,3)
plot(k*T,y_o,'r','LineWidth',1.5)
hold on
plot(k*T,y,'b','LineWidth',1.5)
ylabel('y')
xlabel('Tempo (s)')
legend('Planta Original','Servossistema')
grid on
