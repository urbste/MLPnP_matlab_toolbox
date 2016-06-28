function [al,tnew,at]=getRotationY_wrtT(v,p,t,DB,Rz)
%function al=getRotationY_wrtT(v,p,t)
% 
% returns a minimization of 
% e = sum( (I-Vi)*(Ry*Pi+t)).^2
%

% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


if nargin == 4,
 Rz = eye(3);
end

% generate Vi 
for i=1:size(v,2),
   V(i).V= (v(:,i)*v(:,i)')./(v(:,i)'*v(:,i));
end

%generate G
G=zeros(3);
for i=1:size(v,2),
   G=G+ V(i).V;
end
G=inv(eye(3)-G/size(v,2))/size(v,2);


%% generate opt_t*[bt^2 bt 1]

opt_t = zeros(3,3);
for i=1:size(v,2),

 v11 = V(i).V(1,1); v12 = V(i).V(1,2); v13 = V(i).V(1,3);
 v21 = V(i).V(2,1); v22 = V(i).V(2,2); v23 = V(i).V(2,3);
 v31 = V(i).V(3,1); v32 = V(i).V(3,2); v33 = V(i).V(3,3);

 px = p(1,i); py = p(2,i); pz = p(3,i);
 
 %% generate opt_t*[bt^2 bt 1]
 if 1, %%% with new Rz value

   r1 = Rz(1,1); r2 = Rz(1,2); r3 = Rz(1,3); 
   r4 = Rz(2,1); r5 = Rz(2,2); r6 = Rz(2,3); 
   r7 = Rz(3,1); r8 = Rz(3,2); r9 = Rz(3,3); 

 opt_t = opt_t + [(((v11-1)*r2+v12*r5+v13*r8)*py+(-(v11-1)*r1-v12*r4-v13*r7)*px+(-(v11-1)*r3-v12*r6-v13*r9)*pz) ((2*(v11-1)*r1+2*v12*r4+2*v13*r7)*pz+(-2*(v11-1)*r3-2*v12*r6-2*v13*r9)*px) ((v11-1)*r1+v12*r4+v13*r7)*px+((v11-1)*r3+v12*r6+v13*r9)*pz+((v11-1)*r2+v12*r5+v13*r8)*py;
 ((v21*r2+(v22-1)*r5+v23*r8)*py+(-v21*r1-(v22-1)*r4-v23*r7)*px+(-v21*r3-(v22-1)*r6-v23*r9)*pz) ((2*v21*r1+2*(v22-1)*r4+2*v23*r7)*pz+(-2*v21*r3-2*(v22-1)*r6-2*v23*r9)*px) (v21*r1+(v22-1)*r4+v23*r7)*px+(v21*r3+(v22-1)*r6+v23*r9)*pz+(v21*r2+(v22-1)*r5+v23*r8)*py;
 ((v31*r2+v32*r5+(v33-1)*r8)*py+(-v31*r1-v32*r4-(v33-1)*r7)*px+(-v31*r3-v32*r6-(v33-1)*r9)*pz) ((2*v31*r1+2*v32*r4+2*(v33-1)*r7)*pz+(-2*v31*r3-2*v32*r6-2*(v33-1)*r9)*px) (v31*r1+v32*r4+(v33-1)*r7)*px+(v31*r3+v32*r6+(v33-1)*r9)*pz+(v31*r2+v32*r5+(v33-1)*r8)*py];
  
 else

   opt_t = opt_t+ [ (v12*py+(1-v11)*px-v13*pz) ((2*v11-2)*pz-2*v13*px)  (v11-1)*px+v13*pz+v12*py;
             ((v22-1)*py-v21*px-v23*pz) (2*v21*pz-2*v23*px)      v21*px+v23*pz+(v22-1)*py;
             (v32*py-v31*px+(1-v33)*pz) (2*v31*pz+(-2*v33+2)*px) v31*px+(v33-1)*pz+v32*py];
 end

end
opt_t = G*opt_t;

E_2 = zeros(1,5);
%% estimate Error function E
for i=1:size(v,2),
 v11 = V(i).V(1,1); v12 = V(i).V(1,2); v13 = V(i).V(1,3);
 v21 = V(i).V(2,1); v22 = V(i).V(2,2); v23 = V(i).V(2,3);
 v31 = V(i).V(3,1); v32 = V(i).V(3,2); v33 = V(i).V(3,3);
 px = p(1,i); py = p(2,i); pz = p(3,i);

 %% R*pi;
 Rpi = [ -px 2*pz px;
           py 0 py;
        -pz -2*px pz];

 E = (eye(3)-V(i).V) *( Rz*Rpi+opt_t );
 %% get E.^2
 % syms e2 e1 e0
 %  (e2*bt^2+e1*bt+e0)^2
 e2 = E(:,1);
 e1 = E(:,2);
 e0 = E(:,3);

 E_2 =E_2+ sum([e2.^2 2.*e1.*e2 (2.*e0.*e2+e1.^2) 2.*e0.*e1 e0.^2]);
end

e4=E_2(1);
e3=E_2(2);
e2=E_2(3);
e1=E_2(4);
e0=E_2(5);


a4=-e3;
a3=(4*e4-2*e2);
a2=(-3*e1+3*e3);
a1=(-4*e0+2*e2);
a0=e1;

% disp(['4th order Poly: ' num2str([a0 a1 a2 a3 a4])]);
 

%% solve this stuff 
syms k1;
erg_k1 = solve( a4*k1^4+a3*k1^3+a2*k1^2+a1*k1+a0 );
at=vpa(erg_k1,100);
at=eval(at);

%% get all valid solutions -> which are real zero
e=a4.*at.^4+a3.*at.^3+a2.*at.^2+a1.*at+a0;

%disp(['All Zeros of poly: ' num2str(e) ])

at = at ( find( abs(e) < 1e-3 ) ); 

%%check if we are valid solutions 
p1=(1+at.^2).^3;
at = at( find( abs(real(p1)) > 0.1 ) );

sa = (2.*at)./(1+at.^2);
ca = (1-at.^2)./(1+at.^2);

al =  atan2(sa,ca) * 180/pi;

tMaxMin=real( 4.*a4.*at.^3+3.*a3.*at.^2+2.*a2.*at+a1 );
  
al=al(find(tMaxMin > 0));
at=at(find(tMaxMin > 0));

for a=1:length(al),
  R = Rz*rpyMat([0;al(a)*pi/180;0]);
  t_opt = zeros(3,1) ;
  for i=1:size(v,2),
   t_opt = t_opt + (V(i).V-eye(3))*R*p(:,i);
  end
  t_opt = G*t_opt;
  tnew(:,a) = t_opt;
end

