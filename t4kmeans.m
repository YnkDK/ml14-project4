function [centroids, clusters] = t4kmeans(D,k,epsilon) 
%     rng(0);
    centroids = rand(k, size(D,2),1);
    improvement = inf;
    clustersAssignments = zeros(size(D,1),1);  %what we assign each node to.
    while(improvement>epsilon)
        %assign each point to the closest center
        parfor ii = 1 : size(D,1)
            
             minDist = inf;
             minIndex = -1;
             for cc =1 : k %find dist to all cluster centers.
                 dist = tempDist ( D(ii), centroids(cc));
                 if(dist<= minDist)
                     minDist = dist;
                     minIndex = cc;
                 end
             end
            clustersAssignments(ii) = minIndex; % we are closest to "minIndex".
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
            centroids(cc,:)= mean(idxes);
            improvement = improvement+tempDist (temp, centroids(cc,:));%(eucDist(centroids(cc,:), temp))^2;
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


function D = distL1( X, Y )

m = size(X,1);  n = size(Y,1);
mOnes = ones(1,m); D = zeros(m,n);
for i=1:n
  yi = Y(i,:);  yi = yi( mOnes, : );
  D(:,i) = sum( abs( X-yi),2 );
end
end

function D = distEmd( X, Y )

Xcdf = cumsum(X,2);
Ycdf = cumsum(Y,2);

m = size(X,1);  n = size(Y,1);
mOnes = ones(1,m); D = zeros(m,n);
parfor i=1:n
  ycdf = Ycdf(i,:);
  ycdfRep = ycdf( mOnes, : );
  D(:,i) = sum(abs(Xcdf - ycdfRep),2);
end

end

function d =  tempDist (x,y)
    dim = size(x,2);
    d = nthroot(sum((abs(x-y)).^dim),dim);

end
function dist = eucDist (x, y)
    dist =  sqrt(sum((x-y).^2)) ;
end