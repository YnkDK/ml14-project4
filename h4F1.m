function [F_individual, F_overall] = h4F1(computed, truth)
% H4F1 computes the F1 score for clustering algorithms.
% Arguments:
%   computed = vector of cluster assignments as computed by a clustering
%   algorithm
%   truth = truth vector of cluster assignments 
% 
%  OUTPUT:
%       F_individual = individual F1 scores for each cluster
%       F_overall    = overall F1 score for algorithm, it's the mean
%       average of the individual F1 scores
    k = max(computed');
    k = max (max(truth'), k);
    all = size(truth,1);
    F_individual = zeros(k,1);
    
    
    
    for ii=1 : k% size(computed, 1);
        %compute indivdual
        
        realSize = sum(ii==truth);
        
        allIncomp = sum(computed==ii);
        allInTruth = sum(truth==ii);
        
        
        fp = max(allIncomp - allInTruth,0);
        tp = allIncomp - fp;
        pred = tp/(tp+fp); % is given by truePositive / (true positve + false positive). 
                                         % simply, how many were right out of all in the cluster 
        recall =tp/realSize; %true positive / all in the right cluster/  real cluster.
        F_individual(ii) = (2*pred*recall)/(pred+recall);
        
    end;
    F_overall = mean(F_individual);
end