function [ mask ] = thresholdComplex( im, feat_cs, feat_comp, feat_thresh )
%thresholdComplex Thresholds image on multiple features
%   im is input image in RGB colorspace
%   feat_cs is a vector where each row is a color space
%   feat_cmop is a vector where each row designates which component of the
%       feature space to threshold
%   feat_thresh is a vector where each row is a value [0:1] describing the
%       threshold

mask = zeros(size(im(:,:,1)));
for feat = 1 : length(feat_cs)
   layer = featureExtract(im, feat_cs(feat,:), feat_comp(feat));
   mask_part = layer > (feat_thresh(feat) * max(max(layer)));
   mask = mask | mask_part;
end

end

