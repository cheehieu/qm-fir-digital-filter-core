% figure(4), clf;

%subplot(241), plot(real(x1r)),  title('Reference'), ylabel('I');
subplot(241), plot(real(xpulse)),  title('Simulated'), ylabel('I');

subplot(242), plot(real(xiqm1)), title('Co-pol');
subplot(243), plot(real(xiqm2)), title('X-pol');
subplot(244), plot(real(xiqm3)), title('Noise');

%subplot(245), plot(imag(x1r)), ylabel('Q');

subplot(245), plot(imag(xpulse)), ylabel('Q');

subplot(246), plot(imag(xiqm1));
subplot(247), plot(imag(xiqm2));
subplot(248), plot(imag(xiqm3));


