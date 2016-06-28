
%Author: Gerald Schweighofer

for sig = diff_sigma,
  
  for k=1:iter,
    fprintf(['\r' num2str(sig) ' - ' num2str(k) '     ']);
       
    % opt.methode ='choose best'
    % opt.methode ='choose +t'

    X = feval(fx,1); 
    R = rpyMat(2*pi*rand(3,1));
    t = feval(ft,1);

    c = X*0;
    
    K = [800 0 320;0 800 240;0 0  1];
    p = K* hgenv( R*X+repmat(t,1,size(X,2))+c );
    p = addError(p',sig)';
    
    v = normRv(inv(K)*p); 
    [R_,t_,e,info] = gOp_positive_z( [v;c], X );
   
    E(end+1).e = e;
    E(end).info = info;
    E(end).sig = sig;
    
    E(end).data.v = v;
    E(end).data.c = c;
    E(end).data.X = X;
    E(end).data.R = R;
    E(end).data.t = t;

    E(end).poseGL.rotDiff = RotationDiff(R_,R);
    E(end).poseGL.R = R_; 
    E(end).poseGL.t = t_;
    E(end).poseGL.e = e;
    E(end).poseGL.dt =    100*( norm( E(end).poseGL.t - t ) ) / norm(t);
    E(end).poseGL.dR =    100*( norm( mat2quat(E(end).poseGL.R) - mat2quat(R) ) );
 
 end  
end

    
sig = unique( cat(1,E.sig) ) 



rr = [];

D=[];
Dt = [];
for i=sig',
 fi   = find( cat(1,E.sig) == i );
 data = E(fi);

 data_ = cat(1,data.poseGL);

 % Dt{end+1} = [i cat(1,data_.dt)'];
 D(end+1,:) = [ i  mean(cat(1,data_.dt))  mean(cat(1,data_.dR))   mean(cat(1,data_.rotDiff))  ];

end


SZ = [296   465   598   294]

f=figure; set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
plot(D(:,1),D(:,3),'rx-','LineWidth',2);
xlabel('Gaussian image noise (pixel)');
ylabel('rotation error (%)');
set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
print(f,'acc_noise_rot.eps', ['-d' 'epsc']);


f=figure; set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
plot(D(:,1),D(:,2),'rx-','LineWidth',2);
xlabel('Gaussian image noise (pixel)');
ylabel('translation error (%)');
set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
print(f,'acc_noise_trans.eps', ['-d' 'epsc']);


f=figure; set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
plot(D(:,1),D(:,4),'rx-','LineWidth',2);
xlabel('Gaussian image noise (pixel)');
ylabel('rotation error (degree)');
set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
print(f,'acc_noise_rot_deg.eps', ['-d' 'epsc']);



