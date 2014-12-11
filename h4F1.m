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

    F_individual = zeros(size(compute,1));
    for i=1 : size(compute, 1)
        %compute indivdual
        all = size(truth,1);
        tp = (computed(i,:)==truth);
        pred = tp/(size(computed(i),1)); % is given by truePositive / (true positve + false positive). 
                                         % simply, how many were right out of all in the cluster 
        recall =tp/all; %true positive / all in the right cluster/  real cluster.
        F_individual(i) = (2*pred*recall)/(pred+recall);
        
    end;
    F_overall = mean(F_individual);
end