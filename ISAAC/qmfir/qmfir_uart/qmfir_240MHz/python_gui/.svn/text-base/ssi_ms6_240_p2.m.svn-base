figure(2), clf;

subplot(529), plot(hmseq), xlabel('filter tap'), ylabel('Heq'), ...
  set(gca,'xlim',[0 length(hmseq)+1]), set(gca,'xtick',[0 ceil(length(hmseq)/2) length(hmseq)]);
subplot(521), stem(hmsbp), ylabel('H0'), title('Impulse Response'), set(gca,'xlim',[0 hlngbp+1]), set(gca,'xtick',[0 ceil(hlngbp/2) hlngbp]);

subplot(523), stem(hms1), ylabel('H1'), set(gca,'xlim',[0 hlng1+1]), set(gca,'xtick',[0 ceil(hlng1/2) hlng1]);
subplot(525), stem(hms2), ylabel('H2'), set(gca,'xlim',[0 hlng2+1]), set(gca,'xtick',[0 ceil(hlng2/2) hlng2]);
subplot(527), stem(hms3), ylabel('H3'), set(gca,'xlim',[0 hlng3+1]), set(gca,'xtick',[0 ceil(hlng3/2) hlng3]);

xtick= [];
for jj= Mbp:-1:0
  xtick= [xtick -jj*fs0/2/Mbp];
end
for jj= 1:Mbp
  xtick= [xtick jj*fs0/2/Mbp];
end
ytick= [-40 0];

gaxes= [-fs0/2 fs0/2 -80 20];

xtick= [-120 -90 -60 -30 0 30 60 90 120];

subplot(5,2,10), plot(freq0,fftshift(20*log10(abs(phmseq)/max(abs(phmseq))))), ...
  xlabel('analog frequency (MHz)'), axis(gaxes), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [-fs0/2 -fs0/2/Mbp 0 fs0/2/Mbp fs0/2];

subplot(522), plot(freq0,fftshift(20*log10(abs(phmsbp)/max(abs(phmsbp))))), ... 
  title('Frequency Response (dB)'), ylabel(['M = ' num2str(Mbp)]), axis([-fs0/2 fs0/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [];
for jj= M1:-1:0
  xtick= [xtick -jj*fsbp/2/M1];
end
for jj= 1:M1
  xtick= [xtick jj*fsbp/2/M1];
end

xtick= [-fs0/2/Mbp -fs0/2/Mbp/M1 0 fs0/2/Mbp/M1 fs0/2/Mbp];

subplot(524), plot(freqbp,fftshift(20*log10(abs(phms1)/max(abs(phms1))))), ...
  ylabel(['M = ' num2str(M1)]), axis([-fsbp/2 fsbp/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [];
for jj= M2:-1:0
  xtick= [xtick -jj*fsm1/2/M2];
end
for jj= 1:M2
  xtick= [xtick jj*fsm1/2/M2];
end

xtick= [-fs0/2/Mbp/M1 -fs0/2/Mbp/M1/M2 0 fs0/2/Mbp/M1/M2 fs0/2/Mbp/M1];

subplot(526), plot(freq1,fftshift(20*log10(abs(phms2)/max(abs(phms2))))), ...
  ylabel(['M = ' num2str(M2)]), axis([-fsm1/2 fsm1/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [-fs0/2/Mbp/M1/M2 -fs0/2/Mbp/M1/M2/M3 0 fs0/2/Mbp/M1/M2/M3 fs0/2/Mbp/M1/M2];

subplot(528), plot(freq2,fftshift(20*log10(abs(phms3)/max(abs(phms3))))), ...
  ylabel(['M = ' num2str(M3)]), axis([-fsm2/2 fsm2/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;


figure(3), clf;

xmax= max([length(hmseq) length(h0)]);
xlim= [0 xmax];

xtick= [0 fix(hlng/2) hlng];

subplot(241), plot(h0), ylabel('Single Stage'), title('Imp. Rsp.'), set(gca,'xlim',xlim), set(gca,'xtick',xtick);

xtick= [0 fix(length(hmseq)/2) length(hmseq)];

subplot(245), plot(hmseq), ylabel('Multi Stage'), xlabel('filter tap'), set(gca,'xlim',xlim), set(gca,'xtick',xtick);

gaxes= [-fs0/2 fs0/2 -80 20];
xtick= [-120 -60 0 60 120];

subplot(242), plot(freq0,fftshift(20*log10(abs(ph0)/max(abs(ph0))))), ...
  axis(gaxes), title('Freq. Rsp. (dB)'), set(gca,'xtick',xtick), grid on;
subplot(246), plot(freq0,fftshift(20*log10(abs(phmseq)/max(abs(phmseq))))), ...
  axis(gaxes), xlabel('analog freq (MHz)'), set(gca,'xtick',xtick), grid on;

gaxes= [-fs1 fs1 -80 20];
xtick= [-1.2 -0.5 0 0.5 1.2];

subplot(243), plot(freq0,fftshift(20*log10(abs(ph0)/max(abs(ph0))))), ...
  axis(gaxes), title('Stopband (dB)'), set(gca,'xtick',xtick), grid on;

subplot(247), plot(freq0,fftshift(20*log10(abs(phmseq)/max(abs(phmseq))))), ...
  axis(gaxes), xlabel('analog freq (MHz)'), set(gca,'xtick',xtick), grid on;

gaxes= [-fs1 fs1 -0.4 0];

subplot(244), plot(freq0,fftshift(20*log10(abs(ph0)/max(abs(ph0))))), ...
  axis(gaxes), title('Passband (dB)'), set(gca,'xtick',xtick), grid on;

subplot(248), plot(freq0,fftshift(20*log10(abs(phmseq)/max(abs(phmseq))))), ...
  axis(gaxes), xlabel('analog freq (MHz)'), set(gca,'xtick',xtick), grid on;
