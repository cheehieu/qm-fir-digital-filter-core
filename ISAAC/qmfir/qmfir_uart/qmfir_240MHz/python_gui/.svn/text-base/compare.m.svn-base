FIR0=0;
QM=0;
FIR1FIR2FIR3_C1=0;
FIR1FIR2FIR3_N=0;
FIR1FIR2FIR3_C2=0;
ALL=1;

if FIR0==1
% Compare FIR0
Verilog_file1 = 'xbpi_fromVerilog.txt';
Verilog_file2 = 'xbpr_fromVerilog.txt';
Matlab_file1 = 'xbpi.txt';
Matlab_file2 = 'xbpr.txt';

xbsi3_c1_V = load(Verilog_file1);
xbsr3_c1_V = load(Verilog_file2);
xbsi3_c1 = load(Matlab_file1);
xbsr3_c1 = load(Matlab_file2);

i1=1;
i2=1;
j1=2600;
j2=2600;

xbsi3_c1_D = xbsi3_c1_V(i1:j1,1) - xbsi3_c1(i2:j2,1);
xbsr3_c1_D = xbsr3_c1_V(i1:j1,1) - xbsr3_c1(i2:j2,1);

figure(1)
subplot(2,1,1), plot((xbsi3_c1_D)), title('FIR0 Error Imag Channel'), grid on;
subplot(2,1,2), plot((xbsr3_c1_D)), title('FIR0 Error Real Channel'), grid on;

i=0;
j=0;
figure(2)
 subplot(2,1,1), plot(xbsi3_c1(i2+i:j2-j));
 hold;
 subplot(2,1,1), plot((xbsi3_c1_V(i1+i:j1-j)),'r'), title('FIR0 Result Imag Channel'), grid on
 hold off;
 subplot(2,1,2), plot(xbsr3_c1(i2+i:j2-j));
 hold;
 subplot(2,1,2), plot((xbsr3_c1_V(i1+i:j1-j)),'r'), title('FIR0 Result Real Channel'), grid on
 hold off;
end

if QM==1
% Compare QM
Verilog_file1 = 'xbsi_c1_fromVerilog.txt';
Matlab_file1 = 'xbsi_c1.txt';
Verilog_file2 = 'xbsi_c2_fromVerilog.txt';
Matlab_file2 = 'xbsi_c2.txt';
Verilog_file3 = 'xbsi_c3_fromVerilog.txt';
Matlab_file3 = 'xbsi_c3.txt';
Verilog_file4 = 'xbsr_c1_fromVerilog.txt';
Matlab_file4 = 'xbsr_c1.txt';
Verilog_file5 = 'xbsr_c2_fromVerilog.txt';
Matlab_file5 = 'xbsr_c2.txt';
Verilog_file6 = 'xbsr_c3_fromVerilog.txt';
Matlab_file6 = 'xbsr_c3.txt';

xbsi3_c1_V = load(Verilog_file1);
xbsi3_c2_V = load(Verilog_file2);
xbsi3_c3_V = load(Verilog_file3);
xbsr3_c1_V = load(Verilog_file4);
xbsr3_c2_V = load(Verilog_file5);
xbsr3_c3_V = load(Verilog_file6);

xbsi3_c1 = load(Matlab_file1);
xbsi3_c2 = load(Matlab_file2);
xbsi3_c3 = load(Matlab_file3);
xbsr3_c1 = load(Matlab_file4);
xbsr3_c2 = load(Matlab_file5);
xbsr3_c3 = load(Matlab_file6);

i1=1;
i2=1;
j1=2700;
j2=2700;

xbsi3_c1_D = xbsi3_c1_V(i1:j1,1) - xbsi3_c1(i2:j2,1);
xbsi3_c2_D = xbsi3_c2_V(i1:j1,1) - xbsi3_c2(i2:j2,1);
xbsi3_c3_D = xbsi3_c3_V(i1:j1,1) - xbsi3_c3(i2:j2,1);
xbsr3_c1_D = xbsr3_c1_V(i1:j1,1) - xbsr3_c1(i2:j2,1);
xbsr3_c2_D = xbsr3_c2_V(i1:j1,1) - xbsr3_c2(i2:j2,1);
xbsr3_c3_D = xbsr3_c3_V(i1:j1,1) - xbsr3_c3(i2:j2,1);



