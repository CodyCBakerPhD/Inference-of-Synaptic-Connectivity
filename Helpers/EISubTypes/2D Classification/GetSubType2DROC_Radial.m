
% no defaults are currently setup

function [ROCs,AUROCs] = GetSubType2DROC_Radial(SubTypeValues1,SubTypeValues2,nBins,plotROC)

    %% Combine partitions
    EE1vsEE0Labels = [ones(numel(SubTypeValues1.EE1),1); zeros(numel(SubTypeValues1.EE0),1)];
    EE1vsEE0Value1 = [SubTypeValues1.EE1; SubTypeValues1.EE0];
    EE1vsEE0Value2 = [SubTypeValues2.EE1; SubTypeValues2.EE0];
    EE2vsEE0Labels = [ones(numel(SubTypeValues1.EE2),1); zeros(numel(SubTypeValues1.EE0),1)];
    EE2vsEE0Value1 = [SubTypeValues1.EE2; SubTypeValues1.EE0];
    EE2vsEE0Value2 = [SubTypeValues2.EE2; SubTypeValues2.EE0];
    
    II1vsII0Labels = [ones(numel(SubTypeValues1.II1),1); zeros(numel(SubTypeValues1.II0),1)];
    II1vsII0Value1 = [SubTypeValues1.II1; SubTypeValues1.II0];
    II1vsII0Value2 = [SubTypeValues2.II1; SubTypeValues2.II0];
    II2vsII0Labels = [ones(numel(SubTypeValues1.II2),1); zeros(numel(SubTypeValues1.II0),1)];
    II2vsII0Value1 = [SubTypeValues1.II2; SubTypeValues1.II0];
    II2vsII0Value2 = [SubTypeValues2.II2; SubTypeValues2.II0];
    
    EIvsEIIE0Labels = [ones(numel(SubTypeValues1.EI),1); zeros(numel(SubTypeValues1.EIIE0),1)];
    EIvsEIIE0Value1 = [SubTypeValues1.EI; SubTypeValues1.EIIE0];
    EIvsEIIE0Value2 = [SubTypeValues2.EI; SubTypeValues2.EIIE0];
    IEvsEIIE0Labels = [ones(numel(SubTypeValues1.IE),1); zeros(numel(SubTypeValues1.EIIE0),1)];
    IEvsEIIE0Value1 = [SubTypeValues1.IE; SubTypeValues1.EIIE0];
    IEvsEIIE0Value2 = [SubTypeValues2.IE; SubTypeValues2.EIIE0];
    
    EIIEvsEIIE0Labels = [ones(numel(SubTypeValues1.EIIE),1); zeros(numel(SubTypeValues1.EIIE0),1)];
    EIIEvsEIIE0Value1 = [SubTypeValues1.EIIE; SubTypeValues1.EIIE0];
    EIIEvsEIIE0Value2 = [SubTypeValues2.EIIE; SubTypeValues2.EIIE0];
    
    
    %%
    ROCs = struct();
    AUROCs = struct();
    
    [tempROC,tempAUROC] = perfcurve2D_radial(EE1vsEE0Labels,EE1vsEE0Value1,EE1vsEE0Value2,nBins);
    ROCs.EE1 = tempROC;
    AUROCs.EE1 = tempAUROC;
    
    [tempROC,tempAUROC] = perfcurve2D_radial(EE2vsEE0Labels,EE2vsEE0Value1,EE2vsEE0Value2,nBins);
    ROCs.EE2 = tempROC;
    AUROCs.EE2 = tempAUROC;
    
    [tempROC,tempAUROC] = perfcurve2D_radial(II1vsII0Labels,II1vsII0Value1,II1vsII0Value2,nBins);
    ROCs.II1 = tempROC;
    AUROCs.II1 = tempAUROC;
    
    [tempROC,tempAUROC] = perfcurve2D_radial(II2vsII0Labels,II2vsII0Value1,II2vsII0Value2,nBins);
    ROCs.II2 = tempROC;
    AUROCs.II2 = tempAUROC;
    
    [tempROC,tempAUROC] = perfcurve2D_radial(EIvsEIIE0Labels,EIvsEIIE0Value1,EIvsEIIE0Value2,nBins);
    ROCs.EI = tempROC;
    AUROCs.EI = tempAUROC;
    
    [tempROC,tempAUROC] = perfcurve2D_radial(IEvsEIIE0Labels,IEvsEIIE0Value1,IEvsEIIE0Value2,nBins);
    ROCs.IE = tempROC;
    AUROCs.IE = tempAUROC;
    
    [tempROC,tempAUROC] = perfcurve2D_radial(EIIEvsEIIE0Labels,EIIEvsEIIE0Value1, ...
                                                                           EIIEvsEIIE0Value2,nBins);
    ROCs.EIIE = tempROC;
    AUROCs.EIIE = tempAUROC;
    
    if (plotROC == true)
        lw = 2;
        fs = 16;
        cols = GetEISubTypeColors;
        
        figure
        plot(ROCs.EE1(1,:),ROCs.EE1(2,:), 'Color',cols{1}, 'Linewidth',lw)
        hold on
        plot(ROCs.EE2(1,:),ROCs.EE2(2,:), 'Color',cols{2}, 'Linewidth',lw)
        plot(ROCs.II1(1,:),ROCs.II1(2,:), 'Color',cols{3}, 'Linewidth',lw)
        plot(ROCs.II2(1,:),ROCs.II2(2,:), 'Color',cols{4}, 'Linewidth',lw)
        plot(ROCs.EI(1,:),ROCs.EI(2,:), 'Color',cols{5}, 'Linewidth',lw)
        plot(ROCs.IE(1,:),ROCs.IE(2,:), 'Color',cols{6}, 'Linewidth',lw)
        plot(ROCs.EIIE(1,:),ROCs.EIIE(2,:), 'Color',cols{7}, 'Linewidth',lw)
        
        box off
        title('2D Radial Classification')
        legendNames = {'$E \rightarrow E$', '$E \leftrightarrow E$', '$I \rightarrow I$', ...
                       '$I \leftrightarrow I$','$I \rightarrow E$','$E \rightarrow I$', ...
                       '$E \leftrightarrow I$'};
        legend(legendNames, 'interpreter','latex')
        set(gca,'LineWidth',lw)
        set(gca,'FontSize',fs)
    end
end

