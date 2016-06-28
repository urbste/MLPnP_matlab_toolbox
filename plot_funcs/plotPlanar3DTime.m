addpath plot_funcs;

load planar3DresultsTime

close all;

i= 0; w= 300; h= 300;

yrange= [0 2*max([method_list(:).mean_c])];

figure('color','w','position',[w*i,100,w,h]);
xdrawgraph(npts,yrange,method_list,'mean_c','Mean Cost',...
    'Number of Points','Cost (ms)');