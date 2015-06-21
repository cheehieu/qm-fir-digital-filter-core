figure(1), clf;

xlim= [1 Nr];
ylim= [-1 1];
xtick= [1 floor(Nr/2) Nr];
ytick= [-1 0 1];

subplot(521), plot(real(x1r)), grid on, ylabel('Ref'), title('Waveforms'), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick);

xlim= [1 N0];
ylim= [-2 2];
xtick= [1 floor(N0/2) N0];
ytick=[ -2 -1 0 1 2];

subplot(523), plot(real(xc1)), grid on, ylabel('Co-pol'), ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick);

ylim= [-0.1 0.1];
ytick= [-0.1 -0.05 0 0.05 0.1];

subplot(525), plot(real(xc2)), grid on, ylabel('X-pol'),  ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick);

ylim= [-0.1 0.1];
ytick= [-0.1 -0.03 0 0.03 0.1];

subplot(527), plot(xn0r), grid on, ylabel('Noi'),  ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick);

ylim= [-1 1];
ytick= [-1 0 1];

subplot(529), plot(real(xov)), grid on, xlabel('time sample'), ylabel('Sca Tot'),  ...
  set(gca,'xlim',xlim), set(gca,'ylim',ylim), set(gca,'xtick',xtick), set(gca,'ytick',ytick), set(gca,'ytick',ytick);

gaxesf= [-fs1/2 fs1/2 -100 0];
xtick= [-fpass 0 fpass];
ytick= [-80 -40 0];

subplot(522), plot(freqr,fftshift(20*log10(abs(px1r)/length(x1r)))), ...
  grid on, axis(gaxesf), set(gca,'xtick',xtick), set(gca,'ytick',ytick), title('PSD');

gaxesf= [-fs0/2 fs0/2 -100 0];
xtick= [-120 -60 0 60 120];

subplot(524), plot(freq0,fftshift(20*log10(abs(pxc1)/length(xc1)))), grid on, ...
  axis(gaxesf), set(gca,'xtick',xtick), set(gca,'ytick',ytick);
subplot(526), plot(freq0,fftshift(20*log10(abs(pxc2)/length(xc2)))), grid on, ...
  axis(gaxesf), set(gca,'xtick',xtick), set(gca,'ytick',ytick);
subplot(528), plot(freq0,fftshift(20*log10(abs(pxn0)/length(xn0)))), grid on, ...
  axis(gaxesf), set(gca,'xtick',xtick), set(gca,'ytick',ytick);
subplot(5,2,10), plot(freq0,fftshift(20*log10(abs(pxov)/length(xov)))), xlabel('analog frequency (MHz)'), grid on, ...
  axis(gaxesf), set(gca,'xtick',xtick), set(gca,'ytick',ytick);