function plot_stat(y,data,opt)
%
%
% plots statistical stuff !
%
% opt.mean   : draws the mean
% opt.std    : draws mean+std , mean-std
% opt.median : draws the median
% opt.quart  : draws 1/4 and 3/4 quartile
% opt.minmax : draws min & max
%
% opt.mean_,opt.median_,opt.number_ : 
%            : conect the types with a line !
%
% all of them have fields .c : color style
%                         .s : size  
%
% opt.log    : draws logaritmic scales


hold on;

%erg=[];

if iscell(y),
  %% we have a cell array 
  DR = y;
  y=[];
  for i=1:length(DR),
     d = DR{i};
     k = plot_mean_and_std1(d(2:end),d(1),opt);
     if length(k) > 0,  
        erg(i,:) = k;
     end

     y(i) = d(1);
  end
else
 for i=1:size(data,1),
   k = plot_mean_and_std1(data(i,:),y(i),opt);
   if length(k) > 0,  
      erg(i,:) = k;
    end

  end
end

if exist('erg'),
 for i=1:size(erg,2),
   d = cat(1,erg(:,i).d);
   plot(y,d,erg(1,i).s.c,'LineWidth',2);
 end
end

% plot(y,mean(E,2),c);

function [erg] = plot_mean_and_std1(data,y,opt)
  erg=[];  

  m=mean(data);  
  s=std(data);   
  md=median(data);
  mm = [max(data) min(data)];
  
  
  if isfield(opt,'mean'),
    [c,dx1,dx2] = get_look(y,opt,opt.mean);
    plot([dx1 dx2],[m m],c,'LineWidth',2);
  end
    
  if isfield(opt,'std'),  
    [c,dx1,dx2] = get_look(y,opt,opt.std);
    plot([y y],[m m+s],c,'LineWidth',2);
    plot([y y],[m m-s],c,'LineWidth',2);
    plot([dx1 dx2],[m+s m+s],c,'LineWidth',2);
    plot([dx1 dx2],[m-s m-s],c,'LineWidth',2);
  end

  if isfield(opt,'median'),
    [c,dx1,dx2] = get_look(y,opt,opt.median);
    plot([dx1 dx2],[md md],c,'LineWidth',2);
  end
 
 if isfield(opt,'quart'),
   d=sort(data); 
   mi = ceil(length(d)/2);
   s = length(d);
   qu = d(round(s*0.25));
   qo = d(round(s*0.75));
  
   [c,dx1,dx2] = get_look(y,opt,opt.quart);
   plot([dx1 dx2 dx2 dx1 dx1],[qu qu qo qo qu],c,'LineWidth',2);
 end

 if isfield(opt,'minmax'),
   qu = min(data);
   qo = max(data);
  
   [c,dx1,dx2] = get_look(y,opt,opt.minmax);
   plot([dx1 dx2 dx2 dx1 dx1],[qu qu qo qo qu],c,'LineWidth',2);
 end

 if isfield(opt,'mean_'),
   erg(end+1).d = m;
   erg(end).s = opt.mean_;
 end
 if isfield(opt,'median_'),
   erg(end+1).d = md;
   erg(end).s = opt.median_;
 end
 if isfield(opt,'number_'),
   erg(end+1).d = length(data);
   erg(end).s = opt.number_;
 end
   


function [c,dx1,dx2] = get_look(y,opt,opti)
%
%
%
  c = opti.c;
  if isfield(opt,'log'),
    dx1 = y*opti.s; dx2 = y/opti.s;
  else
    dx1 = y-opti.s; dx2 = y+opti.s;
  end