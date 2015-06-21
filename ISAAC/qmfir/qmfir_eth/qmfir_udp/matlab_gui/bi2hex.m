function bi2hex(indata,outfile)
	In = load(indata);
	total = length(In);
	Answer(total,4) = 0;
	fid = fopen(outfile,'wt');

    i=1;
    while i <= total
        hex1 = In(i,1)*8+In(i,2)*4+In(i,3)*2+In(i,4);
        hex2 = In(i,5)*8+In(i,6)*4+In(i,7)*2+In(i,8);
        hex3 = In(i,9)*8+In(i,10)*4+In(i,11)*2+In(i,12);
        hex4 = In(i,13)*8+In(i,14)*4+In(i,15)*2+In(i,16);

        fprintf(fid,'%x%x%x%x\n', hex1, hex2, hex3, hex4);

        i = i + 1;
    end
end

    