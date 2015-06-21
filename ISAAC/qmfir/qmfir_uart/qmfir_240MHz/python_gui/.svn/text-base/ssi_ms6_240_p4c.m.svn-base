figure(4), clf;

xlim= [1 N0];
xtick= [1 fix(N0/2) N0];
ylim= [-1 1];

subplot(621), plot(real(xov)), ylabel('xov'), title('Waveforms'), ...
  set(gca,'xlim',xlim), set(gca,'xtick',xtick), set(gca,'ylim',ylim), grid on;

xlim= [1 length(xbpr)];
xtick= [1 fix(length(xbpr)/2) length(xbpr)];
ylim= [-0.2 0.2];

subplot(623), plot(real(xbpr)), ylabel('x0'), ...
  set(gca,'xlim',xlim), set(gca,'xtick',xtick), set(gca,'ylim',ylim), grid on;

xlim= [1 length(xbsr)];
xtick= [1 fix(length(xbsr)/2) length(xbsr)]

subplot(625), plot(xbsr), ylabel('xqm'), ...
  set(gca,'xlim',xlim), set(gca,'xtick',xtick), set(gca,'ylim',ylim), grid on;

xlim= [1 length(xbsr_pp1)];
xtick= [1 fix(length(xbsr_pp1)/2) length(xbsr_pp1)];

subplot(627), plot(xbsr_pp1), ylabel('x1'), ...
  set(gca,'xlim',xlim), set(gca,'xtick',xtick), set(gca,'ylim',ylim), grid on;

xlim= [1 length(xbsr_pp2)];
xtick= [1 fix(length(xbsr_pp2)/2) length(xbsr_pp2)];

if ichan == 2
  ylim= [-0.01 0.01];		% for x-pol
elseif ichan == 3
  ylim= [-0.001 0.001];		% for noise
end

subplot(629), plot(xbsr_pp2), ylabel('x2'), ...
  set(gca,'xlim',xlim), set(gca,'xtick',xtick), set(gca,'ylim',ylim), grid on;

xlim= [1 length(xbsr_pp3)];
xtick= [1 fix(length(xbsr_pp3)/2) length(xbsr_pp3)];

subplot(6,2,11), plot(xbsr_pp3), xlabel('time sample'), ylabel('x3'), ...
  set(gca,'xlim',xlim), set(gca,'xtick',xtick), set(gca,'ylim',ylim), grid on;

pxbp= fft(xbpr+ci*xbpi,nfft0);
pxbs= fft(xbsr+ci*xbsi,nfft0);
pxbs1= fft(xbsr_pp1+ci*xbsi_pp1,nfft0);
pxbs2= fft(xbsr_pp2+ci*xbsi_pp2,nfft0);
pxbs3= fft(xbsr_pp3+ci*xbsi_pp3,nfft0);

xlim= [-fs0/2 fs0/2];
ylim= [-100 0];

xtick= [-fs0/2 -fs0/4 0 fs0/4 fs0/2];
ytick= [-80 -40 0];

maxs= max(20*log10(abs(pxov)/length(xov)))+5;
maxs= 0;

subplot(622), plot(freq0,fftshift(20*log10(abs(pxov)/length(xov))),'b', ...
                   freq0,fftshift(20*log10(abs(phmsbpc)/max(abs(phmsbpc)))+maxs),'m--'), ...
  title('Spectra'), ylabel('H0'), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

pxbp= fft(xbpr+ci*xbpi,nfft0);

xtick= [-fsbp/2 -fsbp/4 0 fsbp/4 fsbp/2];
xlim= [-fsbp/2 fsbp/2];

subplot(624), plot(freqbp,fftshift(20*log10(abs(pxbp)/length(xbpr)))), ylabel('QM'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [-fsbp/2 -fsbp/4 0 fsbp/4 fsbp/2];
xlim= [-fsbp/2 fsbp/2];

maxs= max(20*log10(abs(pxbs)/length(xbsr)))+5;
maxs= 0;

subplot(626), plot(freqbp,fftshift(20*log10(abs(pxbs)/length(xbsr))),'b', ...
                   freqbp,fftshift(20*log10(abs(phms1)/max(abs(phms1)))+maxs),'m--'), ...
    ylabel('H1'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [-fsm1/2 -fsm1/4 0 fsm1/4 fsm1/2];
xlim= [-fsm1/2 fsm1/2];

maxs= max(20*log10(abs(pxbs1)/length(xbsr_pp1)))+5;
maxs= 0;

subplot(628), plot(freq1,fftshift(20*log10(abs(pxbs1)/length(xbsr_pp1))),'b', ...
                   freq1,fftshift(20*log10(abs(phms2)/max(abs(phms2)))+maxs),'m--'), ...
    ylabel('H2'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [-fsm2/2 -fsm2/4 0 fsm2/4 fsm2/2];
xlim= [-fsm2/2 fsm2/2];

maxs= max(20*log10(abs(pxbs2)/length(xbsr_pp2)))+5;
maxs= 0;

subplot(6,2,10), plot(freq2,fftshift(20*log10(abs(pxbs2)/length(xbsr_pp2))),'b', ...
                      freq2,fftshift(20*log10(abs(phms3)/max(abs(phms3)))+maxs),'m--'), ...
    ylabel('H3'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xtick= [-fsm3/2 -0.5 0 0.5 fsm3/2];
xlim= [-fsm3/2 fsm3/2];

subplot(6,2,12), plot(freq2,fftshift(20*log10(abs(pxbs2)/length(xbsr_pp2)))), xlabel('analog frequency (MHz)'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

