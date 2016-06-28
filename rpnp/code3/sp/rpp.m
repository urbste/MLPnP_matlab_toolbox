
function [pose,po2]=rpp(model,iprts,opt)
%Pose=rpp(model,points)	
%
% Robust Pose from Planar Tragets
% Estimates a Pose for a given Planar Target / image Points combination
% based on this 1st Solution a second solution is found.
% From both Solutions the "better one" (based on the error) is choosen
% as the correct one !
%
% (For image-sequenzes a more sophisticated approach should be used)
%
% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


%% test 
if nargin == 0,
  model = [  0.0685    0.6383    0.4558    0.7411   -0.7219    0.7081 0.7061    0.2887   -0.9521   -0.2553 ;
    0.4636    0.0159   -0.1010    0.2817    0.6638    0.1582    0.3925 -0.7954    0.6965   -0.7795;
         0         0         0         0         0         0         0 0         0         0];

  iprts =[  -0.0168    0.0377    0.0277    0.0373   -0.0824    0.0386 0.0317    0.0360   -0.1015 -0.0080;
    0.0866    0.1179    0.1233    0.1035    0.0667    0.1102    0.0969 0.1660    0.0622 0.1608;
    1.0000    1.0000    1.0000    1.0000    1.0000    1.0000    1.0000 1.0000    1.0000 1.0000];
end


%model 3xn Model Points: planar       3rd row = 0 
%ipts  3xn Image Points: 2d (homogen) 3rd row = 1

if nargin <= 2,
  %% no opt -> use random values.
  opt.initR=rpyMat(2*pi*(rand(3,1)));
end
opt.method='SVD';

%% get a first guess of the pose.
[Rlu_, tlu_, it1_, obj_err1_, img_err1_] = objpose(model, iprts(1:2,:) , opt);

%% get 2nd Pose 
sol=get2ndPose_Exact(iprts,model,Rlu_,tlu_,0);

%% refine with lu 

for i=1:length(sol),	
 opt.initR =  sol(i).R;
 [Rlu_, tlu_, it1_, obj_err1_, img_err1_] = objpose(model, iprts(1:2,:) , opt);
%  Rlu_
 sol(i).PoseLu.R = Rlu_;
 sol(i).PoseLu.t = tlu_;
 sol(i).obj_err = obj_err1_;
end

% disp(['There are ' num2str(length(sol)) ' Solutions with Error: ' num2str(cat(2,sol.obj_err)) ]);
	
e = [cat(1, sol.obj_err ) [1:length(sol)]' ];
e = sortrows(e,1);

pose     =  sol(e(1,2)).PoseLu;
pose.err =  sol(e(1,2)).obj_err;

if nargout == 2,
 if size(e,1) > 1,
   po2     =  sol(e(2,2)).PoseLu;
   po2.err =  sol(e(2,2)).obj_err;
 else 
   po2 = pose;
 end
end

