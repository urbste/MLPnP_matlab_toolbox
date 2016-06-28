function [R,t] = EPnP_planar(XX,xx)

[R,t]= efficient_pnp_planar(XX.',xx.',diag([1 1 1]));

return