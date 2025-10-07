
clc
clear
format long


T = 0.0030;     
kmax=23;

t = (0:(kmax*2-1));
r = ones(1,kmax);
r = [r 1.5*r];

yr(1)= 0;
e(1) = r(1) - yr(1);
u(1) = 2.49 * e(1);
yr(2) = 0.07772 * u(1) +  1.533 * yr(1);
e(2) = r(2) - yr(2);
u(2) = 2.49 * e(2) - 3.817 * e(1) + 1.2854 * u(1);

for k = 3:kmax*2
    yr(k) =  0.07772 * u(k-1) +  0.06827 * u(k-2) + 1.533 * yr(k-1) - 0.6791 * yr(k-2);
    e(k) = r(k) - yr(k);
    u(k) = 2.49 * e(k) - 3.817 * e(k-1) + 1.691 * e(k-2) + 1.2854 * u(k-1) - 0.2854 * u(k-2);
end

figure(1);
plot(t((length(t)/2):end)*T, yr((length(t)/2):end), 'r*');
figure(2);
plot(t((length(t)/2):end)*T, u((length(t)/2):end), 'r*');