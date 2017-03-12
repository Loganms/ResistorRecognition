function [ comp ] = featureExtract( image, colorspace, component )
%featureExtract extracts the component from image in colorspace

    % change color space
    if (strcmp(colorspace, 'nRGB'))
       image = rgb2nrgb(image);
    elseif (strcmp(colorspace, 'HSV'))
       image = rgb2hsv(image); 
    elseif (strcmp(colorspace, 'Lab'))
       image = rgb2lab(image);
    elseif (strcmp(colorspace, 'YCbCr'))
       image = rgb2ycbcr(image);
    elseif (strcmp(colorspace, 'YIQ'))
       image = rgb2ntsc(image);
    end

    comp = image(:,:, component);

end

