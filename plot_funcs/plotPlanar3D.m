addpath plot_funcs;

load planar3Dresults

close all;
yrange= [0 2];

i= 0; w= 300; h= 300;

yrange= [0 1.2*max([method_list(:).deleted_med_r])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_mean_r','Mean Rotation Error',...
    'Number of Points','Rotation Error (degrees)');

figure('color','w','position',[w*i,100+h,w,h]);i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_med_r','Median Rotation Error',...
    'Number of Points','Rotation Error (degrees)');

yrange= [0 1.2*max([method_list(:).deleted_med_t])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_mean_t','Mean Translation Error',...
    'Number of Points','Translation Error (%)');

figure('color','w','position',[w*i,100+h,w,h]);i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_med_t','Median Translation Error',...
    'Number of Points','Translation Error (%)');

yrange= [0 1.2*max([method_list(:).deleted_med_e])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_mean_e','Mean L2 Error',...
    'Number of Points','L2 error');

figure('color','w','position',[w*i,100+h,w,h]);%i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_med_e','Median L2 Error',...
    'Number of Points','L2 error');

yrange= [0 min(max(1,2*max([method_list(:).pfail])),100)];
figure('color','w','position',[w*i,100+2*h,w,h]);%i=i+1;
xdrawgraph(npts*100,yrange,method_list,'pfail','No solution x method',...
    'Number of Points','% method fails');
i=i+1;

yrange= [0 1.2*max([method_list(:).deleted_med_c])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_mean_c','Mean Cost',...
    'Number of Points','Cost (ms)');

figure('color','w','position',[w*i,100+h,w,h]);i=i+1;
xdrawgraph(npts,yrange,method_list,'deleted_med_c','Median Cost',...
    'Number of Points','Cost (ms)');