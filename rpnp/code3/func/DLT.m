function [R,t]= DLT(XXw,xx)

n= size(xx,2);
D= zeros(n*2,12);
for i= 1:n
    xi= XXw(1,i); yi= XXw(2,i); zi= XXw(3,i);
    ui= xx(1,i); vi= xx(2,i);
    D_= [xi yi zi 0 0 0 -ui*xi -ui*yi -ui*zi 1 0 -ui;
        0 0 0 xi yi zi -vi*xi -vi*yi -vi*zi 0 1 -vi];
    D(i*2-1:i*2,:)= D_;
end

DD= D.'*D;
[V,D]= eig(DD);

v= V(:,1); v= v/norm(v(7:9));
v= v*sign(v(12));

R= reshape(v(1:9),3,3).';
t= v(10:12);

XXc= R*XXw+repmat(t,1,size(XXw,2));
[R,t]= calcampose(XXc,XXw);

return

function [R2,t2] = calcampose(XXc,XXw)

n= length(XXc);

X= XXw;
Y= XXc;

K= eye(n)-ones(n,n)/n;

ux= mean(X,2);
uy= mean(Y,2);
sigmx2= mean(sum((X*K).^2));

SXY= Y*K*(X')/n;
[U, D, V]= svd(SXY);
S= eye(3);
if det(SXY) < 0
    S(3,3)= -1;
end

R2= U*S*(V');
c2= trace(D*S)/sigmx2;
t2= uy-c2*R2*ux;

X= R2(:,1);
Y= R2(:,2);
Z= R2(:,3);
if norm(cross(X,Y)-Z) > 2e-2
    R2(:,3)= -Z;
end

return
