function [R,t] = LHM(XX,xx)

options.method= 'SVD';
[R,t]= objpose(XX,xx,options);

return