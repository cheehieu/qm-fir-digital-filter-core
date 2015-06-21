function y = KaylaFirdecim(string,M,h)
%
%   function y = KaylaFirdecim(string,M,h)
%
%   This is the Matlab version of the Verilog RTL implementation of
%   the polyphase decimation filter.  This mimics the hardware function. 
%
%   string = the inputs to be filtered, vector (1xsnum_in)
%   M      = decimation factor
%   h      = filter coefficients vector
%   N      = number of taps
%

 nn = 1;
 ii = 1;
 N = length(h);
 string2 = [zeros(1,N) string zeros(1,5*N)];
 [m n] = size(string2);
 num_in = n;
while nn < (length(string)+15*M)
     y(1,ii) = sum(string2(1,nn:nn+N-1) .* h(N:-1:1));
     y(1,ii) = sum(string2(1,nn:nn+N-1) .* h(N:-1:1));
     nn = nn + M;
     ii = ii + 1;
end
 




