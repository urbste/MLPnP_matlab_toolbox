
% Author: Rodrigo Carceroni
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.
 
function angs = rpyAng (R)

% Returns a set of Roll, Pitch and Yaw angles that describe a certain 3x3
% transformation matrix. The magnitude of the Pitch angle is constrained 
% to be not bigger than pi/2.

sinB = -R(3,1);
cosB = sqrt (R(1,1) .* R(1,1) + R(2,1) .* R(2,1));
if abs (cosB) > 1e-15
  sinA = R(2,1) ./ cosB;
  cosA = R(1,1) ./ cosB;
  sinC = R(3,2) ./ cosB;
  cosC = R(3,3) ./ cosB;
  angs = [atan2(sinC,cosC); atan2(sinB,cosB); atan2(sinA,cosA)];
else
  sinC = (R(1,2) - R(2,3)) ./ 2;
  cosC = (R(2,2) + R(1,3)) ./ 2;
  angs = [atan2(sinC,cosC); pi./2; 0];
  if sinB < 0
    angs = -angs;
  end;
end;

if norm(R-rpyMat(angs)) > 1e-10,
 disp('rpyMat: Error not correct Solution ');
 pause
end

%if norm(R-rpyMat([angs(1);0;0])*rpyMat([0;angs(2);0])*rpyMat([0;0;angs(3)]),'fro') > 1e-10,
%  disp('rpyMat: Error not correct Solution ');
%  pause
%end

%if norm(R-rpyMat([0;0;angs(3)])*rpyMat([0;angs(2);0])*rpyMat([angs(1);0;0]),'fro') > 1e-10,
%  disp('rpyMat: Error not correct Solution ');
%  pause
%end
