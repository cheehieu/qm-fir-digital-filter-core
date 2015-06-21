
% First, channel bandpass decimation filter 
% note that output is complex

   disp('start to write wdata')
% xov = load('xov.txt');
%hmsbpr = load('hmsr0.txt');
%hmsbpi = load('hmsi0.txt');
%Mbp = 4;
fid = fopen('xov.txt','wt');             
fprintf(fid,'[');           
fprintf(fid,'0,');           
fprintf(fid,'0,');       
fprintf(fid,'0,');
fprintf(fid,'%15.8e,',xov);   
fprintf(fid,'0');
fprintf(fid,']');
fclose(fid);
fid = fopen('xov2.txt','wt');
fprintf(fid,'%15.8e\n',[0,0,0,xov,0]);
fclose(fid);
de2bi_decimal('xov2.txt','xov_bi.txt',8,-6);

% xbpr= myfirdecim(xov,hmsbpr,Mbp);
% xbpi= myfirdecim(xov,hmsbpi,Mbp);
xbpr = KaylaFirdecim([zeros(1,3) xov zeros(1,3000)], Mbp, hmsbpr);   % zeros to account for weird zeros additions
xbpi = KaylaFirdecim([zeros(1,3) xov zeros(1,3000)], Mbp, hmsbpi);
Nbp= length(xbpr);

% Now loop 3 times thru the same multi-stage lowpass decimation filter 

for ichan= 1:MI-1

  if ichan == 1 		% chirp 1
    wshift= wbpc1;
  elseif ichan == 2		% chirp 2
    wshift= wbpc2;
  else
    wshift= wbpc3;		% noise
  end


%%% Complex-baseband subband signals 

  xbsr= xbpr.*cos(wshift*(0:Nbp-1)) + xbpi.*sin(wshift*(0:Nbp-1));
  xbsi= -(xbpr.*sin(wshift*(0:Nbp-1)) - xbpi.*cos(wshift*(0:Nbp-1)));
  
%%% Kayla FIRDECIM

  xbsr_pp1= KaylaFirdecim1(xbsr,M1,hms1);        % 1st stage
  xbsi_pp1= KaylaFirdecim1(xbsi,M1,hms1);    % Designed differently than laster stages..
  xbsr_pp2= KaylaFirdecim(xbsr_pp1,M2,hms2);     % 2nd stage
  xbsi_pp2= KaylaFirdecim(xbsi_pp1,M2,hms2);
  xbsr_pp3= KaylaFirdecim(xbsr_pp2,M3,hms3);     % 3rd stage
  xbsi_pp3= KaylaFirdecim(xbsi_pp2,M3,hms3);
   if ichan == 1 
       fid = fopen('xbsr3_c1_expected.txt','wt');             
       fprintf(fid,'[');
       fprintf(fid,'%15.8e,',xbsr_pp3(1:82));
       fprintf(fid,']');
       fclose(fid);
       fid = fopen('xbsi3_c1_expected.txt','wt');             
       fprintf(fid,'[');
       fprintf(fid,'%15.8e,',xbsi_pp3(1:82));
       fprintf(fid,']');
       fclose(fid);
   elseif ichan == 2 
       fid = fopen('xbsr3_c3_expected.txt','wt');             
       fprintf(fid,'[');
       fprintf(fid,'%15.8e,',xbsr_pp3(1:82));
       fprintf(fid,']');
       fclose(fid);
       fid = fopen('xbsi3_c3_expected.txt','wt');             
       fprintf(fid,'[');
       fprintf(fid,'%15.8e,',xbsi_pp3(1:82));
       fprintf(fid,']');
       fclose(fid);
   elseif ichan == 3 
       fid = fopen('xbsr3_c2_expected.txt','wt');             
       fprintf(fid,'[');
       fprintf(fid,'%15.8e,',xbsr_pp3(1:82));
       fprintf(fid,']');
       fclose(fid)
       fid = fopen('xbsi3_c2_expected.txt','wt');             
       fprintf(fid,'[');
       fprintf(fid,'%15.8e,',xbsi_pp3(1:82));
       fprintf(fid,']');
       fclose(fid);
   end
  
xiq= sqrt(2)*(xbsr_pp3' + ci*xbsi_pp3');
  if ichan == 1
    xiqm1= xiq;
  elseif ichan == 2
    xiqm2= xiq;
  else
    xiqm3= xiq;
  end

  xiq= sqrt(2)*(xbsr_pp3 + ci*xbsi_pp3);

end	% ichan= 1:MI-1

Nrd= length(xiqm1);
nfftd= 2^nextpow2(2*Nrd-1);

pxiqm1= fft(xiqm1,nfftd);
pxiqm2= fft(xiqm2,nfftd);
pxiqm3= fft(xiqm3,nfftd);

