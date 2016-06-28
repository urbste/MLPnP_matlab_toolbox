%% time vs number of points
%
%Author: Gerald Schweighofer

E=[];

 for n=unique( [4 5 6 7 8 9 10:10:100 100:100:1000] ),
%    for n=unique( [ 10] ),
 n
 for k=1:100,
   opt.acc = 1e-10;
   opt.methode ='3D' ;
   % opt.methode ='choose best'
   % opt.methode ='choose +t'
   X = (rand(3,n)-0.5)*100;
   R = rpyMat(2*pi*rand(3,1));
   t = rand(3,1)*10;
   c = rand(3,n)*5;
   % c=c*0; 

   p = hgenv( R*X+repmat(t,1,size(X,2))+c );
   v = normRv(p); 
   % v = v + (rand(size(v))-0.5)*0.01
   try,
   tic; [R_,t_,e,info] = gOp([v;c],X,opt); 
    tt = toc;
    E(end+1).rotDiff = RotationDiff(R_,R);
    E(end).acc = opt.acc;
    E(end).e = e;
    E(end).t = tt;
    E(end).iter = info.iter;
    E(end).info = info;
    E(end).n = n;
   catch
    disp('An error occured')
   end
 end
end
 %   return;

save Speed_GPE E;

acc = unique( cat(1,E.n) ) 

DD=[];

for i=acc',
 fi   = find( cat(1,E.n) == i );
 data = E(fi);
 tt = cat(1,data.info);
  
 DD(end+1,:) = [i median(  cat(1,tt.time_sedum_call)  )  mean(cat(1,data.iter))  median( cat(1,tt.time_global_pose))  ];
end

f=figure;SZ = [296   465   598   294];
plot(DD(:,1),DD(:,2),'kx-','LineWidth',2); hold on 
plot(DD(:,1),DD(:,4),'kx--','LineWidth',2); hold on 
legend('SeDuMi solver','Global Pose',2);
xlabel('number of points');
ylabel('cpu time [sec]');
%a = axis;a(3) = 0;axis(a);
set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
print(f,'speed.eps', ['-d' 'epsc']);

fi = find(DD(:,1) <= 100 );
f=figure;
plot(DD(fi,1),DD(fi,2),'kx-','LineWidth',2); hold on 
plot(DD(fi,1),DD(fi,4),'kx--','LineWidth',2); hold on 
legend('SeDuMi solver','Global Pose',2);
xlabel('number of points');
ylabel('cpu time [sec]');
%a = axis;a(4) = ceil(a(4)*100)/100; a(3) = floor(a(3)*100)/100;axis(a);
set(f,'Position',SZ); set(f,'PaperPositionMode','auto');
print(f,'speed_zi.eps', ['-d' 'epsc']);
