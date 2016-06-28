function [Quat] = SO3toQuat (Rot)
% Construct a unit quaternion from a given rotation matrix.

% Author: Miguel Ribo
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.
% (c) Miguel Ribo  -  26 Sep. 2001

Quat = zeros(4,1);
tr = trace(Rot);

ii=1;
if (Rot(2,2) > Rot(1,1)) ii=2; end
if (Rot(3,3) > Rot(ii,ii)) ii=3; end

if (tr >= 0.0)
  s = sqrt(tr + 1.0);
  Quat(4) = s * 0.5;

  s = 0.5 / s;
  Quat(1) = (Rot(3,2) - Rot(2,3)) * s;
  Quat(2) = (Rot(1,3) - Rot(3,1)) * s;
  Quat(3) = (Rot(2,1) - Rot(1,2)) * s;
else
  switch ii
   case 1
    s = sqrt(Rot(1,1)-Rot(2,2)-Rot(3,3)+1);
    Quat(1) = s * 0.5;
    s = 0.5 / s;

    Quat(2) = (Rot(2,1) + Rot(1,2)) * s;
    Quat(3) = (Rot(3,1) + Rot(1,3)) * s;
    Quat(4) = (Rot(3,2) - Rot(2,3)) * s;
   case 2
    s = sqrt(Rot(2,2)-Rot(3,3)-Rot(1,1)+1);
    Quat(2) = s * 0.5;
    s = 0.5 / s;

    Quat(3) = (Rot(3,2) + Rot(2,3)) * s;
    Quat(1) = (Rot(1,2) + Rot(2,1)) * s;
    Quat(4) = (Rot(1,3) - Rot(3,1)) * s;
   case 3
    s = sqrt(Rot(3,3)-Rot(1,1)-Rot(2,2)+1);
    Quat(3) = s * 0.5;
    s = 0.5 / s;

    Quat(1) = (Rot(1,3) + Rot(3,1)) * s;
    Quat(2) = (Rot(2,3) + Rot(3,2)) * s;
    Quat(4) = (Rot(2,1) - Rot(1,2)) * s;
  end
end
