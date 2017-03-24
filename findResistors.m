function [ r_vert, r_horiz ] = findResistors(im)
%findResistors Finds all resistors in an image and returns their bounding
%   boxes.
%   Applies the preprocessing steps: thresholding & median filter.
%   Deligates later resistor recognition to 'findVerticalResistors' called
%   on both the preprocessed image and the same image rotated by -90
%   degrees, essentially finding all of the horizontal resistors in the
%   original image.

% THRESHOLD
normal = rgb2normalizedrgb(im);
red_layer = normal(:,:,1);
mask1 = red_layer > 175;
hsv = rgb2hsv(im);
hue_layer = hsv(:,:,1);
mask = (hue_layer > 0.05 & hue_layer < .11) | mask1;

% MEDIAN FILTER
filtered = medfilt2(mask, [9,9]);
filtered2 = filtered;
% FIND ALL POSSIBLE RESISTORS

r_vert = findVerticalResistors(filtered, im);
r_horiz = findVerticalResistors(imrotate(filtered2, -90), imrotate(im, -90));
    
end

