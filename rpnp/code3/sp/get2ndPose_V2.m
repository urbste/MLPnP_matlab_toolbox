function sol=get2ndPose_V2(v,P,R,t)
% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


%%% normalise the Image
cent=normRv(mean(normRv(v)')');
Rim=GetRotationbyVector([0;0;1],cent);

v_ = Rim*v;
cent=normRv(mean(normRv(v_)')');

R_=Rim*R;
t_=Rim*t;

%hgenv(R_*P+repmat(t_,1,size(P,2)))
%hgenv(v_)

sol=getRfor2ndPose_V(v_,P,R_,t_);


if length(sol) ~= 2,
  disp(['ATTENTION Only ' num2str(length(sol))  ' Solution']);
end

%% de Normalise the Pose
for i=1:length(sol),	
  sol(i).R = Rim'*sol(i).R;
end

if 0,
  V=[];
  for i=1:size(v,2),
    V(i).V= (v(:,i)*v(:,i)')./(v(:,i)'*v(:,i));
  end
  for j=1:length(sol),
    E=0;
    for i=1:size(v,2),
      E=E+sum(( (eye(3)-V(i).V)*(sol(j).R*P(:,i)+t)).^2);
    end
    E
  end
end

%hgenv(R*P+repmat(t,1,size(P,2)))
%hgenv(v)

