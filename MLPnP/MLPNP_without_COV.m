function [R,t] = MLPNP_without_COV(XX, xx, cov)
    [R,t] = MLPnP(XX, normc(xx));
end
