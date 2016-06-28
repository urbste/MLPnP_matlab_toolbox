function sol=get2ndPose_Exact(v,P,R,t,DB)
%function bet=get2ndPose_Exact(v,P,R,t)
%
%returns the second pose if a first pose was calulated.	
%
% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.

cent=normRv(mean(normRv(v)')');
Rim=GetRotationbyVector([0;0;1],cent);

%cent 
%Rim

v_ = Rim*v;
cent=normRv(mean(normRv(v_)')');

R_=Rim*R;
t_=Rim*t;

%R_ 
%t_

sol=getRfor2ndPose_V_Exact(v_,P,R_,t_,DB);

%% de Normalise the Pose
for i=1:length(sol),	
  sol(i).R = Rim'*sol(i).R;
  sol(i).t = Rim'*sol(i).t;
end


function sol=getRfor2ndPose_V_Exact(v,P,R,t,DB)
% gets the exact R with  variations in t
%

%hgenv(R*P+repmat(t,1,size(P,2)))
%hgenv(v)


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
 
 %hgenv(Rz*Ry*P_+repmat(t,1,size(P_,2)))
 %hgenv(v)

  %v 
  %P_
  %t
  %Rz


  [bl,Tnew,at]=getRotationY_wrtT(v ,P_,t,DB,Rz);
  bl = bl ./180*pi;


 %% we got 2 solutions. YEAH
  V=[];
  for i=1:size(v,2),
    V(i).V= (v(:,i)*v(:,i)')./(v(:,i)'*v(:,i));
  end

  sol=[];
  for j=1:length(bl),
    sol(j).bl = bl(j);
    sol(j).at = at(j);
	
    Ry = rpyMat([0;bl(j);0]);
    sol(j).R = Rz*Ry*RzN';
    sol(j).t = Tnew(:,j);

    %test the Error  
    E=0;
    for i=1:size(v,2),
      E=E+sum(((eye(3)-V(i).V)*(sol(j).R*P(:,i)+sol(j).t)).^2);
    end
    sol(j).E=E;
  end