figure(3)
subplot(2,3,1), plot((xbsi3_c1_D)), title('QM Error Imag C1'), grid on;
subplot(2,3,2), plot((xbsi3_c2_D)), title('QM Error Imag Noise '), grid on;
subplot(2,3,3), plot((xbsi3_c3_D)), title('QM Error Imag C2'), grid on;
subplot(2,3,4), plot((xbsr3_c1_D)), title('QM Error Real C1'), grid on;
subplot(2,3,5), plot((xbsr3_c2_D)), title('QM Error Real Noise '), grid on;
subplot(2,3,6), plot((xbsr3_c3_D)), title('QM Error Real C2'), grid on;

i=0;
j=0;
figure(4)
 subplot(2,3,1), plot(xbsi3_c1(i2+i:j2-j));
 hold;
 subplot(2,3,1),plot((xbsi3_c1_V(i1+i:j1-j)),'r'), title('QM Result Imag C1'), grid on
 hold off;
 subplot(2,3,2), plot(xbsi3_c2(i2+i:j2-j));
 hold;
 subplot(2,3,2), plot((xbsi3_c2_V(i1+i:j1-j)),'r'), title('QM Result Imag Noise'), grid on;
 hold off;
 subplot(2,3,3), plot(xbsi3_c3(i2+i:j2-j));
 hold
 subplot(2,3,3), plot((xbsi3_c3_V(i1+i:j1-j)),'r'), title('QM Result Imag C2'), grid on;
 hold off
 subplot(2,3,4), plot(xbsr3_c1(i2+i:j2-j));
 hold
 subplot(2,3,4), plot((xbsr3_c1_V(i1+i:j1-j)),'r'), title('QM Result Real C1'), grid on;
 hold off
 subplot(2,3,5), plot(xbsr3_c2(i2+i:j2-j));
 hold
 subplot(2,3,5), plot((xbsr3_c2_V(i1+i:j1-j)),'r'), title('QM Result Real Noise'), grid on;
 hold off
 subplot(2,3,6), plot(xbsr3_c3(i2+i:j2-j));
 hold
 subplot(2,3,6), plot((xbsr3_c3_V(i1+i:j1-j)),'r'), title('QM Result Real C2'), grid on;
 hold off
end

if FIR1FIR2FIR3_C1==1
 % Compare FIR1, FIR2, FIR3 
 Verilog_file1 = 'xbsr1_c1_fromVerilog.txt';
 Matlab_file1 = 'xbsr1_c1.txt';
 Verilog_file2 = 'xbsr2_c1_fromVerilog.txt';
 Matlab_file2 = 'xbsr2_c1.txt';
 Verilog_file3 = 'xbsr3_c1f_fromVerilog.txt';  %FULL Version
 Matlab_file3 = 'xbsr3_c1.txt';

 Verilog_file4 = 'xbsi1_c1_fromVerilog.txt';
 Matlab_file4 = 'xbsi1_c1.txt';
 Verilog_file5 = 'xbsi2_c1_fromVerilog.txt';
 Matlab_file5 = 'xbsi2_c1.txt';
 Verilog_file6 = 'xbsi3_c1f_fromVerilog.txt';
 Matlab_file6 = 'xbsi3_c1.txt';

 xbsr3_c1_V = load(Verilog_file1);
 xbsr3_c1 = load(Matlab_file1);
 xbsr3_c2_V = load(Verilog_file2);
 xbsr3_c2 = load(Matlab_file2);
 xbsr3_c3_V = load(Verilog_file3);
 xbsr3_c3 = load(Matlab_file3);

 xbsi3_c1_V = load(Verilog_file4);
 xbsi3_c1 = load(Matlab_file4);
 xbsi3_c2_V = load(Verilog_file5);
 xbsi3_c2 = load(Matlab_file5);
 xbsi3_c3_V = load(Verilog_file6);
 xbsi3_c3 = load(Matlab_file6);
 
i1=1;
i2=1;
j1=530;
j2=530;
i=0;
j=0;

xbsi3_c1_D = xbsi3_c1_V(i1:j1,1) - xbsi3_c1(i2:j2,1);
xbsi3_c2_D = xbsi3_c2_V(i1:floor(j1/5),1) - xbsi3_c2(i2:floor(j2/5),1);
xbsi3_c3_D = xbsi3_c3_V(i1+i:floor(j1/10)+j,1) - xbsi3_c3(i2+i:floor(j2/10)+j,1);
xbsr3_c1_D = xbsr3_c1_V(i1:j1,1) - xbsr3_c1(i2:j2,1);
xbsr3_c2_D = xbsr3_c2_V(i1:floor(j1/5),1) - xbsr3_c2(i2:floor(j2/5),1);
xbsr3_c3_D = xbsr3_c3_V(i1+i:floor(j1/10)+j,1) - xbsr3_c3(i2+i:floor(j2/10)+j,1);

