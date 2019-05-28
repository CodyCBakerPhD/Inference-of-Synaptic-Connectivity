
% [X,Y,AUC,Scores] = ClassifyConOnEstVal_Block(estval,BiDirIds,CurveType,plotROC)
%
% Helper function for ClassifyConOnEstVal. See that function for more
% details.

function [X,Y,AUC,Scores] = ClassifyConOnEstVal_Block(estval,BiDirIds,CurveType,PlotCurve)
    
    % no abs(.) on any of the estvals
    
    lgd = cell(1,2); i = 1;
    
    % Need to include EE2 due to linearity of classifier.
    % Will give artificially low AUC values otherwise, caused by EE2
    % misclassifications...
    EE1labels = (BiDirIds == 'EE1' | BiDirIds == 'EE2');
    if ( any(EE1labels) )
        EE1scores = SigmoidScores( estval );
        lgd{i} = 'EE1'; i = i + 1;
    end
    
    EE2labels = (BiDirIds == 'EE2');
    if ( any(EE2labels) )
        EE2scores = SigmoidScores( estval );
        lgd{i} = 'EE2'; i = i + 1;
    end
    
    % Need to include II2 here, for same reason as EE1 above.
    II1labels = (BiDirIds == 'II1' | BiDirIds == 'II2');
    if ( any(II1labels) )
        II1scores = SigmoidScores( -estval );
        lgd{i} = 'II1'; i = i + 1;
    end
    
    II2labels = (BiDirIds == 'II2');
    if ( any(II2labels) )
        II2scores = SigmoidScores( -estval );
        lgd{i} = 'II2'; i = i + 1;
    end
    
    EIlabels = (BiDirIds == 'EI');
    if ( any(EIlabels) )
        EIscores = SigmoidScores( -estval );
        lgd{i} = 'EI'; i = i + 1;
    end
    
    IElabels = (BiDirIds == 'IE');
    if ( any(IElabels) )
        IEscores = SigmoidScores( estval );
        lgd{i} = 'IE'; i = i + 1;
    end
    
    EIIElabels = (BiDirIds == 'EIIE');
    if ( any(EIIElabels) )
        EIIEscores = SigmoidScores( sign(mean(estval(EIIElabels))) * estval );
        lgd{i} = 'EIIE'; i = i + 1;
    end
    
    
    
    X = struct('XEE1',[], 'XEE2',[], 'XII1',[], 'XII2',[], 'XEI',[], 'XIE',[], 'XEIIE',[]);
    Y = struct('YEE1',[], 'YEE2',[], 'YII1',[], 'YII2',[], 'YEI',[], 'YIE',[], 'YEIIE',[]);
    AUC = struct('AUCEE1',[], 'AUCEE2',[], 'AUCII1',[], 'AUCII2',[], 'AUCEI',[], 'AUCIE',[], 'AUCEIIE',[]);
    Scores = struct('EE1',[], 'EE2',[], 'II1',[], 'II2',[], 'EI',[], 'IE',[], 'EIIE',[]);
    Scores.EE1 = EE1scores;
    Scores.EE2 = EE2scores;
    Scores.II1 = II1scores;
    Scores.II2 = II2scores;
    Scores.EI = EIscores;
    Scores.IE = IEscores;
    Scores.EIIE = EIIEscores;
    
    
    
    switch CurveType
        case 'ROC'
            if ( any(EE1labels) )
                [XEE1,YEE1,~,AUCEE1] = perfcurve(EE1labels,EE1scores,1);
                X.XEE1 = XEE1;
                Y.YEE1 = YEE1;
                AUC.AUCEE1 = AUCEE1;
            end
            if ( any(EE2labels) )
                [XEE2,YEE2,~,AUCEE2] = perfcurve(EE2labels,EE2scores,1);
                X.XEE2 = XEE2;
                Y.YEE2 = YEE2;
                AUC.AUCEE2 = AUCEE2;
            end
            if ( any(II1labels) )
                [XII1,YII1,~,AUCII1] = perfcurve(II1labels,II1scores,1);
                X.XII1 = XII1;
                Y.YII1 = YII1;
                AUC.AUCII1 = AUCII1;
            end
            if ( any(II2labels) )
                [XII2,YII2,~,AUCII2] = perfcurve(II2labels,II2scores,1);
                X.XII2 = XII2;
                Y.YII2 = YII2;
                AUC.AUCII2 = AUCII2;
            end
            if ( any(EIlabels) )
                [XEI,YEI,~,AUCEI] = perfcurve(EIlabels,EIscores,1);
                X.XEI = XEI;
                Y.YEI = YEI;
                AUC.AUCEI = AUCEI;
            end
            if ( any(IElabels) )
                [XIE,YIE,~,AUCIE] = perfcurve(IElabels,IEscores,1);
                X.XIE = XIE;
                Y.YIE = YIE;
                AUC.AUCIE = AUCIE;
            end
            if ( any(EIIElabels) )
                [XEIIE,YEIIE,~,AUCEIIE] = perfcurve(EIIElabels,EIIEscores,1);
                X.XEIIE = XEIIE;
                Y.YEIIE = YEIIE;
                AUC.AUCEIIE = AUCEIIE;
            end
        case 'PR'
            if ( any(EE1labels) )
                [XEE1,YEE1,~,AUCEE1] = perfcurve(EE1labels,EE1scores,1, 'xCrit','reca', 'yCrit','prec');
                X.XEE1 = XEE1;
                Y.YEE1 = YEE1;
                AUC.AUCEE1 = AUCEE1;
            end
            if ( any(EE2labels) )
                [XEE2,YEE2,~,AUCEE2] = perfcurve(EE2labels,EE2scores,1, 'xCrit','reca', 'yCrit','prec');
                X.XEE2 = XEE2;
                Y.YEE2 = YEE2;
                AUC.AUCEE2 = AUCEE2;
            end
            if ( any(II1labels) )
                [XII1,YII1,~,AUCII1] = perfcurve(II1labels,II1scores,1, 'xCrit','reca', 'yCrit','prec');
                X.XII1 = XII1;
                Y.YII1 = YII1;
                AUC.AUCII1 = AUCII1;
            end
            if ( any(II2labels) )
                [XII2,YII2,~,AUCII2] = perfcurve(II2labels,II2scores,1, 'xCrit','reca', 'yCrit','prec');
                X.XII2 = XII2;
                Y.YII2 = YII2;
                AUC.AUCII2 = AUCII2;
            end
            if ( any(EIlabels) )
                [XEI,YEI,~,AUCEI] = perfcurve(EIlabels,EIscores,1, 'xCrit','reca', 'yCrit','prec');
                X.XEI = XEI;
                Y.YEI = YEI;
                AUC.AUCEI = AUCEI;
            end
            if ( any(IElabels) )
                [XIE,YIE,~,AUCIE] = perfcurve(IElabels,IEscores,1, 'xCrit','reca', 'yCrit','prec');
                X.XIE = XIE;
                Y.YIE = YIE;
                AUC.AUCIE = AUCIE;
            end
            if ( any(EIIElabels) )
                [XEIIE,YEIIE,~,AUCEIIE] = perfcurve(EIIElabels,EIIEscores,1, 'xCrit','reca', 'yCrit','prec');
                X.XEIIE = XEIIE;
                Y.YEIIE = YEIIE;
                AUC.AUCEIIE = AUCEIIE;
            end
    end % end switch CurveType
    
    
    
    if (PlotCurve == true)
        
        figure
        if ( any(EE1labels) )
            plot(XEE1,YEE1,'-', 'Color',[0 1 0] * 0.5) % Dark green
            hold on
        end
        
        if ( any(EE2labels) )
            plot(XEE2,YEE2,'g-')
            hold on
        end
        
        if ( any(II1labels) )
            plot(XII1,YII1,'-', 'Color',[1 0 0] * 0.8) % Darker red
            hold on
        end

        if ( any(II2labels) )
            plot(XII2,YII2,'-', 'Color',[0.95 0.2 0]) % Brighter red for contrast
            hold on
        end
        
        if ( any(EIlabels) )
            plot(XEI,YEI,'b-')
            hold on
        end
        
        if ( any(IElabels) )
            plot(XIE,YIE,'c-')
            hold on
        end

        if ( any(EIIElabels) )
            plot(XEIIE,YEIIE,'m-')
            hold on
        end
                
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
        
        legend(lgd)
    end % end if plotROC
end



