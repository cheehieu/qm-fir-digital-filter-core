fs2= 2*fs1;

w0= (2*pi/nfft0)*[0:(nfft0-1)];
mid= ceil(nfft0/2)+1;
w0(mid:nfft0) = w0(mid:nfft0) - 2*pi;
w0= fftshift(w0);
freq0= w0/2/pi*fs0;

w1= (2*pi/nfft1)*[0:(nfft1-1)];
mid= ceil(nfft1/2)+1;
w1(mid:nfft1) = w1(mid:nfft1) - 2*pi;
w1= fftshift(w1);
freq1= w1/2/pi*fs1;

wr= (2*pi/nfftr)*[0:(nfftr-1)];
mid= ceil(nfftr/2)+1;
wr(mid:nfftr) = wr(mid:nfftr) - 2*pi;
wr= fftshift(wr);
freqr= wr/2/pi*fs0;

% figure(1), clf;

subplot(621), plot(real(x1r)), ylabel('Ref'), title('Signal Waveforms (Volts)'), set(gca,'ylim',[-1 1]);
subplot(623), plot(real(xpulse)), ylabel('Pls'), title('Waveforms'), set(gca,'ylim',[-1 1]);
subplot(625), plot(real(xpulse1)), ylabel('C1, 0dB'), set(gca,'ylim',[-2 2]);
subplot(627), plot(real(xpulse2)), ylabel(['C2, ' num2str(A2) 'dB']), set(gca,'ylim',[-2 2]);
subplot(629), plot(real(xn0)), ylabel(['N, -' num2str(SNR0) 'dB']), set(gca,'ylim',[-.2 .2]);
subplot(6,2,11), plot(real(xov)), ylabel('Tot'), xlabel('time samples'), set(gca,'ylim',[-1 1]);

gaxesf= [-fs0/2 fs0/2 -100 0];

subplot(622), plot(freq1,fftshift(10*log10((abs(px1r)/length(x1r)).^2))), grid on, axis([-fs1/2 fs1/2 -60 0]), title('Power Spectral Density (dB, 1 Ohm load)');
subplot(624), plot(freqr,fftshift(10*log10((abs(pxpulse)/length(xpulse)).^2))) , grid on, axis([-fs0/2 fs0/2 -60 0]);
subplot(626), plot(freqr,fftshift(10*log10((abs(pxpulse1)/length(xpulse1)).^2))) , grid on, axis(gaxesf);
subplot(628), plot(freqr,fftshift(10*log10((abs(pxpulse2)/length(xpulse2)).^2))), grid on, axis(gaxesf);
subplot(6,2,10), plot(freqr,fftshift(10*log10((abs(pxn0)/length(xn0)).^2))), grid on, axis(gaxesf);
subplot(6,2,12), plot(freqr,fftshift(10*log10((abs(pxov)/length(xov)).^2))), grid on, xlabel('analog frequency'), axis(gaxesf);