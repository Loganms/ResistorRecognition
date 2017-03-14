function [ nrgb ] = rgb2normalizedrgb( image )
%RGB2NORMALIZEDRGB converts an rgb image to normalized rgb [0, 255]

nrgb = image;

image_red = image(:,:,1);
image_green = image(:,:,2);
image_blue = image(:,:,3);

[rows, cols] = size(image_red);

for x = 1 : rows
   for y = 1 : cols
      px_red = image_red(x,y);
      px_green = image_green(x,y);
      px_blue = image_blue(x,y);
      
      if ((px_red + px_green + px_blue) == 0)
          norm_red = 1/3;
          norm_green = 1/3;
          norm_blue = 1/3;
      else
          norm_red = double(px_red)/double(px_red + px_green + px_blue);
          norm_green = double(px_green)/double(px_red + px_green + px_blue);
          norm_blue = double(px_blue)/double(px_red + px_green + px_blue);
      end
      
      nrgb(x,y,1) = double(norm_red)*255;
      nrgb(x,y,2) = double(norm_green)*255;
      nrgb(x,y,3) = double(norm_blue)*255;
   end
end

end