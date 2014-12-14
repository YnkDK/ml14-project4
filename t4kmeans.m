function [centroids, clusters] = t4kmeans(D,k,epsilon) 
%     rng(0);
    centroids = rand(k, size(D,2),1);
    improvement = inf;
    clustersAssignments = zeros(size(D,1),1);  %what we assign each node to.
    while(improvement>epsilon)
        %assign each point to the closest center
        parfor ii = 1 : size(D,1)
             diff = (ones(k,1)*D(ii,:)) - centroids;% ||diff||^2 = sqrt(sum(diff.^2))^2 = sum(diff.^2)
            distance = sum(diff.^2,2);
            [~, idx] = min(distance);
            clustersAssignments(ii) = idx;
        end
        improvement =0;
        %then update the centers, and calcualte the changes / improvement.
        for cc =1 : k
            temp = centroids(cc,:);
            idxes = D(clustersAssignments == cc,:);
            if( isempty(idxes))
                %we could reassign clusters.
                continue;
            end
            centroids(cc, :) =  1/size(idxes, 1) * sum(idxes, 1);
%             centroids(cc,:)= mean(idxes);
            improvement = improvement+ sum((temp-centroids(cc,:)).^2,2); %tempDist (temp, centroids(cc,:));%(eucDist(centroids(cc,:), temp))^2;
        end
        fprintf('improvement =  %f\n', improvement);
    end
    clusters = cell(k,1);
    for kk = 1 : k
        clusters{kk} = find(clustersAssignments == kk); % index for each data point.
    end
    
    clusters = convertToClusterAssign(clusters, D, k);
end

function dataCluster = convertToClusterAssign (clusters, D, k)
    dataCluster = zeros(size(D,1),1);
    for ii =1 : k
        for jj = 1 : size(clusters{ii},1)
            dataCluster(clusters{ii}(jj)) = ii;
        end
    end
end
