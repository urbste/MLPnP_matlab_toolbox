function W = qmatW(q)
% QMATW - Compute the W matrix (4x4) of quaternion q
%   

w = q(1); x = q(2); y = q(3); z = q(4);
W = [w, -x, -y, -z;
     x, w, z, -y;
     y, -z, w, x;
     z, y, -x, w];