figure(5)
subplot(6,2,4), plot((xbsi3_c1_D)), title('FIR1 Error Imag C1'), grid on;
subplot(6,2,8), plot((xbsi3_c2_D)), title('FIR2 Error Imag C1'), grid on;
subplot(6,2,12), plot((xbsi3_c3_D)), title('FIR3 Error Imag C1'), grid on;
subplot(6,2,3), plot((xbsr3_c1_D)), title('FIR1 Error Real C1'), grid on;
subplot(6,2,7), plot((xbsr3_c2_D)), title('FIR2 Error Real C1'), grid on;
subplot(6,2,11), plot((xbsr3_c3_D)), title('FIR3 Error Real C1'), grid on;

 subplot(6,2,2), plot(xbsi3_c1(i2:j2));
 hold;
 subplot(6,2,2),plot((xbsi3_c1_V(i1:j1)),'r'), title('FIR1 Result Imag C1'), grid on
 hold off;
 subplot(6,2,6), plot(xbsi3_c2(i2:floor(j2/5)));
 hold;
 subplot(6,2,6),plot((xbsi3_c2_V(i1:floor(j1/5))),'r'), title('FIR2 Result Imag C1'), grid on
 hold off;
 subplot(6,2,10), plot(xbsi3_c3(i2+i:floor(j2/10)+j));
 hold;
 subplot(6,2,10),plot((xbsi3_c3_V(i1+i:floor(j1/10)+j)),'r'), title('FIR3 Result Imag C1 '), grid on
 hold off;
 subplot(6,2,1), plot(xbsr3_c1(i2:j2));
 hold;
 subplot(6,2,1),plot((xbsr3_c1_V(i1:j1)),'r'), title('FIR1 Result Real C1'), grid on
 hold off;
 subplot(6,2,5), plot(xbsr3_c2(i2:floor(j2/5)));
 hold;
 subplot(6,2,5),plot((xbsr3_c2_V(i1:floor(j1/5))),'r'), title('FIR2 Result Real C1'), grid on
 hold off;
 subplot(6,2,9), plot(xbsr3_c3(i2+i:floor(j2/10)+j));
 hold;
 subplot(6,2,9),plot((xbsr3_c3_V(i1+i:floor(j1/10)+j)),'r'), title('FIR3 Result Real C1 '), grid on
 hold off;
end

if FIR1FIR2FIR3_N==1
 % Compare FIR1, FIR2, FIR3 
 Verilog_file1 = 'xbsr1_c1_fromVerilog.txt';
 Matlab_file1 = 'xbsr1_c1.txt';
 Verilog_file2 = 'xbsr2_c2_fromVerilog.txt';
 Matlab_file2 = 'xbsr2_c2.txt';
 Verilog_file3 = 'xbsr3_c2f_fromVerilog.txt';  %FULL Version
 Matlab_file3 = 'xbsr3_c2.txt';

 Verilog_file4 = 'xbsi1_c2_fromVerilog.txt';
 Matlab_file4 = 'xbsi1_c2.txt';
 Verilog_file5 = 'xbsi2_c2_fromVerilog.txt';
 Matlab_file5 = 'xbsi2_c2_K.txt';
 Verilog_file6 = 'xbsi3_c2f_fromVerilog.txt';
 Matlab_file6 = 'xbsi3_c2.txt';
 
 xbsr3_c1_V = load(Verilog_file1);
 xbsr3_c1 = load(Matlab_file1);
 xbsr3_c2_V = load(Verilog_file2);
 xbsr3_c2 = load(Matlab_file2);
 xbsr3_c3_V = load(Verilog_file3);
 xbsr3_c3 = load(Matlab_file3);
 
 xbsi3_c1_V = load(Verilog_file4);
 xbsi3_c1 = load(Matlab_file4);
 xbsi3_c2_V = load(Verilog_file5);
 xbsi3_c2 = load(Matlab_file5);
 xbsi3_c3_V = load(Verilog_file6);
 xbsi3_c3 = load(Matlab_file6);
 
