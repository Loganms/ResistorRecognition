function [ fg_all_comp_1, fg_all_comp_2,...
        fg_all_comp_3, bg_all_comp_1,...
        bg_all_comp_2, bg_all_comp_3] = get_all_fg_bg_components(COLOR_SPACE )
%% Constants
FOLDER = 'training/';
NUM_IMAGES = 33;
% color space: 
    % 1) RGB, 
    % 2) nRGB, 
    % 3) HSV,
    % 4) Lab,
    % 5) YCbCr
    % 6) YIQ (NTSC)

%% Code
fg_all_comp_1 = [];
fg_all_comp_2 = [];
fg_all_comp_3 = [];

bg_all_comp_1 = [];
bg_all_comp_2 = [];
bg_all_comp_3 = [];

for i = 1 : NUM_IMAGES
   %read in resized image and mask
   im = imread(strcat(FOLDER, 'r', num2str(i),'.jpg'));
   mask = imread(strcat(FOLDER, 'r', num2str(i), '_mask.png'));
   
   % change color space
   if (COLOR_SPACE == 2)
       im = rgb2nrgb(im); %normalized rgb, scaled between 0 and 255 inclusive
   elseif (COLOR_SPACE == 3)
       im = rgb2hsv(im); 
   elseif (COLOR_SPACE == 4)
       im = rgb2lab(im);
   elseif (COLOR_SPACE == 5)
       im = rgb2ycbcr(im);
   elseif (COLOR_SPACE == 6)
       im = rgb2ntsc(im);
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


end