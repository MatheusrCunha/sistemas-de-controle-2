% Equação recursiva

% Equações obtidas anteriormente

% Cz =
%  
%   3.088 z^2 - 4.92 z + 2.191
%   --------------------------
%     z^2 - 1.311 z + 0.3113

% Gz =
%    0.09073 z + 0.0792
%  ----------------------
%   z^2 - 1.497 z + 0.6666

%FTMF =
 
%    0.2232 z + 0.1948
%  ----------------------
%  z^2 - 1.005 z + 0.4228
 
% Sample time: 0.0024434 seconds

% Periodo de amostragem
T=0.0033;

% Degrau de 1 a 1.5
opt = stepDataOptions('InputOffset',1,'StepAmplitude',.5);

% FTMF da planta controlada
CGz = tf([0.2232 0.1948],[1 -1.005 0.4228],T);

% Grafico resposta ao degrau FTMF
[a,b]=step(CGz,opt);
ti=0.06109:T:0.12109-T;
stairs(ti,a)

hold on
% Serie recursiva
kmax=25;
t = 0:kmax*2-1;

% Degrau de 1 a 1.5
r = ones(1,kmax);
r = [r 1.5*r];

% Condições iniciais
y(1)= 0;
e(1) = r(1)-y(1);
u(1) = 2.46*e(1);
y(2)= 0.6666*y(1)+1.497*y(1);
e(2) = r(2)-yr(2);
u(2) = 2.46*e(2)-3.682*e(1)+1.228*u(1);

for k = 3:kmax*2
    y(k) = 1.497*y(k-1)-0.6666*y(k-2)+0.09073*u(k-1)+0.7292*u(k-2);
    e(k) = r(k) - y(k);
    u(k) = 1.228*u(k-1)-0.228*u(k-2)+2.46*e(k)-3.682*e(k-1)+1.64*e(k-2);​
end

% Resposta da planta controlada usando eq recursiva
plot(t*T,yr,'*')
% Parâmetros para o grafico
xlim([0.06,0.12]);
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('GCz', 'GC EQ Recursiva');
hold off

% Ação do controlador usando eq recursiva
figure(2)
plot(t*T,u,'*')
% Parâmetros para o grafico
xlim([0.06,0.12]);
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('C EQ Recursiva');
