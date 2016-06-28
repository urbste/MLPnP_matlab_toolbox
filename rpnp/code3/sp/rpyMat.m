
% Author: Rodrigo Carceroni
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.
 
function R = rpyMat (angs)

% Return the 3x3 rotation matrix described by a set of Roll, Pitch and Yaw
% angles.

cosA = cos (angs(3));
sinA = sin (angs(3));
cosB = cos (angs(2));
sinB = sin (angs(2));
cosC = cos (angs(1));
sinC = sin (angs(1));

cosAsinB = cosA .* sinB;
sinAsinB = sinA .* sinB;

R = [ cosA.*cosB  cosAsinB.*sinC-sinA.*cosC  cosAsinB.*cosC+sinA.*sinC ;
      sinA.*cosB  sinAsinB.*sinC+cosA.*cosC  sinAsinB.*cosC-cosA.*sinC ;
        -sinB            cosB.*sinC                 cosB.*cosC         ];

