
fid = fopen('signal.txt','wt');             % offset video signal
fprintf(fid,'%15.8e\n',xov);
fclose(fid);

fid = fopen('fir1.txt','wt');               % 1st stage's filter
fprintf(fid,'%15.8e\n',hms1);
fclose(fid);

fid = fopen('fir2.txt','wt');               % 1st stage's filter
fprintf(fid,'%15.8e\n',hms2);
fclose(fid);

fid = fopen('fir3.txt','wt');               % 1st stage's filter
fprintf(fid,'%15.8e\n',hms3);
fclose(fid);





