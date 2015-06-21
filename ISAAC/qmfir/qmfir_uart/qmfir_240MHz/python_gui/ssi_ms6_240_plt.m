% Prepare the frequency axis for plot

fs2= 2*fs1;

w0= (2*pi/nfft0)*[0:(nfft0-1)];
mid= ceil(nfft0/2)+1;
w0(mid:nfft0) = w0(mid:nfft0) - 2*pi;
w0= fftshift(w0);
freq0= w0/2/pi*fs0;

wr= (2*pi/nfftr)*[0:(nfftr-1)];
mid= ceil(nfftr/2)+1;
wr(mid:nfftr) = wr(mid:nfftr) - 2*pi;
wr= fftshift(wr);
freqr= wr/2/pi*fs1;

wd= (2*pi/nfftd)*[0:(nfftd-1)];
mid= ceil(nfftd/2)+1;
wd(mid:nfftd) = wd(mid:nfftd) - 2*pi;
wd= fftshift(wd);
freqd= wd/2/pi*fs1;

freq0= w0/2/pi*fs0;
freqbp= w0/2/pi*fsbp;
freq1= w0/2/pi*fsm1;
freq2= w0/2/pi*fsm2;
freq3= w0/2/pi*fsm3;


%%% Plotting %%%

ssi_ms6_240_p1;
ssi_ms6_240_p2;
ssi_ms6_240_p4;
ssi_ms6_240_p5;


