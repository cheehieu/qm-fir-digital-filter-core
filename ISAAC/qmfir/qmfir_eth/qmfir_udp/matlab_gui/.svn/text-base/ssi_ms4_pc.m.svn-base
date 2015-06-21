%
% Pulse compression
% Pulse compression is just convolution.  
% if nfft > L+P-1 then the number of good points is always L+P-1, the rest are zero
%
% When nfft0= 1024, let nmid= nfft0/2+1, then y0(nmid-3) ~ -57 dB and y0(nmid-2) ~ -31 dB,
% and the null appears to be at nmid-3.
% This is a dubious null (due to sampling)
% When interpolate by a factor of (4,8),  the null is at (nmid - 9, nmid -18).
% This is a true null

Nint= 8;				% set inv fft size large for interpolation
%nfftpc0= Nint*nfft0;

%infft0= 16*nfft0;			% use this to find the true null and 3db
%infft1= 32*nfft1;

infft0= nfft0;				% use this for plotting purpose
infft1= nfft0;				% set ifft0 = ifft1 for comparison

win1= (hamming(N1)).';

j1= fft(x1r,nfft1);                 	% Nyquist sampled chirp
j1win= fft(x1r.*win1,nfft1);		% Nyquist reference
jk= j1.*conj(j1win);
jkp= [jk(1:nfft1/2) zeros(1,infft1-nfft1) jk(nfft1/2+1:nfft1)];
yr= ifft(jkp,infft1);

j1= fft(xiqm1,nfftd);                 	% decimated sig
j1win= fft(x1r.*win1,nfftd);		% Nyquist reference
jk= j1.*conj(j1win);				 
jkp= [jk(1:nfftd/2) zeros(1,infft1-nfftd) jk(nfftd/2+1:nfftd)];
y1= ifft(jkp,infft1);

j1= fft(xiqm2,nfftd);                 	% decimated sig
j1win= fft(x1r.*win1,nfftd);		% Nyquist reference
jk= j1.*conj(j1win);
jkp= [jk(1:nfftd/2) zeros(1,infft1-nfftd) jk(nfftd/2+1:nfftd)];
y2= ifft(jkp,infft1);

zr= fftshift(abs(yr)/max(abs(yr)));
z1= fliplr(fftshift(abs(y1)/max(abs(y1))));
z2= fliplr(fftshift(abs(y2)/max(abs(y1))));

return;

% compute pslr, islr
% middle point is infft0/2+1

% theoretical null and 3db

[xpeak,ipeak]= max(zr);
inul= round(2*(fs1/W)*(infft1/nfft1));
i3db= ceil((1.3/4)*inul);

disp('reference chirp');
radpar_islr2(zr,1,beta,W,fs1,nfft1,infft1)
disp('chirp 1');
radpar_islr2(z1,1,beta,W,fs1,nfft1,infft1)
disp('chirp 2');
radpar_islr2(z2,1,beta,W,fs1,nfft1,infft1)


