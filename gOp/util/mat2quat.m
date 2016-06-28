function q=mat2quat(R)
%
% returns the quaterion for the matrix R
%

q_=SO3toQuat(R);

% change the different location of the angle value
q =q_([ 4 1:3]);

% change the normalisation 
quat2mat( q );
	
	
%% Test if the finction is ok

if norm(quat2mat(q).'*R-eye(3),'fro') > 1e-3,
  kl_mat2quat_not_working
end
