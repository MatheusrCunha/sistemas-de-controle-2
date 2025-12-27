clc;
clear all;
close all;

tf = 100e-3;
R1 = 5;
R2 = 5;
L = 20e-3;
C1 = 1000e-6;
C2 = 1000e-6;

A = [-1/(C1*R1) 0 1/C1; 0 -1/(C2*R2) -1/C2; -1/L 1/L 0];
B = [0; 1/(C2*R2); 0];
C = [1 0 0];
D = 0;

% observador de ordem mínima
Abb=[-200 -1000;50 0];
Aab=[0 1000];
L=[-100 -100];
Ke=acker(Abb',Aab',L)';

Aaa=-200;
Aba=[0;-50];
Ba=0;
Bb=[200;0];

Achapeu=Abb-Ke*Aab;
Bchapeu=Achapeu*Ke+Aba-Ke*Aaa;
Fchapeu=Bb-Ke*Ba;

Cchapeu=[0 0;1 0;0 1];
Dchapeu=[1;Ke];

% simulação com equações recursivas

t = 0:tf/1000:tf;
T = 0.0001;
k = 0:tf/T;

r = ones(1,length(t));
r(1) = 0;
u=ones(1,length(k));

% condições iniciais
x1(1)=0;
x2(1)=0;
x3(1)=0;
x1_pto(1)=0;
x2_pto(1)=0;
x3_pto(1)=0;
y(1)=C(1)*x1(1)+C(2)*x2(1)+C(3)*x3(1);

eta1(1)=0;
eta2(1)=0;
eta1_pto(1)=Fchapeu(1)*u(1);
eta2_pto(1)=Fchapeu(2)*u(1);

for j=2:length(k)
% sistema original
   % Equações dos integradores
    x1(j) = T*x1_pto(j-1)+x1(j-1);
    x2(j) = T*x2_pto(j-1)+x2(j-1);
    x3(j) = T*x3_pto(j-1)+x3(j-1);
    
    % Equação diferencial de estados:  Xponto=A*X+B*U
    x1_pto(j) = A(1,1)*x1(j)+A(1,2)*x2(j)+A(1,3)*x3(j)+B(1)*u(j); 
    x2_pto(j) = A(2,1)*x1(j)+A(2,2)*x2(j)+A(2,3)*x3(j)+B(2)*u(j); 
    x3_pto(j) = A(3,1)*x1(j)+A(3,2)*x2(j)+A(3,3)*x3(j)+B(3)*u(j);
        
    % Equação de Saída: Y=C*X+D*U
    y(j) = C(1)*x1(j)+C(2)*x2(j)+C(3)*x3(j)+D*u(j);

    % Equações dos integradores do observador
    eta1(j)=T*eta1_pto(j-1)+eta1(j-1);
    eta2(j)=T*eta2_pto(j-1)+eta2(j-1);
    % Equação diferencial de estados do observador
    eta1_pto(j)=Achapeu(1,1)*eta1(j)+Achapeu(1,2)*eta2(j)+Bchapeu(1)*y(j)+Fchapeu(1)*u(j);
    eta2_pto(j)=Achapeu(2,1)*eta1(j)+Achapeu(2,2)*eta2(j)+Bchapeu(2)*y(j)+Fchapeu(2)*u(j);
    % equação de saída do observador de ordem mínima
    xtil1(j)=Cchapeu(1,1)*eta1(j)+Cchapeu(1,2)*eta2(j)+Dchapeu(1)*y(j);
    xtil2(j)=Cchapeu(2,1)*eta1(j)+Cchapeu(2,2)*eta2(j)+Dchapeu(2)*y(j);
    xtil3(j)=Cchapeu(3,1)*eta1(j)+Cchapeu(3,2)*eta2(j)+Dchapeu(3)*y(j);
end

subplot(2,2,1)
plot(k*T,x1,'*')
subplot(2,2,2)
plot(k*T,x2,'*')
subplot(2,2,3)
plot(k*T,x3,'*')
subplot(2,2,4)
plot(k*T,y,'*')

%variáveis do observador
subplot(2,2,1)
plot(k*T,xtil1,'o')
subplot(2,2,2)
plot(k*T,xtil2,'o')
subplot(2,2,3)
plot(k*T,xtil3,'o')

hold off