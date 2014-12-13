function [] = showIrisComputed2D(data, truth, computed)
    signs = {'o', 'square', '^'};
    figure();
    for i = 1:max(truth)
    
        allPoints = data(truth==i,:);
        taggetPoints = data(computed==i,:);
        
%         dataPoints = data(computed==i,:);
        
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