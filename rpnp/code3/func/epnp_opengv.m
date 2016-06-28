function [R,t]= epnp_opengv(XX,xx,cov)
T = opengv('epnp',[1:size(xx,2)],XX,normc(xx));
R = T(1:3,1:3);
t = T(1:3,4);
end

