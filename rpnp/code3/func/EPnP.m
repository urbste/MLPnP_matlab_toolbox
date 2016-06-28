function [R,t] = EPnP(XX,xx)

[R,t] = efficient_pnp(XX.',xx.',diag([1 1 1]));

return