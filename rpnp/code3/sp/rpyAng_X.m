function ang_zyx=rpyAng_X(R)
%function ang_zyx=rpyAng_X(R)
%
%same as rpyAng(R);  But: minimizes Rx(al)

% Author: Gerald Schweighofer gerald.schweighofer@tugraz.at
% Disclaimer: This code comes with no guarantee at all and its author
%   is not liable for any damage that its utilization may cause.

  ang_zyx = rpyAng(R);
   
  if abs(ang_zyx(1)) > pi/2,
     %% test the same R 
     while ( abs(ang_zyx(1)) > pi/2 ), 
       if  ang_zyx(1) > 0,	
        ang_zyx(1) = ang_zyx(1)+pi;
        ang_zyx(2) = 3*pi-ang_zyx(2);
        ang_zyx(3) = ang_zyx(3)+pi;
        ang_zyx = ang_zyx-2*pi;
       else
          ang_zyx(1) = ang_zyx(1)+pi;
          ang_zyx(2) = 3*pi-ang_zyx(2);
          ang_zyx(3) = ang_zyx(3)+pi;
       end
     end
  end	


%% test if ok
R_=rpyMat([0;0;ang_zyx(3)])*rpyMat([0;ang_zyx(2);0])*rpyMat([ang_zyx(1);0;0]);
if RotationDiff(R_,R) > 0.1,
  kl_ERROR
end
