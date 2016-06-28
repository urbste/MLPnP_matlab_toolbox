function Q=Quaternion_multiplyByScalar(q,scalar)
% function Q=Quaternion_multiplyByScalar(q,scalar)
%
% Multiply the given quaternion q by a scalar.
%

% Author: Markus Brandner
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.


Q=Quaternion_byVectorAndScalar(scalar*q.Vector,...
															 scalar*q.Scalar);
