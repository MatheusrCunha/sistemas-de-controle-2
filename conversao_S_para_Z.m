% Exemplo de Equacionamento da fun��o de transfer�ncia discreta de um sistema cont�nuo mais amostrador ideal mais ZOH
% Slide 18

% Fun��o de Transfer�ncia Cont�nua

Gs=tf(1,[1 1 0]);

% Per�odo de amostragem

T = 1;

% Fun��o de Transfer�ncia Discreta

Gz=c2d(Gs,T)
