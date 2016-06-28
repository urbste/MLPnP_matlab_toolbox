function [y  y1]= cal_pose_err(T1, T2)

R1= T1(1:3,1:3);
R2= T2(1:3,1:3);

X1= R1(:,1); X2= R2(:,1);
Y1= R1(:,2); Y2= R2(:,2);
Z1= R1(:,3); Z2= R2(:,3);

exyz= [X1'*X2 Y1'*Y2 Z1'*Z2];
exyz(exyz>1)= 1;
exyz(exyz<-1)= -1;

y(1)= max(abs(acos(exyz)))*180/pi;

q1 = Matrix2Quaternion(R1);
q2 = Matrix2Quaternion(R2);

y1(1) = norm(q1-q2)/norm(q2)*100;

if isnan(y(1))
    txt;
end

y(2)= norm(T1(1:3,4)-T2(1:3,4))/norm(T2(1:3,4))*100;
y1(2) = y(2);
y= abs(y);

end

function Q = Matrix2Quaternion(R)
 % Solve (R-I)v = 0;
    [v,d] = eig(R-eye(3));
    
    % The following code assumes the eigenvalues returned are not necessarily
    % sorted by size. This may be overcautious on my part.
    d = diag(abs(d));   % Extract eigenvalues
    [s, ind] = sort(d); % Find index of smallest one
    if d(ind(1)) > 0.001   % Hopefully it is close to 0
        warning('Rotation matrix is dubious');
    end
    
    axis = v(:,ind(1)); % Extract appropriate eigenvector
    
    if abs(norm(axis) - 1) > .0001     % Debug
        warning('non unit rotation axis');
    end
    
    % Now determine the rotation angle
    twocostheta = trace(R)-1;
    twosinthetav = [R(3,2)-R(2,3), R(1,3)-R(3,1), R(2,1)-R(1,2)]';
    twosintheta = axis'*twosinthetav;
    
    theta = atan2(twosintheta, twocostheta);
    
    Q = [cos(theta/2); axis*sin(theta/2)];
end
