function Q=Quaternion_byAngleAndVector(q_angle, q_vector)
% function Q=Quaternion_byAngleAndVector(q_angle, q_vector)
%
% Construct a normalized quaternion that rotates by an angle of
% q_angle around the axis q_vector.
%

% Author: Markus Brandner
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.

rotation_axis=q_vector/norm(q_vector);
Q_=Quaternion_byVectorAndScalar(rotation_axis*sin(q_angle/2),...
												cos(q_angle/2));
Q=Quaternion_multiplyByScalar(Q_,1/Quaternion_Norm(Q_));
