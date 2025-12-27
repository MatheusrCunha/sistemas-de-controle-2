clc; clear; close all;

%% ------------------------------------------------------------
%  PARÂMETROS DA PLANTA
%% ------------------------------------------------------------
NT = 23;
R1 = 2000 * NT;          % R1 = 46000 ohms
R2 = 18000;             % ohms
C1 = 100e-9;            % F
C2 = 680e-9;            % F

A = [ 0               1/C1 ;
     -1/(R1*R2*C2)   (-1/(R1*C2) - 1/(R2*C2)) ];

B = [0 ;
     1/(R1*R2*C2)];

C = [1 0];
D = 0;

%% ------------------------------------------------------------
%  CONFIGURAÇÕES DA SIMULAÇÃO
%% ------------------------------------------------------------
T = 0.1;              % período de amostragem
tf = 30;              % tempo final
k = 0:T:tf;           % vetor de tempo discreto

u = zeros(1, length(k));   % entrada (aqui: zero)
% u = ones(1,length(k));   % caso queira degrau

%% ------------------------------------------------------------
%  CONDIÇÕES INICIAIS
%% ------------------------------------------------------------
x = zeros(2, length(k));      % estados
xp = zeros(2, length(k));     % derivadas dos estados

x(:,1) = [0 ; 0];              % condições iniciais x1(0), x2(0)

y = zeros(1, length(k));
y(1) = C*x(:,1) + D*u(1);

%% ------------------------------------------------------------
%  SIMULAÇÃO – EQUAÇÕES A DIFERENÇAS
%% ------------------------------------------------------------
for j = 2:length(k)

    % ► Integradores (método de Euler)
    x(:,j) = x(:,j-1) + T * xp(:,j-1);

    % ► Dinâmica dos estados:  xp = A*x + B*u
    xp(:,j) = A*x(:,j) + B*u(j);

    % ► Saída
    y(j) = C*x(:,j) + D*u(j);
end

%% ------------------------------------------------------------
%  GRÁFICOS
%% ------------------------------------------------------------
figure;
subplot(3,1,1);
plot(k, x(1,:), 'LineWidth',2);
grid on;
title('Estado x_1(k)');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(k, x(2,:), 'LineWidth',2);
grid on;
title('Estado x_2(k)');
xlabel('Tempo (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(k, y, 'LineWidth',2);
grid on;
title('Saída y(k)');
xlabel('Tempo (s)');
ylabel('Amplitude');
