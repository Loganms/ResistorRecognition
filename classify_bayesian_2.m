function [ labeled ] = classify_bayesian_2( im_layer_1, im_layer_2,...
    class_1_x, class_1_y,...
    class_2_x, class_2_y )
%classify_bayesian_1 Classifies all pixels using bayes' classifier
%   Used for 2 dimension analysis

all_class_x = [class_1_x; class_2_x];

class_1_prior = double(length(class_1_x) / length(all_class_x));
class_2_prior = double(1 - class_1_prior);

class_1_mu = [mean(class_1_x);mean(class_1_y)];
class_2_mu = [mean(class_2_x);mean(class_2_y)];

%% CLASS 1 Covariance Matrix
class_1_covariance = 0;
for feature = 1 : length(class_1_x)
    class_1_feature = double([class_1_x(feature);class_1_y(feature)]);
    class_1_covariance = class_1_covariance +...
    (class_1_feature - class_1_mu) *...
        (transpose(class_1_feature - class_1_mu));
    
end
class_1_covariance = class_1_covariance * (1/(length(class_1_x) - 1));

%% CLASS 2 Covariance Matrix
class_2_covariance = 0;
for feature = 1 : length(class_2_x)
    class_2_feature = double([class_2_x(feature);class_2_y(feature)]);
    class_2_covariance = class_2_covariance +...
    (class_2_feature - class_2_mu) *...
        (transpose(class_2_feature - class_2_mu));
    
end
class_2_covariance = class_2_covariance * (1/(length(class_2_x) - 1));


%% Classify each pixel
[im_rows, im_cols] = size(im_layer_1);
labeled = zeros(im_rows, im_cols);

for i = 1 : im_rows
   for j = 1 : im_cols
    test_feature = double([im_layer_1(i,j);im_layer_2(i,j)]);
       
    class_1_prob = (1 / (2*pi* sqrt(det(class_1_covariance))))^...
    ( -0.5 * transpose(test_feature - class_1_mu) * inv(class_1_covariance) * (test_feature - class_1_mu));

    class_2_prob = (1 / (2*pi* sqrt(det(class_2_covariance))))^...
    ( -0.5 * transpose(test_feature - class_2_mu) * inv(class_2_covariance) * (test_feature - class_2_mu));
   
    labeled(i,j) = (class_1_prob * class_1_prior) <...
        (class_2_prob * class_2_prior);
   end
end

end

