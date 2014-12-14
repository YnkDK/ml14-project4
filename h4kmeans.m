function [centroids, clusters] = h4kmeans(D,k,epsilon) 
% H4KMEANS runs the K-means argorithm.
% 
% [centroids, clusters] = H4KMEANS(D,k,epsilon) takes in a data matrix, a
% number of desired clusters and a min difference between iterations at
% which to stop optimising. It returns the centroids of clusters along with
% cluster assignments for every given data point.


    numDim = size(D, 2);
    numOfRows = size(D, 1);

    % TODO implement h4kmeans+
    t = 0;
    %centroids = zeros(k,size(D,2));
    
    
    %Lastcentroids = rand(k, numDim);
    tmp = unique(D, 'rows');
    if size(tmp, 1) >= k    
        permutation = randperm(size(tmp, 1));
        Lastcentroids = tmp(permutation(1 : k), :);
    else
        % All colors can have their own centroid
        Lastcentroids = [tmp ; rand(k - size(tmp, 1), numDim)];
    end
    centroids = Lastcentroids;
    %randomly initalize the centroids.. in the dimensions we have.
    change =inf; 
    
%     preCompRows= zeros( numOfRows, k, size(D(1, :),2)); %cell(numOfRows,1);
    
%     for ii = 1 : numOfRows
%        row = D(ii, :);
%        repRow = repmat(row, k, 1);
%        preCompRows{ii} = repRow;
%         preCompRows(ii,:,:) = repRow;
%     end;
    
    
    while(change > epsilon)
        t =t+1;
        %// Cluster Assignment Step
        clusters = cell(k, 1); %reset all clusters.
        for ii = 1 : k
            clusters{ii} = logical(false(1,numOfRows));
        end
        for xj = 1 : numOfRows
            diff = (ones(k,1)*D(xj,:)) - centroids;
            % ||diff||^2 = sqrt(sum(diff.^2))^2 = sum(diff.^2)
            distance = sum(diff.^2,2);
            [~, idx] = min(distance);
            clusters{idx}(xj) = true;
        end;
        tempCentroids = centroids; %or dont have a temp ???  and then make the centroids 0 at start ??? 
        for i=1: k
           Ck = D(clusters{i}, :);
           if isempty(Ck)
               continue;
           end;
           centroids(i, :) =  1/size(Ck, 1) * sum(Ck, 1);
        end;
        change = sum(sum((centroids - Lastcentroids).^2, 2));
        fprintf('Change: %f\n', change);
        Lastcentroids = tempCentroids;
    end;
    
    clusters = convertToClusterAssignment(clusters, k);
end

function dataCluster = convertToClusterAssignment (clusters, k)
    dataCluster = zeros(length(clusters{1}),1);
    for ii = 1 : k
        dataCluster(clusters{ii}) = ii;
    end
end