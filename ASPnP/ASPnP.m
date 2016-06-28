function [R0, t0, cost] = ASPnP(U0, u0, K)
%normalized image coordinate
if nargin < 3
    u = u0(1:2,:);
else
    u = K\[u0(1:2,:);ones(1,size(u0,2))];
    u = u(1:2,:);
end

%normalize 3D points
%[U C3D] = normalize_3D_points(U0);

%nonhomogeneous coordinate
U = U0(1:3,:);

C_est = []; t_est = [];
%case1
[R_est_1, t_est_1] = ASPnP_Case1_V2(U, u);
if size(t_est_1,2) > 0
    C_est = cat(3,C_est,R_est_1); t_est = [t_est t_est_1];
end
%case2
[R_est_2, t_est_2] = ASPnP_Case2_V2(U, u);
if size(t_est_2,2) > 0
    C_est = cat(3,C_est,R_est_2); t_est = [t_est t_est_2];
end
%case3
[R_est_3, t_est_3] = ASPnP_Case3_V2(U, u);
if size(t_est_3,2) > 0
    C_est = cat(3,C_est,R_est_3); t_est = [t_est t_est_3];
end
%case4
[R_est_4, t_est_4] = ASPnP_Case4_V2(U, u);
if size(t_est,4) > 0
    C_est = cat(3,C_est,R_est_4); t_est = [t_est t_est_4];
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
