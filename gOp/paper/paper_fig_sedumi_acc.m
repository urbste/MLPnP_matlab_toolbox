

%% generate accuracy of the proposed system 
ACC = 0.1.^[1:15]
E=[];

for acc = ACC,
 opt.acc = acc;
 %opt.acc = 1e-9;

 for k=1:1000,
   fprintf(['\r' num2str(opt.acc) ' - ' num2str(k) ]);
   opt.methode ='3D' ;
   % opt.methode ='choose best'
   % opt.methode ='choose +t'


   n = 100;
   X = (rand(3,n)-0.5)*100;
   R = rpyMat(2*pi*rand(3,1));
   t = rand(3,1)*10;
   c = rand(3,n)-0.5; %% jo 
   % c=c*0; 

   p = hgenv( R*X+repmat(t,1,size(X,2))+c );
   v = normRv(p); 
   % v = v + (rand(size(v))-0.5)*0.01
   try,
   tic; [R_,t_,e,info] = gOp([v;c],X,opt); tt = toc;
    E(end+1).rotDiff = RotationDiff(R_,R);
    E(end).acc = opt.acc;
    E(end).e = e;
    E(end).t = tt;
    E(end).iter = info.iter;
    E(end).info = info;
   catch
    disp('An error occured')
   end
 end
end

save Accuracy_GPE2 E;


%% plot accuracy vs. rotDiff

acc = unique( cat(1,E.acc) ) 

f1=figure;
hold on;

f2=figure;
hold on;

f3=figure;
hold on;

f4=figure;
hold on;

f5=figure;
hold on;

f6=figure;
hold on;

DD = [];
DR = [];
DT = [];
DE = [];
DI = [];
DER=[];
for i=acc',
 fi   = find( cat(1,E.acc) == i );
 data = E(fi);

 rd = cat(1,data.rotDiff);
 %figure(f1);
 %plot_mean_and_std_log(i,rd',0.5,'k') 

 %% save i , rd 
 DR{end+1} = [ i rd' ];
 
 tt =  cat(1,data.t);
 DT{end+1} = [i tt' ];  

 %figure(f2);
 %plot_mean_and_std_log(i,tt',0.5,'k') 

 e =  cat(1,data.e);
 % figure(f3);
 % plot_mean_and_std_log(i,e',0.5,'k') 
 DE{end+1} = [i e' ];  

 iter =  cat(1,data.iter);
% figure(f4);
% plot_mean_and_std_log(i,iter',0.5,'k') 
 DI{end+1} = [i iter' ];  

 %figure(f5);
 %plot(i,length(fi),'rx');
  
 DD{end+1} = [ i length(fi) ];
 ee = cat(1,data.info);

 %figure(f6);
 ee = abs( cat(1,ee.ErrorM) - cat(1,ee.gamma) );
 %plot_mean_and_std_log(i,ee',0.5,'k') ;
 DER{end+1} = [ i ee' ];
end

 opt1.mean.c='k-'; opt1.mean.s=2;
 %opt1.std.c='k-'; opt1.std.s=1;
 opt1.median.c='k--'; opt1.median.s=1.8;
 opt1.quart.c='k--'; opt1.quart.s=1.5;
 opt1.minmax.c='k--'; opt1.minmax.s=1.5;
 opt1.log = 1;
 opt1.mean_.c='kx-';
 opt1.median_.c='rx--';

clear opt1;

 opt1.median.c='k-'; opt1.median.s=1.8;
 opt1.quart.c='k-'; opt1.quart.s=1.5;
% opt1.minmax.c='k--'; opt1.minmax.s=1.5;
 opt1.log = 1;
% opt1.mean_.c='kx-';
 opt1.median_.c='kx-';


SZ = [296 488 565 271]
%SZ = [296   465   598   294];
%SZ = [296 551 448 208]
figure(f1); set(f1,'Position',SZ); set(f1,'PaperPositionMode','auto');
plot_stat(DR,[],opt1);
set(get(f1,'Child'),'YScale','log')
set(get(f1,'Child'),'XScale','log')
xlabel('Accuracy for SeDuMi');
ylabel('rotation error (degree)');
a = axis;a=[10^-16 10^1 10^-5 10^1];axis(a);


figure(f2); set(f2,'Position',SZ); set(f2,'PaperPositionMode','auto');
plot_stat(DT,[],opt1);
%set(get(f2,'Child'),'YScale','log')
set(get(f2,'Child'),'XScale','log')
xlabel('Accuracy for SeDuMi');
ylabel('cpu time');
a=axis;a(1:2) = [10^-16 10^1];axis(a);

figure(f3); set(f3,'Position',SZ); set(f3,'PaperPositionMode','auto');
plot_stat(DE,[],opt1);
set(get(f3,'Child'),'YScale','log')
set(get(f3,'Child'),'XScale','log')
xlabel('Accuracy for SeDuMi');
ylabel('estimated error');
a=axis;a = [10^-16 10^1 10^-12 10^1];axis(a);



figure(f6);  set(f6,'Position',SZ); set(f6,'PaperPositionMode','auto');
plot_stat(DER,[],opt1)
set(get(f6,'Child'),'YScale','log')
set(get(f6,'Child'),'XScale','log')
xlabel('Accuracy for SeDuMi');
ylabel('|Solution - \gamma |');
a=axis;a(1:2) = [10^-16 10^1];axis(a);



clear opt1;
%opt1.median.c='k-'; opt1.median.s=1.8;
%opt1.quart.c='k-'; opt1.quart.s=1.5;
opt1.mean_.c='kx-';
opt1.log = 1;
figure(f4); set(f4,'Position',SZ); set(f4,'PaperPositionMode','auto');
plot_stat(DI,[],opt1);
%set(get(f4,'Child'),'YScale','log')
set(get(f4,'Child'),'XScale','log')
xlabel('Accuracy for SeDuMi');
ylabel('SeDuMi iterations');
a=axis;a(1:2) = [10^-16 10^1];axis(a);

figure(f5);  set(f5,'Position',SZ); set(f5,'PaperPositionMode','auto');
plot_stat(DD,[],opt1)
%set(get(f5,'Child'),'YScale','log')
set(get(f5,'Child'),'XScale','log')
xlabel('Accuracy for SeDuMi');
ylabel('Valid Computations');
a=axis;a = [10^-16 10^1 0 1010];axis(a);




figure(f1);  print(f1,'acc_rot.eps', ['-d' 'epsc']);
figure(f2);  print(f2,'acc_cpu.eps', ['-d' 'epsc']);
figure(f3);  print(f3,'acc_err.eps', ['-d' 'epsc']);
figure(f4);  print(f4,'acc_iter.eps', ['-d' 'epsc']);
figure(f5);  print(f5,'acc_valid.eps', ['-d' 'epsc']);
figure(f6);  print(f6,'acc_gamma.eps', ['-d' 'epsc']);
