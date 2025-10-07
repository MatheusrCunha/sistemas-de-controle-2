
clc
clear
format long
% Periodo de amostragem
T = 0.0033;

% Degrau de 1 a 1.5
opt = stepDataOptions('InputOffset',1,'StepAmplitude',.5);

% FTMF da planta controlada
CGz = tf([0.2232 0.1948],[1 -1.005 0.4228],T);

[y,t] = step(CGz,opt);

stairs(t,y,'LineWidth',1.5)
title('Resposta ao degrau da FTMF')

kmax=24;

t = (0:(kmax*2-1));
r = ones(1,kmax);
r = [r 1.5*r];
% Condições iniciais
yr(1)= 0;
e(1) = r(1)-yr(1);
u(1) = 2.46*e(1);
yr(2)= 0.09073*u(1)+1.497*yr(1);
e(2) = r(2)-yr(2);
u(2) = 2.46*e(2) -3.682*e(1)+1.228*u(1);
% 

hold on

for k = 3:length(t)
    yr(k)= 0.09073*u(k-1) + 0.0792*u(k-2) + 1.497*yr(k-1) - 0.6666*yr(k-2);
    e(k) = r(k) - yr(k);
    u(k) = 2.46*e(k) - 3.682*e(k-1) + 1.64*e(k-2) + 1.228*u(k-1) - 0.228*u(k-2);
end

figure(1);
plot(t((length(t)/2):end)*T, yr((length(t)/2):end), 'r*');
figure(2);
plot(t((length(t)/2):end)*T, u((length(t)/2):end), 'r*');
