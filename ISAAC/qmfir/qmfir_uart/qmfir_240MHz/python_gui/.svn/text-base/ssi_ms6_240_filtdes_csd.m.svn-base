c_i= sqrt(-1);

i_coef_nbit= 16;
xmin= 2^(-16);

hmsbpr_csd= zeros(size(hmsbpr));
hmsbpi_csd= zeros(size(hmsbpi));

for i= 1:hlngbp
    num= hmsbpr(i)
    if abs(num) < xmin
        tmp= '.';
        for j= 1:i_coef_nbit
           tmp= [tmp num2str(0)];
        end
    else
        tmp= csdigit(num,0,i_coef_nbit);
    end
    for j= 2:i_coef_nbit+1
        sd= tmp(j);
        if sd == '+'
            sv= 2^(-(j-1));
        elseif sd == '-'
            sv= - 2^(-(j-1));
        else
            sv= 0.0;
        end
        hmsbpr_csd(i)= hmsbpr_csd(i)+sv;
    end
end

for i= 1:hlngbp
    num= hmsbpi(i);
    if abs(num) < xmin
        tmp= '.';
        for j= 1:i_coef_nbit
           tmp= [tmp num2str(0)];
        end
    else
        tmp= csdigit(num,0,i_coef_nbit);
    end
    for j= 2:i_coef_nbit+1
        sd= tmp(j);
        if sd == '+'
            sv= 2^(-(j-1));
        elseif sd == '-'
            sv= - 2^(-(j-1));
        else
            sv= 0.0;
        end
        hmsbpi_csd(i)= hmsbpi_csd(i)+sv;
    end
end

hmsbp_csd= hmsbpr_csd+c_i*hmsbpi_csd;
phmsbp_csd= fft(hmsbp_csd,nfftfr);

figure(1), clf;

subplot(421), stem(hmsbp), ylabel('LP Prototype'), title('Impulse Response');
subplot(423), stem(hmsbpr), ylabel('BP FM');
subplot(425), stem(hmsbpr_csd), ylabel('BP CSD');
subplot(427), stem(hmsbpr-hmsbpr_csd), ylabel('Diff')

xtick= [-fs0/2 -fs0/2/Mbp 0 fs0/2/Mbp fs0/2];

subplot(422), plot(freq0,fftshift(20*log10(abs(phmsbp)/max(abs(phmsbp))))), ... 
  title('Frequency Response (dB)'), axis([-fs0/2 fs0/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

subplot(424), plot(freq0,fftshift(20*log10(abs(phmsbpc)/max(abs(phmsbpc))))), ... 
  axis([-fs0/2 fs0/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;

subplot(426), plot(freq0,fftshift(20*log10(abs(phmsbp_csd)/max(abs(phmsbp_csd))))), ... 
  axis([-fs0/2 fs0/2 -80 20]), ...
  set(gca,'xtick',xtick), set(gca,'ytick',ytick), grid on;
