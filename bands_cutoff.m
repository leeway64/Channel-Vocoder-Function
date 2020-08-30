%----------------design of the logarithmic filter bank------------------
% fmin: the lowest frequency to cover
% fmax: the highest frequency to cover
% N: number of bands or number of channels
% The output fco contains N+1 frequency values for N bandpass filters. For
% example, [fco(i) fco(i+1)] is for the ith bandpass filter.

function fco=bands_cutoff(fmin, fmax, N)
    xmin = log10(fmin/165.4+1)/2.1;
    xmax = log10(fmax/165.4+1)/2.1; %relative value
    dx = (xmax-xmin)/N;
    x = xmin:dx:xmax;
    fco=zeros(1,N+1);
    for i=1:N+1
        fco(i)=165.4*(10^(x(i)*2.1)-1);
    end
end