function [y,y_burst] = pts( x, fs, T_0, g, T_out, T_ref, fc, r, a, v, tpad, angles )
%PTS      simulate radar returns from a single pulse
%-----
%  Usage:
%    R = radar( X, Fs, T_0, G, T_out, T_ref, Fc, R, A, V )
%
%      X:      input pulse (vector containing one pulse for burst)
%      Fs:     sampling frequency of input pulse(s)      [in MHz]
%      T_0:    start time(s) of input pulse(s)         [microsec]
%      G:      complex gains; # pulses = length(g)
%      T_out:  2-vector [T_min,T_max] defines output
%                window delay times w.r.t. start of pulse
%      T_ref:  system "reference" time, needed to simulate
%                 burst returns. THIS IS THE "t=0" TIME !!!
%      Fc:     center freq. of the radar.                [in MHz]
%      R:      vector of ranges to target(s)         [kilometers]
%      A:      (complex) vector of target amplitudes
%      V:      vector of target velocities (optional)  [in m/sec]
%      t_pad:  padding window [usec]
%      angles: [the0,phi0,phitgt], [look, azimuth, target] angles
%
%  note(1): VELOCITY in meters/sec !!!
%           distances in km, times in microsec, BW in MegaHz.
%
%  note(2): assumes each pulse is constant (complex) amplitude
%  note(3): will accommodate up to quadratic phase pulses
%  note(4): vector of ranges, R, allows DISTRIBUTED targets
%
%
%---------------------------------------------------------------
% copyright 1994, by C.S. Burrus, J.H. McClellan, A.V. Oppenheim,
% T.W. Parks, R.W. Schafer, & H.W. Schussler.  For use with the book
% "Computer-Based Exercises for Signal Processing Using MATLAB"
% (Prentice-Hall, 1994).
%---------------------------------------------------------------
% Modified by Charles Le, 10/05/2007


CJ = sqrt(-1);		% complex i
c = 0.3;         	% km/usec, velocity of light

r = r(:);
a = a(:);


if nargin < 7
  v = zeros(length(r),1);	% default = 0 m/sec
end

[Mx, Nx] = size(x);
if Mx == 1
   old_Nx = Nx;
   Mx = Nx;
   Nx = 1;
   x = x.';
end

if Nx ~= 1
  error('MATRIX x NOT ALLOWED !!!');
end

g = g(:).';		%-- gains of each pulse in burst
delta_t = 1/fs;		% sampling period
T_p = Mx*delta_t;	% pulse length in usec

t_x = (delta_t)*[0:(Mx-1)]'; % pulse sampling times

x_ph = unwrap(angle(x));       % find phase modulation
q = polyfit( t_x, x_ph, 2 );   % assume LFM signal

xfit = polyval( q, t_x );

