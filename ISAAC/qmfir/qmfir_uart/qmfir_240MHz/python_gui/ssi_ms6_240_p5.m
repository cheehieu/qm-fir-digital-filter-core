figure(6), clf;

gaxes= [0 infft1 -70 10];
%xtick= [1 infft1/8 2*infft1/8 3*infft1/8 4*infft1/8+1 5*infft1/8 6*infft1/8 7*infft1/8 infft1];
xtick= [1 2*infft1/8 4*infft1/8 6*infft1/8 infft1];

subplot(321),plot(20*log10(abs(zr))), axis(gaxes), ylabel('Reference'), title('Pulse Compression - Full Scale'), set(gca,'xtick',xtick), grid on;

xtick= [1 2*infft1/8 4*infft1/8-4 6*infft1/8 infft1];

subplot(323),plot(20*log10(abs(z1))), axis(gaxes), ylabel('Co-pol'), set(gca,'xtick',xtick), grid on;
subplot(325),plot(20*log10(abs(z2))), axis(gaxes), xlabel('range bin'), ylabel('X-pol'), set(gca,'xtick',xtick), grid on;

gaxes= [3*infft1/8 5*infft1/8 -70 10];
%xtick= [3*infft1/8 ipeak-inul 4*infft1/8+1 ipeak+inul 5*infft1/8];
xtick= [3*infft1/8 4*infft1/8 5*infft1/8];

subplot(322),plot(20*log10(abs(zr))), axis(gaxes), ylabel('Reference'), title('Pulse Compression - Main Lobe'), set(gca,'xtick',xtick), grid on;
subplot(324),plot(20*log10(abs(z1))), axis(gaxes), ylabel('Chirp 1'), set(gca,'xtick',xtick), grid on;
subplot(326),plot(20*log10(abs(z2))), axis(gaxes), xlabel('range bin'), ylabel('Chirp 2'), set(gca,'xtick',xtick), grid on;
