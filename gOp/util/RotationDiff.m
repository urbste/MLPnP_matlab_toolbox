function diff=RotationDiff(R1,R2)
%function RotationDiff(R1,R2)
%
%estimates the differemce of 2 Rotations.
%

ergE = R1'*R2; %% difference Rotation
Qerg = SO3toQuat(ergE);
diff= abs( real(acos(Qerg(4))*2*180/pi) );
diff= min([ diff 360-diff ]);

