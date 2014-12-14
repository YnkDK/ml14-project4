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
    %% Global variables
    d = size(D, 2);
    n = size(D, 1);
    %% Init
    if nargin == 3
        centroids = h4kmeans(D,k,epsilon); % TODO: Should be random
    else
        centroids = mu;
    end
    P = ones(k, 1)/k;
    SIGMA = cell(k,1);
    for ii = 1 : k
        SIGMA{ii} = eye(d);
    end
    clusters = zeros(n,1);
    disp('Starting EM');
    %% Expectation Maximization iterations
    change = Inf;
    w = zeros(k, n);
    while change > epsilon
        oldCent = centroids;
        %% Expectation
        for ii = 1 : k
            parfor jj = 1 : n
                f = P(ii) * mvnpdf(D(jj,:), centroids(ii,:), SIGMA{ii}); %#ok<PFBNS>
                fsum = eps;
                for aa = 1 : k
                    fsum = fsum + mvnpdf(D(jj,:), centroids(aa,:), SIGMA{aa}) * P(aa);
                end
                w(ii,jj) = f/fsum;
            end
        end
        %% Maximization
        for ii = 1 : k
           wij = sum(w(ii, :));
           %% Re-estimate mean
           centroids(ii) = sum(w(ii, :)*D)/wij;
           %% Re-estimate covariance matrix
           fsum = 0;
           parfor jj = 1 : n
              fsum = fsum + w(ii, jj)*(D(jj,:) - centroids(ii,:))*(D(jj,:)-centroids(ii,:))'; %#ok<PFBNS>
           end
           SIGMA{ii} = eye(d,d) * (fsum/wij);
           %% Re-estimate priors
           P(ii) = wij/n;
        end
        change = sum(sum((centroids - oldCent).^2, 2));
    end
    mu = centroids;
    sigma = SIGMA;
    for ii = 1 : n
        [~,cl] = max(w(:, ii));
        clusters(ii) = cl;
    end
end