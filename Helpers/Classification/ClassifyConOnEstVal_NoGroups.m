
% [X,Y,AUC] = ClassifyConOnEstVal_NoGroups(estval,BiDirIds,CurveType,plotROC)
%
% Helper function for ClassifyConOnEstVal. See that function for more
% details.

function [X,Y,AUC,Scores] = ClassifyConOnEstVal_NoGroups(estval,BiDirIds,CurveType,PlotCurve)
    
    labels = 1*(BiDirIds ~= 'Z'); % 1* to convert to floating point
    Scores = SigmoidScores( abs(estval) );
    
    switch CurveType
        case 'ROC'
            [X,Y,~,AUC] = perfcurve(labels,Scores,1);
        case 'PR'
            [X,Y,~,AUC] = perfcurve(labels,Scores,1, 'xCrit','reca', 'yCrit','prec');
    end
    
    
    
    if (PlotCurve == true)
        
        figure
        plot(X,Y, 'Color','k')
        
        txt = sprintf('AUC: %0.2f',AUC);
        text(0.7,0.3,txt)
        
        switch CurveType
            case 'ROC'
                hline = refline([1 0]);
                hline.Color = 'r';
                hline.LineStyle = '--';

                title('ROC')
            case 'PR'
                axis([0 1 0 1])
                title('PRC')
        end % end switch CurveType
    end % end if plotROC
end



