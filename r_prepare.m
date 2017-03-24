function [ im ] = r_prepare( im )
%r_prepare Takes an image and standardizes its resolution for recognition
%   Makes the image's dominant dimension always follow the horizontal axis.
%   Resizes the image if dominant dimension is less than 1300 pixels or
%   more than 1900 pixels to 1600 pixels.

MIN_HORIZ_LENGTH = 1300;
MAX_HORIZ_LENGTH = 1900;
BASE_HORIZ_LENGTH = 1600;

[im_rows, im_cols] = size (im(:,:,1));

% MAKE HORIZONTAL DOMINANT DIMENSION
if (im_cols < im_rows)
    im = imrotate(im, -90);
    [~, im_cols] = size (im);
end

% RESIZE
if (im_cols < MIN_HORIZ_LENGTH || im_cols > MAX_HORIZ_LENGTH)
   ratio = double(BASE_HORIZ_LENGTH) / double(im_cols);
   im = imresize(im, ratio);
end

end

