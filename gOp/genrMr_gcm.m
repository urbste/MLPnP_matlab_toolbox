function [M,Mc,Mcc] = genrMr_gcm(X,v,c,R)
%
%
% returns the parametrisation of the problem 
% as: r'*M*r + Mc*r + Mcc
% 
  
if nargin == 2,
  c=[];
end

if prod(size(c)) == 0,
  c = zeros(3,size(v,2));
end

if sum(size(v) ~= size(c) | size(X) ~= size(v)),
  disp('Sizes must be equal!');
  X 
  v 
  c 
  return;
end


if nargin == 4,
 t=get_opt_t(R,X,v,c)
end

 clear W
 clear V
 for pi_=1:size(v,2),
   V(pi_).V= (v(:,pi_)*v(:,pi_)')./(v(:,pi_)'*v(:,pi_));
   W(pi_).W = (V(pi_).V-eye(3)).'*(V(pi_).V-eye(3));
 end	

 G_=zeros(3);
  for pi_=1:size(X,2),
   Wi =  W(pi_).W ;
   G_=G_+ Wi+Wi';
  end
  G_=inv(G_/size(X,2))/size(X,2);

  t_opt_  = zeros(3,9);
  t_opt_c = zeros(3,1); 

  for pi_=1:size(X,2),
    Wi = W(pi_).W' + W(pi_).W ;
 
%%     t_opt = t_opt + (Wi)*(R*X(:,pi_)) + Wic(:,pi_);

    %W(pi_).
    WP =  [Wi(:,1) * X(:,pi_).'   Wi(:,2) * X(:,pi_).'   Wi(:,3) * X(:,pi_).' ];
    % t_opt_  = t_opt_ +  W(pi_).WP ; % [Wi(:,1) * X(:,pi_).'   Wi(:,2) * X(:,pi_).'   Wi(:,3) * X(:,pi_).' ];
    t_opt_  = t_opt_ +  WP ;
    t_opt_c = t_opt_c +   Wi * c(:,pi_);
  end

  t_opt_  = -G_*t_opt_;
  t_opt_c = -G_*t_opt_c;


 if nargin == 4,
    %% check if t_opt is equal to t_opt
    r = R'; r=r(:); 
    t_opt_*r + t_opt_c 
   %% seems to be correct !
 end


%% assume we have a t_opt = T*[r1..r9] + t ,   T=3x9 Matrix t=3x1
%%
%e=  (R*P)'*Wi*(R*P) +  (R*P)'*Wi*(t_opt)  + (t_opt)'*Wi*(R*P) + (t_opt)'*Wi*(t_opt)
%e=  (R*P+T*rc+t+ci)'*Wi*(R*P+T*rc+t+ci)

%e=  (R*P)'*Wi*(R*P) +  (R*P)'*Wi*(T*rc+t+ci) + (T*rc+t+ci)'*Wi*(R*P) + (T*rc+t+ci)'*Wi*(T*rc+t+ci)
%e=  (R*P)'*Wi*(R*P) +  (R*P)'*Wi*(T*rc)   + (R*P)'*Wi*(t+ci)  + rc'*T'*Wi*(R*P)    + (t+ci)'*Wi*(R*P) + (T*rc)'*Wi*(T*rc) + ((t+ci))'*Wi*(T*rc) + (T*rc)'*Wi*((t+ci)) + ((t+ci))'*Wi*((t+ci))

%e1= (R*P)'*Wi*(R*P)             +  (R*P)'*Wi*(T*rc)       + rc'*T'*Wi*(R*P)       + (T*rc)'*Wi*(T*rc) 
%e1= (v2V(P)*rc)'*Wi*(v2V(P)*rc) + (v2V(P)*rc)'*Wi*(T*rc)  + rc'*T'*Wi*(v2V(P)*rc) + rc'*T'*Wi*T*rc

%e2= (R*P)'*Wi*t              + t'*Wi*(R*P)       + t'*Wi*T*rc + (T*rc)'*Wi*(t) 
%e2= (v2V(P)*rc)'*Wi*(t+ci)   + (t+ci)'*Wi*(v2V(P)*rc) + (t+ci)'*Wi*T*rc + (T*rc)'*Wi*(t+ci) 


%e3= (t+ci)'*Wi*(t+ci)


%e=  (v2V(P)*rc)'*W*(v2V(P)*rc) +  (v2V(P)*rc)'*W*(T*rc)  + rc'*T'*W*(v2V(P)*rc) + rc'*T'*W*T*rc
%e=  rc*v2V(P)'*W*v2V(P)*rc + rc'*v2V(P)'*W*T*rc + rc'*T'*W*v2V(P)*rc + rc'*T'*W*T*rc
%e=  rc* ( v2V(P)'*W*v2V(P) + v2V(P)'*W*T + T'*W*v2V(P) + T'*W*T  ) *rc 


  M=zeros(9,9); Mc=zeros(9,1); Mcc=0;
  T = t_opt_; t = t_opt_c;
 
   for pi_=1:size(v,2),
      Wi =  W(pi_).W ;
      P  =  X(:,pi_);
      ci =  c(:,pi_);
 
      v2Vp = v2V(P);
      PWi =  v2Vp.'*Wi;

      tci = t+ci;
      v2VpT = v2Vp + T;
      Witci = Wi*tci;

      M  =M+   PWi*v2VpT + T.'*(PWi.' + Wi*T) ; % e1
      Mc =Mc+  v2VpT.'*Witci; %e2
      Mcc=Mcc+ tci.'*Witci; % e3
   end     
   Mc = 2*Mc;

if nargin == 4,
 r = R'; r=r(:); 

% M
% Mc 
% Mcc

 e = r'*M*r + r'*Mc + Mcc;
 disp(['Error using known R:' num2str(e) ]);
 %% check the error with the known R 
end

return;

 %% is MC always zero ??

 if 0,
   %% check if the functions are correct 
   if nargin ~= 4,
     R= rpyMat(rand(3,1)*2*pi); 
   end
   %% get the opt t 
   t=get_opt_t(R,X,v,c)
   
   e=0;
   for pi_=1:size(v,2),
     V= (v(:,pi_)*v(:,pi_)')./(v(:,pi_)'*v(:,pi_));
     ei= (V-eye(3))*(R*X(:,pi_)+t+c(:,pi_));
     e = e + ei.'*ei;
   end
  
   r = R';r=r(:);
   r.'*M*r + r.'*Mc + Mcc

 end


function t=get_opt_t(R,X,v,c)


%% ei =      (I-V)*(R*X+t+c) 
%% opt_t =   

 G=zeros(3,3);
 for pi_=1:size(v,2),
  V= (v(:,pi_)*v(:,pi_)')./(v(:,pi_)'*v(:,pi_));
  G=G+ V;
 end
 G=inv(eye(3)-G/size(v,2))/size(v,2);

 t_opt = zeros(3,1) ;
 for pi_=1:size(v,2),
   V= (v(:,pi_)*v(:,pi_)')./(v(:,pi_)'*v(:,pi_));
   t_opt = t_opt + (V-eye(3))*(R*X(:,pi_)+c(:,pi_));
 end
 t = G*t_opt;