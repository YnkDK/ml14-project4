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
    
    
    Lastcentroids = rand(numDim, k);
    centroids = Lastcentroids;
    %randomly initalize the centroids.. in the dimensions we have.
    change =epsilon*2; 
    while(change > epsilon)
        fprintf('%f > %f\n', change, epsilon);
        t =t+1;
        %// Cluster Assignment Step
        clusters = cell(k, 1); %reset all clusters.
        for ii = 1 : k
            clusters{ii} = NaN(numOfRows,numDim);
        end
        clusterSize = ones(k, 1);
        for xj = 1 : numOfRows   
            row = D(xj, :);
            repRow = repmat(row, k, 1)';
            [value, idx] = min((sqrt(sum(abs(repRow - centroids).^2,1))).^2);
            %j = the index of the cenroids, with the least distance.
            % and assignt Xj to that cluster
            clusters{idx}(clusterSize(idx),:) = row;
            clusterSize(idx) = clusterSize(idx) + 1;
        end;
        tempCentroids = centroids; %or dont have a temp ???  and then make the centroids 0 at start ??? 
        for i=1: k
           centroids(:, i) =  1/size(clusters{i}, 1)* nansum(clusters{i}, 1)';
        end;
        change = sum((sqrt(sum(abs(centroids - Lastcentroids).^2))).^2);
        Lastcentroids = tempCentroids;
    end;
end