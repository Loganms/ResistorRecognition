%% Sample Image Analysis
NUM_IMAGES = 33;
FOLDER = 'training/';


%% Lab 
SAVE_PATH = 'ThresholdingTests/Lab/';

% Notes Best Thresh: L, none | a, .4*max | b, .5*max

test_comp = 2;
test_string = 'a';

for i = 1 : NUM_IMAGES
   % read in each picture
   im = rgb2lab(imread(strcat(FOLDER, 'r', num2str(i),'.jpg')));
   
   % create the mask and write to file
   %figure(1)
   %imshow(im(:,:,test_comp), []);
   mask = im(:,:,test_comp) > 0.40 * max(max(im(:,:,test_comp)));
   
   %figure(2)
   %imshow(mask);
   imwrite(mask,[SAVE_PATH, test_string, '/r', num2str(i), '_thresh_', test_string, '.png']); 
end

%% YIQ (NTSC)
SAVE_PATH = 'ThresholdingTests/YIQ/';

% Notes Best Thresh: Y, none | I, .5*max | Q, .4*max

test_comp = 3;
test_string = 'Q';

for i = 1 : NUM_IMAGES
   % read in each picture
   im = rgb2ntsc(imread(strcat(FOLDER, 'r', num2str(i),'.jpg')));
   
   % create the mask and write to file
   %figure(1)
   %imshow(im(:,:,test_comp), []);
   mask = im(:,:,test_comp) > 0.4 * max(max(im(:,:,test_comp)));
   
   %figure(2)
   %imshow(mask);
   imwrite(mask,[SAVE_PATH, test_string, '/r', num2str(i), '_thresh_', test_string, '.png']); 
end

%% nRGB 
SAVE_PATH = 'ThresholdingTests/nRGB/';

% Notes Best Thresh: nR, (.75*max) ALSO (>.64) | nG, none | nB, <.52

test_comp = 3;
test_string = 'nB';

for i = 1 : NUM_IMAGES
   % read in each picture
   im = rgb2nrgb(imread(strcat(FOLDER, 'r', num2str(i),'.jpg')));
   
   % create the mask and write to file
   %figure(1)
   %imshow(im(:,:,test_comp), []);
   mask = im(:,:,test_comp) < 0.52;
   
   %figure(2)
   %imshow(mask);
   imwrite(mask,[SAVE_PATH, test_string, '/r', num2str(i), '_thresh_', test_string, '.png']); 
end


