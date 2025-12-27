clc;
clear all;

tf = 100e-3;

A = [-200 0 1000; 0 -200 -1000; -50 50 0];
B = [0; 200; 0];
C = [1 0 0];
D = 0;

sistema = ss(A, B, C, D);
% Matriz de controlabilidade
M = ctrb(A,B);
posto = rank(M);

% Forma Controlável
[b, a] = ss2tf(A, B, C, 0);
AC = [0 1;-a(3) -a(2)];
BC = [0; b(3)];
CC= [1 0];
sistemaControlavel = ss(AC, BC, CC, 0);

% Polos do Controlador
zeta = 0.7;
wn = 500;

p1 = -zeta*wn + i*wn*sqrt(1-zeta^2);
p2 = -zeta*wn - i*wn*sqrt(1-zeta^2);
p3 = 10 * real(p1);
p4 = 10 * real(p1); 

P = [p1 p2 p3 p4];

% Observabilidade do sistema
OB = [C' ((A')*(C'))];
postoOB = rank(OB);

if postoOB == size(A,1)
    disp('Sistema completamente observável');
    const_obs = 2;
    PO = [real(const_obs*P(1)) real(const_obs*P(1))];
    Ke = acker(A',C', PO)';
else
    disp('Sistema não é completamente observável');
end

% Controle
n = size(A);
A_hat = [A zeros(n(1),1); -C 0];
B_hat = [B; 0];

K_hat = acker(A_hat, B_hat, P);
K = zeros(1, 2);

for i = 1:length(K_hat)-1
    K(i) = K_hat(i);
end

MatrizDeGanhoDoControlador = K;

ki = -K_hat(1+i);

AA = A_hat-B_hat*K_hat;
BB = vertcat(zeros([rank(A),1]), 1);
CC = horzcat(C, 0);
DD = D;
sistCtrl = ss(AA, BB, CC, DD);

ErroParaEntradaDeDegrauUnitario = 1 + CC*inv(AA)*BB;

% Comparação entre o sistema sem e com controle
figure();
stepplot(sistema);
hold on;
step(sistCtrl);
legend('Sem controle','Com controle', 'Location', 'southeast');
grid on;

tp_teorico = pi/(wn*sqrt(1-zeta^2));
Mp_teorico = exp(-pi*zeta/sqrt(1-zeta^2));

info_sistCtrl = stepinfo(sistCtrl,'SettlingTimeThreshold',0.05);
tp_simulado = info_sistCtrl.PeakTime;
Mp_simulado = info_sistCtrl.Peak - 1;


dados = {'Mp';'tp'};
ValorTeorico = [Mp_teorico;tp_teorico];
ValorDaSimulacao = [Mp_simulado;tp_simulado];
T = table(ValorTeorico,ValorDaSimulacao,'RowNames',dados);