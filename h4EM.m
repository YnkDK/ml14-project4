function [mu, P, SIGMA, clusters] = h4EM(D, k, epsilon, mu)
% H4EM runs k-means clustering using Expectation Maximization.
% 
% [mu, P, SIGMA, clusters] = H4EM(D, k, epsilon) takes in a data matrix, a
% number of desired clusters and a min difference between iterations at
% which to stop optimising. It returns the centroids of clusters along with
% cluster probabilities for every cluster, covariance matrices for every
% cluster and a cluster assignment for every data point so that each point
% is assigned to the cluster it is most likely to be part of.
% 
% [mu, P, SIGMA, clusters] = H4EM(D, k, epsilon, mu) is similar to the
% previous call, but it accepts the initial centroids as a parameter. This
% can be used, for example, by starting k-means and using the cetroids from
% k-means to initialise EM.
% 
% See also H4KMEANS.
    change = epsilon*2;
    dataPoints = size(D,2);
    if nargin == 3
%         The initial centroids haven't been given, initialise the 
% centroids uniformly, at random from the range for every dimension.
    centroids  =  rand(numDim, k);
    oldCentroids = centroids;
    end

    % TODO implement EM
    mu = zeros(k,size(D,2));
    P = zeros(k,1);
    SIGMA = cell(k,1);
    clusters = zeros(k,1);
    
    
    w = zeros(k, dataPoints);
    
    t = 0;
    while(change > epsilon)
        t = t +1;
        %expectation step
        for ii = 1 : k
            for j=1 : dataPoints
                %top = f(x(j) | mu(i), ???(i)) * P(i);
                top =0;%f(xj| mu_i, Sigma_i) \dot P(C_i)
                bottom = 0;
                %bottom  = sum(...)which is just larger
                w(ii,j) = top/bottom;
            end;
        end;
        
        
       
        tempCentroids = centroids;
         % maximization step
        for ii= 1 : k
            centroids(ii) = 0;%.... 
            SIGMA(ii) = 0;%....sum(w(i,:)) / sum(w(i,:));
            
            
            P(ii) = sum(w(ii,:)) / n ; %average
            
        end;
        
        
        change = ((sum(centroids - oldCentroids).^2));
        oldCentroids = tempCentroids;
        
    end
    
end