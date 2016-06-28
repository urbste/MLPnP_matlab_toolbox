function  [R_,t_,e,info] = gOp_positive_z( VC, X )
%
%
% returns the global optimal pose with t(3) > 0 
%


opt.acc = 1e-10;
opt.methode ='3D' ;  % thats the faster version !
    
ok = 0;
try,
  [R_,t_,e,info] = gOp(VC,X,opt); 
  if t_(3) >= 0,
    ok = 1;
  end
catch
end


%% check if we failed -> there are two reasons 
if ~ok, 
  %% 1 accuracy was to bad 
  opt_ = opt; opt_.acc = 1e-15;
  %% 2 it is a planar model 
  opt_.methode ='choose +t';
  [R_,t_,e,info] = gOp(VC,X,opt_); 
end

%% xxx : we should sum up the timings !