function ssi_ms4_K_afterHardware
%SSI	Split Spectrum Implementation - Multi-Stage Decimation Design
%
%	SSI simulates an offset video chirp, designes the bandpass decimation
%	filter, designes the halfband filter, performs the bandpass decimation
%	filtering at the required output format, and pulse-compresses the 
%	decimated output.
%	
%	Only the bandpass decimation filtering portion is required for
%	HW implementation at this time.
%
%	In this first iteration, the decimation factor is assumed to be an integer.
%	However, fractional decimation ratio is a desired feature for future
% 	iteration.
%  

%       Charles Le, 02/15/04.
%	This work was performed at the Jet Propulsion Laboratory, California
%	Institute of Technology, under contract with the National Aeronautics
%	and Space Administration.
%
%	Version 0.1
%
%	FOR OFFICIAL USE only.
%
%	This program was sent to AccelChip for a quick conversion to RTL design,
%	so that the JPL team can evaluate the effectiveness of AccelChip's tools.
%
%  2008/04/02. Modify and send to ISAAC team for FPGA's development and implementation.
%  2008/05/27. Version 2: implement polyphase representation
%  2008/06/17. Version 3: impose HW constraints on filter length
%  2008/07/01. Version 4: simulate radar receive window with multiple targets 
  

clear;

%%%%%%%%%%%%%%%%%
%%% CONSTANTS %%%
%%%%%%%%%%%%%%%%%

constants;

%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUT PARAMETERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%

params;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for Target Simulator %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

params_tgtsim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CALCULATED PARAMETERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Radar parameters

p0= fs0/W;			% oversampling factor
p1= fs1/W;			% oversampling factor

w_ov1= 2*pi*f_ov1/fs0; 		% normalized offset video frequency
w_ov2= 2*pi*f_ov2/fs0; 		% normalized offset video frequency


% Filter parameters

Q= 2^(1-nbits);			% quantization step
wbpc1= 2*pi*fbpc1/fs0;		% normalized subband center frequency
wbpc2= 2*pi*fbpc2/fs0;		% normalized subband center frequency
wbpc3= 2*pi*fbpc3/fs0;		% normalized subband center frequency

M= floor(fs0/fs1);		% decimation factor

if i_demod == i_quad
  wbpcm1= mod(wbpc1*M,2*pi);	% normalized decimated subband center frequency
  wbpcm2= mod(wbpc2*M,2*pi);	% normalized decimated subband center frequency
  wbpcm3= mod(wbpc3*M,2*pi);	% normalized decimated subband center frequency
else		
  wbpcm1= mod(wbpc1*M/2,2*pi) - pi/2;
  wbpcm2= mod(wbpc2*M/2,2*pi) - pi/2;
end

%%% overall frequency specifications

wc= 2*pi*(1/2/M);		% cutoff frequency
wp= 0.052359877559830;%alpha*wc;			% alias-free passband
%ws= 2*wc - wp;			% stopband frequency
ws= wc;				% stopband frequency

fpass= W/2;			
fstop= fs1/2;


%%% multistage specifications

MI= 3;
M1= 5;
M2= 5;
M3= 2;

fsm1= fs0/M1;
fsm2= fsm1/M2;
fsm3= fsm2/M3;
 
fpass1= fpass;
fstop1= fsm1 - fstop; 
wc1= 2*pi*(1/2/M1);
wpass1= 2*pi*(fpass1/fs0);
wstop1= 2*pi*(fstop1/fs0);

fpass2= fpass;
fstop2= fsm2 - fstop; 
wc2= 2*pi*(1/2/M2);
wpass2= 2*pi*(fpass2/fsm1);
wstop2= 2*pi*(fstop2/fsm1);

fpass3= fpass;
fstop3= fsm3 - fstop; 
wc3= 2*pi*(1/2/M3);
wpass3= 2*pi*(fpass3/fsm2);
wstop3= 2*pi*(fstop3/fsm2);


if hlng_m == 0
%  if i_filt == i_hamm

%%% single stage

