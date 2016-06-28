function [R,T] = GOP(Pts,impts)
    v = normRv([impts;ones(1,size(impts,2))]); 
    c = Pts * 0;
    [R,T] = gOp_positive_z([v;c],Pts);
return
