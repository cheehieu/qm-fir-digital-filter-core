%Nrngshft= 4100;		    	% Target shift in time samples
 				% To avoid target "wrap-around" effect, choose
				% Nrngshft > (chirp length + t_pad) * fs0 
				% Nrngshft > (chirp length + t_swath + t_pad) * fs0
				% 3100 < Nrngshft < 14,000

ckm= 0.3;                   	% km/usec, light speed 
t_N= 2;                     	% Number of targets
t_tpad= 5;                  	% usec, guard window before/after receiving window
t_swath= 117;			% usec, swath width
t_H= 800;                   	% km, platform attitude
t_Rearth= 6378;			% km, earth radius
a_velo= 7500;               	% m/s, platform relative velocity
a_freq= 1.285e9;             	% Hz, radar frequency
r_T= T;                     	% usec, pulse width

% Antenna & Beams

g_bigthe= 40;			% degree, look angle
g_bigphi= 0;			% degree, azimuth angle
g_phitgt= 0;			% degree, target azimuth angle

g_bigthe= onedeg*g_bigthe;
g_bigphi= onedeg*g_bigphi;
g_phitgt= onedeg*g_phitgt;

g_angles= [g_bigthe g_bigphi g_phitgt];

g_eta= asin(sin(g_bigthe)*(t_Rearth+t_H)/t_Rearth);	% incidence angle
t_range0= (t_Rearth+t_H)*sin(g_eta-g_bigthe)/sin(g_eta);


a_PRF= 7300;                	% Hz, radar PRF
a_PRI= 1/a_PRF;		
a_Naz= 1;                   	% Number of pulses (azimuth samples) per dwell
a_gain= ones(1,a_Naz);		% gain of each pulse

T_0= (a_PRI*1e6)*(0:a_Naz-1);		% usec, starting times of input pulses

if t_N == 1                 % POINT TARGET
  t_rngs= 20;				% km, target ranges
  t_amps= 1;				% target amplitude
  t_vels= 0*1e-9;			% km/usec, target velocities
elseif t_N == 2             % DISTRIBUTED TARGET
  t_rngs= t_range0 + [0 ckm*t_swath];	% km, target ranges 
  t_amps= [1 0.5];			% target amplitude
  t_vels= [a_velo a_velo];		% m/s, targets' velocities
end

t_vels= t_vels*1e-9;			% convert to km/usec

% Receiving Window
% T_out(1) < t1st < t1st + Tp + Swath < T_out(2)

the0= g_angles(1);
phi0= g_angles(2);
phitgt= g_angles(3);

Afact= sin(the0)*sin(phi0) + phitgt*sin(the0)*cos(phi0);

t_tfirst= 10000;				% time of first sample

for k= 1:t_N
  tmp= min( (t_rngs(k) - Afact*t_vels(k)*T_0)/(ckm/2+t_vels(k)) );
  t_tfirst= min(t_tfirst,tmp);
end


if t_N == 1
  t_tlast= t_tfirst + r_T;
else
  t_tlast= t_tfirst + r_T + 2*t_swath;		% time of last sample
end

%t_tfirst= t_tfirst - t_tpad;			% substract/add guarding window to start/end
%t_tlast= t_tlast + t_tpad;

%if t_N == 1
%  T_outmin= 100;			% usec, start of receiving window
%  T_outmax= 270;			% usec, end of receiving window
%elseif t_N == 2
%  T_outmin= 100;
%  T_outmax= 270+t_rngs(2)/(.3/2);
%end

T_out= [t_tfirst t_tlast];	% usec, receiving window

T_ref= 0;			% usec, reference time, why anything else