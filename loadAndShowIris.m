function [data, labels] = loadAndShowIris(fileName)
% LOADANDSHOWIRIS loads one of two IRIS data sets.
% 
% [data, labels] = loadAndShowIris('data/iris.csv') loads the full IRIS
% dataset.
% 
% [data, labels] = loadAndShowIris('data/iris-PC.csv') loads the Principal
% Components of the IRIS dataset.

%     load data
    fileData = csvread(fileName);
    data = fileData(:,1:end-1);
    labels = fileData(:,end);
    
%     display graph of data
    signs = {'o', 'square', '^'};
    if size(fileData,2) == 3
        for i = 1:max(fileData(:,end))
           dataTemp = data;
           dataTemp(fileData(:,3) ~= i,:) = [];
           scatter(dataTemp(:,1),dataTemp(:,2),36,signs{i});
           hold on
        end
        hold off
    else
        gplotmatrix(data, data, labels, 'bgrcmyk', '.', 10, 'on');
    end
end