function [] = runner()
[data, labels] = loadAndShowIris('data/iris-PC.csv');

disp('sanity check, first compare labels against labels, should yield 1');
[indi, overall] =  h4F1(labels, labels);
printF1(indi, overall,'sanity results');

fprintf('------------------------- 2d data----------------------------\r');
fprintf('\r\n------------------------- K means -------------------\r\n');
[centers, cla] =  t4kmeans(data, 3, 0.00);
[indi, overall] =  h4F1(cla, labels);
% fprintf('\r\n------------------------- results-------------------\r\n');
% fprintf('\r\nF1 score(overall): %f\r\n',overall);
% for ii =1 : size(indi,1)
%     
% end

printF1(indi,overall, 'results');
title = sprintf('k-means|(F1): %f',overall);
showIrisComputed2D(data, labels, cla, title);
s =  h4Silhouette(data, cla);
fprintf('\r-------------------------');
fprintf('\rSilhouette for k-means:%f\r',mean(s));
if(mean(s)>0.5) 
    fprintf('which is (very) good\r');
else
    fprintf('which is not (too) good\r');
end
fprintf('-------------------------\r');




fprintf('\r\n------------------------- EM -------------------\r\n');
[mu, P, sigma, clusters] =h4EM(data, 3, 0.0000000000000001);
plotEM2D(P, mu, sigma, data, labels);
[indi, overall] =  h4F1(clusters, labels);
printF1(indi,overall, 'results');
showIrisComputed2D(data, labels, clusters, title);
s =  h4Silhouette(data, clusters);
fprintf('\r-------------------------');
fprintf('\rSilhouette for EM:%f\r',mean(s));
if(mean(s)>0.5) 
    fprintf('which is (very) good\r');
else
    fprintf('which is not (too) good\r');
end
fprintf('-------------------------\r');

fprintf('------------------------- 4d data----------------------------\r');

% return; %dont do 4d .
[data, labels] = loadAndShowIris('data/iris.csv');


fprintf('\r\n------------------------- K means -------------------\r\n');
[centers, cla] =  h4kmeans(data, 3, 0.00);
[indi, overall] =  h4F1(cla, labels);
% fprintf('\r\n------------------------- results-------------------\r\n');
% fprintf('\r\nF1 score(overall): %f\r\n',overall);
% for ii =1 : size(indi,1)
%     
% end

printF1(indi,overall, 'results');
title = sprintf('k-means|(F1): %f',overall);
showIrisComputed2D(data, labels, cla, title);
s =  h4Silhouette(data, cla);
fprintf('\r-------------------------');
fprintf('\rSilhouette for k-means:%f\r',mean(s));
if(mean(s)>0.5) 
    fprintf('which is (very) good\r');
else
    fprintf('which is not (too) good\r');
end
fprintf('-------------------------\r');




fprintf('\r\n------------------------- EM -------------------\r\n');
[mu, P, sigma, clusters] =h4EM(data, 3, 0.0);
plotEMMultidimensional(clusters, labels, data);
[indi, overall] =  h4F1(clusters, labels);
printF1(indi,overall, 'results');
showIrisComputed2D(data, labels, clusters, title);
s =  h4Silhouette(data, clusters);
fprintf('\r-------------------------');
fprintf('\rSilhouette for EM:%f\r',mean(s));
if(mean(s)>0.5) 
    fprintf('which is (very) good\r');
else
    fprintf('which is not (too) good\r');
end
fprintf('-------------------------\r');






end



function [] = printF1(indi, overall, title)
fprintf('\r------------------------- %s-------------------\r', title);
fprintf('\rF1 score(overall): %f\r',overall);
for ii =1 : size(indi,1)
    fprintf('\t cluster %i  : %f\r', ii, indi(ii));
end


end


