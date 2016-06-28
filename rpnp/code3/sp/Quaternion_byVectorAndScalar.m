function q=Quaternion_byVectorAndScalar(vector,scalar)
% function q=Quaternion_byVectorAndScalar(vector,scalar)
%
% Build a valid Quaternion based on the given vector
% and scalar (see Shoemaker's paper for details)
%

% Author: Markus Brandner
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.



q = struct('Vector',vector,...
					 'Scalar',scalar);


