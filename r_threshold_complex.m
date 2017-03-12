%% Sample Image Analysis
NUM_IMAGES = 5;
FOLDER = 'ComplexImages/';
SAVE_PATH = [FOLDER, 'ComplexThresh/'];

% Features:
    % color space
    feat_cs = ['Lab'; 'Lab'; 'YIQ'];
    % component
    feat_comp = [2;3;2];
    % threshold amount
    feat_thresh = [0.4; 0.75; 0.42];


for i = 1 : NUM_IMAGES
   % read in each picture
   im = imread([FOLDER, 'c', num2str(i), '.jpg']);
   
%    figure(1)
%    imshow(im);
   
   mask = zeros(size(im(:,:,1)));
   for feat = 1 : length(feat_cs)
       layer = featureExtract(im, feat_cs(feat,:), feat_comp(feat));
       mask_part = layer > (feat_thresh(feat) * max(max(layer)));
       %imwrite(mask_part, [SAVE_PATH, 'c', num2str(i), '_mask_part_', num2str(feat), '.png']);
       mask = mask | mask_part;
   end
   
%    figure(2)
%    imshow(mask);

   %imwrite(mask,[SAVE_PATH, 'c', num2str(i), '_result.png']);
   
   % Extra Processing
   
   colored = bsxfun(@times, im, cast(mask, 'like', im));
   imwrite(colored, [SAVE_PATH, 'c', num2str(i), '_result_colored.png']);
end
