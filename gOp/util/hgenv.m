function [x]=hgenv(X)
% function X=hgenv(X)
% 
% returns the homogenous value of vector X
% X  = [x;y;z] values

x = X./repmat(X(3,:),3,1);

