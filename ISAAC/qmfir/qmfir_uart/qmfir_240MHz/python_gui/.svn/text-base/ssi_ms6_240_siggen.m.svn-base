% For pulse compression, set nfft0 >= (2N0-1)

N0= floor(p0*T*W);
nfft0= 2^nextpow2(2*N0-1); 

% Oversampled chirp at fs0

[x0,pha0]= mychirp(T,W, p0,f_begin0,i_chirp_dir,i_band0);
px0= fft(x0,nfft0);

% Nyquist sampled chirp at fs1

Nr= floor(p1*T*W);
nfftr= 2^nextpow2(2*Nr-1);
[x1r,pha1r]= mychirp(T,W,p1,f_begin0,i_chirp_dir,i_band0);
px1r= fft(x1r,nfftr);


% Up-convert to offset video

xc1= sqrt(2)*((real(x0).*cos(w_ov1*(0:N0-1)) - imag(x0).*sin(w_ov1*(0:N0-1))));
xc2= sqrt(2)*((10^(A2/20))*(real(x0).*cos(w_ov2*(0:N0-1)) - imag(x0).*sin(w_ov2*(0:N0-1))));

xc1= ((real(x0).*cos(w_ov1*(0:N0-1)) - imag(x0).*sin(w_ov1*(0:N0-1))));
xc2= ((10^(A2/20))*(real(x0).*cos(w_ov2*(0:N0-1)) - imag(x0).*sin(w_ov2*(0:N0-1))));


pxc1= fft(xc1,nfft0);
pxc2= fft(xc2,nfft0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE RANGE LINE (complex) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[xpulse_sim,xburst]= pts(x0,fs0,T_0,a_gain,T_out,T_ref,a_freq/1e6,t_rngs,t_amps,t_vels,t_tpad,g_angles);

%xpulse= -imag(xpulse_sim) + ci*real(xpulse_sim);

%Nrp= length(xpulse);
%nfftr= 2^nextpow2(2*Nrp-1); 


% Shift pulse to simulate different target positions

%xpulse= cshift(xpulse,Nrngshft,Nrp);


% Upconverted to offset video

%mod_angle= w_ov1*(0:Nrp-1).';
%xpulse1= sqrt(2)*(real(xpulse).*cos(mod_angle) - imag(xpulse).*sin(mod_angle));
%mod_angle= w_ov2*(0:Nrp-1).';
%xpulse2= (10^(A2/20))*sqrt(2)*(real(xpulse).*cos(mod_angle) - imag(xpulse).*sin(mod_angle));

%pxpulse= fft(xpulse,nfftr);
%pxpulse1= fft(xpulse1,nfftr);
%pxpulse2= fft(xpulse2,nfftr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Front-End Thermal Noises %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xn0r= max(xc1)*An*2*(rand(1,N0)-0.5);	% front-end thermal noise
xn0i= max(xc1)*An*2*(rand(1,N0)-0.5);	% front-end thermal noise
xn0= xn0r + ci*xn0i;
pxn0= fft(xn0,nfft0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Add all the signals together %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xov= xc1+xc2+xn0r;
maxs= max(xov);

xov= K_ADC*xov/maxs;            % signal scaling between [-1,1]
pxov= fft(xov,nfft0);
