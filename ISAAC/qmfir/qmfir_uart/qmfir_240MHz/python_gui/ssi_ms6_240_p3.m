figure(4), clf;

gaxes1= [1 N1 -1.2 1.2];
gaxes2= [-fs1/2 fs1/2 -20 40];

xlim= [1 N0];
ylim= [-1.2 1.2];

subplot(521), plot(real(x0)), ylabel('Oversampled'), title('Waveforms'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N1];
ylim= [-1.2 1.2];

subplot(523), plot(real(x1r)), ylabel('Nyq. Sampled'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N0];
ylim= [-1 1];

subplot(525), plot(real(xov)), ylabel('Input'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N1];
ylim= [-1.1*max(real(xov)) 1.1*max(real(xov))];

subplot(527), plot(real(xiqm1)), ylabel('Out 1'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

ylim= (10^(A2/20))*ylim;

subplot(529), plot(real(xiqm2)), xlabel('time samples'), ylabel('Out 2'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on; 

xlim= [-fs0/2 fs0/2];
ylim= [0 70];
xtick= [-120 -60 0 60 120];
    
subplot(522), plot(freq0,fftshift(20*log10(abs(px0)))), title('Spectra'),  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs1/2 fs1/2];
ylim= [0 30];
xtick= [-0.6 -0.5 0 0.5 0.6];

subplot(524), plot(freq1,fftshift(20*log10(abs(px1r)))), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs0/2 fs0/2];
ylim= [0 70];
xtick= [-120 -60 0 60 120];

subplot(526), plot(freq0,fftshift(20*log10(abs(pxov)))), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs1/2 fs1/2];
ylim= [-20 10];
xtick= [-0.6 -0.5 0 0.5 0.6];

subplot(528), plot(freq1,fftshift(20*log10(abs(pxiqm1)))), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs1/2 fs1/2];
ylim= [-40 -10];
xtick= [-0.6 -0.5 0 0.5 0.6];

subplot(5,2,10), plot(freq1,fftshift(20*log10(abs(pxiqm2)))), xlabel('analog frequency'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;




figure(5), clf;

gaxes1= [1 N1 -1.2 1.2];
gaxes2= [-fs1/2 fs1/2 -20 40];

xlim= [1 N0];
ylim= [-1.2 1.2];

subplot(521), plot(real(x0)), ylabel('Oversampled'), title('Waveforms'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N1];
ylim= [-1.2 1.2];

subplot(523), plot(real(x1r)), ylabel('Nyq. Sampled'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N0];
ylim= [-1 1];

subplot(525), plot(real(xov)), ylabel('Input'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

xlim= [1 N1];
ylim= [-1.1*max(real(xov)) 1.1*max(real(xov))];

subplot(527), plot(real(xiqm1)), ylabel('Out 1'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on;

ylim= (10^(A2/20))*ylim;

subplot(529), plot(real(xiqm2)), xlabel('time samples'), ylabel('Out 2'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), grid on; 

xlim= [-fs0/2 fs0/2];
ylim= [0 70];
xtick= [-120 -60 0 60 120];
    
subplot(522), plot(freq0,fftshift(20*log10(abs(px0)))), title('Spectra'),  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs1/2 fs1/2];
ylim= [0 30];
xtick= [-0.6 -0.5 0 0.5 0.6];

subplot(524), plot(freq1,fftshift(20*log10(abs(px1r)))), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs0/2 fs0/2];
ylim= [0 70];
xtick= [-120 -60 0 60 120];

subplot(526), plot(freq0,fftshift(20*log10(abs(pxov)))), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs1/2 fs1/2];
ylim= [-20 10];
xtick= [-0.6 -0.5 0 0.5 0.6];

subplot(528), plot(freq1,fftshift(20*log10(abs(pxiqm1)))), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

xlim= [-fs1/2 fs1/2];
ylim= [-40 -10];
xtick= [-0.6 -0.5 0 0.5 0.6];

subplot(5,2,10), plot(freq1,fftshift(20*log10(abs(pxiqm2)))), xlabel('analog frequency'), set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), grid on;

