%%% Radar Parameters %%%

p0= fs0/W;			% oversampling factor
p1= fs1/W;			% oversampling factor

w_ov1= 2*pi*f_ov1/fs0; 		% normalized offset video frequency, needed for up-conversion simulation
w_ov2= 2*pi*f_ov2/fs0; 		% normalized offset video frequency


%%% Filter Parameters %%%

Q= 2^(1-nbits);			% quantization step

% Decimation Factors

MI= 4;				% number of decimation stages

Mtot= floor(fs0/fs1);		% overall decimation factor (200)
Mbp= 4;				% bandpass decimation factor
Mlp= floor(Mtot/Mbp);		% overall lowpass decimation factor (50)

M1= 5;				% 1st lowpass decimation factor
M2= 5;				% 2nd lowpass decimation factor
M3= 2;				% 3rd lowpass decimation factor

% Subband Center Frequencies

wbpc1_0= 2*pi*fbpc1/fs0;		% normalized original subband center frequency
wbpc2_0= 2*pi*fbpc2/fs0;		
wbpc3_0= 2*pi*fbpc3/fs0;		

if i_demod == i_quad
  wbpc1= mod(wbpc1_0*Mbp,2*pi);		% center frequency after 1st bandpass decimation
  wbpc2= mod(wbpc2_0*Mbp,2*pi);		
  wbpc3= mod(wbpc3_0*Mbp,2*pi);		
else		
  wbpcm1= mod(wbpc1*M/2,2*pi) - pi/2;
  wbpcm2= mod(wbpc2*M/2,2*pi) - pi/2;
end

%%% overall frequency specifications %%%

% For bandpass filter

alpha_bp= f_chan/(fs0/Mbp);	% alias-free passband percentage, bandpass (10/240/4)

wcbp= 2*pi*(1/2/Mbp);		% cutoff frequency (30 MHz)
wpbp= alpha_bp*wcbp;		% alias-free passband
wsbp= wcbp;			% stopband frequency


% For lowpass filters

alpha= W/fs1;			% alias-free passband percentage, lowpass (1/1.2)

wc= 2*pi*(1/2/Mlp);		% cutoff frequency (0.6 MHz)
wp= alpha*wc;			% alias-free passband
%ws= 2*wc - wp;			% stopband frequency
ws= wc;				% stopband frequency

% For single stage filter

wc0= 2*pi*(1/2/Mtot);		% cutoff frequency (0.6 MHz)
wp0= alpha*wc0;			% alias-free passband
%ws= 2*wc - wp;			% stopband frequency
ws0= wc0;			% stopband frequency


%%% multistage specifications


fpass_bp= f_chan/2;		% 10/2=		% 5MHz			
fstop_bp= fs0/Mbp/2;		% 240/4/2=	% 30 MHz

fpass= W/2;			% 1/2=		% 0.5 MHz			
fstop= fs1/2;			% 1.2/2=	% 0.6 MHz

fsbp= fs0/Mbp;			% 240/4=	% 60 MHz
fsm1= fsbp/M1;			% 60/5=		% 12 MHz
fsm2= fsm1/M2;			% 12/5=		% 2.4 MHz
fsm3= fsm2/M3;			% 2.4/2=	% 1.2 MHz

fpassbp= fpass_bp;
%fstopbp= fstop_bp; 
fstopbp= fsbp - fstop; 

wcbp= 2*pi*(1/2/Mbp);
wpassbp= 2*pi*(fpassbp/fs0);
wstopbp= 2*pi*(fstopbp/fs0);

fpass1= fpass;
fstop1= fsm1 - fstop; 
wc1= 2*pi*(1/2/M1);
wpass1= 2*pi*(fpass1/fsbp);
wstop1= 2*pi*(fstop1/fsbp);

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

% single stage

%    Ap= 1 - 10^(-delp/20);			% peak deviation from unity (?)
    Ap= (10^(delp/20)-1)/(10^(delp/20)+1);	% maximum passband variation
    As= 10^(dels/20);
    hlng= fix((-20*log10(sqrt(Ap*As))-13)/(14.6*(ws0-wp0)/(2*pi)) + 1);

%%% multi stage

    Api= Ap/MI;
    Asi= As;

    hlngbp= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstopbp-wpassbp)/(2*pi)) + 1);

    hlng1= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstop1-wpass1)/(2*pi)) + 1);
    hlng2= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstop2-wpass2)/(2*pi)) + 1);
    hlng3= fix((-20*log10(sqrt(Api*Asi))-13)/(14.6*(wstop3-wpass3)/(2*pi)) + 1);

    %disp(' ');
    %disp('Filter Lengths, Hbp,H1,H2,H3 = ');
    %disp(['Before HW constraints: ' num2str([hlngbp,hlng1,hlng2,hlng3])]);


% Extend filter length to multiple of decimation ratio and compare with hardware-allowed maximum

    if (mod(hlngbp,Mbp) ~= 0)
        hlngbp= (floor(hlngbp/Mbp)+1)*Mbp;
    end
    hlngbp= min(hlngbp,hlngbp_max);


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
    
    rdlybp= (hlngbp-1)/2;
    rdly1= (hlng1-1)/2;
    rdly2= (hlng2-1)/2;
    rdly3= (hlng3-1)/2;

    ndlybp= fix(rdlybp);
    ndly1= fix(rdly1);
    ndly2= fix(rdly2);
    ndly3= fix(rdly3);

    if mod(hlng,2) ~= 0
      hlng= hlng+1;
    end

else

  hlng= hlng_m*M;

  hlngbp= hlng_m*Mlp;
  hlng1= hlng_m*M1;
  hlng2= hlng_m*M2;
  hlng3= hlng_m*M3;

end

%disp(['After HW constraints: ' num2str([hlngbp,hlng1,hlng2,hlng3])]);
%disp(' ');






