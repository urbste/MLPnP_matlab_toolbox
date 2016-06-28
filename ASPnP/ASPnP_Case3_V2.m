function [R0 t0 error0] = ASPnP_Case3_V2(U,u)
%lift to 10-order)
%full-rank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CORRECT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = size(U,2);

sum_uv = sum(u,2);
invQTQ = inv([n   0   -sum_uv(1); 0 n -sum_uv(2); -sum_uv(1) -sum_uv(2) sum(sum(u.*u))]);

Ut = U';
ut = u';

temp1 = [-Ut(:,1) zeros(n,1) -Ut(:,1)];
temp2 = [Ut(:,3) -2*Ut(:,2) -Ut(:,3)];
N1 = temp1 + temp2.*repmat(ut(:,1),1,3);

temp1 = [Ut(:,2) 2*Ut(:,3) -Ut(:,2)];
N2 = temp1 + temp2.*repmat(ut(:,2),1,3);

QTN = [-sum(N1,1); -sum(N2,1); u(1,:)*N1+u(2,:)*N2] ;
invQTQ_QTN = invQTQ*QTN;

M = -(QTN')*invQTQ_QTN + N1'*N1 + N2'*N2;


m11 = M(1,1); m12 = M(1,2); m13 = M(1,3); 
              m22 = M(2,2); m23 = M(2,3); 
                            m33 = M(3,3); 

%variable sequence
a1 = [ 4*m33, 6*m23, 4*m13 + 2*m22, 2*m12];

if a1(1) < 1e-20    
    R0 = []; t0 = []; error0 = inf;
    return;
end

[D] = eig(compan(a1));

if (find(isnan(D)) > 0) 
    z = [];
else

    I = find(not(imag( D)));
    z = D(I);
end

R0 = []; t0 = []; error0 = inf;
for i = 1:length(z)
    d = z(i);
    
    R = 1/(1+d^2)*[-1-d^2     0     0
                   0         1-d^2  2*d
                   0         2*d    -1+d^2];
    vec1 = [1 d d^2];
    t = invQTQ_QTN*vec1'/(1+d^2);
    proj = R*U+t*ones(1,n);

%     if min(proj(3,:)) < 0
%         continue;
%     end
% 
%     proj = proj./repmat(proj(3,:),3,1);    
%     err = norm(proj(1:2,:)-u,'fro')/n;
% 
%     %choose the solution with smallest reprojection error
%     if err < error0
%         R0 = R; t0 = t; error0 = err;
%     end
    R0 = cat(3,R0,R);
    t0 = [t0 t];
end

end

 

 