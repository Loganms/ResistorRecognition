%% Template Matching
INPUT = 'ComplexImages/';
NUM_IMAGES = 5;

TEMPLATES = 'templates/';
NUM_TEMPLATES = 2;

% Features:
    % color space
    feat_cs = ['Lab'; 'Lab'; 'YIQ'];
    % component
    feat_comp = [2;3;2];
    % threshold amount
    feat_thresh = [0.4; 0.75; 0.42];

    
%% MAIN
for test = 1 : NUM_IMAGES
    image = imread([INPUT, 'c', num2str(test), '.jpg']);

    mask = thresholdComplex(image, feat_cs, feat_comp, feat_thresh);
    
    for template_num = 2 %: NUM_TEMPLATES
        template = imread([TEMPLATES, 'r_template', num2str(template_num), '.png']);

        C = normxcorr2(template, mask);
        
        [x,y] = size(mask);
        [cor_x,cor_y] = size(C);
        offset = [cor_x-x,cor_y-y];
        C = C(offset(1)/2:cor_x-offset(1)/2,offset(2)/2:cor_y-offset(2)/2);
        imshow(C)
    end
end





