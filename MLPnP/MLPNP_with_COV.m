function [R,t] = MLPNP_with_COV(XX,xx,cov)
    [R,t] = MLPnP(XX, normc(xx),cov);
end