i1=1;
i2=1;
j1=520;
j2=520;
i=13;
j=13;

xbsi3_c1_D = xbsi3_c1_V(i1:j1,1) - xbsi3_c1(i2:j2,1);
xbsi3_c2_D = xbsi3_c2_V(i1+1:floor(j1/5)+1,1) - xbsi3_c2(i2:floor(j2/5),1);
xbsi3_c3_D = xbsi3_c3_V(i1+i:floor(j1/10)+j,1) - xbsi3_c3(i2+i:floor(j2/10)+j,1);
xbsr3_c1_D = xbsr3_c1_V(i1:j1,1) - xbsr3_c1(i2:j2,1);
xbsr3_c2_D = xbsr3_c2_V(i1+1:floor(j1/5)+1,1) - xbsr3_c2(i2:floor(j2/5),1);
xbsr3_c3_D = xbsr3_c3_V(i1+i:floor(j1/10)+j,1) - xbsr3_c3(i2+i:floor(j2/10)+j,1);

figure(6)
subplot(6,2,4), plot((xbsi3_c1_D)), title('FIR1 Error Imag Noise'), grid on;
subplot(6,2,8), plot((xbsi3_c2_D)), title('FIR2 Error Imag Noise'), grid on;
subplot(6,2,12), plot((xbsi3_c3_D)), title('FIR3 Error Imag Noise'), grid on;
subplot(6,2,3), plot((xbsr3_c1_D)), title('FIR1 Error Real Noise'), grid on;
subplot(6,2,7), plot((xbsr3_c2_D)), title('FIR2 Error Real Noise'), grid on;
subplot(6,2,11), plot((xbsr3_c3_D)), title('FIR3 Error Real Noise'), grid on;

 subplot(6,2,2), plot(xbsi3_c1(i2:j2));
 hold;
 subplot(6,2,2),plot((xbsi3_c1_V(i1:j1)),'r'), title('FIR1 Result Imag Noise'), grid on
 hold off;
 subplot(6,2,6), plot(xbsi3_c2(i2:floor(j2/5)));
 hold;
 subplot(6,2,6),plot((xbsi3_c2_V(i1+1:floor(j1/5)+1)),'r'), title('FIR2 Result Imag Noise'), grid on
 hold off;
 subplot(6,2,10), plot(xbsi3_c3(i2+i:floor(j2/10)+j));
 hold;
 subplot(6,2,10),plot((xbsi3_c3_V(i1+i:floor(j1/10)+j)),'r'), title('FIR3 Result Imag Noise'), grid on
 hold off;
 subplot(6,2,1), plot(xbsr3_c1(i2:j2));
 hold;
 subplot(6,2,1),plot((xbsr3_c1_V(i1:j1)),'r'), title('FIR1 Result Real Noise'), grid on
 hold off;
 subplot(6,2,5), plot(xbsr3_c2(i2:floor(j2/5)));
 hold;
 subplot(6,2,5),plot((xbsr3_c2_V(i1+1:floor(j1/5)+1)),'r'), title('FIR2 Result Real Noise'), grid on
 hold off;
 subplot(6,2,9), plot(xbsr3_c3(i2+i:floor(j2/10)+j));
 hold;
 subplot(6,2,9),plot((xbsr3_c3_V(i1+i:floor(j1/10)+j)),'r'), title('FIR3 Result Real Noise'), grid on
 hold off;
end

if FIR1FIR2FIR3_C2==1
 % Compare FIR1, FIR2, FIR3 
 Verilog_file1 = 'xbsr1_c3_fromVerilog.txt';
 Matlab_file1 = 'xbsr1_c3_K_new.txt';
 Verilog_file2 = 'xbsr2_c3_fromVerilog.txt';
 Matlab_file2 = 'xbsr2_c3_K_new.txt';
 Verilog_file3 = 'xbsr3_c3f_fromVerilog.txt';  %FULL Version
 Matlab_file3 = 'xbsr3_c3_K_new.txt';

 Verilog_file4 = 'xbsi1_c3_fromVerilog.txt';
 Matlab_file4 = 'xbsi1_c3_K_new.txt';
 Verilog_file5 = 'xbsi2_c3_fromVerilog.txt';
 Matlab_file5 = 'xbsi2_c3_K_new.txt';
 Verilog_file6 = 'xbsi3_c3f_fromVerilog.txt';
 Matlab_file6 = 'xbsi3_c3_K_new.txt';

 xbsr3_c1_V = load(Verilog_file1);
 xbsr3_c1 = load(Matlab_file1);
 xbsr3_c2_V = load(Verilog_file2);
 xbsr3_c2 = load(Matlab_file2);
 xbsr3_c3_V = load(Verilog_file3);
 xbsr3_c3 = load(Matlab_file3);

 xbsi3_c1_V = load(Verilog_file4);
 xbsi3_c1 = load(Matlab_file4);
 xbsi3_c2_V = load(Verilog_file5);
 xbsi3_c2 = load(Matlab_file5);
 xbsi3_c3_V = load(Verilog_file6);
 xbsi3_c3 = load(Matlab_file6);
 
