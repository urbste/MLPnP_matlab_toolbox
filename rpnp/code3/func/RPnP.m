function [R t]= RPnP(XX,xx)
R= []; t= [];

n= length(xx);
XXw= XX;

xxv= [xx; ones(1,n)];
for i=1:n
    xxv(:,i)= xxv(:,i)/norm(xxv(:,i));
end

% selecting an edge $P_{i1}P_{i2}$ by n random sampling
i1= 1;
i2= 2;
lmin= xxv(1,i1)*xxv(1,i2)+xxv(2,i1)*xxv(2,i2)+xxv(3,i1)*xxv(3,i2);

rij= ceil(rand(n,2)*n);
for ii= 1:n
	i= rij(ii,1);
	j= rij(ii,2);
	if i == j
		continue;
	end
	l= xxv(1,i)*xxv(1,j)+xxv(2,i)*xxv(2,j)+xxv(3,i)*xxv(3,j);
	if l < lmin
		i1= i;
		i2= j;
		lmin= l;
	end
end

% calculating the rotation matrix of $O_aX_aY_aZ_a$.
p1= XX(:,i1);
p2= XX(:,i2);
p0= (p1+p2)/2;
x= p2-p0; x= x/norm(x);
if abs([0 1 0]*x) < abs([0 0 1]*x)
    z= xcross(x,[0; 1; 0]); z= z/norm(z);
    y= xcross(z, x); y= y/norm(y);
else
    y= xcross([0; 0; 1], x); y= y/norm(y);
    z= xcross(x,y); z= z/norm(z);
end
Ro= [x y z];

% transforming the reference points form orignial object space 
% to the new coordinate frame  $O_aX_aY_aZ_a$.
XX= Ro.'*(XX-repmat(p0,1,n));

% Dividing the n-point set into (n-2) 3-point subsets
% and setting up the P3P equations

v1= xxv(:,i1);
v2= xxv(:,i2);
cg1= v1.'*v2;
sg1= sqrt(1-cg1^2);
D1= norm(XX(:,i1)-XX(:,i2));
D4= zeros(n-2,5);

if 0 % determining F', the deviation of the cost function.
    
    j= 0;
    for i= 1:n
        if i == i1 || i == i2
            continue;
        end
        j= j+1;

        vi= xxv(:,i);
        cg2= v1.'*vi;
        cg3= v2.'*vi;
        sg2= sqrt(1-cg2^2);
        D2= norm(XX(:,i1)-XX(:,i));
        D3= norm(XX(:,i)-XX(:,i2));
        
        % get the coefficients of the P3P equation from each subset.
        D4(j,:)= getp3p(cg1,cg2,cg3,sg1,sg2,D1,D2,D3);
    end

    % get the 7th order polynomial, the deviation of the cost function.
    D7= zeros(1,8);
    for i= 1:n-2
        D7= D7+ getpoly7(D4(i,:));
    end

else % =======================================================================
     % following code is the same as the code above (between "if 0" and "else")
     % but the following code is a little more efficient than the former
     % in matlab when the number of points is large, 
     % because the dot multiply operation is used.
    
    idx= true(1,n);
    idx([i1 i2])= false;
    vi= xxv(:,idx);
    cg2= vi.'*v1;
    cg3= vi.'*v2;
    sg2= sqrt(1-cg2.^2);
    D2= cg2;
    D3= cg2;
    didx= find(idx);
    for i= 1:n-2
        D2(i)= norm(XX(:,i1)-XX(:,didx(i)));
        D3(i)= norm(XX(:,didx(i))-XX(:,i2));
    end

    A1= (D2./D1).^2;
    A2= A1*sg1^2-sg2.^2;
    A3= cg2.*cg3-cg1;
    A4= cg1*cg3-cg2;
    A6= (D3.^2-D1^2-D2.^2)./(2*D1^2);
    A7= 1-cg1^2-cg2.^2+cg1*cg2.*cg3+A6.*sg1^2;

    D4= [A6.^2-A1.*cg3.^2, 2*(A3.*A6-A1.*A4.*cg3),...
        A3.^2+2*A6.*A7-A1.*A4.^2-A2.*cg3.^2,...
        2*(A3.*A7-A2.*A4.*cg3), A7.^2-A2.*A4.^2];

    F7= [4*D4(:,1).^2,...
        7*D4(:,2).*D4(:,1),...
        6*D4(:,3).*D4(:,1)+3*D4(:,2).^2,...
        5*D4(:,4).*D4(:,1)+5*D4(:,3).*D4(:,2),...
        4*D4(:,5).*D4(:,1)+4*D4(:,4).*D4(:,2)+2*D4(:,3).^2,...
        3*D4(:,5).*D4(:,2)+3*D4(:,4).*D4(:,3),...
        2*D4(:,5).*D4(:,3)+D4(:,4).^2,...
        D4(:,5).*D4(:,4)];
    D7= sum(F7);
end