if (x_ph'*xfit)/norm(x_ph)/norm(xfit) < 0.99   %-- correlation coeff
   disp(' no quadratic phase match')
end

%
%---  output matrix ---
%

t_y = [ T_out(1):delta_t:T_out(2) ]';  	% output sampling times

Mr = length(t_y);			% range dimension
Nr = length(g);     			% pulse dimension
y = zeros(Mr,Nr);			% output matrix, [range, pulse]

the0= angles(1);
phi0= angles(2);
phitgt= angles(3);

Afact= sin(the0)*sin(phi0) + phitgt*sin(the0)*cos(phi0);

for  i = 1:length(r)			% LOOP OVER TARGETS

  ri = r(i);				% target range
%  vi = v(i)/(10^9);  			% target velocity, convert m/sec to km/usec
  vi= v(i);
  f_doppler = 2*(vi/c)*fc;		% doppler frequency
 
  for j = 1:length(g)			% LOOPS OVER PULSES

%    r_at_T_0 = ri - vi*T_0(j);    	% target range @ start of pulse, toward rcvr: f_doppler > 0
    r_at_T_0 = ri + Afact*vi*T_0(j);    % target range @ start of pulse, toward rcvr: f_doppler > 0

    tau = r_at_T_0./(c/2+vi);		% time elapsed before reaching target, measured wrt T_0(j)
    tmax = tau + T_p;			% time of last returning sample 

    if tau >= T_out(2) | tmax <= T_out(1)		% T_out(1) < tau < tau + T_p < T_out(2)

      disp(' ');
      disp(['COMPLETELY OUT OF range window, decrease Tout(1) = ' num2str(T_out(1)) ' & increase Tout(2) = ' num2str(T_out(2))]);
      disp(['Target ' num2str(i) ', range ' num2str(ri) ', tau ' num2str(tau) ', tmax ' num2str(tmax)]);  

    else

%      t_in_pulse = t_y - tau + (2*vi/c)*t_y;			% normalized wrt first return sample
      t_in_pulse = t_y - tau - (2*vi*Afact/c)*t_y;			% normalized wrt first return sample

      n_out = find( t_in_pulse >= 0  &  t_in_pulse < T_p );	% time indices when there's sample return

      if tau < T_out(1)
         nsamp_inv= fix( (T_out(1)-tau)/delta_t);
         if nsamp_inv > 1
           disp(' ');
           disp(['BEFORE range window, decrease Tout(1) = ' num2str(T_out(1))])
           disp(['Target ' num2str(i) ', range ' num2str(ri) ', tau ' num2str(tau) ', nsamp ' num2str(nsamp_inv)]);  
         end
      end

      if tmax > T_out(2)
         nsamp_inv= (tmax-T_out(2))/delta_t;
         if nsamp_inv > 1 
           disp(' ');
           disp(['AFTER range window, increase Tout(2) = ' num2str(T_out(2))]);    
           disp(['Target ' num2str(i) ', range ' num2str(ri) ', tmax ' num2str(tmax) ', nsamp ' num2str(nsamp_inv)]);  
         end
      end
       

      if length(n_out) < 1

         disp('NO OVERLAP ???, check sampling rate fs');  

      else

        y(n_out,j)= y(n_out,j) + a(i) * g(j) * ...
                   [ exp( CJ*2*pi*2*fc*(-r_at_T_0 + vi*t_y(n_out))/c ) ].* ...
                   [ exp( CJ*polyval(q,t_in_pulse(n_out)) ) ];

      end % if n_out

    end % if tau

  end % for j, pulses

end % for i, targets


% Assemble pulses to make a long burst

y_burst= y(:,1);
Nburst= length(y_burst);

% first target is reference

r1 = r(1);				% target 1 range
v1 = v(1)/(10^9);  			% target 1 velocity, convert m/sec to km/usec

T01= T_0(1);				% time reference of pulse 1 
r1_at_T01 = r1 - v1*T01;   		% target range at start of pulse 1
tau1 = r1_at_T01./(c/2+v1);		% time elapsed before reaching target, measured wrt T_0(1)

r_at_T0j = r1 - v1*T_0;			% target range @ start of pulse j
tauj = r_at_T0j./(c/2+v1);		% time elapsed before reaching 1st target
tdly= T_0+tauj-T_out(1);		% time delay of pulse j, T_out(1) is reference
idly= fix(tdly/delta_t);		% index delay


for j = 2:length(g)			% loop over pulses

  if Mr < (idly(j)-idly(j-1))

    y_burst= [y_burst;...
              zeros(idly(j)-Mr,1);...
              y(:,j)];

  else

    y_burst= [y_burst(1:idly(j)-1);...
              y_burst(idly(j):Nburst)+y(1:Nburst-idly(j)+1,j);...
              y(Nburst-idly(j)+2:Mr,j)];

    Nburst= length(y_burst);

  end

end

% substract/add guarding window to start/end

y_burst= [zeros(fix(tpad*fs),1);y_burst;zeros(fix(tpad*fs),1)];
y= [zeros(fix(tpad*fs),1);y;zeros(fix(tpad*fs),1)];








