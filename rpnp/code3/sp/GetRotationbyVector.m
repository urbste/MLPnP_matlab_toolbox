function R = GetRotationbyVector(v1,v2)
%function R = GetRotationbyVector(v1,v2)
%
% returns R so that v1 = R * v2;

% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


winkel = acos(dot(v2,v1));
QU=Quaternion_byAngleAndVector(winkel,cross(v2,v1));
R=quat2mat([QU.Scalar ;  QU.Vector; QU.Scalar  ]) ;


if sum((normRv(v1)-R*normRv(v2)).^2) > 1e-3,
  kl_not_correct_Rotation
end
