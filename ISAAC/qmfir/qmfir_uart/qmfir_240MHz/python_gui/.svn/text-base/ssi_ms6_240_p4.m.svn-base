figure(5), clf;

gaxes1= [1 Nr -1.2 1.2];
gaxes2= [-fs1/2 fs1/2 -20 40];

xlim= [1 Nr];
ylim= [-1.2 1.2];

subplot(621), plot(real(x1r)), ylabel('Ref'), title('Waveforms'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N0];
ylim= [-1.2 1.2];

subplot(623), plot(real(x0)), ylabel('Overs'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;


xlim= [1 N0];
ylim= [-1 1];

subplot(625), plot(real(xov)), ylabel('Input'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 Nr];
ylim= [-1.1*max(real(xov)) 1.1*max(real(xov))];

subplot(627), plot(real(xiqm1)), ylabel('C-pol'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

ylim= (10^(A2/20))*ylim;

subplot(629), plot(real(xiqm2)), ylabel('X-pol'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on; 

ylim= 2*An*ylim;

subplot(6,2,11), plot(real(xiqm3)), xlabel('time sample'), ylabel('Noi'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on; 


xlim= [-fs0/2 fs0/2];
ylim= [-100 0];
xtick= [-120 -60 0 60 120];
ytick= [-80 -40 0];

subplot(624), plot(freq0,fftshift(20*log10(abs(px0)/length(x0)))),  ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fs1/2 fs1/2];
xtick= [-0.5 0 0.5];

subplot(622), plot(freqr,fftshift(20*log10(abs(px1r)/length(x1r)))), title('Spectra'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fs0/2 fs0/2];
xtick= [-120 -60 0 60 120];

subplot(626), plot(freq0,fftshift(20*log10(abs(pxov)/length(xov)))), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

xlim= [-fs1/2 fs1/2];
xtick= [-0.5 0 0.5];

subplot(628), plot(freqd,fftshift(20*log10(abs(pxiqm1)/length(xiqm1)))), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

subplot(6,2,10), plot(freqd,fftshift(20*log10(abs(pxiqm2)/length(xiqm2)))), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

subplot(6,2,12), plot(freqd,fftshift(20*log10(abs(pxiqm3)/length(xiqm3)))), xlabel('analog frequency (MHz)'), ...
    set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

