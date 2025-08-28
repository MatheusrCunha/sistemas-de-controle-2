% Exemplo de Algoritmo de Equa��es Recursivas
% Circuito RC
clc
clear
format long

V3 = 10;
Vo = 100
R = 23;
C = 1000e-6;
NT = 23;

Io = 16;            % valor inicial
T = 5e-3;             % período de amostragem
RC = R*C;    % constante RC
Tf = NT*10e-3;             % tempo final de simula��o em segundos
a = exp(-T/RC);
b = 1 - exp(-T/RC);
% a=0.2;


% Gráfico "contínuo" com 1000 pontos
t = 0:Tf/999:Tf;
V1 = Vo*exp(-t/RC);
figure(1)           %cria uma figura
plot(t,V1)
hold on             %lembrar de hold off no final

% Gráfico discreto
k = 0:Tf/T;
V2 = Vo*exp(-k*T/RC);
plot(k*T,V2,'*r')
%figure(2)

% Gráfico discreto a partir da equação recursiva

% Condi��o Inicial
I3(1) = Vo;   % para k = 0

% no matlab o primeiro índice é 1 e não 0

for j=1:length(k)-1
    I3(j+1)=a*I3(j);
end
%figure(3)
plot(k*T,I3,'ok')
hold off

% ou
%for j=2:length(k) % pq 2??
%     I3(j)=a*I3(j-1);
%end
%figure(4)
%plot(k*T,I3,'ok')

% Gráfico "contínuo" com 1000 pontos
t = 0:Tf/999:Tf;
V4 = V3*(1-exp(-t/RC));
figure(4)           %cria uma figura
plot(t,V4)
hold on

% Gráfico discreto
k = 0:Tf/T;
V5 = V3*(1-exp(-k*T/RC));
%figure(5)
plot(k*T,V5,'*r')

I4(1) = 0;   % para k = 0

% no matlab o primeiro índice é 1 e não 0

for j=1:length(k)-1
    I4(j+1)=a*I4(j) + b*V3;
end
%figure(6)
plot(k*T,I4,'ok')

hold off
