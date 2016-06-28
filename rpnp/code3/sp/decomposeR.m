function [Rz,Rz2]=decomposeR(R)
% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.

cl = atan2( R(3,2),R(3,1) ); 
Rz = rpyMat([0;0;cl]);

R_ = R*Rz;

if R_(3,2) > 1e-3,
  kl_ERROR_cl;
end

%R_

ang_zyx=rpyAng_X(R_);

if abs(ang_zyx(1)) > 1e-3,
  kl_error;
end

if nargout == 2,
  
  Rz2 = Rz*rpyMat([0;0;pi]);
  R_ = R*Rz2;
  if R_(3,2) > 1e-3,
    kl_ERROR_c2;
  end
  ang_zyx=rpyAng_X(R_);

end
