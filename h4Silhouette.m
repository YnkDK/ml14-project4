function [s] = h4Silhouette(D, clusters)
% H4SILHOUETTE computes the Silhouette score for clustering algorithms.
% 
% H4SILHOUETTE(D, clusters) takes in a data matrix and cluster assignments
% for each point in D and returns the silhouette values in the n-by-1
% vector s

    % TODO implement h4Silhouette
     
    for i=1 : size(D,1)
    xi = D(i);
    
    
    %step 1: get the cluster xi is from.
    ownCluster = clusters(1); %TODO ME
    %step 2 
    MeanDistOwnCluster  =0;
    for j = 1 : size(ownCluster, 1)
       MeanDistOwnCluster =MeanDistOwnCluster  + norm((ownCluster(j)-xi));
    end;

    myInXi = meanDistOwnCluster/ size(ownCluster, 1)-1;
    
    
    minSoFar = inf;
    for cl= 1: size(clusters,1)
        if(clusters(cl) ~= ownCluster)
            nearTop =sum(norm(repmat(xi,size(clusters(cl),1))- clusters(cl)));
            minToThisCluster =nearTop/size(clusters(cl),1) ;
            if(minToThisCluster<minSoFar)
                minSoFar = minToThisCluster;
            end;
        end;
    end
    
    
    myMin = minSoFar
    
    top =myMin-myInXi;
    bottom = max([myInXi, myMin]);
    
    
    si =top/bottom;
    
    
    end;
    
    
    
end