

function Inew=addError(Iorig,error)
%
% error -> sigma von Guass-Verteilung 
%  Pixel Error  
%

E=normrnd(0,error,length(Iorig(:,1)),1);


%K=[];
for i=1:length(Iorig(:,1)),
  point = Iorig(i,1:2);
  
  winkel = rand*180;
  wrad = winkel*pi/180;
  
  dx = sin(wrad)*E(i);
  dy = cos(wrad)*E(i);
 % K = [K ; [dx dy]];
 de(i,:)=[dx dy];
  Inew(i,:) = [  Iorig(i,1)+dx  Iorig(i,2)+dy  Iorig(i,3:size(Iorig,2)) ];
end

%plot(K(:,1),K(:,2),'x');