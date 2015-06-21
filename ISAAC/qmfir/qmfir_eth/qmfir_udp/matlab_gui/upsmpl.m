function y=upsmpl(x,R)
% 	y=upsmpl(x,R)
%

[r, c] = size(x);		% convert to row for column vector
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

ny= R*len_x;
y= zeros(1,ny);
y(1:R:ny)= x;

if c == 1
    y = y.';
end
