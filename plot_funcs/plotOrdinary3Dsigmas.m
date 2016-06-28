addpath plot_funcs;

load ordinary3DresultsSigma

close all;
yrange= [0 2];

i= 0; w= 300; h= 300;

yrange= [0 max([method_list(:).mean_r])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_mean_r','Mean Rotation Error',...
    'Gaussian Image Noise (pixels)','Rotation Error (degrees)');

figure('color','w','position',[w*i,100+h,w,h]);i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_med_r','Median Rotation Error',...
    'Gaussian Image Noise (pixels)','Rotation Error (degrees)');

yrange= [0 max([method_list(:).mean_t])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_mean_t','Mean Translation Error',...
    'Gaussian Image Noise (pixels)','Translation Error (%)');

figure('color','w','position',[w*i,100+h,w,h]);i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_med_t','Median Translation Error',...
    'Gaussian Image Noise (pixels)','Translation Error (%)');

yrange= [0 max([method_list(:).mean_e])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_mean_e','Mean L2 Error',...
    'Gaussian Image Noise (pixels)','L2 error');

figure('color','w','position',[w*i,100+h,w,h]);
xdrawgraph(nls,yrange,method_list,'deleted_med_e','Median L2 Error',...
    'Gaussian Image Noise (pixels)','L2 error');

yrange= [0 min(max(1,2*max([method_list(:).pfail])),100)];
figure('color','w','position',[w*i,100+2*h,w,h]);%i=i+1;
xdrawgraph(nls,yrange,method_list,'pfail','No solution x method',...
    'Gaussian Image Noise (pixels)','% method fails');
i=i+1;


yrange= [0 max([method_list(:).mean_c])];

figure('color','w','position',[w*i,100,w,h]);%i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_mean_c','Mean Cost',...
    'Gaussian Image Noise (pixels)','Cost (ms)');

figure('color','w','position',[w*i,100+h,w,h]);i=i+1;
xdrawgraph(nls,yrange,method_list,'deleted_med_c','Median Cost',...
    'Gaussian Image Noise (pixels)','Cost (ms)');
