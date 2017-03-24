%% Main for resistor recognition

INPUT_FOLDER = 'ComplexImages/';
SAVE_FOLDER = 'ComplexImages/FinalProcessingPipeline2/';

TEST_IMAGE_NUMBER = 1;
TEST_IMAGE_LOCATION = [INPUT_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '.jpg'];

% READ IMAGE
% replace TEST_IMAGE_LOCATION with the location of your image
im = r_prepare(imread(TEST_IMAGE_LOCATION));

[r_vert, r_horiz] = findResistors(im);

    %% Show/Save Vertical Resistors
figure(7)
hold on;
imshow(im)
for i = 1 : size(r_vert, 1)
    box = r_vert(i, :);
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
%saveas(gcf, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_x1verticals.png']);
hold off;

    %% Show/Save Horizontal Resistors
figure(8)
hold on;
imshow(imrotate(im, -90))
for i = 1 : size(r_horiz, 1)
    box = r_horiz(i, :);
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
%saveas(gcf, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_x2horizontals.png']);
hold off;

    %% Combine Vertical and Horizontal BBoxes
% transform horizontal bounding boxes to vertical coordinate space, combine
[rows, cols] = size(im);
r_vert2 = r_horiz;
for i = 1 : size(r_horiz, 1)
    r_vert2(i, :) = [r_horiz(i,2), rows - r_horiz(i,1) - r_horiz(i,3), r_horiz(i,4), r_horiz(i,3)];
end
r_all = [r_vert; r_vert2];

    %% Show/Save All Detected Resistors
figure(9)
hold on;
imshow(im)
for i = 1 : size(r_all, 1)
    box = r_all(i, :);
    rectangle('position', [box(1),box(2),box(3),box(4)], 'EdgeColor','m','linewidth',3);
end
saveas(gcf, [SAVE_FOLDER, 'c', num2str(TEST_IMAGE_NUMBER), '_x3all.png']);
hold off;