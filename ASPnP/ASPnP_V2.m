function [R0, t0, cost] = ASPnP_V2(U, u)
%
R = cat(3, rotx(pi/2), roty(pi/2), rotz(pi/2));
t = mean(U,2);

cost = inf;
C_est = [];
t_est = [];

for i = 1:3
    % Make a random rotation
    pp = R(:,:,i) * (U - repmat(t, 1, size(U,2)));
    
    %case1
    [C_est_i, t_est_i] = ASPnP_Case1_V2(pp, u);
    
    %rotate back to the original system
    for j = 1:size(t_est_i,2)
        t_est_i(:,j) = t_est_i(:,j) - C_est_i(:,:,j) * R(:,:,i) * t;
        C_est_i(:,:,j) = C_est_i(:,:,j) * R(:,:,i);
    end
    
	%stack all rotations and translations     
    if size(t_est_i,2) > 0
        C_est = cat(3,C_est, C_est_i);
        t_est = [t_est t_est_i];
    end
    
end
%among all these solutions, choose the one with smallest reprojection error
%how to determine multiple solutions with the same reprojection error???
index = ones(1,size(t_est,2));
for i = 1:size(t_est,2)
    proj = C_est(:,:,i)*U+t_est(:,i)*ones(1,size(u,2));   
    %not in front of the camera
    if min(proj(3,:)) < 0
        index(i) = 0;
    end
    %calculate reprojection error
    proj = proj./repmat(proj(3,:),3,1);  
    err = proj(1:2,:)-u;
    error(i) = sum(sum(err.*err));
end
%choose the one with smallest reprojection error
error0 = min(error(index>0));

if isempty(error0)
      R0 = []; t0 = []; cost = inf; 
    return;
end

%using 5% as tolerance to detect multiple solutions
rr = find((error<error0*1.05).*(index>0));
R0 = C_est(:,:,rr);
t0 = t_est(:,rr);
cost = error(rr);
end

function r = rotx(t)
ct = cos(t);
st = sin(t);
r =    [1	0	0;
    0	ct	-st;
    0	st	ct];
end

function r = roty(t)
% roty: rotation about y-axi-
ct = cos(t);
st = sin(t);
r =    [ct	0	st;
    0	1	0;
    -st	0	ct];
end

function r = rotz(t)
% rotz: rotation about z-axis

ct = cos(t);
st = sin(t);
r = [ct	-st	0
    st	ct	0
    0	0	1];

end
