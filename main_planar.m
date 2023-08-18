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

clear all; clc;
IniToolbox;

% experimental parameters
nl= [1,2,3,4,5,6,7,8,9,10];
nlsamples = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]; %percentatge of samples for each sigma
npts= [10:10:200];
num = 200;

% if you want to use UPnP you have to download and install OpenGV
% also if you want to reproduce the runtime shown in the MLPnP paper
% yout have to install the OpenGV fork with MLPnP 

name = {'MLPnPWithCov','MLPnP','LHM', 'EPnP+GN', 'RPnP', 'DLS', 'PPnP', 'ASPnP', 'SDP', 'OPnP', 'EPPnP', 'CEPPnP'};
f = {@MLPNP_with_COV,  @MLPNP_without_COV, @LHM, @EPnP_GN,  @RPnP, @robust_dls_pnp, @PPnP, @ASPnP, @GOP, @OPnP, @EPPnP, @CEPPnP};
marker = { 'x', 'd', 's',      'd',      '^',            '*',   '<',      'v',      '>','o','+','<'};
color = {'g',  'g', 'c',      [1,0.5,0],'m',       [1,0.5,1],  'b',      'y',      'r','k','k',[1,0.5,0.5]};
markerfacecolor = {'g','b','c',[1,0.5,0],'m',     [1,0.5,1],  'b',      'y',      'r','k','n',[0,0.5,0.5]};

method_list= struct('name', name, 'f', f, 'mean_r', zeros(size(npts)), 'mean_t', zeros(size(npts)),...
    'med_r', zeros(size(npts)), 'med_t', zeros(size(npts)), 'std_r', zeros(size(npts)), 'std_t', zeros(size(npts)),...
    'mean_e', zeros(size(npts)),...
    'marker', marker, 'color', color, 'markerfacecolor', markerfacecolor);

meanR = zeros(length(npts),length(method_list)+1);
medianR = zeros(length(npts),length(method_list)+1);
meanT = zeros(length(npts),length(method_list)+1);
medianT = zeros(length(npts),length(method_list)+1);
medianTime = zeros(length(npts),length(method_list)+1);
meanE = zeros(length(npts),length(method_list)+1);

