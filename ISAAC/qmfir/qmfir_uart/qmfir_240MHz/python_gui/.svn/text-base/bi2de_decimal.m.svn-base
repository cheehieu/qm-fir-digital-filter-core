function bi2de_decimal(infile, outfile, bitwidth)


format long

        In = load(infile);
        total =length(In);
        Answer(total-2,1) = 0;
        fid = fopen(outfile, 'wt');   %binary 

i =1;
m = 1;
 while i <= total
     if (In(i,1) == 1)
          if bitwidth == 16
                     Answer(i,1) = -In(i,1)*2^m+In(i,2)*2^(m-1)+In(i,3)*2^(m-2)+In(i,4)*2^(m-3)+In(i,5)*2^(m-4)+In(i,6)*2^(m-5)+In(i,7)*2^(m-6)+In(i,8)*2^(m-7)+In(i,9)*2^(m-8)+In(i,10)*2^(m-9)+In(i,11)*2^(m-10)+In(i,12)*2^(m-11)+In(i,13)*2^(m-12)+In(i,14)*2^(m-13)+In(i,15)*2^(m-14)+In(i,16)*2^(m-15);
          elseif bitwidth == 8   
                       Answer(i,1) = -In(i,1)*2^m+In(i,2)*2^(m-1)+In(i,3)*2^(m-2)+In(i,4)*2^(m-3)+In(i,5)*2^(m-4)+In(i,6)*2^(m-5)+In(i,7)*2^(m-6)+In(i,8)*2^(m-7);
          elseif bitwidth == 32
%          Answer(i,1) = -In(i,1)*2^3+In(i,2)*2^(2)+In(i,3)*2^(1)+In(i,4)*2^(0)+In(i,5)*2^(-1)+In(i,6)*2^(-2)+In(i,7)*2^(-3)+In(i,8)*2^(-4)+In(i,9)*2^(-5)+In(i,10)*2^(-6)+In(i,11)*2^(-7)+In(i,12)*2^(-8)+In(i,13)*2^(-9)+In(i,14)*2^(-10)+In(i,15)*2^(-11)+In(i,16)*2^(-12)+In(i,17)*2^(-13)+In(i,18)*2^(-14)+In(i,19)*2^(-15)+In(i,20)*2^(-16)+In(i,21)*2^(-17)+In(i,22)*2^(-18)+In(i,23)*2^(-19)+In(i,24)*2^(-20)+In(i,25)*2^(-21)+In(i,26)*2^(-22)+In(i,27)*2^(-23)+In(i,28)*2^-(24)+In(i,29)*2^(-25)+In(i,30)*2^(-26)+In(i,31)*2^(-27)+In(i,32)*2^(-28);
            
          end

     else
          if bitwidth == 16
                     Answer(i,1) = In(i,1)*2^m+In(i,2)*2^(m-1)+In(i,3)*2^(m-2)+In(i,4)*2^(m-3)+In(i,5)*2^(m-4)+In(i,6)*2^(m-5)+In(i,7)*2^(m-6)+In(i,8)*2^(m-7)+In(i,9)*2^(m-8)+In(i,10)*2^(m-9)+In(i,11)*2^(m-10)+In(i,12)*2^(m-11)+In(i,13)*2^(m-12)+In(i,14)*2^(m-13)+In(i,15)*2^(m-14)+In(i,16)*2^(m-15);
          elseif bitwidth == 8
                       Answer(i,1) =In(i,1)*2^m+In(i,2)*2^(m-1)+In(i,3)*2^(m-2)+In(i,4)*2^(m-3)+In(i,5)*2^(m-4)+In(i,6)*2^(m-5)+In(i,7)*2^(m-6)+In(i,8)*2^(m-7);
          elseif bitwidth == 32
          %          Answer(i,1) = In(i,1)*2^3+In(i,2)*2^(2)+In(i,3)*2^(1)+In(i,4)*2^(0)+In(i,5)*2^(-1)+In(i,6)*2^(-2)+In(i,7)*2^(-3)+In(i,8)*2^(-4)+In(i,9)*2^(-5)+In(i,10)*2^(-6)+In(i,11)*2^(-7)+In(i,12)*2^(-8)+In(i,13)*2^(-9)+In(i,14)*2^(-10)+In(i,15)*2^(-11)+In(i,16)*2^(-12)+In(i,17)*2^(-13)+In(i,18)*2^(-14)+In(i,19)*2^(-15)+In(i,20)*2^(-16)+In(i,21)*2^(-17)+In(i,22)*2^(-18)+In(i,23)*2^(-19)+In(i,24)*2^(-20)+In(i,25)*2^(-21)+In(i,26)*2^(-22)+In(i,27)*2^(-23)+In(i,28)*2^-(24)+In(i,29)*2^(-25)+In(i,30)*2^(-26)+In(i,31)*2^(-27)+In(i,32)*2^(-28);
          end
     end
     fprintf(fid,'%15.8e\n',Answer(i,1));
     i = i + 1	;
 
 
end