function [v,varargout]=normRv(V,varargin)
%function [v,varargout]=normRv(V,varargin)
%
% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.

if size(V,1) ~=3,
  disp( 'Function is used incorrect');
  pause
else
 % [l,dl] = lengthv(V);
 % n = 1./l;
 % v = V.*repmat(n,3,1);
  
  l=1./sqrt(sum(V.^2));
  v = [ V(1,:).*l; V(2,:).*l ;V(3,:).*l ];

end


