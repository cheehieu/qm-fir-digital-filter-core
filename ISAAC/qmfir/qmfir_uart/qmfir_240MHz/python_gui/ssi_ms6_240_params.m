% Radar parameters, L band 
% make sure f_begin0*p0*T = integer (mychirp.m)

i_band0= i_base;		% original baseband chirp
i_chirp_dir= i_chirp_up;	% chirp direction
T= 45;				% pulse width, microseconds			
W= 1;    			% chirp bandwidth, MHz
f_begin0= -W/2;			% lowest baseband frequency

fs0= 240;			% MHz, input sampling rate (real)
fs1= 1.2;			% MHz, new sampling frequency (complex)

%f_ov1= 12.5;			% chirp's offset video frequency
%f_ov2= 17.5;			% chirp's offset video frequency
%f_noi= 15;              	% noise's center frequency

f_offset= 50;			% MHz, offset frequency from baseband


f_ov1 = f_noi-2.5;
f_ov2 = f_noi+2.5;
%f_ov1= 50+12.5;			% MHz, chirp's offset video frequency
%f_ov2= 50+17.5;			% MHz, chirp's offset video frequency
%f_noi= 50+15;              	% MHz, noise's center frequency

%f_chan= 10;			% MHz, channel's bandwidth (why 10 ???)
f_chan= (f_ov2-f_ov1)+W;
f_chanc= f_noi;			% MHz, channel's center

fbpc1= f_ov1;			% subband center frequency, MHz
fbpw1= W;               	% subband bandwidth, MHz
fbpc2= f_ov2;			% subband center frequency, MHz
fbpw2= W;               	% subband bandwidth, MHz
fbpc3= f_noi;			% subband center frequency, MHz
fbpw3= W;               	% subband bandwidth, MHz

A1= 1;  				% amplitude 1 = max echo (-168 dBW)
A2= -25;				% dB, amplitude 2 = min echo (-193 dBW)

SNR0= 34;               		% dB, kTB (-202 dBW)
An= sqrt(3*10^(-SNR0/10));    		% magnitude of input thermal noise

SNR3= 2;                % dB

i_mod= i_iq;			% subband type

beta= 1;	              	% percentage of processing bandwidth

% Filter parameters

i_quant= i_noquant;
nbits= 12;

i_filt= i_remz;

%alpha= 0.8;			% alias-free passband percentage

fmult= 60;			% MHz, multiplier's speed

hlng_m= 0;			% filter's length, multiple of M (0 to calculate)
delp= 0.1;			% passband ripple (dB)
dels= -40;			% stopband attenuation (dB)
%dels= -60;			% stopband attenuation (dB)

Nmax= 256;			% maximum filter length

if (dels == -40)
  hlngbp_max= 16;
  hlng1_max= 15;
  hlng2_max= 25;
  hlng3_max= 50;
else
  hlngbp_max= 16;
  hlng1_max= 20;
  hlng2_max= 30;
  hlng3_max= 80;
end

%hlngbp_max= 100;
%hlng1_max= 100;
%hlng2_max= 100;
%hlng3_max= 100;



% Default Fixed-Point Properties

K_ADC= 0.25;                                    % ADC scaling factor

c_filtstruct= 'dffir';                          % Filter Structure
c_method= 'equiripple';                         % Design Method
c_arithmetic= 'fixed';                          % Arithmetic Type	
c_filtinternal= 'SpecifyPrecision';             % Filter Internal Precision

i_iput_wlng0= 8;                        % Input
i_iput_flng0= 7;

i_coef_wlng0= 16;                        % Coefficient
i_coef_flng0= 15;

i_prod_wlng0= i_iput_wlng0 + i_coef_wlng0;         % Product 
i_prod_flng0= i_iput_flng0 + i_coef_flng0;

i_accu_wlng0= i_prod_wlng0 + ceil(log2(Nmax));	% Accumulator
i_accu_flng0= i_prod_flng0;

i_oput_wlng0= 16;                                % Output
i_oput_flng0= 15;


