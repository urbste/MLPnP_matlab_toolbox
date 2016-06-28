function R=getRotation(u,v)
%function R=getRotation(u,v)
%
% Returns the rotation Matrix M
%
% so that u = M*v;
%
%Author: Gerald Schweighofer

u = u/norm(u);
v = v/norm(v);


[ Rv,p_v,th_v ] = getR(v);
[ Ru,p_u,th_u ] = getR(u);

R = inv(Ru)*Rv;

if sum(abs(R*v' - u')) > 1e-6,
    disp('Error in getRotation ');
end


%-------------------------
function [R,phi,theta]=getR(v)  % funktionsweise aus BARTSCH Seite :219

if sqrt(v(1)^2+v(2)^2) > 1e-8,
  phi = acos(v(1)/sqrt(v(1)^2+v(2)^2));
  R1a =  rotate(0,0,-phi);
  R1b =  rotate(0,0,+phi);
 
v1a = R1a*v';
v1b = R1b*v';

  if abs(v1a(2)) < abs(v1b(2)),
   R1 = R1a;
   phi = -phi;
  else 
   R1 = R1b;
  end
else 
  R1 =  diag([ 1 1 1 ]);
end
v2 = R1*v';
r = sqrt(sum(v.^2));
theta = acos(v2(3)/r);
  R2a=rotate(0,-theta,0);
  R2b=rotate(0,+theta,0);
 
v3a = R2a*v2;
v3b = R2b*v2;

  if v3a(3) > v3b(3),
   R2 = R2a;
   theta = -theta;
  else 
   R2 = R2b;
  end
 
R = R2*R1;

function [R,phi,theta]=getRyx(v)  % funktionsweise aus BARTSCH Seite :219

if sqrt(v(2)^2+v(3)^2) > 1e-8,
  phi = acos(v(3)/sqrt(v(2)^2+v(3)^2));
  R1a =  rotate(-phi,0,0);
  R1b =  rotate(+phi,0,0);
 
v1a = R1a*v';
v1b = R1b*v';

  if abs(v1a(2)) < abs(v1b(2)),
   R1 = R1a;
   phi = -phi;
  else 
   R1 = R1b;
  end
else 
  R1 =  diag([ 1 1 1 ]);
end
v2 = R1*v';
r = sqrt(sum(v.^2));

 theta = atan(v2(3)/v2(1));
 
 R2a=rotate(0,-theta,0);
 R2b=rotate(0,+theta,0);
 
v3a = R2a*v2;
v3b = R2b*v2;

  if v3a(1) > v3b(1),
   R2 = R2a;
   theta = -theta;
  else 
   R2 = R2b;
  end
 
R = R2*R1;

