nfftdbg= nfft0;

xbp= xbpr + ci*xbpi;
pxbp= fft(xbp,nfftdbg);

xbs= xbsr + ci*xbsi;
pxbs= fft(xbs,nfftdbg);

xbs_pp1= xbsr_pp1 + ci*xbsi_pp1;
pxbs_pp1= fft(xbs_pp1,nfftdbg);

xbs_pp2= xbsr_pp2 + ci*xbsi_pp2;
pxbs_pp2= fft(xbs_pp2,nfftdbg);

xbs_pp3= xbsr_pp3 + ci*xbsi_pp3;
pxbs_pp3= fft(xbs_pp3,nfftdbg);


figure(3), clf;


subplot(6,2,1), plot(real(xov)), ylabel('Inp'), title('Waveforms'), ...
  set(gca,'xlim',[0 length(xov)]), set(gca,'xtick',[0 length(xov)]);
subplot(6,2,3), plot(real(xbp)), ylabel('Obp'), ...
  set(gca,'xlim',[0 length(xbp)]), set(gca,'xtick',[0 length(xbp)]);
subplot(6,2,5), plot(real(xbs)), ylabel('Oqm'), ...
  set(gca,'xlim',[0 length(xbs)]), set(gca,'xtick',[0 length(xbs)]);
subplot(6,2,7), plot(real(xbs_pp1)), ylabel('O1'), ...
  set(gca,'xlim',[0 length(xbs_pp1)]), set(gca,'xtick',[0 length(xbs_pp1)]);
subplot(6,2,9), plot(real(xbs_pp2)), ylabel('O2'), ...
  set(gca,'xlim',[0 length(xbs_pp2)]), set(gca,'xtick',[0 length(xbs_pp2)]);
subplot(6,2,11), plot(real(xbs_pp3)), xlabel('time sample'), ylabel('O3'), ...
  set(gca,'xlim',[0 length(xbs_pp3)]), set(gca,'xtick',[0 length(xbs_pp3)]);

xlim= [-fs0/2 fs0/2];
xtick= [-fs0/2 -fs0/4 0 fs0/4 fs0/2];

ylim= [-60 10];
ytick= [-40 0];


subplot(6,2,2), plot(freq0,fftshift(20*log10(abs(pxov)/max(abs(pxov)))),'b',...
                     freq0,fftshift(20*log10(abs(phmsbpc)/max(abs(phmsbpc)))),'r--'), ...
  title('Spectra'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fsbp/2 fsbp/2];
xtick= [-fsbp/2 -fsbp/4 0 fsbp/4 fsbp/2];

subplot(6,2,4), plot(freqbp,fftshift(20*log10(abs(pxbp)/max(abs(pxbp))))), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

subplot(6,2,6), plot(freqbp,fftshift(20*log10(abs(pxbs)/max(abs(pxbs)))),'b',...
                     freqbp,fftshift(20*log10(abs(phms1)/max(abs(phms1)))),'r--'), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fsm1/2 fsm1/2];
xtick= [-fsm1/2 -fsm1/4 0 fsm1/4 fsm1/2];

subplot(6,2,8), plot(freq1,fftshift(20*log10(abs(pxbs_pp1)/max(abs(pxbs_pp1)))),'b',...
                     freq1,fftshift(20*log10(abs(phms2)/max(abs(phms2)))),'r--'), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fsm2/2 fsm2/2];
xtick= [-fsm2/2 -fsm2/4 0 fsm2/4 fsm2/2];

subplot(6,2,10), plot(freq2,fftshift(20*log10(abs(pxbs_pp2)/max(abs(pxbs_pp2)))),'b',...
                      freq2,fftshift(20*log10(abs(phms3)/max(abs(phms3)))),'r--'), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fsm3/2 fsm3/2];
xtick= [-fsm3/2 -fsm3/4 0 fsm3/4 fsm3/2];

subplot(6,2,12), plot(freq3,fftshift(20*log10(abs(pxbs_pp3)/max(abs(pxbs_pp3))))), ...
  xlabel('analog frequency'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;
