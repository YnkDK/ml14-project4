function [] = runner()
[data, labels] = loadAndShowIris('data/iris-PC.csv');

disp('sanity check, first compare labels against labels, should yield 1');
[indi, overall] =  h4F1(labels, labels);
printF1(indi, overall,'sanity results');

fprintf('\r\n------------------------- K means -------------------\r\n');
[centers, cla] =  t4kmeans(data, 3, 0.00);
[indi, overall] =  h4F1(cla, labels);
% fprintf('\r\n------------------------- results-------------------\r\n');
% fprintf('\r\nF1 score(overall): %f\r\n',overall);
% for ii =1 : size(indi,1)
%     
% end

printF1(indi,overall, 'results');
showIrisComputed2D(data, labels, cla);

end



function [] = printF1(indi, overall, title)
fprintf('\r------------------------- %s-------------------\r', title);
fprintf('\rF1 score(overall): %f\r',overall);
for ii =1 : size(indi,1)
    fprintf('\t cluster %i  : %f\r', ii, indi(ii));
end
end


