function [v]=normRv(V)
%
%
%

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

