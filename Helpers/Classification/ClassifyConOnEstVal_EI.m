
% [X,Y,AUC] = ClassifyConOnEstVal_EI(estval,BiDirIds,CurveType,plotROC)
%
% Helper function for ClassifyConOnEstVal. See that function for more
% details.

function [X,Y,AUC,Scores] = ClassifyConOnEstVal_EI(estval,BiDirIds,CurveType,PlotCurve)
    
    % no abs(.) on ay of the estvals
    % By E/I presynaptic neuron
    
    % Remove EIIE group
    EIIE_Ids = (BiDirIds == 'EIIE');
    BiDirIds = BiDirIds(~EIIE_Ids);
    estval = estval(~EIIE_Ids);
    
    pos_scores = SigmoidScores( estval );
    neg_scores = SigmoidScores( -estval );
    
    Elabels = (BiDirIds == 'EE1' | BiDirIds == 'EE2' | BiDirIds == 'IE');
    Ilabels = (BiDirIds == 'II1' | BiDirIds == 'II2' | BiDirIds == 'EI');
    
    switch CurveType
        case 'ROC'
            [XE,YE,~,AUCE] = perfcurve(Elabels,pos_scores,1);
            [XI,YI,~,AUCI] = perfcurve(Ilabels,neg_scores,1);
        case 'PR'
            [XE,YE,~,AUCE] = perfcurve(Elabels,pos_scores,1, 'xCrit','reca', 'yCrit','prec');
            [XI,YI,~,AUCI] = perfcurve(Ilabels,neg_scores,1, 'xCrit','reca', 'yCrit','prec');
    end % end switch CurveType
    
    
    
    X = struct('XE',XE, 'XI',XI);
    Y = struct('YE',YE, 'YI',YI);
    AUC = struct('AUCE',AUCE, 'AUCI',AUCI);
    Scores = struct('E',[], 'I',[]);
    Scores.E = pos_scores;
    Scores.I = neg_scores;
    
    
    
    if (PlotCurve == true)
        
        figure
        plot(XE,YE, 'Color',[0 1 0] * 0.5) % Dark green)
        hold on
        plot(XI,YI, 'Color',[1 0 0] * 0.8) % Darker red
        
        txt = sprintf('AUC-E: %0.2f\nAUC-I: %0.2f',AUCE,AUCI);
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
        
        legend('E','I')
    end % end if plotROC
end



