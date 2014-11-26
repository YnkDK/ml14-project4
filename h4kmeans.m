function [centroids, clusters] = h4kmeans(D,k,epsilon) 
% H4KMEANS runs the K-means argorithm.
% 
% [centroids, clusters] = H4KMEANS(D,k,epsilon) takes in a data matrix, a
% number of desired clusters and a min difference between iterations at
% which to stop optimising. It returns the centroids of clusters along with
% cluster assignments for every given data point.

    % TODO implement h4kmeans
    centroids = zeros(k,size(D,2));
    clusters = zeros(size(D,1),1);
end