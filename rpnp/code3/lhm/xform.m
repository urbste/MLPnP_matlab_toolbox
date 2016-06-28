function Q = xform(P, R, t)
% XFORM - Transform
%   XFORM(P, R, t) transform the 3D point set P by rotation
%   R and translation t
%   

n = size(P,2);

Q(1:3,n) = 0;

for i = 1:n
  Q(:,i) = R*P(:,i)+t;
end


