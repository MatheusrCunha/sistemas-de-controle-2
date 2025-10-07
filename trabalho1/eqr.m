% Equação recursiva (usando suas condições iniciais)

% Periodo de amostragem
T = 0.0033;

% Degrau de 1 a 1.5
opt = stepDataOptions('InputOffset',1,'StepAmplitude',.5);

% FTMF da planta controlada
CGz = tf([0.2232 0.1948],[1 -1.005 0.4228],T);

% Grafico resposta ao degrau FTMF
[a,b] = step(CGz,opt);   % a = saída, b = tempo
stairs(b,a)


% Serie recursiva
kmax = 25;
t = 0:kmax*2-1;

% Degrau de 1 a 1.5 (2*kmax amostras)
r = ones(1,kmax);
r = [r 1.5*r];

% Prealocar vetores para segurança
N = kmax*2;
y = zeros(1,N);
u = zeros(1,N);
e = zeros(1,N);

% Condições iniciais (suas, corrigidas apenas sintaticamente)
y(1) = 0;
e(1) = r(1) - y(1);
u(1) = 2.46 * e(1);

% observação: mantive exatamente a sua expressão para y(2)
y(2) = 0.6666*y(1) + 1.497*y(1);
e(2) = r(2) - y(2);
u(2) = 2.46*e(2) - 3.682*e(1) + 1.228*u(1);

% Loop recursivo
for k = 3:N
    % Planta (usando os coeficientes originais)
    y(k) = 1.497*y(k-1) - 0.6666*y(k-2) + 0.09073*u(k-1) + 0.0792*u(k-2);
    
    % Erro
    e(k) = r(k) - y(k);
    
    % Controlador (linha corrigida, sem caracteres invisíveis)
    u(k) = 1.228*u(k-1) - 0.228*u(k-2) + 2.46*e(k) - 3.682*e(k-1) + 1.64*e(k-2);
end

% Resposta da planta controlada usando eq recursiva
plot(t*T,y,'*')

% Parâmetros para o grafico
xlim([0.06,0.12]);
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('GCz', 'GC EQ Recursiva');
hold off

% Ação do controlador usando eq recursiva
figure(2)
plot(t*T,u,'*')
xlim([0.06,0.12]);
xlabel('Tempo (s)');
ylabel('Amplitude');
legend('C EQ Recursiva');
