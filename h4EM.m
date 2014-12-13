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


emDim = 2;


    change = epsilon*2;
    dataPoints = size(D,1);
    if nargin == 3
      centroids  =  rand(k, size(D,2)); % centroids uniformly, at random from the range for every dimension.
    else
        centroids  = mu;
    end
    oldCentroids = centroids;
    
    % TODO implement EM
    mu = zeros(k,size(D,2));
    P = zeros(k,1);
    for kk = 1 : k
        P(kk) = 1/k;
    end
    SIGMA = repmat(eye(emDim,emDim),k,1);
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

function [mu, P, SIGMA, clusters] = h4EM2(D, k, epsilon, mu)
     if nargin == 3
        centroids  =  rand(k, size(D,2)); % centroids uniformly, at random from the range for every dimension.
     else
         centroids  = mu;
     end
    [means, sigma, P] = init(k, centroids);
    change = inf;
    while(change> epsilon)
       w =  expect(D,k,
    end
    
end

function [] = init()

end


function [w] = expect(D,k)

    preCompCluster = zeros(k,1);
    %     calc the first loop seperate since it is a lot smaller than the
    %     other, so dont wast time recomputing it again.
    %       essentially the top of the division. ( and if we sum it, part
    %       of the button.
    for kk = 1 : k
        
    end;
    

end


function [] = maxi()

end
