
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

  A_def= [1 1 0 0];

  if (dels == -40) 
    Wss= [1 1];
    Wms= [1 1];
  else
    Wss= [1 15];
    Wms= [1 15];
  end

  [h0,err]= remez(hlng-1,[0 wp0/pi ws0/pi 1],A_def,Wss);

  [hmsbp,err]= remez(hlngbp-1,[0 wpassbp/pi wstopbp/pi 1],A_def,Wms);

  [hms1,err]= remez(hlng1-1,[0 wpass1/pi wstop1/pi 1],A_def,Wms);
  [hms2,err]= remez(hlng2-1,[0 wpass2/pi wstop2/pi 1],A_def,Wms);
  [hms3,err]= remez(hlng3-1,[0 wpass3/pi wstop3/pi 1],A_def,Wms);

% lowpass-to-bandpass transformation by modulation

  wbpc= 2*pi*f_chanc/fs0;

  hmsbpr= hmsbp.*cos(wbpc*[0:1:hlngbp-1]);  
  hmsbpi= hmsbp.*sin(wbpc*[0:1:hlngbp-1]);  

  hmsbpc= hmsbpr + ci*hmsbpi;

end

Cmul= (2*hlngbp*fsbp + 3*4*fsbp + 3*2*(hlng1*fsm1 + hlng2*fsm2 + hlng3*fsm3))/1e3;
Cadd= (2*(hlngbp-1)*fsbp + 3*2*fsbp + 3*2*((hlng1-1)*fsm1 + (hlng2-1)*fsm2 + (hlng3-1)*fsm3))/1e3;
Ctot= Cmul+Cadd;

Cmul0= (3*2*fs0 + 3*2*hlng*fs0/Mtot)/1e3;
Cadd0= (3*2*(hlng-1)*fs0/Mtot)/1e3;
Ctot0= Cmul0+Cadd0;

Nmul= ceil(2*hlngbp*fsbp/fmult) + ceil(3*4*fsbp/fmult) + ...
      ceil(3*2*hlng1*fsm1/fmult) + ceil(3*2*hlng2*fsm2/fmult) + ceil(3*2*hlng3*fsm3/fmult);

Nmul0= ceil(3*2*fs0/fmult) + ceil(3*2*hlng*fs0/Mtot/fmult);

%Nmul= Cmul*1e3/fmult;
%Nmul0= Cmul0*1e3/fmult;

%disp(' ');
%disp('Computational Throughput:');
%disp(['Single Stage: ' num2str(Ctot0) ' GOPS']);
%disp(['Multi-Stage: ' num2str(Ctot) ' GOPS']);

%disp('Number of Multipliers:');
%disp(['Single Stage: ' num2str(Nmul0)]);
%disp(['Multi-Stage: ' num2str(Nmul)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate Equivalent Multi Stage Composite Filter %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N0= floor(p0*T*W);
nfft0= 2^nextpow2(2*N0-1); 
nfftfr= nfft0;

hms1_up= upsmpl(hms1,M1);
hms2_up= upsmpl(hms2,M1*M2);
hms3_up= upsmpl(hms3,M1*M2*M3);

hms1_up= upsmpl(hms1,Mbp);
hms2_up= upsmpl(hms2,Mbp*M1);
hms3_up= upsmpl(hms3,Mbp*M1*M2);

j1= conv(hmsbp,hms1_up);
j2= conv(j1,hms2_up);
hmseq= conv(j2,hms3_up);

ph0= fft(h0,nfftfr);

phmsbpc= fft(hmsbpc,nfftfr);

phmsbp= fft(hmsbp,nfftfr);
phmsbpc= fft(hmsbpc,nfftfr);
phms1= fft(hms1,nfftfr);
phms2= fft(hms2,nfftfr);
phms3= fft(hms3,nfftfr);

phmseq= fft(hmseq,nfftfr);

junk= find(abs(phmsbp)==0);
if ~isempty(junk) 
  phmsbp(junk)= phmsbp(min(junk)-1)*ones(1,length(junk));
end

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

