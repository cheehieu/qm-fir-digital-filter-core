function y = KaylaFirdecim(size,string,M,h,N)
%
%   function y = KaylaFirdecim(x,h,M)
%
%   This is the Matlab version of the Verilog RTL implementation of
%   the polyphase decimation filter.  This mimics the hardware function. 
%
%   size   = number of inputs
%   string = the inputs to be filtered, vector (1xsize)
%   M      = decimation factor
%   h      = filter coefficients vector
%   N      = number of taps
%

 nn = 1;
 ii = 1;
while nn < size
     y(1,ii) = sum(string(1,nn:nn+N-1) .* h);
     y(1,ii) = sum(string(1,nn:nn+N-1) .* h);
     nn = nn + M;
     ii = ii + 1;
end
 




