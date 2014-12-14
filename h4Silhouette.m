function [s] = h4Silhouette(D, clusters)
% H4SILHOUETTE computes the Silhouette score for clustering algorithms.
% 
% H4SILHOUETTE(D, clusters) takes in a data matrix and cluster assignments
% for each point in D and returns the silhouette values in the n-by-1
% vector s

pointsMis =0;
% ssss = silhouette(D, clusters); %the inbuilt. 
s = zeros(size(D, 1)-1,1);
    % TODO implement h4Silhouette
     
    for ii=1 : size(D,1)
        xi = D(ii,:);
        ownCluster = clusters(ii);
        %step 1
        pointsInCluster =  D(clusters==ownCluster,:);
        myInXi = myIn(pointsInCluster, xi);

        %step 2
%         ncl = nearstCluster(D, clusters, ii);
%         pointsInNear = D(clusters==ncl,:);
%         myMin = myOut(pointsInNear, xi);
        myMin = testOut (D, clusters, ii);
        
        top =myMin-myInXi;
        bottom = max([myInXi, myMin]);
        if(bottom==0 || bottom == inf)
            s(ii)=0;
        else
            si = top/bottom;
            if(si<0.1 && si>=0)
              fprintf('point at:%f,%f is at the border of the cluster..\r', xi(1), xi(2));
            end
            if(si<=0)
                pointsMis=  pointsMis +1;
                fprintf('point at:%f,%f is belived to be misclustered.\r', xi(1), xi(2));
            end
            s(ii) =si;
        end
    end;
    fprintf('found totally : %i points of possibly misclasification',pointsMis);
end

function res = myIn(data, thisPoint)
    sumVal =0;
    sizeData = size(data,1);
    for ii = 1 : sizeData
        sumVal  = sumVal + dist(thisPoint, data(ii,:));
    end
    res = sumVal / (sizeData-1);

end

function res = myOut(data, thisPoint)
    sumVal =0;
    sizeData = size(data,1);
    for ii = 1 : sizeData
        sumVal  = sumVal + dist(thisPoint, data(ii,:));
    end
    res = sumVal / (sizeData);
    
end

function myMin =  testOut (D, clusters, index)

    myPoint = D(index, :);
    myMin = inf;
    myCluster = clusters(index);
    k = max(clusters);
    for ii = 1 : k
        if(ii==myCluster)
            continue;
        end
        mo = myOut(D(clusters==ii,:),myPoint);
        myMin = min(mo, myMin);
    end
end

function d = dist(x,y)
   d =  sqrt(sum((x-y).^2)) ;
end

