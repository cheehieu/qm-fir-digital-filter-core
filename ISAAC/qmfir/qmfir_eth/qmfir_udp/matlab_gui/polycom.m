function [y,ny,nr]= polycom(x,M)
% y= polycom(x,M)
%
% Function to determine the polyphase components of vector x
% The matrix y is of size [M,ny] where ny=fix(nx/M)+1
% The first nr components have length ny
% The remaining components has length ny-1 with one zero padded at the end
% Each row contains the components

nx= length(x);
nq= fix(nx/M);
nr= rem(nx,M);
ny= nq + min(nr,1);

ry= zeros(M,ny);

for k=1:M
   if (k <= nr)|(nr == 0)
      y(k,:)= x(k:M:nx);
   else
      y(k,:)= [x(k:M:nx) 0];
   end
end
