function plotEMMultidimensional(clusters, correct, D)
% PLOTEMMULTIDIMENSIONAL makes a plot matrix of cluster assigments coming
% from a clustering algorithm. 
% 
% PLOTEMMULTIDIMENSIONAL(clusters, correct, D) takes a vector of predicted
% cluster assignments, real cluster assignments and a data matrix and
% creates a plot of correctness of cluster assignment. It colors all
% misclassified elements using the same color.
% 
% See also H4EM.
    if size(D,2) <= 2
        error 'plotEMMULTIDIMENSIONAL only works on data with more than two dimensions.'
    end
    r = max(clusters);
    k = max(correct);
    N = zeros(r, k);
    c = [ones(length(clusters), 1) clusters correct];
    for i=1:r
        for j=1:k
            N(i,j) = length(c(c(:,2)==i & c(:,3) == j));
        end
    end
    [~,I] = max(N, [], 2);
    correctness = zeros(size(clusters));
    for i=1:length(I)
        correctness(clusters == i) = I(i);
    end
    wrongIndex = max(correct)+1;
    correctness(correctness ~= correct) = wrongIndex;
    [h,ax,bigax] = gplotmatrix(D, D, correctness, 'bgrcmyk', '.', [], 'off', 'none');
    colorName = '';
    switch(wrongIndex)
        case 1
            colorName = 'blue';
        case 2
            colorName = 'green';
        case 3
            colorName = 'red';
        case 4
            colorName = 'cyan';
        case 5
            colorName = 'magenta';
        case 6
            colorName = 'yellow';
        case 7
            colorName = 'black';
    end
    t = get(bigax,'title');
    set(t, 'String',sprintf('Misclassified elements are represented using the color %s\n\n', colorName));
    fprintf('Misclassified elements are represented using the color %s\n\n', colorName);
end