clear
clf
clc

%Nome:Matheus Rodrigues da Cunha

Gs = tf(1, [1 1]);
Hs = tf(1,[1 0]);

% Per�odo de amostragem

T = .2;

Gz=c2d(Gs,T);
Hz=c2d(Hs,T);

% Fun��o de Transfer�ncia em malha fechada
% Caso b) medidor digital
FTMFb=feedback(Gz,Hz)  % ou  minreal(Gz/(1+Gz*Hz))
step(FTMFb)
axis([0 16 -0.2 0.6])
grid

hold on

k = 0:16/T;

r = ones(1,length(k));

%equa��o recursiva caso b

y(1) = 0; %para k = 0
v(1) = 0;
e(1) = r(1)-v(1);

for j=2:length(k)
    y(j)=0.1813*e(j-1)+0.8187*y(j-1);
    v(j)=0.2*y(j-1)+v(j-1);
    e(j) = r(j)-v(j);
      
end
plot(k*T,y,'ok')

hold off

%equa��o recursiva caso a

y(1) = 0; %para k = 0
v(1) = 0;
e(1) = r(1)-v(1);

GHz=c2d(Gs*Hs,T);

for j=2:length(k)
    v(j)=0.01873*e(j-1)+0.01752*e(j-2)+1.819*v(j-1)+0.8187(j-1);
      
end
plot(k*T,y,'ok')



% Fun��o de Transfer�ncia em malha fechada
% Caso a) medidor anal�gico
% FTMFa=minreal(Gz/(1+GHz))  % n�o � possivel usar o comando feedback
% figure(1)
% subplot(2,1,1)
% step(FTMFa)
% axis([0 16 -0.2 0.6])
% grid


