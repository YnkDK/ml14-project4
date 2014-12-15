% function [mu, P, SIGMA, clusters] = h4EM(D, k, epsilon, mu)
% H4EM runs k-means clustering using Expectation Maximization.
% 
% [mu, P, SIGMA, clusters] = H4EM(D, k, epsilon) takes in a data matrix, a
% number of desired clusters and a min difference between iterations at
% which to stop optimising.
% It returns the centroids of clusters along with
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


function [mu, P, sigma, clusters] = h4EM(D, k, epsilon, mu)
     [centroids, sigma, P] = init(D,k, nargin ==4 );
     if nargin ==4
         centroids  = mu; %decide it ourselves.
     end
    figure();
    change = inf;
    while(change> epsilon)
       w =  expect(D,k,P, centroids, sigma);
       oldCent = centroids;
       [P, centroids,sigma] = maximization(D,k,w); %w = expectation = E... incase of notation.

       change = 0;
       for cc =1 : k
          change = change+ (eucDist(centroids(cc,:), oldCent(cc,:)))^2;
        end
        fprintf('improvement =  %10.20f\n', change);
        if(isnan(change))
            centroids = oldCent;
            break;
        end
    end
    %we need to assign every datapoint to a cluster.  so use the most
    %likely one.
    
    clusters = zeros(size(D,1),1);
    mu = centroids;
    for ii = 1 : size(D,1)
        [~,cl] = max(w(ii,:));
        clusters(ii) = cl;
    end
    hold off;
end

function [centroids, sigma, P] = init(D,k, haveCentroids)
    P = (1/k)*ones(k,1);
    dims = size(D,2);
     sigma = zeros(dims, dims, k);
%     sigma = ones(dims, dims, k);
      
     val =  eye(dims,dims); 
     for ii = 1 : k
         sigma(:,:,ii) = val;
     end
%     
%     sigma = eye(dims,dims,k);
    %or use kmeans to get the centroids.... ??
    if(haveCentroids ==false)
         [centroids, ~] = h4kmeans(D,k,0.0001);
%          centroids = rand(k, size(D,2)); 
    else
        centroids = [];
    end;
%     centroids  =  rand(k, size(D,2)); % centroids uniformly, at random from the range for every dimension.
end


function [w] = expect(D,k,P, centroids, sigma)
    dims = size(D,2);
    w = zeros(size(D,1),k);
    
    
    aaMat = zeros(k, dims);
    bbInvMat= zeros(dims,dims,k);
    for kk = 1 : k
         aaMat(kk,:) = 1/((2*pi)^(dims/2) * sqrt(det(sigma(:,:,kk))));
         bbInvMat(:,:,kk) = inv(sigma(:,:,kk));
    end
    
    
    for jj = 1 : size(D,1)
        
        allCalc = zeros(k,1);
        xj = D(jj,:);
        for ii = 1 : k  %use 13.6 ?? 
            % aa = 1/((2*pi)^(dims/2) * sqrt(det(sigma(:,:,ii))));
            aa =   aaMat(ii);
            dist = xj-centroids(ii,:);
            bb = -(dist * bbInvMat(:,:,ii)*dist')/2;
            f_i = (aa*exp(bb));
            allCalc(ii) = (f_i.*P(ii))';
        end
        
        sumVal = sum(allCalc);
        for ii = 1 : k
            val = (allCalc(ii) / sumVal);
            w(jj,ii)= val;
        end
         if(sum(w(jj,:))>1.000001)
             fprintf('bug');
         end
    end
end

function  [P, centroids,sigma] = maximization(D,k,w)
    dims = size(D,2);
    count = size(D,1);
    P = zeros(1,k);
    centroids = zeros(k,dims);
    sigma = zeros(dims,dims,k);
    
    %mean
    for kk = 1 : k
            centroids(kk,:) =((w(:,kk)'*D) / sum(w(:,kk)));
    end
    scatter(centroids(:,1),centroids(:,2));
    hold on;
    %P.
    for kk = 1 : k
        P(kk) = sum(w(:,kk))/count;
    end
    %sigma
    for kk = 1 : k
        top = 0;
        for jj  = 1 : count
            dist = D(jj,:) - centroids(kk,:);
            top = top+ w(jj,kk) * (dist' * dist); %remeber that we have reversed data already.. 
        end
        bottom = sum(w(:,kk));
        sigma(:,:,kk) = top/bottom;
    end

    

end


function dist = eucDist (x, y)
    dist =  sqrt(sum((x-y).^2)) ;
end