function y=cshift(x,lshift,N)
% y = cshift(x,lshift,N)
% function to CIRCULARLY ROTATE (modulo N) the vector x by l samples
%
% y[n] = x[n-l] = n[(n-l) mod N] = x[n-l]	n = l, ... , N-1
%                                  x[n+N-l]	n = 0, ... , l-1
%
% if N > length(x), x is first ZERO-PADDED, then SHIFTED
% if N < length(x), x is first TRUNCATED, then SHIFTED
% If N is omitted, then N=length(x)
%
% Example: 	cshift([1 2 3 4 5],2,5)= 	[4 5 1 2 3];
%		cshift([1 2 3 4 5],-2,5)= 	[3 4 5 1 2]
%		cshift([1 2 3 4 5],2,7)=	[0 0 1 2 3 4 5]
%		cshift([1 2 3 4 5],2,3)=	[2 3 1]
%
% Written by Charles Le, 01/25/97
% References: see Burrus, pp. 67.

[r,c]= size(x);
if r==1
  x= x.';
  nx= c;
else
  nx= r;
end;

if nargin == 2
  N= length(x);
end

y= zeros(N,1);
x= [x;zeros(N-nx,1)];

% Make sure 0 <= l <= N 
l= rem(lshift,N);
if l < 0
  l= N+l;
end

% Now rotate 
for n = 1:N
  if n <= l
    y(n) = x(n+N-l);
  else
    y(n) = x(n-l);
  end
end

if r==1
  y= y.';
end;