%    hlng= ceil(3.32*M/(1-alpha))
    Ap= 1 - 10^(-delp/20);
    As= 10^(dels/20);
    hlng= fix((-20*log10(sqrt(Ap*As))-13)/(14.6*(ws-wp)/(2*pi)) + 1);
%  end

%%% multi stage

    Api= Ap/MI;
    Asi= As;
    hlng1= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstop1-wpass1)/(2*pi)) + 1);
    hlng2= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstop2-wpass2)/(2*pi)) + 1);
    hlng3= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstop3-wpass3)/(2*pi)) + 1);

    % Extend filter length to multiple of decimation ratio

    if (mod(hlng1,M1) ~= 0)
        hlng1= (floor(hlng1/M1)+1)*M1;
    end
    hlng1= min(hlng1,hlng1_max);
    
    if (mod(hlng2,M2) ~= 0)
        hlng2= (floor(hlng2/M2)+1)*M2;
    end
    hlng2= min(hlng2,hlng2_max);
    
    if (mod(hlng3,M3) ~= 0)
        hlng3= (floor(hlng3/M3)+1)*M3;
    end
    hlng3= min(hlng3,hlng3_max);
    
    rdly1= (hlng1-1)/2;
    rdly2= (hlng2-1)/2;
    rdly3= (hlng3-1)/2;

    ndly1= fix(rdly1);
    ndly2= fix(rdly2);
    ndly3= fix(rdly3);


  if mod(hlng,2) ~= 0
    hlng= hlng+1;
  end

else
  hlng= hlng_m*M;
end



%%%%%%%%%%%%%%%%%%%%%%%%
%%% CHIRP GENERATION %%%
%%%%%%%%%%%%%%%%%%%%%%%%

% For pulse compression, set nfft0 >= (2N0-1)

N0= floor(p0*T*W);
nfft0= 2^nextpow2(2*N0-1); 

% Oversampled chirp at fs0

[x0,pha0]= mychirp(T,W, p0,f_begin0,i_chirp_dir,i_band0);
px0= fft(x0,nfft0);

% Nyquist sampled chirp at fs1

N1= floor(p1*T*W);
nfft1= 2^nextpow2(2*N1-1);
[x1r,pha1r]= mychirp(T,W,p1,f_begin0,i_chirp_dir,i_band0);
px1r= fft(x1r,nfft1);


% Up-convert to offset video

xc1= sqrt(2)*((real(x0).*cos(w_ov1*(0:N0-1)) + imag(x0).*sin(w_ov1*(0:N0-1))));
xc2= sqrt(2)*((10^(A2/10))*(real(x0).*cos(w_ov2*(0:N0-1)) + imag(x0).*sin(w_ov2*(0:N0-1))));


