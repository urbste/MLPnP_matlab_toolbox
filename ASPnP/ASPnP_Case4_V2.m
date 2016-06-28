function [R0 t0 error0] = ASPnP_Case4_V2(U,u)
%PnP_case4
%a=0,b=0,c=0,d=1;
%R=diag([-1,-1,1]);
n = size(U,2);

sum_uv = sum(u,2);
invQTQ = inv([n   0   -sum_uv(1); 0 n -sum_uv(2); -sum_uv(1) -sum_uv(2) sum(sum(u.*u))]);

Ut = U';
ut = u';

N1 = -Ut(:,1) - Ut(:,3).*ut(:,1);
N2 = -Ut(:,2) - Ut(:,3).*ut(:,2);

QTN = [-sum(N1,1); -sum(N2,1); u(1,:)*N1+u(2,:)*N2] ;

%translation vector
t = invQTQ*QTN;

%rotation matrix
R = diag([-1,-1,1]);

%reprojection error
proj = R*U+t*ones(1,n);

%no correct solution
% if min(proj(3,:)) < 0
%      R0 = []; t0 = []; error0 =inf;
%      return;
% end
    
% proj = proj./repmat(proj(3,:),3,1);  
% err = proj(1:2,:)-u;
% err = sum(sum(err.*err));

R0 = R; t0 = t; 
end

 

 