i1=1;
i2=1;
j1=530;
j2=530;
i=13;
j=13;

xbsi3_c1_D = xbsi3_c1_V(i1:j1,1) - xbsi3_c1(i2:j2,1);
xbsi3_c2_D = xbsi3_c2_V(i1+1:floor(j1/5)+1,1) - xbsi3_c2(i2:floor(j2/5),1);
xbsi3_c3_D = xbsi3_c3_V(i1+i:floor(j1/10)+j,1) - xbsi3_c3(i2+i:floor(j2/10)+j,1);
xbsr3_c1_D = xbsr3_c1_V(i1:j1,1) - xbsr3_c1(i2:j2,1);
xbsr3_c2_D = xbsr3_c2_V(i1+1:floor(j1/5)+1,1) - xbsr3_c2(i2:floor(j2/5),1);
xbsr3_c3_D = xbsr3_c3_V(i1+i:floor(j1/10)+j,1) - xbsr3_c3(i2+i:floor(j2/10)+j,1);

figure(7)
subplot(6,2,4), plot((xbsi3_c1_D)), title('FIR1 Error Imag C2'), grid on;
subplot(6,2,8), plot((xbsi3_c2_D)), title('FIR2 Error Imag C2'), grid on;
subplot(6,2,12), plot((xbsi3_c3_D)), title('FIR3 Error Imag C2'), grid on;
subplot(6,2,3), plot((xbsr3_c1_D)), title('FIR1 Error Real C2'), grid on;
subplot(6,2,7), plot((xbsr3_c2_D)), title('FIR2 Error Real C2'), grid on;
subplot(6,2,11), plot((xbsr3_c3_D)), title('FIR3 Error Real C2'), grid on;

 subplot(6,2,2), plot(xbsi3_c1(i2:j2));
 hold;
 subplot(6,2,2),plot((xbsi3_c1_V(i1:j1)),'r'), title('FIR1 Result Imag C2'), grid on
 hold off;
 subplot(6,2,6), plot(xbsi3_c2(i2:floor(j2/5)));
 hold;
 subplot(6,2,6),plot((xbsi3_c2_V(i1+1:floor(j1/5)+1)),'r'), title('FIR2 Result Imag C2'), grid on
 hold off;
 subplot(6,2,10), plot(xbsi3_c3(i2+i:floor(j2/10)+j));
 hold;
 subplot(6,2,10),plot((xbsi3_c3_V(i1+i:floor(j1/10)+j)),'r'), title('FIR3 Result Imag C2 '), grid on
 hold off;
 subplot(6,2,1), plot(xbsr3_c1(i2:j2));
 hold;
 subplot(6,2,1),plot((xbsr3_c1_V(i1:j1)),'r'), title('FIR1 Result Real C2'), grid on
 hold off;
 subplot(6,2,5), plot(xbsr3_c2(i2:floor(j2/5)));
 hold;
 subplot(6,2,5),plot((xbsr3_c2_V(i1+1:floor(j1/5)+1)),'r'), title('FIR2 Result Real C2'), grid on
 hold off;
 subplot(6,2,9), plot(xbsr3_c3(i2+i:floor(j2/10)+j));
 hold;
 subplot(6,2,9),plot((xbsr3_c3_V(i1+i:floor(j1/10)+j)),'r'), title('FIR3 Result Real C2 '), grid on
 hold off;
end

if ALL==1
 % Compare with KaylaFirdecim
