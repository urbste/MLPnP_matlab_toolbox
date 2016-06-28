
function R=rotate(a,b,c)
%
%function R=rotate(a,b,z)
%
%returns rotationsmatrix 
%
  Rb  = [ cos(b) 0 -sin(b); 0 1 0 ; sin(b) 0 cos(b) ];
  Rc  = [ cos(c) -sin(c) 0 ; sin(c) cos(c) 0; 0 0 1 ];
  Ra  = [ 1 0 0; 0 cos(a) -sin(a);0 sin(a) cos(a)];
  
  R = Ra*Rb*Rc;

  