% camera's parameters
f= 800;
K = [f 0 0;
     0 f 0;
     0 0 1];

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
    
    index_fail = cell(1,length(name));
    
    for j= 1:num
        % generate 3d coordinates in world space
        XXw= [xrand(2,npt,[-2 2]); zeros(1,npt)];

		R= rodrigues(randn(3,1)); % cw
        t= [rand-0.5;rand-0.5;rand*4+4];
        
        Xc= R*XXw+repmat(t,1,npt);

        % projection
        xx= [Xc(1,:)./Xc(3,:); Xc(2,:)./Xc(3,:)]*f;
   	
        nnl = round(npt * nlsamples);
        nls = zeros(1,npt);
        id  = 1;
        for idnl = 1:length(nl)
            sigma = nl(idnl);
            nls(id:id+nnl(idnl)-1) = sigma .* ones(1,nnl(idnl));
            id = id+nnl(idnl);
        end
        
        randomvals = randn(2,npt);
        xxn= xx+randomvals.*[nls;nls];
        homx = [xxn/f; ones(1,size(xxn,2))];
        v = normc(homx);
        
        Cu = zeros(2,2,npt);
        Evv = zeros(3,3,npt);
        cov = zeros(9,size(Cu,3));
        for id = 1:npt
            Cu(:,:,id) = diag([nls(id) nls(id)]);
            cov_proj = K\diag([nls(id) nls(id) 0])/K';
            J = (eye(3)-(v(:,id)*v(:,id)')/(v(:,id)'*v(:,id)))/norm(homx(:,id));
            Evv(:,:,id) = J*cov_proj*J';
            cov(:,id) = reshape(Evv(:,:,id),9,1);
        end
        
        % pose estimation
        for k= 1:length(method_list)
            try
               if strcmp(method_list(k).name, 'CEPPnP') 
                    tic;
                    mXXw = XXw - repmat(mean(XXw,2),1,size(XXw,2));
                    [R1,t1]= method_list(k).f(mXXw,xxn/f,Cu);
                    t1 = t1 - R1 * mean(XXw,2);
                    tcost = toc; 
                elseif strcmp(method_list(k).name, 'MLPnP') || strcmp(method_list(k).name, 'MLPnPWithCov') 
                    tic;
                    [R1,t1]= method_list(k).f(XXw, v, cov);
                    tcost = toc;
                else
                    tic;
                    [R1,t1]= method_list(k).f(XXw, xxn/f);
                    tcost = toc;
                end
            catch
                disp(['The solver - ',method_list(k).name,' - encounters internal errors!!!']);
                index_fail{k} = [index_fail{k}, j];
                continue;
            end
            
            %no solution
            if size(t1,2) < 1
                disp(['The solver - ',method_list(k).name,' - returns no solution!!!']);
                index_fail{k} = [index_fail{k}, j];
                continue;
            elseif (sum(sum(sum(imag(R1).^2))>0) == size(R1,3) || sum(sum(imag(t1(:,:,1)).^2)>0) == size(t1,2))
                index_fail{k} = [index_fail{k}, j];
                continue;
            end
			
            %choose the solution with smallest error 
            error = inf;
            for jjj = 1:size(R1,3)
                tempy = cal_pose_err([R1(:,:,jjj) t1(:,jjj)],[R t]);
                if sum(tempy) < error
                    cost  = tcost;
                    ercorr= mean(sqrt(sum((R1(:,:,jjj) * XXw +  t1(:,jjj) * ones(1,npt) - Xc).^2)));
                    y     = tempy;
                    error = sum(tempy);
                end
            end
            
            method_list(k).c(j)= cost * 1000;
            method_list(k).e(j)= ercorr;
            method_list(k).r(j)= y(1);
            method_list(k).t(j)= y(2);
        end

        showpercent(j,num);
    end
    fprintf('\n');
    
    % save result
    for k= 1:length(method_list)
       %results without deleting solutions
       tmethod_list = method_list(k);
       method_list(k).c(index_fail{k}) = [];
       method_list(k).e(index_fail{k}) = [];
       method_list(k).r(index_fail{k}) = [];
       method_list(k).t(index_fail{k}) = [];

       % computational cost should be computed in a separated procedure as
       % in main_time.m

       method_list(k).pfail(i) = 100 * numel(index_fail{k})/num;

       method_list(k).mean_c(i)= mean(method_list(k).c);
       method_list(k).mean_e(i)= mean(method_list(k).e);
       method_list(k).med_c(i)= median(method_list(k).c);
       method_list(k).med_e(i)= median(method_list(k).e);
       method_list(k).std_c(i)= std(method_list(k).c);
       method_list(k).std_e(i)= std(method_list(k).e);

       method_list(k).mean_r(i)= mean(method_list(k).r);
       method_list(k).mean_t(i)= mean(method_list(k).t);
       method_list(k).med_r(i)= median(method_list(k).r);
       method_list(k).med_t(i)= median(method_list(k).t);
       method_list(k).std_r(i)= std(method_list(k).r);
       method_list(k).std_t(i)= std(method_list(k).t);

       meanR (i,1) = npt;
       meanT (i,1) = npt;
       medianR (i,1) = npt;
       medianT (i,1) = npt;            
       medianTime(i,1) = npt;
       meanE (i,1) = npt;

       meanR(i,k+1) = method_list(k).mean_r(i);
       meanT(i,k+1) = method_list(k).mean_t(i);
       medianR(i,k+1) = method_list(k).med_r(i);
       medianT(i,k+1) = method_list(k).med_t(i);
       medianTime(i,k+1) = method_list(k).med_c(i);
       meanE(i,k+1) = method_list(k).mean_e(i);

       %results deleting solutions where not all the methods finds one
       tmethod_list.c(unique([index_fail{:}])) = [];
       tmethod_list.e(unique([index_fail{:}])) = [];
       tmethod_list.r(unique([index_fail{:}])) = [];
       tmethod_list.t(unique([index_fail{:}])) = [];

       method_list(k).deleted_mean_c(i)= mean(tmethod_list.c);
       method_list(k).deleted_mean_e(i)= mean(tmethod_list.e);
       method_list(k).deleted_med_c(i)= median(tmethod_list.c);
       method_list(k).deleted_med_e(i)= median(tmethod_list.e);
       method_list(k).deleted_std_c(i)= std(tmethod_list.c);
       method_list(k).deleted_std_e(i)= std(tmethod_list.e);

       method_list(k).deleted_mean_r(i)= mean(tmethod_list.r);
       method_list(k).deleted_mean_t(i)= mean(tmethod_list.t);
       method_list(k).deleted_med_r(i)= median(tmethod_list.r);
       method_list(k).deleted_med_t(i)= median(tmethod_list.t);
       method_list(k).deleted_std_r(i)= std(tmethod_list.r);
       method_list(k).deleted_std_t(i)= std(tmethod_list.t);
    end
end

%save planar3Dresults method_list npts;

plotPlanar3D;
