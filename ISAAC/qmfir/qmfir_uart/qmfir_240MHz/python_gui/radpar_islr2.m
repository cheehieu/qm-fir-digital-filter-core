function y=radpar_islr2(x,iwin,beta,W,fs,nfft0,nfft1)
%
% y=[pslr islr islr20 fnul f3db];
%
winr= 0;
winh= 1;

%ipeak= fix(length(x)/2)+1;
[xpeak,ipeak]= max(x); 

%%% look for left and right mins

inulx= round(2*(fs/(beta*W))*(nfft1/nfft0));  % approximate null
inulx= inulx+mod(inulx,2);

n1= ipeak-inulx/2;
n2= ipeak+inulx/2;
xmin1= x(n1);
xmin2= x(n2);
iloop= 1;
while iloop==1
  if xmin1 >= x(n1-1) 
    n1= n1-1;
    xmin1= x(n1);
  else
    iloop=0;
  end
end
iloop= 1;
while iloop==1
  if xmin2 >= x(n2+1) 
    n2= n2+1;
    xmin2= x(n2);
  else
    iloop=0;
  end
end



%%% Compute the 20-3db point

if iwin == winr
  i3dbm= fix(ipeak - 20*(0.89/2)*(ipeak-n1));
  i3dbp= ceil(ipeak + 20*(0.89/2)*(n2-ipeak));
elseif iwin == winh
  i3dbm= max([1 fix(ipeak - 20*(1.3/4)*(ipeak-n1))]);
  i3dbp= min([length(x) ceil(ipeak + 20*(1.3/4)*(n2-ipeak))]);
end

mlb= 0.0;
for n=n1:n2
  mlb= mlb + x(n)^2;
end

slb= 0.0;
for n=1:n1
  slb= slb+x(n)^2;
end

for n=n2:length(x)
  slb= slb+x(n)^2;
end

slb20= 0.0;
for n= i3dbm:n1                  % Use 20*3db
  slb20= slb20+x(n)^2;
end

for n= n2:i3dbp
  slb20= slb20+x(n)^2;
end

islr= 10*log10(slb/mlb);
islr20= 10*log10(slb20/mlb);

pslr= max([max(abs(x(1:n1-1))) max(abs(x(n2+1:length(x))))]);
pslr= 20*log10(pslr/max(abs(x)));

%%% compare null and 3dB point with theoretical values

inul= round(2*(fs/W)*(nfft1/nfft0));
fnul= (n2-n1)/2/inul;

n1f= n1;			% limit fitting to greater than -50 dB
n2f= n2;
iloop= 1;
while iloop==1
  if x(n1f) < 10^(-50/20) 
    n1f= n1f+1;
  else
    iloop=0;
  end
end
iloop= 1;
while iloop==1
  if x(n2f) < 10^(-50/20) 
    n2f= n2f-1;
  else
    iloop=0;
  end
end

delx= 0.05;
nv= 0:n2f-n1f;
yv= x(n1f:n2f);
p= polyfit(nv,yv,10);
xf= 0:delx:n2f-n1f;
yf= polyval(p,xf);
igt3db= find(yf > 1/sqrt(2));
x3dbl= min(igt3db)*delx;
x3dbr= max(igt3db)*delx;
 
i3db= (1.3/4)*inul;
f3db= (x3dbr-x3dbl)/2/i3db; 

y=[pslr islr islr20 fnul f3db]';

