
% For plotting, figure is assumed to be open

function TypeROCs = GetEITypeROCs(prec,BiDirIds,plotROC,AbsOnCross)

    if (nargin == 2)
        plotROC = false;
    end
    
    if (nargin == 3)
        AbsOnCross = false;
    end
    
    N = size(prec,1);
    if (N > 5e3)
        nUse = 5e3; % hardcoded for eps output
    else
        nUse = N;
    end
    
    SubTypeValues = GetEITypeValues(prec,BiDirIds,nUse);
    
    TypeROCs = struct();
    
    if (any(SubTypeValues.EEConn))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EEConn),1); ...
                                   zeros(numel(SubTypeValues.EE0),1)], ...
                                                       [SubTypeValues.EEConn; SubTypeValues.EE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        E = struct();
        E.X = X;
        E.Y = Y;
        E.T = T;
        E.AUROC = AUROC;
        TypeROCs.E = E;
    else
        TypeROCs.E = [];
    end
    
    if (any(SubTypeValues.IIConn))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.IIConn),1); ...
                                   zeros(numel(SubTypeValues.II0),1)], ...
                                                       [SubTypeValues.IIConn; SubTypeValues.II0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        I = struct();
        I.X = X;
        I.Y = Y;
        I.T = T;
        I.AUROC = AUROC;
        TypeROCs.I = I;
    else
        TypeROCs.I = [];
    end
    
    if (any(SubTypeValues.EIConn))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EIConn),1); ...
                                   zeros(numel(SubTypeValues.EIIE0),1)], ...
                                                     [SubTypeValues.EIConn; SubTypeValues.EIIE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        EI = struct();
        EI.X = X;
        EI.Y = Y;
        EI.T = T;
        EI.AUROC = AUROC;
        TypeROCs.EI = EI;
        
        if (AbsOnCross)
            tempData = [SubTypeValues.EIConn; SubTypeValues.EIIE0];
            [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EIConn),1); ...
                                   zeros(numel(SubTypeValues.EIIE0),1)], ...
                                                     abs(tempData - mean(tempData)),1);
            clear tempData
            if (AUROC < 0.5)
                X = 1 - X;
                Y = 1 - Y;
                AUROC = 1 - AUROC;
            end
            EIAbs = struct();
            EIAbs.X = X;
            EIAbs.Y = Y;
            EIAbs.T = T;
            EIAbs.AUROC = AUROC;
            TypeROCs.EIAbs = EIAbs;
        end
    else
        TypeROCs.EI = [];
        
        if (AbsOnCross)
            TypeROCs.EIAbs = [];
        end
    end
    
    lw = 2;
    fz = 16;
    
    if (plotROC == true)
        
        figure
        legendNames = cell(1,1); ii = 1;
        Colors = {[0 0.7 0], ... % E
                  [0.7 0 0], ... % I
                  [0.4940 0.1840 0.5560]}; % EI
        
        if (isstruct(TypeROCs.E))
            plot(TypeROCs.E.X,TypeROCs.E.Y, 'Linewidth',lw, 'Color',Colors{1})
            hold on
            legendNames{ii} = 'Exc.'; ii = ii + 1;
        end
        
        if (isstruct(TypeROCs.I))
            plot(TypeROCs.I.X,TypeROCs.I.Y, 'Linewidth',lw, 'Color',Colors{2})
            hold on
            legendNames{ii} = 'Inh.'; ii = ii + 1;
        end
        
        if (isstruct(TypeROCs.EI))
            plot(TypeROCs.EI.X,TypeROCs.EI.Y, 'Linewidth',lw, 'Color',Colors{3})
            hold on
            legendNames{ii} = 'Cross'; ii = ii + 1;
        end
        
        if (isstruct(TypeROCs.EIAbs))
            plot(TypeROCs.EIAbs.X,TypeROCs.EIAbs.Y, ':', 'Linewidth',lw, 'Color',Colors{3})
            hold on
            legendNames{ii} = 'Cross-Abs'; ii = ii + 1;
        end
        
        plot(0:1,0:1, 'r--', 'Linewidth',lw)
        box off
        title('Types vs. Null Groups')
        %legend(legendNames, 'interpreter','latex')
        set(gca,'LineWidth',lw)
        set(gca,'FontSize',fz)
    end
end

