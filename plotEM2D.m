function plotEM2D(P, mu, SIGMA, D, correct)
% PLOTEM2D plots the resuts of running the EM algorithm.
% 
% PLOTEM2D(P, mu, SIGMA, D, correct) takes the results of running H4EM
% and makes a plot. D should be a two dimensional matrix of elements and
% correct should be a n-by-1 ground thruth of labels;
% 
% See also H4EM.
    if size(D,2) ~= 2
        error 'plotEM2D only works on two dimensional data.'
    end

    scatter(D(:,1), D(:,2), 20, correct);figure(gcf)
    hold on

    colors = [1, 1, 0; % yellow
              0, 0, 1; % blue
              0, 0, 0; % black
              0, 1, 0; % green
              1 0 1; % magenta
              1, 0, 0; % red
              0, 01, 01; % cyan
              0.5, 0.5, 0.5;
              0.5, 0.5, 0.5;
              0.5, 0.5, 0.5];
   
    [X1,X2] = meshgrid(linspace(-4,4,80)', linspace(-4,4,80)');
    X = [X1(:) X2(:)];
    for i=1:size(P,1)
        sigma_for_cluster = SIGMA(:,:,i);
         p = mvnpdf(X, mu(i,:), sigma_for_cluster);
%         p = mvnpdf(X, mu(i,:));
%          p = mvnpdf(X, [],sigma_for_cluster);
        [~, h] = contour(X1,X2,reshape(p,80,80),1);
        set(h, 'LineColor', colors(i,:));
    end
    hold off
end