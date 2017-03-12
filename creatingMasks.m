%% Creating Masks

NUM_IMAGES = 33;
FOLDER = 'training/';

for i = 1 : NUM_IMAGES
   % read in each picture
   im = imread(strcat(FOLDER, 'r', num2str(i),'.jpg'));
   
   % create the mask and write to file
   mask = roipoly(im);
   imwrite(mask, strcat(FOLDER, 'r', num2str(i), '_mask.png')); 
end