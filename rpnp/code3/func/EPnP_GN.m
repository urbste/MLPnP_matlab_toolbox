function [R,t] = EPnP_GN(XX,xx)

[R,t]= efficient_pnp_gauss(XX.',xx.',diag([1 1 1]));

return