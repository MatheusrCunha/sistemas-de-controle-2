% Representação do Sistema no Espaço de Estados
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

% Condições Iniciais
x0=[1; 1; 1];

% entrada nula
t=0:30/999:30;
u=zeros(1,length(t));

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

clear u
T=0.0001;
k=0:.12/T;

u=ones(1,length(k));

% Condições Iniciais
x1(1)=0;  %  para k = 0
x2(1)=0;  %  para k = 0
x1_ponto(1)=0;  %  para k = 0
x2_ponto(1)=0;  %  para k = 0
y(1)=0;  %  para k = 0

for j=2:length(k)
    
    x1(j)=T*x1_ponto(j-1)+x1(j-1);
    x2(j)=T*x2_ponto(j-1)+x2(j-1);    
      
    x1_ponto(j)=A(1,1)*x1(j)+A(1,2)*x2(j);  
    x2_ponto(j)=A(2,1)*x1(j)+A(2,2)*x2(j)+B(2)*u(j);  
    
    y(j)=C(1)*x1(j);
end

subplot(2,2,1)
plot(k*T,x1,'O')
ylabel('x1')
grid on;
subplot(2,2,2)
plot(k*T,x2,'O')
ylabel('x2')
grid on;
subplot(2,2,3)
plot(k*T,y,'O')
ylabel('y')
grid on;

hold off

