function diff=RotationDiff(R1,R2)
%function RotationDiff(R1,R2)
%
%estimates the differemce of 2 Rotations.
%

% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


ergE = R1'*R2;
Qerg = SO3toQuat(ergE);
diff=real(acos(Qerg(4))*2*180/pi);

