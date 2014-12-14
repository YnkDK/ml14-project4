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
end

function [centroids, sigma, P] = init(D,k, haveCentroids)
    P = (1/k)*ones(k,1);
    dims = size(D,2);
    sigma = zeros(dims, dims, k);
    val =  eye(dims,dims); 
    for ii = 1 : k
        sigma(:,:,ii) = val;
    end
    
%     sigma = eye(dims,dims,k);
    %or use kmeans to get the centroids.... ??
    if(haveCentroids ==false)
        [centroids, ~] = h4kmeans(D,k,0);
    else
        centroids = [];
    end;
%     centroids  =  rand(k, size(D,2)); % centroids uniformly, at random from the range for every dimension.
end


function [w] = expect(D,k,P, centroids, sigma)
    
    dims = size(D,2);
    w = zeros(size(D,1),k);
    preCompCluster = zeros(dims, dims, k);
    %     calc the first loop seperate since it is a lot smaller than the
    %     other, so dont wast time recomputing it again.
    %       essentially the top of the division. ( and if we sum it, part
    %       of the button.
    emptyVal = zeros(dims, dims);
    S = zeros(1,k);
    
    posterior = zeros(k,1);
    for kk = 1 : k
        %avoid 0 posibilities by setting it to the lowest possible value
        %(eps).
        if( sigma(:,:,kk) == emptyVal )
            sigma(:,:,kk) = ones(dims, dims)*eps;
        end
        posterior(kk) = sqrt(det(inv(sigma(:,:,kk))));
         S(kk) = sqrt(det(sigma(:,:,kk))); %todo fix.should not have max.
         preCompCluster(:,:,kk) = inv(sigma(:,:,kk));
         if(preCompCluster(:,:,kk) == ones(dims, dims)*inf) %todo fix.
             preCompCluster(:,:,kk) = sigma(:,:,kk);
         end
    end;
    tempFac = sqrt(2*pi); %or sqrt of it all ?? TODO find out.
    
    for ii = 1 : size(D,1)
        for kk = 1 : k
            dXM = D(ii,:)-centroids(kk,:);% x-ui.
            pl = exp(-0.5*dXM*preCompCluster(:,:,kk)*dXM')/(tempFac*S(kk));
            
            
            aa = tempFac*(sqrt(det(sigma(:,:,kk))));
            bb = dXM * dXM';
            cc = 2*(det(sigma(:,:,kk)));
            
%             f_val = (1/(tempFac*S(kk))) * exp(-1* ((dXM)*dXM')/(2*(S(kk).^2)));
            f_val = exp(-bb/cc)/aa;
            
            diff= pl-f_val;
            if(diff~=0)
%                 fprintf('|%f|%f|\r', pl, f_val);
            end
            w(ii,kk) =posterior(kk)*f_val;
        end
        w(ii,:) = w(ii,:)/sum(w(ii,:));
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
        top = w(:,kk)'*D(:,:); %is the top part, remeber the vector operation *
                               % A= (a,b) ; B = (c,d) A*B = a*c+.. which is what we want
        bottom = sum(w(:,kk));
        centroids(kk,:)= top/bottom;
    end
    
    for kk = 1 : k
        P(kk) = sum(w(:,kk))/count;
    end
    
    
    for kk = 1 : k
        
        tempSum =0 ;
        
        for jj  = 1 : count
            tempVal = D(jj,:)-centroids(kk,:);
            tempSum = tempSum +w(jj,kk)*(tempVal*tempVal');
        end
        top  = tempSum;
%       top = w(:,kk)'*(D(:,:)*D(:,:)');
       bottom = sum(w(:,kk));
       sigma(:,:,kk) =eye(dims,dims) *top/bottom;
    end
    
%     for i = 1 : k, 
%         for j = 1 : count
%             P(i) = P(i) + w(j,i);
%             centroids(i,:) = centroids(i,:) + w(j,i)*D(j,:);
%              % f(xj | centroids, sigma). the chance to see xj, in our model Sigma, given the expectaition
%         end
%         centroids(i,:) = centroids(i,:)/P(i); %move center, to the most "likely" points we have encountered. 
%                                               %in kmeans this would just be the average (but here we
%                                               %take advantage of the expectation
%     end
%     for i=1:k,
%         for j=1: count
%             dXM = D(j,:)-centroids(i,:); %direct distance / the delta in the points.
%             sigma(:,:,i) = sigma(:,:,i) + w(j,i)*(dXM*dXM');
%         end
%         sigma(:,:,i) = eye(dims, dims).*sigma(:,:,i)./P(i);
%         % we assume we only have dims independt variables... 
%         
%     end
%     P = P./count;
end


function dist = eucDist (x, y)
    dist =  sqrt(sum((x-y).^2)) ;
end