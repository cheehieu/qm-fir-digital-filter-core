function bi2de_decimal(indata, outfile)

format long
In = indata;
total = length(In);
Answer(total-2,1) = 0;
fid = fopen(outfile, 'wt');   %binary 
i =1;
m = 1;
 while i <= total
     if (In(i,1) == 1)
        Answer(i,1) = -In(i,1)*2^m+In(i,2)*2^(m-1)+In(i,3)*2^(m-2)+In(i,4)*2^(m-3)+In(i,5)*2^(m-4)+In(i,6)*2^(m-5)+In(i,7)*2^(m-6)+In(i,8)*2^(m-7)+In(i,9)*2^(m-8)+In(i,10)*2^(m-9)+In(i,11)*2^(m-10)+In(i,12)*2^(m-11)+In(i,13)*2^(m-12)+In(i,14)*2^(m-13)+In(i,15)*2^(m-14)+In(i,16)*2^(m-15);
     else
        Answer(i,1) = In(i,1)*2^m+In(i,2)*2^(m-1)+In(i,3)*2^(m-2)+In(i,4)*2^(m-3)+In(i,5)*2^(m-4)+In(i,6)*2^(m-5)+In(i,7)*2^(m-6)+In(i,8)*2^(m-7)+In(i,9)*2^(m-8)+In(i,10)*2^(m-9)+In(i,11)*2^(m-10)+In(i,12)*2^(m-11)+In(i,13)*2^(m-12)+In(i,14)*2^(m-13)+In(i,15)*2^(m-14)+In(i,16)*2^(m-15);
     end
     fprintf(fid,'%15.8e\n',Answer(i,1));
     i = i + 1	;
 
 end
     