function [ r_convicts ] = findVerticalResistors( prepared, im )
%findVerticalResistors Finds all vertically oriented resistors
%   Performs morphological operators imclose and imopen to get full
%   resistor body regions, which are separated from other nearby
%   non-resistor body regions.
%   Then performs a series of tests including an aspect ratio test,
%   a color distribution test, and finally calls stripeTest to perform a
%   stripe test.

MIN_ASPECT_RATIO = 2.0;
MAX_ASPECT_RATIO = 4.2;
MIN_WIDTH = 5;
MAX_WIDTH = 150;

HUE_EDGES = 0:0.2:1;

    % CLOSE Y GAPS
strel_opener = strel('rectangle', [20, 6]);
closed_image = imclose(prepared, strel_opener);

    % OPEN X GAPS
strel_closer = strel('rectangle', [25, 23]);
opened_image = imopen(closed_image, strel_closer);

figure
imshow(opened_image);

    % Get all interesting regions
center = regionprops(opened_image, 'centroid', 'BoundingBox');

    % Eliminate regions with invalid aspect ratio
r_suspects = double(zeros(1,4));
for i = 1 : length(center)
    box = center(i).BoundingBox;
    b_aspect = double(box(4)) / double(box(3))
    if (b_aspect > MIN_ASPECT_RATIO &&...
            b_aspect < MAX_ASPECT_RATIO)
        if box(3) > MIN_WIDTH && box(3) < MAX_WIDTH
            r_suspects = [r_suspects; box];
        end
    end
end
r_suspects = r_suspects(2:end, :)

    % Eliminate regions with invalid background color
hsv_image = rgb2hsv(im);
hue = hsv_image(:,:,1);
r_perpetrators = double(zeros(1,4));

for i = 1 : size(r_suspects, 1)
    box = r_suspects(i, :);
    hist = histcounts(hue(box(2):floor(box(2) + box(4)), box(1):floor(box(1)+box(3))), HUE_EDGES);
    maxIndex = max(hist(:));
    index = find(hist == maxIndex);
    if (index == 1)
        r_perpetrators = [r_perpetrators; box];
    end
end
r_perpetrators = r_perpetrators(2:end, :)

    % STRIPE TEST
r_convicts = double(zeros(1,4));

for i = 1 : length(r_perpetrators(:,1))
    box = r_perpetrators(i, :);

    resistor_can = im(box(2):floor(box(2) + box(4)), box(1):floor(box(1)+box(3)),:);

    if stripeTest(resistor_can)
        r_convicts = [r_convicts; box];
    end
end

r_convicts = r_convicts(2:end, :)

end

