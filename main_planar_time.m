%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this toolbox is an addition to the toolbox provided by the authors of
% CEPPnP and OPnP
% we extended it to show the use of MLPnP
% if you use this file it would be neat to cite our paper:
%
% @INPROCEEDINGS {mlpnp2016,
%    author    = "Urban, S.; Leitloff, J.; Hinz, S.",
%    title     = "MLPNP - A REAL-TIME MAXIMUM LIKELIHOOD SOLUTION TO THE PERSPECTIVE-N-POINT PROBLEM.",
%    booktitle = "ISPRS Annals of Photogrammetry, Remote Sensing \& Spatial Information Sciences",
%    year      = "2016",
%    volume    = "3",
%    pages     = "131-138"}
%
% Copyright (C) <2016>  <Steffen Urban>

%     Steffen Urban email: urbste@googlemail.com
%     Copyright (C) 2016  Steffen Urban
% 
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 2 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License along
%     with this program; if not, write to the Free Software Foundation, Inc.,
%     51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 28.06.2016 Steffen Urban

clear; clc;
IniToolbox;

% experimental parameters
nl= [1,2,3,4,5,6,7,8,9,10];
nlsamples = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]; %percentatge of samples for each sigma
npts= [10,100:100:1000];

num = 100;

% compared methods
A= zeros(size(npts));
B= zeros(num,1);


name= {'MLPnPWithCov','MLPnP','LHM', 'EPnP','RPnP', 'DLS','PPnP', 'ASPnP','OPnP','EPPnP','CEPPnP'};
f= {@MLPNP_with_COV,  @MLPNP_without_COV,@LHM, @EPnP_planar, @RPnP, @robust_dls_pnp, @PPnP, @ASPnP,@OPnP, @EPPnP_planar, @CEPPnP_planar};
marker= { 'x', 'd', 'x', 's',      'd',      '^',            '*',   '<',            '>','o','+'};
color= {'g',  'g','c',   'r',      [1,0.5,0],'m',      [1,0.5,1],   'b',            'r','k',[0,0.5,0.5]};
markerfacecolor= {'g','g','c','g',[1,0.5,0],'m',    [1,0.5,1],   'b',            'r','k',[0,0.5,0.5]};

method_list= struct('name', name, 'f', f, 'mean_r', A, 'mean_t', A,...
    'med_r', A, 'med_t', A, 'std_r', A, 'std_t', A, 'r', B, 't', B,...
    'marker', marker, 'color', color, 'markerfacecolor', markerfacecolor);
% experiments
for i= 1:length(npts)
    
    npt= npts(i);
    fprintf('npt = %d (num sg = %d ): ', npt, length(nl));
   
    
     for k= 1:length(method_list)
        method_list(k).c = zeros(1,num);
        method_list(k).e = zeros(1,num);
        method_list(k).r = zeros(1,num);
        method_list(k).t = zeros(1,num);
    end
    
    %index_fail = [];
    index_fail = cell(1,length(name));
    
    XXw = zeros(3,npts(i),num);
    xxn = zeros(2,npts(i),num);

    for j= 1:num
        
        % camera's parameters
        width= 640;
        height= 480;
        f= 800;
                    K = [f 0 0
             0 f 0
             0 0 1];
        % generate 3d coordinates in camera space
        XXw(:,:,j)= [xrand(2,npt,[-2 2]); zeros(1,npt)];
		R= rodrigues(randn(3,1));
        t= [rand-0.5;rand-0.5;rand*4+4];
        Xc= R*XXw(:,:,j)+repmat(t,1,npt);
        
        % projection
        xx= [Xc(1,:)./Xc(3,:); Xc(2,:)./Xc(3,:)]*f;
        randomvals = randn(2,npt);
        
        nnl = round(npt * nlsamples);
        nls = zeros(1,npt);
        id  = 1;
        for idnl = 1:length(nl)
            sigma = nl(idnl);
            nls(id:id+nnl(idnl)-1) = sigma .* ones(1,nnl(idnl));
            id = id+nnl(idnl);
            
        end
        
        xxn(:,:,j)= xx+randomvals.*[nls;nls];
        
        Cu = zeros(2,2,length(nls));
        for id = 1:length(nls);
            Cu(:,:,id) = [nls(id) 0; 0 nls(id)];
        end
    end
    
    
    % pose estimation
    for k= 1:length(method_list)
        tic;
        for j=1:num
            try
                if strcmp(method_list(k).name, 'CEPPnP')
                    %mXXw = XXw - repmat(mean(XXw,2),1,size(XXw,2));
                    [R1,t1]= method_list(k).f(XXw(:,:,j),xxn(:,:,j)/f,Cu);
                    %t1 = t1 - R1 * mean(XXw,2); 
                elseif strcmp(method_list(k).name, 'MLPnP') || ...
                     strcmp(method_list(k).name, 'MLPnPWithCov') 
                    [R1,t1]= method_list(k).f(XXw,v,cov);
                else
                    [R1,t1]= method_list(k).f(XXw(:,:,j),xxn(:,:,j)/f);
                end
            catch
            end
        end
        tcost = toc;
        method_list(k).mean_c(i)= tcost * 1000/num;
    
        showpercent(k,length(method_list));
    
    end
    
    
    
    fprintf('\n');
    
end

save planar3DresultsTime method_list npts;

plotPlanar3DTime;