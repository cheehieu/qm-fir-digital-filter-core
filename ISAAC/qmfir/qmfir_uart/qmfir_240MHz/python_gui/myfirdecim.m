function y = myfirdecim(x,h,M)
%
%   function y = myfirdecim(x,h,M)
%
%   myfirdecim implements a decimation filter using efficient polyphase
%   representation. 
%
%   Charles Le, 05/27/08.
%	This work was performed at the Jet Propulsion Laboratory, California
%	Institute of Technology, under contract with the National Aeronautics
%	and Space Administration.
%
%	Version 1
%
%	FOR OFFICIAL USE only.

% filter's polyphase decomposition

ndly0= fix((length(h)-1)/2);             % delay of original filter

hpp= polycom(h,M);         
[rh,ch]= size(hpp);            
ndly1= fix((ch-1)/2);                   % delay in each polyphase component

% input serial-to-parallel conversion

l0= length(x);                          % original signal's length
l1= fix(length(x)/M);                   % signal's length after decimation

xspc= spc([x zeros(1,ndly0)],M);        % remember zero-padding signal with delay of original filter
[rx,cx]= size(xspc);

y= zeros(1,cx);

for k= 1:M;
  y= y + filter(hpp(k,:),1,xspc(k,:));
end

y= y(ndly1+1:ndly1+l1);

