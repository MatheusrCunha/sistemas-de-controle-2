% Exemplo de Equacionamento da função de transferência discreta de um sistema contínuo mais amostrador ideal mais ZOH
% Slide 18

% Função de Transferência Contínua

Gs=tf(1,[1 1 0]);

% Período de amostragem

T = 1;

% Função de Transferência Discreta

Gz=c2d(Gs,T)
