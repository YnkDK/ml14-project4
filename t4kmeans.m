function [centroids, clusters] = t4kmeans(D,k,epsilon) 
%T4KMEANS Summary of this function goes here
%   Detailed explanation goes here

    
    t = 0;
%     centroids = zeros(k, size(D,2));
    centroids = rand(k, size(D,2),1);
    
%     for kk =1 : k
%        centroids(kk,:) = rand(size(D,2),1)'; 
%     end
    improvement = inf;
    clustersAssignments = zeros(size(D,1),1);  %what we assign each node to.
    while(improvement>epsilon)
        parfor ii = 1 : size(D,1)
            %find dist to all clusters.
            %ecludian dist.
             minDist = inf;
             minIndex = -1;
             for cc =1 : k
                 dist = sqrt(sum((D(ii)-centroids(cc)).^2)); %eucDist(centroids(cc),D(ii));
                 if(dist< minDist)
                     minDist = dist;
                     minIndex = cc;
                 end
             end
            clustersAssignments(ii) = minIndex;
        end
        improvement =0;
        for cc =1 : k
            temp = centroids(cc,:);
            idxes = D(clustersAssignments == cc,:);
            if( isempty(idxes))
                continue;
            end
            centroids(cc,:)= mean(idxes);
            improvement = improvement+ eucDist(centroids(cc,:), temp);
        end
        
        
        
        
        drawfig(clustersAssignments, centroids,k,improvement);
        
        fprintf('improvement =  %f\n', improvement);
    end
    
    clusters = cell(k,1);
    
    for kk = 1 : k
        clusters{kk} = find(clustersAssignments == kk); % index for each data point.
    end
    
    
end


function [] = drawfig(clustersAssignments, centroids,k,improvement)

 clusters = cell(k,1);
    
    for kk = 1 : k
        clusters{kk} = find(clustersAssignments == kk); % index for each data point.
    end
    img_size = [600,800,3];
    img_compressed = zeros(img_size(1)*img_size(2), img_size(3));
 for ii = 1 : k
     Ck = clusters{ii};
     if isempty(Ck)
         fprintf('Cluster %d is empty!\n', ii);
         continue
     end
     for jj = 1 : 3
         img_compressed(clusters{ii}, jj) = centroids(ii, jj);
     end
 end
    figure();
    img_compressed = reshape(img_compressed, img_size(1), img_size(2), 3);
    subplot(1, 2, 2);
    imagesc(1:1024, 1:768, img_compressed)
    title(sprintf('imp:%f.',improvement ));
 end

function dist = eucDist (x, y)
    dist =  sqrt(sum((x-y).^2)) ;
end