function Qp = xformproj(P, R, t)
% XFORMPROJ - Transform and project
%   XFORMPROJ(P, R, t) transform the 3D point set P by 
%   rotation R and translation t, and then project them
%   to the normalized image plane

%   

n = size(P,2);

Q(1:3,n) = 0;
Qp(1:2,n) = 0;

for i = 1:n
  Q(:,i) = R*P(:,i)+t;
  Qp(:,i) = Q(1:2,i)/Q(3,i);
end


