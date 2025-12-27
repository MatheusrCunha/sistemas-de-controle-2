clc; 
clear all; 
close all;

R1 = 5;
R2 = 5;
L = 20e-3;
C1 = 1000e-6;
C2 = 1000e-6;
t = 0:1e-6:100e-3;

A = [-1/(C1*R1) 0 1/C1; 0 -1/(C2*R2) -1/C2; -1/L 1/L 0];
B = [0; 1/(C2*R2); 0];
C = [1 0 0];
D = 0;

ysistema = ss(A,B,C,D);
% entrada nula
u=zeros(1,length(t));

figure(1)
step(ysistema)

% Equações recursivas
T = 5e-4;
tf = 100e-3;
k=0:tf/T;

u  = ones (1,length(k));
x1 = zeros(1,length(k));
x2 = zeros(1,length(k));
x3 = zeros(1,length(k));
x1_pto= zeros(1,length(k));
x2_pto= zeros(1,length(k));
x3_pto= zeros(1,length(k));
y  = zeros(1,length(k));
y(1)=C(1)*x1(1)+C(2)*x2(1)+C(3)*x3(1)+D*u(1);

for i=2:length(k)
   x1(i) = T*x1_pto(i-1)+x1(i-1);
   x2(i) = T*x2_pto(i-1)+x2(i-1);
   x3(i) = T*x3_pto(i-1)+x3(i-1);

   y(i)  = C(1)*x1(i)+C(2)*x2(i)+C(3)*x3(i)+D*u(i);

   x1_pto(i)= A(1,1)*x1(i)+A(1,2)*x2(i)+A(1,3)*x3(i)+B(1)*u(i);
   x2_pto(i)= A(2,1)*x1(i)+A(2,2)*x2(i)+A(2,3)*x3(i)+B(2)*u(i);
   x3_pto(i)= A(3,1)*x1(i)+A(3,2)*x2(i)+A(3,3)*x3(i)+B(3)*u(i);
end

u_cont = ones(1, length(t));  
[y_continuo, t_continuo, x_continuo] = lsim(ysistema, u_cont, t);

figure('Name','Gráfico Vo(kt)');
hold on
plot(k*T, y, '*', 'DisplayName', 'Eq. recursiva');             
plot(t_continuo, y_continuo, 'r', 'LineWidth', 2,'DisplayName','Simulação contínua');                       
grid;
legend;
title('Comparação da saída y(t)');
hold off;

figure('Name','Estados x1, x2, x3');

subplot(3,1,1);
plot(k*T, x1, 'b'); hold on;
plot(t_continuo, x_continuo(:,1), 'r', 'LineWidth',2);
title('Estado x1');
legend('Recursiva','Contínua');
grid on;

subplot(3,1,2);
plot(k*T, x2, 'b'); hold on;
plot(t_continuo, x_continuo(:,2), 'r', 'LineWidth',2);
title('Estado x2');
legend('Recursiva','Contínua');
grid on;

subplot(3,1,3);
plot(k*T, x3, 'b'); hold on;
plot(t_continuo, x_continuo(:,3), 'r', 'LineWidth',2);
title('Estado x3');
legend('Recursiva','Contínua');
grid on;