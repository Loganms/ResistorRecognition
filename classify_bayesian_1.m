function [ labeled ] = classify_bayesian_1( im_layer_1, class_1_x,...
    class_2_x )
%classify_bayesian_1 Classifies all pixels using bayes' classifier
%   Used for 1 dimension analysis

all_class_x = [class_1_x; class_2_x];

class_1_prior = double(length(class_1_x) / length(all_class_x));
class_2_prior = double(1 - class_1_prior);

class_1_mu = mean(class_1_x);
class_2_mu = mean(class_2_x);

class_1_covariance = (1/(length(class_1_x) - 1)) *...
    sum((class_1_x - class_1_mu).^2);
class_2_covariance = (1/(length(class_2_x) - 1)) *...
    sum((class_2_x - class_2_mu).^2);

[im_rows, im_cols] = size(im_layer_1);
labeled = zeros(im_rows, im_cols);

for i = 1 : im_rows
   for j = 1 : im_cols
    test_x = double(im_layer_1(i,j));
       
    class_1_prob = (1 / sqrt(2*pi*class_1_covariance))^...
    ( -0.5 * (test_x - class_1_mu )^2 / class_1_covariance^2);

    class_2_prob = (1 / sqrt(2*pi*class_2_covariance))^...
    ( -0.5 * (test_x - class_2_mu )^2 / class_2_covariance^2);
   
    labeled(i,j) = (class_1_prob * class_1_prior) <...
        (class_2_prob * class_2_prior);
   end
end

end

