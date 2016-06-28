function P_=v2V(P)


%P_=[ P.' zeros(1,6);zeros(1,3) P.' zeros(1,3);zeros(1,6) P.' ];

if isnumeric(P),
 P_=zeros(3,9);   %XXX speedup  does ot work for symbolic 
end

P_(1,1:3) = P.';
P_(2,4:6) = P.';
P_(3,7:9) = P.';
