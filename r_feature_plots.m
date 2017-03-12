%% Reduce data points
bg_all_comp_1(2:2:end) = [];
bg_all_comp_2(2:2:end) = [];
bg_all_comp_3(2:2:end) = [];

fg_all_comp_1(2:2:end) = [];
fg_all_comp_2(2:2:end) = [];
fg_all_comp_3(2:2:end) = [];


%% SHOW CLASS DISTRIBUTION

figure()
hold on
scatter(bg_all_comp_1, bg_all_comp_3, 2,'g');
scatter(fg_all_comp_1, fg_all_comp_3, 2,'r');
plot(mean(bg_all_comp_1), mean(bg_all_comp_3), 'xk');
plot(mean(fg_all_comp_1), mean(fg_all_comp_3), 'ok');
hold off

%% CLASSIFY

im = rgb2lab(imread('training/r1.jpg'));
labeled = classify_bayesian_2(im(:,:,1), im(:,:,3),...
    fg_all_comp_1, fg_all_comp_3, bg_all_comp_1, bg_all_comp_3);
figure()
imshow(labeled)