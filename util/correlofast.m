function [corrs,samples,timelags,P,SPEC]=correlofast(trace1,trace2,wl,ol,deltmax,sps,normalize)

% correlofast.m performs a running correlation calculation on two time
% series and returns a matrix of normalized cross correlation values.  It
% peforms correlations in the frequency domain and is much faster than
% correplot.  Input data vectors must be time aligned.  This script is
% optimal for processing long time series
%
% USAGE:
%[corrs,samples,timelag]=correlofast(trace1,trace2,window,overlap,deltmax,resize)
%   
% INPUT VARIABLES:
%       trace1 and trace2 (input time series to be compared)
%       wl (time length in samples of the running comparison window...
%           if no window length is declared the correlation will be applied
%           to the entire time series)
%       ol (overlap of comparison window... default is 1/2 window)
%       deltmax (+/-range of lag times that are searched... optional)
%       resize (increase the time resolution of the cross-correlation... optional)
%       normalize ('coeff' or 'none')
%
% OUTPUT VARIABLES
%       corrs (matrix of cross correlations aranged as columns)
%       samples (middle sample of the correlation window)
%       timelag (delay times associated with cross correlation values)
%       traces1/traces2 (optional output with reshaped matrix of all time
%       series)
%       P (power associated with each cross-correlation time window)
%
%
% EXAMPLE:
%
% AUTHOR: Jeff Johnson (jeffreybjohnson@boisestate.edu) updated 6/11/21

if nargin<6
    sps = 100;
end
sps;
ol;
wl;
half_win = ceil(wl/2);

dt = wl-ol;
num_windows = ceil(length(trace1)/dt);
disp(['number of windows is ' num2str(num_windows)])
%N = dt*num_windows; % truncate samples that are not evenly divisible by the time step

disp(['time step is ' num2str(dt) ' samples'])
trace1pad = [zeros(half_win,1)*nan; trace1; zeros(half_win,1)*nan];
trace2pad = [zeros(half_win,1)*nan; trace2; zeros(half_win,1)*nan];
inds = half_win+1:dt:length(trace1pad)-half_win+1;
% sample index for center of each window
samples = inds-half_win;
numsamples = length(trace1pad);

% create matrix of overlapping samples
index = 0;
clear TRACE1 TRACE2
for k = inds % create matrix of overlapping time windows
    k; index = index + 1;
    TRACE1(:,index) = trace1pad(k+[-half_win:half_win-1]);
    TRACE2(:,index) = trace2pad(k+[-half_win:half_win-1]);
end



num_windows = size(TRACE1,2);
if (k+half_win-1)<numsamples
    disp('notice: original data is not an individual multiple of wl and ol')
end

% window overlapping traces with Hanning window
HANN = repmat(hann(wl),1,num_windows);
T1 = TRACE1.*HANN;
T2 = TRACE2.*HANN;

% calculate frequency domain equivalents of time series
FFT1 = fft(T1);
FFT2 = fft(T2);

% calculate optional SPECTROGRAM
if nargout>4;
    nfft = floor(wl/2);
    SPEC = abs(FFT1(1:nfft,:)).*abs(FFT2(1:nfft,:)); % this is analogous to power
end

% normalization factor
NORM21 = sqrt(repmat(sum(abs(FFT1).^2).*sum(abs(FFT2).^2),wl,1));

% create matrix of overlapping correlation functions
if nargin>6 % don't normalize!
    CORRS21 = wl*fftshift(ifft(FFT1.*conj(FFT2)),1);
else
    CORRS21 = wl*fftshift(ifft(FFT1.*conj(FFT2)./NORM21),1);
end


% create other output values
timelags = (1:size(CORRS21,1)) - wl/2 - 1; % time lags in samples
P = NORM21(1,:)/wl; % this is the power of the cross correlation trace

corrs = real(CORRS21);
disp('the following indices are not finite')

nan_indices = find(isnan(sum(corrs)));

% if maximum time lag is declared crop both the correlation matrix and the  
if nargin>4
    lag_indices = abs(timelags)<=deltmax;
    timelags = timelags(lag_indices);
    corrs = corrs(lag_indices,:);
end


disp(['processing ' num2str(num_windows) ' windows of ' num2str(wl) ' samples each; overlap is ' num2str(ol/wl*100) '%'])
end