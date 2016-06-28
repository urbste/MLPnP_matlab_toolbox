function [R,t] = HOMO(Pts,impts)

n= size(Pts,2);
A= [];
for i= 1:n
    xi= Pts(1,i);
    yi= Pts(2,i);
    ui= impts(1,i);
    vi= impts(2,i);
    ai= [xi yi 1];
    Ai= [ai 0 0 0 -ui*ai; 0 0 0 ai -vi*ai];
    A= [A; Ai];
end

[V D]= eig(A'*A);
V= V(:,1);
V= V*sign(V(end));
A= reshape(V,3,3)';
A= A/norm(A(:,1));
R= A;
t= A(:,3);
R(:,3)= cross(A(:,1),A(:,2));

if 1
    [U S V]= svd(R);
    R= U*V';
else
    for i= 1:3
        R(:,i)= R(:,i)/norm(R(:,i));
    end
end

return
