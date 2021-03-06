function [] = image_compression()
%  This script will load and compress an image using kmeans clustering of
%  colors.
fprintf('\nRunning K-Means clustering on pixels from an image.\n\n');

%  TODO. Load an image. This can be done using the call:
 A = double(imread('images/DAIMI_AU_small.png'));
%  A = double(imread('images/penisr.png'));

% Size of the image
img_size = size(A);

% Reshape the image into an N x 3 matrix where N = number of pixels.
% Each row will contain the Red, Green and Blue pixel values. 
D = reshape(A, [img_size(1)*img_size(2) img_size(3)]);
originalColors = size(unique(D), 1)+1;
fprintf('Image contains %d different colors\n', originalColors);
D = D / 255; % Divide by 255 so that all values are in the range 0 - 1
% Run k-means or EM to form clusters of colors. Experiment with using
% different values for K.
K = 100;
  [centroids, idx] = h4kmeans(D, K, 0.001);
% disp('here');
%  [centroids, ~, ~, ~] =h4EM(D, K, 0.1,centroids);
 fprintf('\nApplying K-Means to compress an image.\n\n');

% Use the resulting centroids and cluster assignments to construct a
% vector of N-by-3 where for each pixel you use the centroid color values.
% Use img_compressed for variable name.
img_compressed = zeros(img_size(1)*img_size(2), img_size(3));
for ii = 1 : size(D, 1)
    img_compressed(ii, :) = centroids(idx(ii), :);
end
% Reshape the vector into a 3 dimensional matrix corresponding to the
% image.
img_compressed = reshape(img_compressed, img_size(1), img_size(2), 3);
% Display the original image 
subplot(1, 2, 1);
imagesc(1:img_size(2), 1: img_size(1), reshape(D, img_size(1), img_size(2), 3)); 
title(sprintf('Original, with %d colors.', originalColors));

% Display compressed image next to original
subplot(1, 2, 2);
imagesc(1:img_size(2), 1: img_size(1), img_compressed)
title(sprintf('Compressed, with %d colors.', K));
end