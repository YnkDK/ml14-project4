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
    
    
    Lastcentroids = rand(k, numDim);
    centroids = Lastcentroids;
    %randomly initalize the centroids.. in the dimensions we have.
    change =epsilon*2; 
    
    preCompRows= cell(numOfRows,1);
    
    parfor ii = 1 : numOfRows
       row = D(ii, :);
       repRow = repmat(row, k, 1);
       preCompRows{ii} = repRow;
    end;
    
    
    while(change > epsilon)
        fprintf('%f > %f\n', change, epsilon);
        t =t+1;
        %// Cluster Assignment Step
        clusters = cell(k, 1); %reset all clusters.
        for ii = 1 : k
            clusters{ii} = logical(false(1,numOfRows));
        end
        for xj = 1 : numOfRows   
            repRow = preCompRows{xj};
            [value, idx] = min(sum(arrayfun(@dist, repRow, centroids)));
            %j = the index of the cenroids, with the least distance.
            % and assignt Xj to that cluster
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
        change = sum(sum(dist(centroids, Lastcentroids).^2));
        fprintf('Change: %f\n', change);
        Lastcentroids = tempCentroids;
    end;
end

function [dist] = dist(X, Y)
    dist = pdist2(X, Y, 'emd');
end