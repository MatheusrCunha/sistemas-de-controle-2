T=0.2;
g1=tf(10,[1 5]);
g1z=c2d(g1,T);

hs=tf(1,[1 0]);
hz=c2d(hs,T);
%zpk(GHZ)
FTMA = g1z;


% importante, erro em regime permanente é calculado a partir 
% da função de transferência de laço aberto
aux=minreal(tf([1 -1],[1 0],T)*FTMA);  % onde tf([1 -1],[1 0],T) = (z-1)/z = 1-z^-1
[n,d]=tfdata(aux,'v')
kv=(polyval(n,1)/polyval(d,1))/T   % substituindo 1 em aux
ess=1/kv
