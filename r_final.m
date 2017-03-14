INPUT_FOLDER = 'ComplexImages/';
SAVE_FOLDER = 'ComplexImages/FinalProcessingPipeline/';

MIN_HORIZ_LENGTH = 1300;
MAX_HORIZ_LENGTH = 1900;
BASE_HORIZ_LENGTH = 1600;

MIN_ASPECT_RATIO = 2.1;
MAX_ASPECT_RATIO = 4.2;

HUE_EDGES = 0:0.2:1;

TEST_IMAGE_NUMBER = 5;
TEST_IMAGE_LOCATION = [INPUT_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '.jpg'];

% READ IMAGE
im = imread(TEST_IMAGE_LOCATION);

% MAKE HORIZONTAL DOMINANT DIMENSION
[im_rows, im_cols] = size (im(:,:,1));

if (im_cols < im_rows)
    im = imrotate(im, 90);
    [im_rows, im_cols] = size (im);
end

% RESIZE
if (im_cols < MIN_HORIZ_LENGTH || im_cols > MAX_HORIZ_LENGTH)
   ratio = double(BASE_HORIZ_LENGTH) / double(im_cols);
   im = imresize(im, ratio);
end

% THRESHOLD
normal = rgb2normalizedrgb(im);
red_layer = normal(:,:,1);
mask1 = red_layer > 175;
hsv = rgb2hsv(im);
hue_layer = hsv(:,:,1);
mask = (hue_layer > 0 & hue_layer < .11) | mask1;

figure(1)
imshow(mask);

% MEDIAN FILTER
filtered = medfilt2(mask, [9,9]);

% CLOSE Y GAPS
strel_opener = strel('rectangle', [19,3]);
closed_image = imclose(filtered, strel_opener);

figure(2)
imshow(closed_image)

% OPEN X GAPS
strel_closer = strel('rectangle', [1,14]);
opened_image = imopen(closed_image, strel_closer);

figure(3)
imshow(opened_image);

% FIND ALL POSSIBLE RESISTORS
    
    % Get all interesting regions
center = regionprops(opened_image, 'centroid', 'BoundingBox');

    % Show what we start with, before narrowing down
figure(4)
hold on;
imshow(im)
for i = 1: length(center)
    box = center(i).BoundingBox;
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
saveas(gcf, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_4witnesses.png']);
hold off;

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

figure(7)
hold on;
imshow(im)
for i = 1 : size(r_suspects, 1)
    box = r_suspects(i, :);
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
saveas(gcf, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_5suspects.png']);
hold off;

    % Eliminate regions with invalid background color
hsv_image = rgb2hsv(im);
hue = hsv_image(:,:,1);
r_perpetrators = double(zeros(1,4));

for i = 1 : size(r_suspects, 1)
    box = r_suspects(i, :);
    hist = histcounts(hue(box(2):(box(2) + box(4)), box(1):(box(1)+box(3))), HUE_EDGES);
    maxIndex = max(hist(:));
    index = find(hist == maxIndex);
    if (index == 1)
        r_perpetrators = [r_perpetrators; box];
    end
end
r_perpetrators = r_perpetrators(2:end, :);

    % Draw Boxes to check
figure(8)
hold on;
imshow(im)
for i = 1 : size(r_perpetrators, 1)
    box = r_perpetrators(i, :);
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
saveas(gcf, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_6perpetrators.png']);
hold off;

% STRIPE TEST

% (POSSIBLY REMOVE DUPLICATES)

% COMBINE

% DRAW BOUNDING BOXES

% RETURN RESULT

imwrite(mask, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_1threshed.png']);
imwrite(closed_image, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_2closed.png']);
imwrite(opened_image, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_3opened.png']);
