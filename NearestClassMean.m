%% Part A
NUM_IMAGES = 20;
% choose color space: 1) rgb, 2) nrgb, 3) hsv
COLOR_SPACE = 2;

%% GET ALL FOREGROUND AND BACKGROUND COMPONENTS
fg_all_comp_1 = [];
fg_all_comp_2 = [];
fg_all_comp_3 = [];

bg_all_comp_1 = [];
bg_all_comp_2 = [];
bg_all_comp_3 = [];

for i = 1 : NUM_IMAGES
   %read in resized image and mask
   im = imread(strcat('s', num2str(i),'_r.png'));
   mask = imread(strcat('s', num2str(i), '_mask.png'));
   
   % change color space
   if (COLOR_SPACE == 2)
       im = rgb2nrgb(im); %normalized rgb, scaled between 0 and 255 inclusive
   elseif (COLOR_SPACE == 3)
       im = rgb2hsv(im);        
   end

   % extract foreground pixel components
   fg_extraction = (bsxfun(@times, im, cast(mask, 'like', im)));
   fg_comp_1 = fg_extraction(:,:,1);
   fg_comp_1 = fg_comp_1(mask ~= 0);
   fg_comp_2 = fg_extraction(:,:,2);
   fg_comp_2 = fg_comp_2(mask ~= 0);
   fg_comp_3 = fg_extraction(:,:,3);
   fg_comp_3 = fg_comp_3(mask ~= 0);
   
   fg_comp_1 = fg_comp_1(:);
   fg_comp_2 = fg_comp_2(:);
   fg_comp_3 = fg_comp_3(:);
   
   fg_all_comp_1 = [fg_all_comp_1; fg_comp_1];
   fg_all_comp_2 = [fg_all_comp_2; fg_comp_2];
   fg_all_comp_3 = [fg_all_comp_3; fg_comp_3];
   
   % extract background pixel components
   % flip mask
   mask = mask == 0;
   
   bg_extraction = (bsxfun(@times, im, cast(mask, 'like', im)));
   bg_comp_1 = (bg_extraction(:,:,1));
   bg_comp_1 = bg_comp_1(mask ~= 0);
   bg_comp_2 = bg_extraction(:,:,2);
   bg_comp_2 = bg_comp_2(mask ~= 0);
   bg_comp_3 = bg_extraction(:,:,3);
   bg_comp_3 = bg_comp_3(mask ~= 0);
   
   bg_comp_1 = bg_comp_1(:);
   bg_comp_2 = bg_comp_2(:);
   bg_comp_3 = bg_comp_3(:);
   
   bg_all_comp_1 = [bg_all_comp_1; bg_comp_1];
   bg_all_comp_2 = [bg_all_comp_2; bg_comp_2];
   bg_all_comp_3 = [bg_all_comp_3; bg_comp_3];
end
%% SHOW HISTS
figure
imhist(fg_all_comp_1);
title('Comp 1 fg');
saveas(gcf, ('Comp 1 fg.png'));
figure
imhist(bg_all_comp_1);
title('Comp 1 bg');
saveas(gcf, 'Comp 1 bg.png');

figure
imhist(fg_all_comp_2);
title('Comp 2 fg');
saveas(gcf, 'Comp 2 fg.png');
figure
imhist(bg_all_comp_2);
title('Comp 2 bg');
saveas(gcf, 'Comp 2 bg.png');

figure
imhist(fg_all_comp_3);
title('Comp 3 fg');
saveas(gcf, 'Comp 3 fg.png');
figure
imhist(bg_all_comp_3);
title('Comp 3 bg');
saveas(gcf, 'Comp 3 bg.png');

%% Find the means of the component

meanFG1 = mean(fg_all_comp_1);
meanBG1 = mean(bg_all_comp_1);

%% Apply Nearest Class Mean Classifier
orig1 = imread('c1.jpg');
orig2 = imread('c5.jpg');
orig3 = imread('c10.jpg');

% Normalize the images
orig1 = rgb2nrgb(orig1);
orig2 = rgb2nrgb(orig2);
orig3 = rgb2nrgb(orig3);

% Apply classification
out1 = cityblock1D(orig1, meanBG1,  meanFG1);
out2 = cityblock1D(orig2, meanBG1,  meanFG1);
out3 = cityblock1D(orig3, meanBG1,  meanFG1);

%% Show results
imshow(out1);
figure
imshow(out2);
figure
imshow(out3);

%% Green component
meanFG2 = mean(fg_all_comp_2);
meanBG2 = mean(bg_all_comp_2);

meanBG = [meanBG1; meanBG2];
meanFG = [meanFG1; meanFG2];

out1 = cityblock2D(orig1, meanBG,  meanFG);
out2 = cityblock2D(orig2, meanBG,  meanFG);
out3 = cityblock2D(orig3, meanBG,  meanFG);

%% Show results
imshow(out1);
figure
imshow(out2);
figure
imshow(out3);

%% Blue component
meanFG3 = mean(fg_all_comp_3);
meanBG3 = mean(bg_all_comp_3);

meanBG = [meanBG1; meanBG2; meanFG3];
meanFG = [meanFG1; meanFG2; meanFG3];

out1 = cityblock3D(orig1, meanBG,  meanFG);
out2 = cityblock3D(orig2, meanBG,  meanFG);
out3 = cityblock3D(orig3, meanBG,  meanFG);

%% Show results
imshow(out1);
figure
imshow(out2);
figure
imshow(out3);
