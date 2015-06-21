% figure(5), clf;

gaxes= [1 infft1 -70 10];
%xtick= [1 infft1/8 2*infft1/8 3*infft1/8 4*infft1/8+1 5*infft1/8 6*infft1/8 7*infft1/8 infft1];
xtick= [1 2*infft1/8 4*infft1/8+1 6*infft1/8 infft1];

% subplot(321),plot(20*log10(zr)), axis(gaxes), ylabel('Reference'), title('Pulse Compression - Full Scale'), set(gca,'xtick',xtick), grid on;
subplot(5,3,12),plot(20*log10(z1)), axis(gaxes), ylabel('Channel 1'), set(gca,'xtick',xtick), grid on;
drawnow;

subplot(5,3,15),plot(20*log10(z2)), axis(gaxes), xlabel('range bins'), ylabel('Channel 2'), set(gca,'xtick',xtick), grid on;
drawnow;

gaxes= [3*infft1/8 5*infft1/8 -50 10];
xtick= [3*infft1/8 4*infft1/8+1 5*infft1/8];


% subplot(322),plot(20*log10(zr)), axis(gaxes), ylabel('Reference'), title('Pulse Compression - Main Lobes'), set(gca,'xtick',xtick), grid on;

Npeakshft1= (Nrngshft/M)*(infft1/nfftd);

if Nrngshft < 3000
  Npeakshft2= Npeakshft1;
else
  Npeakshft2= (7743-4044)+Npeakshft1;
end

xpeak1= 4044-Npeakshft1;
gaxes= [xpeak1-infft1/8 xpeak1+infft1/8 -50 10];
xtick= [xpeak1];

% subplot(5,3,11),plot(20*log10(z1)), axis(gaxes), set(gca,'xtick',xtick), grid on, title('Tgt 1');
% drawnow;

xpeak2= 7743-Npeakshft2;
gaxes= [xpeak2-infft1/8 xpeak2+infft1/8 -50 10];
xtick= [xpeak2];

% subplot(5,3,12),plot(20*log10(abs(z1))), axis(gaxes), set(gca,'xtick',xtick), grid on, title('Tgt 2');
% drawnow; 

xpeak1= 4044-Npeakshft1;
gaxes= [xpeak1-infft1/8 xpeak1+infft1/8 -65 -15];
xtick= [xpeak1];

% subplot(5,3,14),plot(20*log10(abs(z2))), axis(gaxes), set(gca,'xtick',xtick), grid on, title('Tgt 1');
% drawnow;

xpeak2= 7743-Npeakshft2;
gaxes= [xpeak2-infft1/8 xpeak2+infft1/8 -65 -15];
xtick= [xpeak2];

% subplot(5,3,15),plot(20*log10(abs(z2))), axis(gaxes), set(gca,'xtick',xtick), grid on, title('Tgt 2');
% drawnow;