% retriving the local minima of the cost function.
try % try catch added by Luis Ferraz 
    
t2s= roots(D7);

maxreal= max(abs(real(t2s)));
t2s(abs(imag(t2s))/maxreal > 0.001)= [];
t2s= real(t2s);

D6= (7:-1:1).*D7(1:7);
F6= polyval(D6,t2s);
t2s(F6 <= 0)= [];

if isempty(t2s)
    %fprintf('no solution!\n');
    return
end

catch
    %fprintf('no solution!\n');
    return
end

% calculating the camera pose from each local minimum.
m= length(t2s);
for i= 1:m
    t2= t2s(i);
    % calculating the rotation matrix
    d2= cg1+t2;
    x= v2*d2- v1; x= x/norm(x);
    
    if abs([0 1 0]*x) < abs([0 0 1]*x)
        z= xcross(x,[0; 1; 0]); z= z/norm(z);
        y= xcross(z, x); y= y/norm(y);
    else
        y= xcross([0; 0; 1], x); y= y/norm(y);
        z= xcross(x,y); z= z/norm(z);
    end
    Rx= [x y z];

    % calculating c, s, tx, ty, tz
    D= zeros(2*n,6);
    r= Rx.';
    for j= 1:n
        ui= xx(1,j); vi= xx(2,j);
        xi= XX(1,j); yi= XX(2,j); zi= XX(3,j);
        D(2*j-1,:)= [-r(2)*yi+ui*(r(8)*yi+r(9)*zi)-r(3)*zi, ...
            -r(3)*yi+ui*(r(9)*yi-r(8)*zi)+r(2)*zi, ...
            -1, 0, ui, ui*r(7)*xi-r(1)*xi];
        D(2*j, :)= [-r(5)*yi+vi*(r(8)*yi+r(9)*zi)-r(6)*zi, ...
            -r(6)*yi+vi*(r(9)*yi-r(8)*zi)+r(5)*zi, ...
            0, -1, vi, vi*r(7)*xi-r(4)*xi];
    end
    DTD= D.'*D;
    [V D]= eig(DTD);
    
    V1= V(:,1); V1= V1/V1(end);
    c= V1(1); s= V1(2); t= V1(3:5);

    % calculating the camera pose by 3d alignment
    xi= XX(1,:); yi= XX(2,:); zi= XX(3,:);
    XXcs= [r(1)*xi+(r(2)*c+r(3)*s)*yi+(-r(2)*s+r(3)*c)*zi+t(1);
        r(4)*xi+(r(5)*c+r(6)*s)*yi+(-r(5)*s+r(6)*c)*zi+t(2);
        r(7)*xi+(r(8)*c+r(9)*s)*yi+(-r(8)*s+r(9)*c)*zi+t(3)];
    
    XXc= zeros(size(XXcs));
    for j= 1:n
        XXc(:,j)= xxv(:,j)*norm(XXcs(:,j));
    end
    
    [R t]= calcampose(XXc,XXw);
    
    % calculating the reprojection error
    XXc= R*XXw+t*ones(1,n);
    xxc= [XXc(1,:)./XXc(3,:); XXc(2,:)./XXc(3,:)];
    %r= mean(sqrt(sum((xxc-xx).^2)));
    r = norm(xxc-xx,'fro')/n;
    
    res{i}.R= R;
    res{i}.t= t;
    res{i}.r= r;
end

% determing the camera pose with the smallest reprojection error.
minr= inf;
for i= 1:m
    if res{i}.r < minr
        minr= res{i}.r;
        R= res{i}.R;
        t= res{i}.t;
    end
end

return

function B = getp3p(l1,l2,A5,C1,C2,D1,D2,D3)

A1= (D2/D1)^2;
A2= A1*C1^2-C2^2;
A3= l2*A5-l1;
A4= l1*A5-l2;
A6= (D3^2-D1^2-D2^2)/(2*D1^2);
A7= 1-l1^2-l2^2+l1*l2*A5+A6*C1^2;

B= [A6^2-A1*A5^2, 2*(A3*A6-A1*A4*A5), A3^2+2*A6*A7-A1*A4^2-A2*A5^2,...
    2*(A3*A7-A2*A4*A5), A7^2-A2*A4^2];

return

function F7= getpoly7(F)

F7= [4*F(1)^2;
7*F(2)*F(1);
6*F(3)*F(1)+3*F(2)^2;
5*F(4)*F(1)+5*F(3)*F(2);
4*F(5)*F(1)+4*F(4)*F(2)+2*F(3)^2;
3*F(5)*F(2)+3*F(4)*F(3);
2*F(5)*F(3)+F(4)^2;
F(5)*F(4)].';

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
if norm(xcross(X,Y)-Z) > 2e-2
    R2(:,3)= -Z;
end

return

function c = xcross(a,b)

c = [a(2)*b(3)-a(3)*b(2);
     a(3)*b(1)-a(1)*b(3);
     a(1)*b(2)-a(2)*b(1)];
 
 return
