function y= spc(x,M)
% y= spc(x,M)
%
% S/P Converter (Serial-to-Parallel) 
% See text pp. 307

[r, c] = size(x);
if r * c == 0
    y = [];
    return;
end;
if c == 1
    x = x.';
    len_x = r;
else
    len_x = c;
end;

nx= length(x);
q= fix((nx-1)/M)+1;
r= rem(nx-1,M);
ny= q + min(r,1);
y= zeros(M,ny);

for k=1:M
  q= fix((nx-k)/M)+1;
  tmp= x(k:M:nx);
  if k == 1			% first branch
    y(k,:)= [tmp zeros(1,ny-q)];
  else				% other branches
    y(M-k+2,:)= [0 tmp zeros(1,ny-q-1)];
  end
end

if c == 1
    y = y.';
end

