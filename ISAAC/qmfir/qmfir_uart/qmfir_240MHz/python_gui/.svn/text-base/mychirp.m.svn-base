function [s,pha] = mychirp(T,W, p,f_begin,i_chirp_dir,i_band)
% TW : time-bandwidth product
% p  : sample at p times the Nyquist rate (W)

ci= sqrt(-1);

i_chirp_up= 1;
i_chirp_dn= 2;

i_base= 0;
i_pass= 1;

% n_off= f_begin*p*T;
% n_off= fix(n_off);

n_off= fix(p*T*W/2);

alpha= 1/(2*p^2*T*W);
N= floor(p*T*W);
n= 0:N-1;

%s= exp(i*2*pi*alpha*(n-N/2).^2);

if i_chirp_dir==i_chirp_dn
  if i_band == i_base
%    pha= 2*pi*alpha*(N+n_off-n).^2;
    pha = -2*pi*alpha*(n-n_off).^2;
    s= exp(ci*pha);
  else
    s= cos(2*pi*alpha*(N+n_off-n).^2);
  end
else
  if i_band == i_base
    pha = 2*pi*alpha*(n-n_off).^2;
    s= exp(ci*pha);		% up chirp
  else
    s= cos(2*pi*alpha*(n+n_off).^2);	
  end
end






