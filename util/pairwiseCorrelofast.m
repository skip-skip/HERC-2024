function [corrs,samples,timelags,P] = pairwiseCorrelofast(acfilts,wl,ol,dtmax)
%UNTITLED3 Summary of this function goes here
%   acfilts is a matrix where each column is a channel. Channels are
%   pairwise cross correlated
pairs = nchoosek([1:size(acfilts,2)],2);

for k=1:size(pairs,1)
        [corrs(:,:,k),samples,timelags,P(:,k)] = correlofast(acfilts(:,pairs(k,1)),acfilts(:,pairs(k,2)),wl,ol,dtmax);
end

end