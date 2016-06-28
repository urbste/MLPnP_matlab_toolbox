
%
% simpe script which tests if gOp works
%
% Author: Gerald Schweighofer 


opt.acc = 1e-8; 
opt.methode ='3D';

% generate a test model 
n = 10;
X = (rand(3,n)-0.5)*100;
R = rpyMat(2*pi*rand(3,1));
t = rand(3,1)*10;
c = rand(3,n)*5;
% c=c*0;     %% for simple perspective camera 

%% generate a measurement 
p = hgenv( R*X+repmat(t,1,size(X,2))+c );
v = normRv(p);

%% add Noise
% v = v + (rand(size(v))-0.5)*0.01 

%% call gOp
[R_,t_,e,info] = gOp([v;c],X,opt)

%% check the error 
RotationDiff(R_,R)