pxc1= fft(xc1,nfft0);
pxc2= fft(xc2,nfft0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE RANGE LINE (complex) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[xpulse,xburst]= pts(x0,fs0,T_0,a_gain,T_out,T_ref,a_freq/1e6,t_rngs,t_amps,t_vels,t_tpad,g_angles);

xpulse= -imag(xpulse) + ci*real(xpulse);

% Upconverted to offset video

Nrp= length(xpulse);
nfftr= 2^nextpow2(2*Nrp-1); 

mod_angle= w_ov1*(0:Nrp-1).';
xpulse1= sqrt(2)*(real(xpulse).*cos(mod_angle) - imag(xpulse).*sin(mod_angle));
mod_angle= w_ov2*(0:Nrp-1).';
xpulse2= (10^(A2/20))*sqrt(2)*(real(xpulse).*cos(mod_angle) - imag(xpulse).*sin(mod_angle));

pxpulse= fft(xpulse,nfftr);
pxpulse1= fft(xpulse1,nfftr);
pxpulse2= fft(xpulse2,nfftr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Front-End Thermal Noises %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%xn0r= (10^(-SNR0/10))*(rand(1,N0)-0.5);	% front-end thermal noise
%xn0i= (10^(-SNR0/10))*(rand(1,N0)-0.5);	% front-end thermal noise
%xn0= xn0r + ci*xn0i;
%pxn0= fft(xn0,nfft0);

xn0r= An*2*(rand(1,Nrp)-0.5);	% front-end thermal noise
xn0i= An*2*(rand(1,Nrp)-0.5);	% front-end thermal noise
xn0= xn0r + ci*xn0i;
pxn0= fft(xn0,nfftr);

%%%%%%%%%%%%%%%%%%%%%
%%% FILTER DESIGN %%%
%%%%%%%%%%%%%%%%%%%%%

%%% For Decimation 

rdly= (hlng-1)/2;

if (i_filt == i_rect) | (i_filt == i_hamm)	% rectangular or hamming

%%% single stage

  h0= zeros(1,hlng);
  ihlf= fix((hlng-1)/2);

  if ihlf == rdly		% odd length
    h0(ihlf+1) = wc/pi;
  else				% even length
    ihlf= ihlf+1;
  end

  iv= 1:ihlf;
  h0(iv)= sin(wc*(iv-1-rdly))./(pi*(iv-1-rdly));
  if i_filt == i_hamm
    h0(iv)= h0(1:ihlf).* (.54 - .46*cos(2*pi*(iv-1)/hlng));
  end
  h0(hlng-iv+1)= h0(iv);


%%% multistage

% 1st stage

  hms1= zeros(1,hlng1);
  ihlf1= fix((hlng1-1)/2);

  if ihlf1 == rdly1
    hms1(ihlf1+1) = wc1/pi;
  else
    ihlf1= ihlf1+1;
  end

  iv= 1:ihlf1;
  hms1(iv)= sin(wc1*(iv-1-rdly1))./(pi*(iv-1-rdly1));
  if i_filt == i_hamm
    hms1(iv)= hms1(1:ihlf1).* (.54 - .46*cos(2*pi*(iv-1)/hlng1));
  end
  hms1(hlng1-iv+1)= hms1(iv);

% 2nd stage

  hms2= zeros(1,hlng2);
  ihlf2= fix((hlng2-1)/2);

  if ihlf2 == rdly2
    hms2(ihlf2+1) = wc2/pi;
  else
    ihlf2= ihlf2+1;
  end

  iv= 1:ihlf2;
  hms2(iv)= sin(wc2*(iv-1-rdly2))./(pi*(iv-1-rdly2));
  if i_filt == i_hamm
    hms2(iv)= hms2(1:ihlf2).* (.54 - .46*cos(2*pi*(iv-1)/hlng2));
  end
  hms2(hlng2-iv+1)= hms2(iv);

% 3rd stage

  hms3= zeros(1,hlng3);
  ihlf3= fix((hlng3-1)/2);

  if ihlf3 == rdly3
    hms3(ihlf3+1) = wc3/pi;
  else
    ihlf3= ihlf3+1;
  end

  iv= 1:ihlf3;
  hms3(iv)= sin(wc3*(iv-1-rdly3))./(pi*(iv-1-rdly3));
  if i_filt == i_hamm
    hms3(iv)= hms3(1:ihlf3).* (.54 - .46*cos(2*pi*(iv-1)/hlng3));
  end
  hms3(hlng3-iv+1)= hms3(iv);


elseif i_filt == i_kaiser			% kaiser

  Ar= 70;
  if Ar > 50
    beta_k= 0.1102*(Ar-8.7);
  elseif (Ar > 21)&(Ar < 50)
    beta_k= 0.5842*(Ar-21)^0.4 + 0.07886*(Ar-21);
  else
    beta_k= 0;
  end
  
  h0= kaiser(hlng,beta_k);
  delf= (Ar-7.95)/(14.35*(hlng-1));

elseif i_filt == i_mult				% lagrange multiplier

  Nhlf= hlng/2;
  Qdim= Nhlf;
  Ncons= 2;

  x= zeros(Nhlf,1);
  Qm= zeros(Qdim,Qdim);
  Cm= zeros(Ncons,Qdim);
  Km= [1;zeros(Nhlf-1,1)];

  for i= 1:Qdim
    for k= 1:Qdim
      if k==i
        Qm(i,k)= pi - ws - sin((2*i-1)*ws)/(2*i-1);
      else
        Qm(i,k)= -sin((i+k-1)*ws)/(i+k-1) - sin((i-k)*ws)/(i-k);
      end
    end
  end

  for i= 1:Ncons
    for k= 1:Qdim
      Cm(i,k)= (-(k-1/2)^2)^(i-1);
    end
  end

  CQC= inv(Cm*inv(Qm)*Cm.');
  QC= inv(Qm)*Cm.';

  v0= CQC(:,1);
  u0= QC*v0;
  v1= CQC(:,2);
  u1= QC*v1;

  for i= 1:Nhlf
    s_tkv(i)= cos((i-1/2)*wp);
  end

  kv(1)= 1;
  Gwp= 10^(-1.5/20);   % gain at passband edge (5.3 for maxflat)

  kv(2)= (Gwp - s_tkv*u0)/(s_tkv*u1);

  Es= 20*log10(kv*(CQC*kv')/(2*pi));
  lambda= (1/pi)*(CQC*kv');

  x= (kv(1)*u0 + kv(2)*u1);
  x= u0;                        % maxflat design is optimal

  h0= [flipud(x);x]/2;

elseif i_filt == i_remz				% remez exchange

%  dels = 10^((hlng*14.6*(1-alpha)/M +13)/(-20))/sqrt(M-1);
%  h0= remez(hlng-1,[0 wp/pi ws/pi 1],[1 1 0 0],[1 16.8702]);      % 16.8702 for alpha = 0.8, N=4M

  [h0,err]= remez(hlng-1,[0 wp/pi ws/pi 1],[1 1 0 0],[1 20]);
  [hms1,err]= remez(hlng1-1,[0 wpass1/pi wstop1/pi 1],[1 1 0 0],[1 20]);
  [hms2,err]= remez(hlng2-1,[0 wpass2/pi wstop2/pi 1],[1 1 0 0],[1 20]);
  [hms3,err]= remez(hlng3-1,[0 wpass3/pi wstop3/pi 1],[1 1 0 0],[1 20]);

%  [h0,err]= firpm(hlng-1,[0 wp/pi ws/pi 1],[1 1 0 0],[1 20]);               % Matlab new version
%  [hms1,err]= firpm(hlng1-1,[0 wpass1/pi wstop1/pi 1],[1 1 0 0],[1 20]);
%  [hms2,err]= firpm(hlng2-1,[0 wpass2/pi wstop2/pi 1],[1 1 0 0],[1 20]);
%  [hms3,err]= firpm(hlng3-1,[0 wpass3/pi wstop3/pi 1],[1 1 0 0],[1 20]);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Filter Quantization %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

if i_quant == i_noquant
   h0q= h0;
else

  if i_quantshift == i_shift
    if i_filt == i_hamm      % when quantized, make the peak same as for Remez
      h0s= h0 +0.014;
    elseif i_filt == i_mult
      h0s= h0 + 0.0487;
    end
  else
    h0s= h0;
  end

  h0q= Q*floor(h0s/Q+0.5);   % 2's-complement rounding
  if i_quant == i_pow2
        h0q= sign(h0q).* (2.^floor(log2(abs(h0q)) + 0.5));
  end

  h0q= fxquant(h0,nbits,'trunc','overfl');  % this is much better than pow2

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate Equivalent Multi Stage Composite Filter %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hms2_up= upsmpl(hms2,M1);
hms3_up= upsmpl(hms3,M1*M2);
j2= conv(hms1,hms2_up);
hmseq= conv(j2,hms3_up);

ph0= fft(h0,nfft0);

phms1= fft(hms1,nfft0);
phms2= fft(hms2,nfft0);
phms3= fft(hms3,nfft0);
phmseq= fft(hmseq,nfft0);

junk= find(abs(phms1)==0);
if ~isempty(junk) 
  phms1(junk)= phms1(min(junk)-1)*ones(1,length(junk));
end

junk= find(abs(phms2)==0);
if ~isempty(junk) 
  phms2(junk)= phms2(min(junk)-1)*ones(1,length(junk));
end

junk= find(abs(phms3)==0);
if ~isempty(junk) 
  phms3(junk)= phms3(min(junk)-1)*ones(1,length(junk));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s
%%% Measurement Noises %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% white

%xn3r= (10^(-SNR3/10))*(rand(1,N0)-0.5);	% front-end thermal noise
%xn3i= (10^(-SNR3/10))*(rand(1,N0)-0.5);	% front-end thermal noise
%xn3full= xn3r + ci*xn3i;

xn3r= (10^(-SNR3/10))*(rand(1,Nrp)-0.5);	% front-end thermal noise
xn3i= (10^(-SNR3/10))*(rand(1,Nrp)-0.5);	% front-end thermal noise
xn3full= xn3r + ci*xn3i;

% complex bandpass filtered

%xn3filt= filter(h0q3,[1],xn3full);

% modulate down to baseband

%xn3base= xn3filt.*exp(ci*wbpc3*(0:N0-1));

% create real signal

%xn3= sqrt(2)*(real(xn3base).*cos(wbpc3*(0:N0-1)) + imag(xn3base).*sin(wbpc3*(0:N0-1)));

%pxn3= fft(xn3,nfft0);


%%% Add all the signals together %%%

%xov= xc1+xc2+xn0+xn3;
%xov= xc1+xc2+xn0;
%xov= xc1+xc2+xn0r;

xov= xpulse1.' + xpulse2.' + xn0r;
xov= K_ADC*xov/max(xov);            % signal scaling between [-1,1]
pxov= fft(xov,nfftr);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% START THE BASEBANDING AND DECIMATION FILTERING PROCESS %%%
%%% HW Implementation                                      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Multi-stage implementation: loop 3 times thru the 3 lowpass decimation filters

for ichan= 1:MI

  if ichan == 1 		% chirp 1
    wshift= wbpc1;
    ndly= fix((hlng-1)/2);
  elseif ichan == 2		% chirp 2
    wshift= wbpc2;
  else
    wshift= wbpc3;		% noise
  end


%%% Channel basebanding

%  xov = load('signal.txt');
% 
%    xbsr= xov'.*cos(wshift*(0:Nrp-1));
%    xbsi= xov'.*sin(wshift*(0:Nrp-1));
%   if ichan == 1
%     fid = fopen('xbsr_c1.txt', 'wt');  
%     fprintf(fid,'%15.8e\n',xbsr);
%     fclose(fid);
%     fid = fopen('xbsi_c1.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi);
%     fclose(fid);  
%   elseif ichan == 2
%     fid = fopen('xbsr_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr);
%     fclose(fid);
%     fid = fopen('xbsi_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi);
%     fclose(fid);
%   else
%     fid = fopen('xbsr_c3.txt', 'wt');   
%     fprintf(fid,'%15.8sie\n',xbsr);
%     fclose(fid);
%     fid = fopen('xbsi_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi);
%     fclose(fid);
%   end
%
% 05/27/08, Charles Le
% Commenting out for efficient polyphase representation
%

%%% 1st decimation filter

%  xbsr1= filter(hms1,[1],[xbsr zeros(1,ndly1)]);
%  xbsi1= filter(hms1,[1],[xbsi zeros(1,ndly1)]);
 
%  xbsr1= xbsr1(ndly1+1:length(xbsr1));
%  xbsi1= xbsi1(ndly1+1:length(xbsi1));

%  xbsr1= dnsmpl(xbsr1,M1);
%  xbsi1= dnsmpl(xbsi1,M1);

%%% 2nd decimation filter

%  xbsr2= filter(hms2,[1],[xbsr1 zeros(1,ndly2)]);
%  xbsi2= filter(hms2,[1],[xbsi1 zeros(1,ndly2)]);
 
%  xbsr2= xbsr2(ndly2+1:length(xbsr2));
%  xbsi2= xbsi2(ndly2+1:length(xbsi2));

%  xbsr2= dnsmpl(xbsr2,M2);
%  xbsi2= dnsmpl(xbsi2,M2);

%%% 3rd decimation filter

%  xbsr3= filter(hms3,[1],[xbsr2 zeros(1,ndly3)]);
%  xbsi3= filter(hms3,[1],[xbsi2 zeros(1,ndly3)]);
 
%  xbsr3= xbsr3(ndly3+1:length(xbsr3));
%  xbsi3= xbsi3(ndly3+1:length(xbsi3));

%  xbsr3= dnsmpl(xbsr3,M3);
%  xbsi3= dnsmpl(xbsi3,M3);

%  xiq= sqrt(2)*(xbsr3 + ci*xbsi3);

%
%%% 05/27/08, Charles Le
%%% Polyphase representation
%

%   xbsr_pp1= myfirdecim(xbsr,hms1,M1);        % 1st stage
%   xbsi_pp1= myfirdecim(xbsi,hms1,M1);
%   if ichan == 1
%     fid = fopen('xbsr1_c1.txt', 'wt');  
%     fprintf(fid,'%15.8e\n',xbsr_pp1);
%     fclose(fid);
%     fid = fopen('xbsi1_c1.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp1);
%     fclose(fid);  
%   elseif ichan == 2
%     fid = fopen('xbsr1_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_pp1);
%     fclose(fid);
%     fid = fopen('xbsi1_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp1);
%     fclose(fid);
%   else
%     fid = fopen('xbsr1_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_pp1);
%     fclose(fid);
%     fid = fopen('xbsi1_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp1);
%     fclose(fid);
%   end
%   
%   xbsr_pp2= myfirdecim(xbsr_pp1,hms2,M2);     % 2nd stage
%   xbsi_pp2= myfirdecim(xbsi_pp1,hms2,M2);
%   if ichan == 1
%     fid = fopen('xbsr2_c1.txt', 'wt');  
%     fprintf(fid,'%15.8e\n',xbsr_pp2);
%     fclose(fid);
%     fid = fopen('xbsi2_c1.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp2);
%     fclose(fid);  
%   elseif ichan == 2
%     fid = fopen('xbsr2_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_pp2);
%     fclose(fid);
%     fid = fopen('xbsi2_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp2);
%     fclose(fid);
%   else
%     fid = fopen('xbsr2_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_pp2);
%     fclose(fid);
%     fid = fopen('xbsi2_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp2);
%     fclose(fid);
%   end
% 
%   xbsr_pp3= myfirdecim(xbsr_pp2,hms3,M3);     % 3rd stage
%   xbsi_pp3= myfirdecim(xbsi_pp2,hms3,M3);
%   if ichan == 1
%     fid = fopen('xbsr3_c1.txt', 'wt');  
%     fprintf(fid,'%15.8e\n',xbsr_pp3);
%     fclose(fid);
%     fid = fopen('xbsi3_c1.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp3);
%     fclose(fid);  
%   elseif ichan == 2
%     fid = fopen('xbsr3_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_pp3);
%     fclose(fid);
%     fid = fopen('xbsi3_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp3);
%     fclose(fid);
%   else
%     fid = fopen('xbsr3_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_pp3);
%     fclose(fid);
%     fid = fopen('xbsi3_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_pp3);
%     fclose(fid);
%   end
  
% 9/24/08 - Kayla Nguyen
% Matlab representation of Verilog
% 
%  xbsr = [xbsr zeros(1,20)]; 
%  xbsi = [xbsi zeros(1,20)]; 
% 
% xbsr_1 = KaylaFirdecim(floor(length(xov)),xbsr,5,hms1,15);
% xbsi_1 = KaylaFirdecim(floor(length(xov)),xbsi,5,hms1,15);

%  if ichan == 1
%     fid = fopen('xbsr_1_c1kk.txt', 'wt');   % data to feed to 2nd filter (r)
%     fprintf(fid,'%15.8e\n',xbsr_1);
%     fclose(fid);
%     fid = fopen('xbsi_1_c1kk.txt', 'wt');   % data to feed to 2nd filter (i)
%     fprintf(fid,'%15.8e\n',xbsi_1);
%     fclose(fid);  
%   elseif ichan == 2
%     fid = fopen('xbsr_1_c2.txt', 'wt');   % data to feed to 2nd filter (r)
%     fprintf(fid,'%15.8e\n',xbsr_1);
%     fclose(fid);
%     fid = fopen('xbsi_1_c2.txt', 'wt');   % data to feed to 2nd filter (i)
%     fprintf(fid,'%15.8e\n',xbsi_1);
%     fclose(fid);
%   else
%     fid = fopen('xbsr_1_c3.txt', 'wt');   % data to feed to 2nd filter (r)
%     fprintf(fid,'%15.8e\n',xbsr_1);
%     fclose(fid);
%     fid = fopen('xbsi_1_c3.txt', 'wt');   % data to feed to 2nd filter (i)
%     fprintf(fid,'%15.8e\n',xbsi_1);
%     fclose(fid);
%  end

% 
%  xbsr_1 = [zeros(1,20) xbsr_1 zeros(1,20)];
%  xbsi_1 = [zeros(1,20) xbsi_1 zeros(1,20)];
% 
% xbsr_2 = KaylaFirdecim(floor(length(xov)/5+20),xbsr_1,5,hms2,20);%length(xbsr_1)-20,xbsr_1,5,hms2,20);
% xbsi_2 = KaylaFirdecim(floor(length(xov)/5+20),xbsi_1,5,hms2,20);%length(xbsr_1)-20,xbsr_1,5,hms2,20);

%  if ichan == 1
%     fid = fopen('xbsr_2_c1kk.txt', 'wt');   % data to feed to 2nd filter (r)
%     fprintf(fid,'%15.8e\n',xbsr_2);
%     fclose(fid);
%     fid = fopen('xbsi_2_c1kk.txt', 'wt');   % data to feed to 2nd filter (i)
%     fprintf(fid,'%15.8e\n',xbsi_2);
%     fclose(fid);  
%   elseif ichan == 2
%     fid = fopen('xbsr_2_c2.txt', 'wt');   % data to feed to 2nd filter (r)
%     fprintf(fid,'%15.8e\n',xbsr_2);
%     fclose(fid);
%     fid = fopen('xbsi_2_c2.txt', 'wt');   % data to feed to 2nd filter (i)
%     fprintf(fid,'%15.8e\n',xbsi_2);
%     fclose(fid);
%   else
%     fid = fopen('xbsr_2_c3.txt', 'wt');   % data to feed to 2nd filter (r)
%     fprintf(fid,'%15.8e\n',xbsr_2);
%     fclose(fid);
%     fid = fopen('xbsi_2_c3.txt', 'wt');   % data to feed to 2nd filter (i)
%     fprintf(fid,'%15.8e\n',xbsi_2);
%     fclose(fid);
%  end


%  xbsr_2 = [zeros(1,48) xbsr_2 zeros(1,50)];
%  xbsi_2 = [zeros(1,48) xbsi_2 zeros(1,50)];
%  
% xbsr_3 = KaylaFirdecim(floor(length(xov)/25+48),xbsr_2,2,hms3,50);
% xbsi_3 = KaylaFirdecim(floor(length(xov)/25+48),xbsi_2,2,hms3,50);

%  if ichan == 1
%     fid = fopen('xbsr_3_c1kk.txt', 'wt');  
%     fprintf(fid,'%15.8e\n',xbsr_3);
%     fclose(fid);
%     fid = fopen('xbsi_3_c1kk.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_3);
%     fclose(fid);  
%    elseif ichan == 2
%     fid = fopen('xbsr_3_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_3);
%     fclose(fid);
%     fid = fopen('xbsi_3_c2.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_3);
%     fclose(fid);
%   else
%     fid = fopen('xbsr_3_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsr_3);
%     fclose(fid);
%     fid = fopen('xbsi_3_c3.txt', 'wt');   
%     fprintf(fid,'%15.8e\n',xbsi_3);
%     fclose(fid);
% end 
    if ichan == 1
        xbsr_3 = load('real1.txt')';
        xbsr_3 = xbsr_3(14:length(xbsr_3));
        xbsi_3 = load('imag1.txt')';
        xbsi_3 = xbsi_3(14:length(xbsi_3));
    elseif ichan == 2
        xbsr_3 = load('real2.txt')';
        xbsr_3 = xbsr_3(14:length(xbsr_3));
        xbsi_3 = load('imag2.txt')';
        xbsi_3 = xbsi_3(14:length(xbsi_3));
    else
        xbsr_3 = load('real3.txt')';
        xbsr_3 = xbsr_3(14:length(xbsr_3));
        xbsi_3 = load('imag3.txt')';
        xbsi_3 = xbsi_3(14:length(xbsi_3));
    end
    if length(xbsr_3) < 346
        xbsr_3(length(xbsr_3)+1:346) = 0;
        xbsi_3(length(xbsi_3)+1:346) = 0;
    end
    xbsi_3 = floor(xbsi_3*(2^14));
    xbsr_3 = floor(xbsr_3*(2^14));
    xbsshift = bitshift(xbsi_3, 16);
    xbstotal = xbsshift + xbsr_3;
    
%     if ichan == 1
%         figure(2), plot(xbsr_3), title('Real chan1');
%         figure(3), plot(xbsi_3), title('Imaginary chan1');
%         figure(9), plot(xbstotal), title('channel1');
%     else if ichan == 2
%             figure(4), plot(xbsr_3), title('Real chan2');
%             figure(6), plot(xbsi_3), title('Imaginary chan2');
%         else 
%             figure(7), plot(xbsr_3), title('Real chan3');
%             figure(8), plot(xbsi_3), title('Imaginary chan3');
%         end
%     end

  xiq= sqrt(2)*(xbsr_3 + ci*xbsi_3);

  if ichan == 1
    xiqm1= xiq;
  elseif ichan == 2
    xiqm2= xiq;
  else
    xiqm3= xiq;
  end

end

Nrd= length(xiqm1);
nfftd= 2^nextpow2(Nrd);

pxiqm1= fft(xiqm1,nfftd);
pxiqm2= fft(xiqm2,nfftd);
pxiqm3= fft(xiqm3,nfftd);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Done BDF Process! %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare the frequency axis for plot

fs2= 2*fs1;

w0= (2*pi/nfft0)*[0:(nfft0-1)];
mid= ceil(nfft0/2)+1;
w0(mid:nfft0) = w0(mid:nfft0) - 2*pi;
w0= fftshift(w0);
freq0= w0/2/pi*fs0;

w1= (2*pi/nfft1)*[0:(nfft1-1)];
mid= ceil(nfft1/2)+1;
w1(mid:nfft1) = w1(mid:nfft1) - 2*pi;
w1= fftshift(w1);
freq1= w1/2/pi*fs1;

wr= (2*pi/nfftr)*[0:(nfftr-1)];
mid= ceil(nfftr/2)+1;
wr(mid:nfftr) = wr(mid:nfftr) - 2*pi;
wr= fftshift(wr);
freqr= wr/2/pi*fs0;

wd= (2*pi/nfftd)*[0:(nfftd-1)];
mid= ceil(nfftd/2)+1;
wd(mid:nfftd) = wd(mid:nfftd) - 2*pi;
wd= fftshift(wd);
freqd= wd/2/pi*fs1;


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pulse Compression %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

ssi_ms4_pc;


%%%%%%%%%%%%%%%%
%%% Plotting %%%
%%%%%%%%%%%%%%%%

% ssi_ms4_p1;
% ssi_ms4_p4;
ssi_ms4_p5;


% Saving

return;       % Comment it out to save
% 
% fid = fopen('signal.txt','wt');             % offset video signal
% fprintf(fid,'%15.8e\n',xov);
% fclose(fid);
% 
% fid = fopen('fir1.txt','wt');               % 1st stage's filter
% fprintf(fid,'%15.8e\n',hms1);
% fclose(fid);
% 
% fid = fopen('fir2.txt','wt');               % 1st stage's filter
% fprintf(fid,'%15.8e\n',hms2);
% fclose(fid);
% 
% fid = fopen('fir3.txt','wt');               % 1st stage's filter
% fprintf(fid,'%15.8e\n',hms3);
% fclose(fid);





