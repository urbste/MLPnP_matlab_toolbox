function nm=Quaternion_Norm(Q)
% function nm=Quaternion_Norm(Q) 
%
% Compute the L2 norm of the given quaternion
%

% Author: Markus Brandner
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.

nm = sqrt(norm(Q.Vector)^2+Q.Scalar^2);
