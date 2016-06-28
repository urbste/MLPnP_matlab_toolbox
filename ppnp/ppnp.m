function [R, T] = ppnp(P,S,tol)
% input
% P: matrix (nx3) image coordinates in camera reference [u v 1]
% S: matrix (nx3) coordinates in world reference [X Y Z]
% tol: exit threshold
% output
% R : matrix (3x3) rotation (world-to-camera)
% T : vector (3x1) translation  (world-to-camera)

    n = size(P,1); Z = zeros(n); e = ones(n,1);
    A = eye(n)-((e*e')./n); II = e./n;
    err = +Inf; E_old = 1000*ones(n,3);

    iter = 0;
    while err>tol
        [U,~,V] = svd(P'*Z*A*S);
        VT = V';
        R=U*[1 0 0; 0 1 0; 0 0 det(U*VT)]*VT;
        PR = P*R;
        c = (S-Z*PR)'*II;
        Y = S-e*c';
        Zmindiag = diag(PR*Y')./(sum(P.*P,2));
        Zmindiag(Zmindiag<0)=0; Z = diag(Zmindiag);
        E = Y-Z*PR;
        err = norm(E-E_old,'fro'); E_old = E;
        iter = iter +1;
    end
    iter;
    T= -R*c;
end