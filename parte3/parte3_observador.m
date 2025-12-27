% Exemplo de Projeto de Observador de Ordem Plena
% Verificação dos estados observados através do sistema expandidoclc
clear
format long

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

% Informacoes de Projeto
Mp = 0.14;
ts5 = 0.023;                     

% Calculo do zeta e wn
syms zeta wn;
zeta = solve(Mp == exp(-pi*(zeta/sqrt(1-zeta^2))), zeta);
zeta = eval(zeta(1));
wn = 3/(zeta*ts5);

% Polos de malha fechada
s1=-zeta*wn+1i*wn*sqrt(1-zeta^2);
s2=-zeta*wn-1i*wn*sqrt(1-zeta^2);
s3=-10*abs(s1); 

u1 = s1;
u2 = s2;

% Matriz de observabilidade
N=[conj(C') conj(A')*conj(C')];
rank(N)

% Matriz de Ganhos do Observador
Ke=acker(A',C',[u1 u2])';

% Verificação através do sistema expandido
AA=[A zeros(length(A));Ke*C A-Ke*C];
BB=[B;B];
CC=eye(2*length(A));
DD=zeros(2*length(A),1);
sys=ss(AA,BB,CC,DD);
step(sys)

% polinomio característico desejado
Pd=conv([1 -u1],[1 -u2]);
alfa1=Pd(2);
alfa2=Pd(3);

% polinomio característico original
P=poly(A);
a1=P(2);
a2=P(3);

% Matriz de observabilidade
N=[conj(C') conj(A')*conj(C')];
rank(N)

W=[a1 1;1 0];

% Matriz de Transformação

Q=inv(W*conj(N'));

% Matriz de Ganho do Observador

Ke=Q*[alfa2-a2;alfa1-a1];

eig(A-Ke*C);

figure()
t=0:0.00001:0.14;
AAA = [A zeros(length(A)); Ke*C A-Ke*C];
BBB = [B;B];
CCC = eye(2*length(A));
DDD = zeros(2*length(A),1);

% step(sistema)
% hold on
% so = step(AAA,BBB,CCC,DDD,1,t);
% plot(t, so(:,1), 'r', 'LineWidth', 1.5)   % curva em vermelho
% title('Resposta ao Degrau da Planta Original X Observador de Ordem Plena')
% legend('Planta Original', 'Observador de Ordem Plena')
% hold off

% Condições Iniciais


figure()
[Y,t,X]=step(sistema);

% separando os elementos do vetor X
x1a=X(:,1);
x1b=X(:,2);

% figure(1)
% subplot(2,2,1)
% plot(t,x1a,'b')
% hold on
% subplot(2,2,2)
% plot(t,x1b,'b')
% hold on
% subplot(2,2,3)
% plot(t,Y,'b')
% hold on

clear u
T = 3.3e-3;     % período de amostragem de 3,3 ms
TempoTotal = 0.15;  
k = 0 : T : TempoTotal;
u=ones(1,length(k));

% condições iniciais
x1(1)=0;  %  para k = 0
x2(1)=0;  %  para k = 0
x1_ponto(1)=B(1);  %  para k = 0
x2_ponto(1)=B(2);  %  para k = 0

y(1)=C(1)*x1(1)+C(2)*x2(1)+D*u(1);  %  para k = 0

% condições iniciais do observador
x1_obs(1)=0;  %  para k = 0
x2_obs(1)=0;  %  para k = 0

y_obs(1)=C(1)*x1_obs(1)+C(2)*x2_obs(1)+D*u(1);  %  para k = 0

x1_ponto_obs(1)=B(1)*u(1)+Ke(1)*(y(1)-y_obs(1));  %  para k = 0
x2_ponto_obs(1)=B(2)*u(1)+Ke(2)*(y(1)-y_obs(1));  %  para k = 0

for j=2:length(k)
    % Equações dos integradores
    x1(j)=T*x1_ponto(j-1)+x1(j-1);
    x2(j)=T*x2_ponto(j-1)+x2(j-1);    
    
    % Equação diferencial de estados:  Xponto=A*X+B*U
    x1_ponto(j)=A(1,1)*x1(j)+A(1,2)*x2(j)+B(1)*u(j);  
    x2_ponto(j)=A(2,1)*x1(j)+A(2,2)*x2(j)+B(2)*u(j); 
    % Equação de Saída: Y=C*X+D*U
    y(j)=C(1)*x1(j)+C(2)*x2(j)+D*u(j);
    
    % Equações dos integradores do observador
    x1_obs(j)=T*x1_ponto_obs(j-1)+x1_obs(j-1);
    x2_obs(j)=T*x2_ponto_obs(j-1)+x2_obs(j-1);    
    
     % Equação de Saída observador: Y=C*X+D*U
     y_obs(j)=C(1)*x1_obs(j)+C(2)*x2_obs(j)+D*u(j);
    
    % Equação diferencial de estados do observador:
    % Xponto=A*X+B*U+Ke(y-C*x)
    x1_ponto_obs(j)=A(1,1)*x1_obs(j)+A(1,2)*x2_obs(j)+B(1)*u(j)+Ke(1)*(y(j)-y_obs(j));  
    x2_ponto_obs(j)=A(2,1)*x1_obs(j)+A(2,2)*x2_obs(j)+B(2)*u(j)+Ke(2)*(y(j)-y_obs(j)); 
   
end

subplot(2,2,1)
plot(k*T,x1_obs,'*')
ylabel('x1')
subplot(2,2,2)
plot(k*T,x2_obs,'*')
ylabel('x2')
subplot(2,2,3)
plot(k*T,y_obs,'*')
ylabel('y')
legend('Planta Original', 'Observador')
