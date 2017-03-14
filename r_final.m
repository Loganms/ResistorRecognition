INPUT_FOLDER = 'ComplexImages/';
MIN_HORIZ_LENGTH = 1200;
MAX_HORIZ_LENGTH = 2000;
BASE_HORIZ_LENGTH = 1600;

MIN_ASPECT_RATIO = 2.3;
MAX_ASPECR_RATIO = 3.4;

% READ IMAGE
im = imread([INPUT_FOLDER, 'c1.jpg']);

% MAKE HORIZONTAL DOMINANT DIMENSION
[im_rows, im_cols] = size (im(:,:,1));

if (im_cols < im_rows)
    im = imrotate(im, 90);
    [im_rows, im_cols] = size (im);
end

% RESIZE
if (im_cols < MIN_HORIZ_LENGTH || im_cols > MAX_HORIZ_LENGTH)
   ratio = BASE_HORIZ_LENGTH / im_cols;
   im = imresize(im, ratio);
end

% THRESHOLD
normal = rgb2normalizedrgb(im);
red_layer = normal(:,:,1);
mask = red_layer > 175;

% MEDIAN FILTER
filtered = medfilt2(mask);

% CLOSE Y GAPS
strel_opener = strel('recangle', [17,3]);
closed_image = imclose(filtered, strel_opener);

% OPEN X GAPS
strel_closer = strel('rectangle', [12,8]);
opened_image = imopen(closed_image, strel_closer);

% FIND ALL POSSIBLE RESISTORS
    
    % Get all interesting regions
center = regionprops(opened_image, 'centroid', 'BoundingBox');

    % Eliminate regions with invalid aspect ratio
r_suspects = double(zeros(1,4));
for i = 1 : length(center)
    box = center(i).BoundingBox;
    b_aspect = double(box(4)) / double(box(3));
    if (b_aspect > MIN_ASPECT_RATIO &&...
            b_aspect < MAX_ASPECT_RATIO)
        r_suspects = [r_suspects; box];
    end
end
r_suspects = r_suspects(2:end, :);

    % Eliminate regions with invalid background color
hsv_image = rgb2hsv(im);
hue = hsv_image(:,:,1);
r_perpetrators = double(zeros(1,4));

for i = 1 : length(r_suspects)
    box = r_suspects(i, :);
    hist = histogram(hue(box(2):(box(2) + box(4)), box(1):(box(1)+box(3))), 5);
    bins = hist.BinCounts;
    maxBin = max(bins(:));
    index = find(bins == maxBin);
    if (index == 1)
        r_perpetrators = [r_perpetrators; box];
    end
end
r_perpetrators = r_perpetrators(2:end, :);

    % Draw Boxes to check
figure(8)
hold on;
imshow(im)
for i = 1 : length(r_perpetrators)
    box = r_perpetrators(i, :);
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
hold off;

% FIND HORIZONTAL/VERTICAL

% REGION PROPS

% STRIPE TEST

% (POSSIBLY REMOVE DUPLICATES)

% COMBINE

% DRAW BOUNDING BOXES

% RETURN RESULT