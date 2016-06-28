function sol=getRfor2ndPose_V(v,P,R,t)
%
% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


%% get Rx = Rx(0);
RzN=decomposeR(R);
R_= R*RzN;

%% change model by Rz 
%hgenv(R*P+repmat(t,1,size(P,2)))
%hgenv(v)

P_=RzN'*P;

%hgenv(R_*P_+repmat(t,1,size(P_,2)))
%hgenv(v)

%% project into Image with only Ry

ang_zyx = rpyAng_X(R_);

Ry =rpyMat([0;ang_zyx(2);0]);
Rz =rpyMat([0;0;ang_zyx(3)]);

v_ = Ry*P_+repmat(t,1,size(P,2));

bl=getRotationY(v_,P_,t,0)./180*pi;

%% we got 2 solutions. YEAH
V=[];
for i=1:size(v,2),
  V(i).V= (v(:,i)*v(:,i)')./(v(:,i)'*v(:,i));
end

sol=[];
for j=1:length(bl),
  Ry = rpyMat([0;bl(j);0]);
  sol(j).R = Rz*Ry*RzN';
  %test the Error
  
  E=0;
  for i=1:size(v,2),
    E=E+sum(((eye(3)-V(i).V)*(sol(j).R*P(:,i)+t)).^2);
  end
  sol(j).E=E;
end
