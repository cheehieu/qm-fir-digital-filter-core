function de2bi_decimal(indata, outfile)

format long
 pp = 1;
 JJ = 16; % Number of bits
 KK = -14; % Last bit 2^kk     
 K_1 = 1; % starting bit of 2^kk

    
 In = load(indata);
 total = length(In);
 Answer(total,JJ) = 0;
 fid = fopen(outfile,'wt');

 i = 1;
while i <= total
    if In(i,1) < 0
        In1(i,1) = -In(i,1);
    else
        In1(i,1) = In(i,1);
    end
    j = 1;
    k = K_1;
    while (j <= JJ && k >= KK)
        if (In1(i,1) >= 2^k)
            Answer(i,j) = 1;
            In1(i,1) = In1(i,1) - 2^k;
        else 
            Answer(i,j) = 0;
        end
        j = j + 1;
        k = k -1;
    end
    m = JJ:-1:1;
    
    if In(i,1) < 0
        n = 1;
        Answer(i,:) = ~Answer(i,:);
        Answer(i,m(1,n)) = Answer(i,m(1,n)) + 1;
        while n < JJ
            if Answer(i,m(1,n)) >= 2
                Answer(i,m(1,n)) = 0;
                Answer(i,m(1,n+1)) = Answer(i,m(1,n+1)) + 1;
                n = n + 1;
            end
            if (Answer(i,m(1,n)) <= 1)
                Answer(i,m(1,n)) = Answer(i,m(1,n));
                n = n + 1;
            end
        end
        if Answer(i,1) == 2
            Answer(i,:) = 0;
        end
    end
         fprintf(fid,'%1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f %1.0f\n',Answer(i,:));
     i = i + 1;
end