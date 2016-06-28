%Author: Gerald Schweighofer 

%% generate all figs of the BMVC'08 paper 

%% accuracy plot (Figure 2)
paper_fig_sedumi_acc

%% timeing plot (Figure 3)
paper_fig_time

%% Noise Plot (Figure 4) 
K = [800 0 320;0 800 240;0 0  1];
fx = inline( '(rand(3,10)-0.5).*repmat([2;2;2],1,10)');
ft = inline( '[0;0;6]');
diff_sigma = [0:3:15];
iter = 400;
E=[];
paper_fig_gauss


