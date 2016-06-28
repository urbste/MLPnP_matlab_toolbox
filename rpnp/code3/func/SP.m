function [R,t] = SP(Pts,impts)

if 0
    [R t]= HOMO(Pts,impts);
    opt.initR=R;
end
opt.method='SVD';

impts= [impts; ones(1,size(impts,2))];

[pose po2]= rpp(Pts,impts,opt);
if pose.err < po2.err
    R= pose.R;
    t= pose.t;
else
    R= po2.R;
    t= po2.t;
end

return
