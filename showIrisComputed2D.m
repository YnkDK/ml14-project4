function [] = showIrisComputed2D(data, truth, computed, wt)
    signs = {'o', 'square', '^'};
    figure('Name',wt);
    
    for i = 1:max(truth)
    
        allPoints = data(truth==i,:);
        
        correctI = 1;
        bestLength = -Inf;
        for ii = 1 : max(truth)
            len = length(intersect(allPoints, data(computed==ii,:),'rows'));
            if bestLength < len
                correctI = ii;
                bestLength = len;
            end
        end
        
%         dataPoints = data(computed==i,:);
        taggetPoints = data(computed==correctI,:);
        correctPoints = intersect(allPoints, taggetPoints,'rows');
        
        
        wrongPoints =setxor(correctPoints,taggetPoints,'rows');
        
%         correctPoints = data((truth(comp)==i),:);
%         wrongPoints = data((truth(comp)~=i),:);
        
        
        correctcolor = [0,0.8,0.2];
        
        scatter(correctPoints(:,1),correctPoints (:,2),36,correctcolor ,signs{i});
        hold on;
        
        wrongcolor = [1,0.1,0.2];
        
        
        scatter(wrongPoints(:,1),wrongPoints(:,2),36,wrongcolor ,signs{i},'filled');
        
    end
    hold off
end
