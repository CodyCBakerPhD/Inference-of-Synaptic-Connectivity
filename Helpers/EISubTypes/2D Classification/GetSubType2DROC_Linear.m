
% no defaults are currently setup
% OptOrients is defined to be the maximal AUROC conditional on orientation.
% OptShifts is the shift value given the optimal orientation which achieves
% ideal level of sparsity pHat
% antiClass is a logical vector for each of the seven subtypes indicating
% the returned optimal shift value needs to be flipped; separate out this complicated shift
% value stuff for other code!

function [AllAUROCs,OptOrients,OptShifts,OptROCs,OptAUROCs] = GetSubType2DROC_Linear(SubTypeValues1,SubTypeValues2,nBins,plotROC)

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
    AllAUROCs = struct();
    OptOrients = struct();
    OptShifts = struct();
    OptROCs = struct();
    OptAUROCs = struct();
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC] = perfcurve2D_linear(...
                                                EE1vsEE0Labels,EE1vsEE0Value1,EE1vsEE0Value2,nBins);
    AllAUROCs.EE1 = tempAllAUROC;
    OptOrients.EE1 = tempOptOrient;
    OptShifts.EE1 = tempOptShift;
    OptROCs.EE1 = tempOptROC;
    OptAUROCs.EE1 = tempOptAUROC;
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC] = perfcurve2D_linear(EE2vsEE0Labels, ...
                                                               EE2vsEE0Value1,EE2vsEE0Value2,nBins);
    AllAUROCs.EE2 = tempAllAUROC;
    OptOrients.EE2 = tempOptOrient;
    OptShifts.EE2 = tempOptShift;
    OptROCs.EE2 = tempOptROC;
    OptAUROCs.EE2 = tempOptAUROC;
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC] = perfcurve2D_linear(II1vsII0Labels, ...
                                                               II1vsII0Value1,II1vsII0Value2,nBins);
    AllAUROCs.II1 = tempAllAUROC;
    OptOrients.II1 = tempOptOrient;
    OptShifts.II1 = tempOptShift;
    OptROCs.II1 = tempOptROC;
    OptAUROCs.II1 = tempOptAUROC;
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC] = perfcurve2D_linear(II2vsII0Labels, ...
                                                               II2vsII0Value1,II2vsII0Value2,nBins);
    AllAUROCs.II2 = tempAllAUROC;
    OptOrients.II2 = tempOptOrient;
    OptShifts.II2 = tempOptShift;
    OptROCs.II2 = tempOptROC;
    OptAUROCs.II2 = tempOptAUROC;
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC] = perfcurve2D_linear(EIvsEIIE0Labels, ...
                                                             EIvsEIIE0Value1,EIvsEIIE0Value2,nBins);
    AllAUROCs.EI = tempAllAUROC;
    OptOrients.EI = tempOptOrient;
    OptShifts.EI = tempOptShift;
    OptROCs.EI = tempOptROC;
    OptAUROCs.EI = tempOptAUROC;
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC,~,~,~,~] = perfcurve2D_linear(IEvsEIIE0Labels, ...
                                                             IEvsEIIE0Value1,IEvsEIIE0Value2,nBins);
    AllAUROCs.IE = tempAllAUROC;
    OptOrients.IE = tempOptOrient;
    OptShifts.IE = tempOptShift;
    OptROCs.IE = tempOptROC;
    OptAUROCs.IE = tempOptAUROC;
    
    [tempAllAUROC,tempOptOrient,tempOptShift,tempOptROC,tempOptAUROC] = perfcurve2D_linear(EIIEvsEIIE0Labels, ...
                                                         EIIEvsEIIE0Value1,EIIEvsEIIE0Value2,nBins);
    AllAUROCs.EIIE = tempAllAUROC;
    OptOrients.EIIE = tempOptOrient;
    OptShifts.EIIE = tempOptShift;
    OptROCs.EIIE = tempOptROC;
    OptAUROCs.EIIE = tempOptAUROC;
    
    if (plotROC == true)
        lw = 2;
        fs = 16;
        cols = GetEISubTypeColors;
        
        figure
        plot(OptROCs.EE1(1,:),OptROCs.EE1(2,:), 'Color',cols{1}, 'Linewidth',lw)
        hold on
        plot(OptROCs.EE2(1,:),OptROCs.EE2(2,:), 'Color',cols{2}, 'Linewidth',lw)
        plot(OptROCs.II1(1,:),OptROCs.II1(2,:), 'Color',cols{3}, 'Linewidth',lw)
        plot(OptROCs.II2(1,:),OptROCs.II2(2,:), 'Color',cols{4}, 'Linewidth',lw)
        plot(OptROCs.EI(1,:),OptROCs.EI(2,:), 'Color',cols{5}, 'Linewidth',lw)
        plot(OptROCs.IE(1,:),OptROCs.IE(2,:), 'Color',cols{6}, 'Linewidth',lw)
        plot(OptROCs.EIIE(1,:),OptROCs.EIIE(2,:), 'Color',cols{7}, 'Linewidth',lw)
        
        box off
        title('2D Linear Classification')
        legendNames = {'$E \rightarrow E$', '$E \leftrightarrow E$', '$I \rightarrow I$', ...
                       '$I \leftrightarrow I$','$I \rightarrow E$','$E \rightarrow I$', ...
                       '$E \leftrightarrow I$'};
        legend(legendNames, 'interpreter','latex')
        set(gca,'LineWidth',lw)
        set(gca,'FontSize',fs)
        
        
        figure
        subplot(2,4,1)
        plot(AllAUROCs.EE1)
        
        subplot(2,4,2)
        plot(AllAUROCs.EE2)
        
        subplot(2,4,3)
        plot(AllAUROCs.II1)
        
        subplot(2,4,4)
        plot(AllAUROCs.II2)
        
        subplot(2,4,5)
        plot(AllAUROCs.EI)
        
        subplot(2,4,6)
        plot(AllAUROCs.IE)
        
        subplot(2,4,7)
        plot(AllAUROCs.EIIE)
    end
    
    
end