Verilog_file1 = './../xbsi3_c1.txt';
Matlab_file1 = 'xbsi3_c1_expected.txt';
Verilog_file2 = './../xbsi3_c2.txt';
Matlab_file2 = 'xbsi3_c2_expected.txt';
Verilog_file3 = './../xbsi3_c3.txt';
Matlab_file3 = 'xbsi3_c3_expected.txt';
Verilog_file4 = './../xbsr3_c1.txt';
Matlab_file4 = 'xbsr3_c1_expected.txt';
Verilog_file5 = './../xbsr3_c2.txt';
Matlab_file5 = 'xbsr3_c2_expected.txt';
Verilog_file6 = './../xbsr3_c3.txt';
Matlab_file6 = 'xbsr3_c3_expected.txt';

xbsi3_c1_V = load(Verilog_file1);
xbsi3_c2_V = load(Verilog_file2);
xbsi3_c3_V = load(Verilog_file3);
xbsr3_c1_V = load(Verilog_file4);
xbsr3_c2_V = load(Verilog_file5);
xbsr3_c3_V = load(Verilog_file6);

xbsi3_c1 = load(Matlab_file1);
xbsi3_c2 = load(Matlab_file2);
xbsi3_c3 = load(Matlab_file3);
xbsr3_c1 = load(Matlab_file4);
xbsr3_c2 = load(Matlab_file5);
xbsr3_c3 = load(Matlab_file6);

i1=1;
i2=1;
j1=65;
j2=65;

xbsi3_c1_D = xbsi3_c1_V(i1:j1,1) - xbsi3_c1(i2:j2,1);
xbsi3_c2_D = xbsi3_c2_V(i1:j1,1) - xbsi3_c2(i2:j2,1);
xbsi3_c3_D = xbsi3_c3_V(i1:j1,1) - xbsi3_c3(i2:j2,1);
xbsr3_c1_D = xbsr3_c1_V(i1:j1,1) - xbsr3_c1(i2:j2,1);
xbsr3_c2_D = xbsr3_c2_V(i1:j1,1) - xbsr3_c2(i2:j2,1);
xbsr3_c3_D = xbsr3_c3_V(i1:j1,1) - xbsr3_c3(i2:j2,1);



figure(8)
subplot(2,3,1), plot((xbsi3_c1_D)), title('FIR3 Error Imag C1'), grid on;
subplot(2,3,2), plot((xbsi3_c2_D)), title('FIR3 Error Imag Noise'), grid on;
subplot(2,3,3), plot((xbsi3_c3_D)), title('FIR3 Error Imag C2'), grid on;
subplot(2,3,4), plot((xbsr3_c1_D)), title('FIR3 Error Real C1'), grid on;
subplot(2,3,5), plot((xbsr3_c2_D)), title('FIR3 Error Real Noise'), grid on;
subplot(2,3,6), plot((xbsr3_c3_D)), title('FIR3 Error Real C2'), grid on;

i=0;
j=0;
figure(9)
 subplot(2,3,1), plot(xbsi3_c1(i2+i:j2-j));
 hold;
 subplot(2,3,1),plot((xbsi3_c1_V(i1+i:j1-j)),'r'), title('FIR3 Result Imag C1'), grid on;
 hold off;
 subplot(2,3,2), plot(xbsi3_c2(i2+i:j2-j));
 hold;
 subplot(2,3,2), plot((xbsi3_c2_V(i1+i:j1-j)),'r'), title('FIR3 Result Imag Noise'), grid on;
 hold off;
 subplot(2,3,3), plot(xbsi3_c3(i2+i:j2-j));
 hold
 subplot(2,3,3), plot((xbsi3_c3_V(i1+i:j1-j)),'r'), title('FIR3 Result Imag C2'), grid on;
 hold off
 subplot(2,3,4), plot(xbsr3_c1(i2+i:j2-j));
 hold
 subplot(2,3,4), plot((xbsr3_c1_V(i1+i:j1-j)),'r'), title('FIR3 Result Real C1'), grid on;
 hold off
 subplot(2,3,5), plot(xbsr3_c2(i2+i:j2-j));
 hold
 subplot(2,3,5), plot((xbsr3_c2_V(i1+i:j1-j)),'r'), title('FIR3 Result Real Noise'), grid on;
 hold off
 subplot(2,3,6), plot(xbsr3_c3(i2+i:j2-j));
 hold
 subplot(2,3,6), plot((xbsr3_c3_V(i1+i:j1-j)),'r'), title('FIR3 Result Real C2'), grid on;
 hold off
end



