function [s,angle] = mychirp(T,W, p,f_begin,i_chirp_dir,i_band)
% TW : time-bandwidth product
% p  : sample at p times the Nyquist rate (W)

i_chirp_up= 1;
i_chirp_dn= 2;

i_base= 0;
i_pass= 1;

n_off= f_begin*p*T;
n_off= fix(n_off);

alpha= 1/(2*p^2*T*W);
N= floor(p*T*W);
n= 0:N-1;
%s= exp(i*2*pi*alpha*(n-N/2).^2);
if i_chirp_dir==i_chirp_dn
  if i_band == i_base
    s= exp(i*2*pi*alpha*(N+n_off-n).^2);		% down chirp
  else
    s= cos(2*pi*alpha*(N+n_off-n).^2);
  end
else
  if i_band == i_base
    s= exp(i*2*pi*alpha*(n+n_off).^2);		% up chirp
    angle= 2*pi*alpha*(n+n_off).^2;
  else
    s= cos(2*pi*alpha*(n+n_off).^2);	
  end
end






