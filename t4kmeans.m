function [centroids, clusters] = t4kmeans(D,k,epsilon)  %original h4kmeans
% H4KMEANS runs the K-means argorithm.
% 
% [centroids, clusters] = H4KMEANS(D,k,epsilon) takes in a data matrix, a
% number of desired clusters and a min difference between iterations at
% which to stop optimising. It returns the centroids of clusters along with
% cluster assignments for every given data point.

    %% Global variables
    numDim = size(D, 2);
    numOfRows = size(D, 1);

    
    %% Initialize centroids
    tmp = unique(D, 'rows');
    if size(tmp, 1) >= k
        % Pick k random data points as initial
        permutation = randperm(size(tmp, 1));
        Lastcentroids = tmp(permutation(1 : k), :);
    else
        % All colors can have their own centroid
        Lastcentroids = [tmp ; rand(k - size(tmp, 1), numDim)];
    end
    
    %% Find "best" cluster assignment iterative
    centroids = Lastcentroids;
    % Everything changes in the begining
    change = Inf; 
    while(change > epsilon)
        %% Cluster Assignment Step
        clusters = cell(k, 1); %reset all clusters.
        parfor ii = 1 : k
            clusters{ii} = logical(false(1,numOfRows));
        end
        for xj = 1 : numOfRows
            diff = (ones(k,1)*D(xj,:)) - centroids;
            % ||diff||^2 = sqrt(sum(diff.^2))^2 = sum(diff.^2)
            distance = sum(diff.^2,2);
            [~, idx] = min(distance);
            clusters{idx}(xj) = true;
        end;
        %% Update centroids
        tempCentroids = centroids;
        parfor i=1: k
           Ck = D(clusters{i}, :);
           if isempty(Ck)
               continue;
           end;
           centroids(i, :) =  1/size(Ck, 1) * sum(Ck, 1);
        end;
        %% Get the change
        change = sum(sum((centroids - Lastcentroids).^2, 2));
        fprintf('Change: %f\n', change);
        Lastcentroids = tempCentroids;
    end;
    %% Convert output
    clusters = convertToClusterAssignment(clusters, k);
end

function dataCluster = convertToClusterAssignment (clusters, k)
% CONVERTTOCLUSTERASSIGNMENT converts to proper output
    dataCluster = zeros(length(clusters{1}),1);
    for ii = 1 : k
        dataCluster(clusters{ii}) = ii;
    end
end