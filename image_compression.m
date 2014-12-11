%  This script will load and compress an image using kmeans clustering of
%  colors.
fprintf('\nRunning K-Means clustering on pixels from an image.\n\n');

%  TODO. Load an image. This can be done using the call:
A = double(imread('images/DAIMI_AU_small.png'));

%  We will be displaying the image later on. MatLab expects pixel values to
%  be in the 0 to 1 range
A = A / 255; % Divide by 255 so that all values are in the range 0 - 1

% Size of the image
img_size = size(A);

% TODO. Reshape the image into an N x 3 matrix where N = number of pixels.
% Each row will contain the Red, Green and Blue pixel values. 
D = reshape(A, [img_size(1)*img_size(2) img_size(3)]);

% TODO. Run k-means or EM to form clusters of colors. Experiment with using
% different values for K.
K = 255;


fprintf('\nApplying K-Means to compress an image.\n\n');
[centroids, clusters] = h4kmeans(D,K,0.00001); 

% TODO. Use the resulting centroids and cluster assignments to construct a
% vector of N-by-3 where for each pixel you use the centroid color values.
% Use img_compressed for variable name.
img_compressed = zeros(img_size(1)*img_size(2), img_size(3));
for ii = 1 : K
    img_compressed(clusters{ii}, :) = centroids(ii);
end
% Reshape the vector into a 3 dimensional matrix corresponding to the
% image.
img_compressed = reshape(img_compressed, img_size(1), img_size(2), 3);

% Display the original image 
subplot(1, 2, 1);
imagesc(1:1024, 1:768, A); 
title('Original');

% Display compressed image next to original
subplot(1, 2, 2);
imagesc(1:1024, 1:768, img_compressed)
title(sprintf('Compressed, with %d colors.', K));