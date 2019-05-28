
% For plotting, figure is assumed to be open

function SubTypeROCs = GetEISubTypeROCs(prec,BiDirIds,plotROC)

    if (nargin == 2)
        plotROC = false;
    end
    
    N = size(prec,1);
    if (N > 5e3)
        nUse = 5e3; % hardcoded for eps output
    else
        nUse = N;
    end
    
    SubTypeValues = GetEISubTypeValues(prec,BiDirIds,nUse);
    
    SubTypeROCs = struct();
    
    if (any(SubTypeValues.EE1))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EE1),1); zeros(numel(SubTypeValues.EE0),1)], ...
                                                                         [SubTypeValues.EE1; SubTypeValues.EE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        EE1vsEE0 = struct();
        EE1vsEE0.X = X;
        EE1vsEE0.Y = Y;
        EE1vsEE0.T = T;
        EE1vsEE0.AUROC = AUROC;
        SubTypeROCs.EE1vsEE0 = EE1vsEE0;
    else
        SubTypeROCs.EE1vsEE0 = [];
    end
    
    if (any(SubTypeValues.EE2))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EE2),1); zeros(numel(SubTypeValues.EE0),1)], ...
                                                                         [SubTypeValues.EE2; SubTypeValues.EE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        EE2vsEE0 = struct();
        EE2vsEE0.X = X;
        EE2vsEE0.Y = Y;
        EE2vsEE0.T = T;
        EE2vsEE0.AUROC = AUROC;
        SubTypeROCs.EE2vsEE0 = EE2vsEE0;
    else
        SubTypeROCs.EE2vsEE0 = [];
    end
    
    if (any(SubTypeValues.EE2))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EE2),1); zeros(numel(SubTypeValues.EE1),1)], ...
                                                                         [SubTypeValues.EE2; SubTypeValues.EE1],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        EE2vsEE1 = struct();
        EE2vsEE1.X = X;
        EE2vsEE1.Y = Y;
        EE2vsEE1.T = T;
        EE2vsEE1.AUROC = AUROC;
        SubTypeROCs.EE2vsEE1 = EE2vsEE1;
    else
        SubTypeROCs.EE2vsEE1 = [];
    end
    
    if (any(SubTypeValues.II1))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.II1),1); zeros(numel(SubTypeValues.II0),1)], ...
                                                                         [SubTypeValues.II1; SubTypeValues.II0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        II1vsII0 = struct();
        II1vsII0.X = X;
        II1vsII0.Y = Y;
        II1vsII0.T = T;
        II1vsII0.AUROC = AUROC;
        SubTypeROCs.II1vsII0 = II1vsII0;
    else
        SubTypeROCs.II1vsII0 = [];
    end
    
    if (any(SubTypeValues.II2))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.II2),1); zeros(numel(SubTypeValues.II0),1)], ...
                                                                         [SubTypeValues.II2; SubTypeValues.II0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        II2vsII0 = struct();
        II2vsII0.X = X;
        II2vsII0.Y = Y;
        II2vsII0.T = T;
        II2vsII0.AUROC = AUROC;
        SubTypeROCs.II2vsII0 = II2vsII0;
    else
        SubTypeROCs.II2vsII0 = [];
    end
    
    if (any(SubTypeValues.II2))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.II2),1); zeros(numel(SubTypeValues.II1),1)], ...
                                                                         [SubTypeValues.II2; SubTypeValues.II1],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        II2vsII1 = struct();
        II2vsII1.X = X;
        II2vsII1.Y = Y;
        II2vsII1.T = T;
        II2vsII1.AUROC = AUROC;
        SubTypeROCs.II2vsII1 = II2vsII1;
    else
        SubTypeROCs.II2vsII1 = [];
    end
    
    if (any(SubTypeValues.EI))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EI),1); zeros(numel(SubTypeValues.EIIE0),1)], ...
                                                                        [SubTypeValues.EI; SubTypeValues.EIIE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        EIvsEIIE0 = struct();
        EIvsEIIE0.X = X;
        EIvsEIIE0.Y = Y;
        EIvsEIIE0.T = T;
        EIvsEIIE0.AUROC = AUROC;
        SubTypeROCs.EIvsEIIE0 = EIvsEIIE0;
    else
        SubTypeROCs.EIvsEIIE0 = [];
    end
    
    if (any(SubTypeValues.IE))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.IE),1); zeros(numel(SubTypeValues.EIIE0),1)], ...
                                                                        [SubTypeValues.IE; SubTypeValues.EIIE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        IEvsEIIE0 = struct();
        IEvsEIIE0.X = X;
        IEvsEIIE0.Y = Y;
        IEvsEIIE0.T = T;
        IEvsEIIE0.AUROC = AUROC;
        SubTypeROCs.IEvsEIIE0 = IEvsEIIE0;
    else
        SubTypeROCs.IEvsEIIE0 = [];
    end
    
    if (any(SubTypeValues.EIIE))
        [X,Y,T,AUROC] = perfcurve([ones(numel(SubTypeValues.EIIE),1); zeros(numel(SubTypeValues.EIIE0),1)], ...
                                                                      [SubTypeValues.EIIE; SubTypeValues.EIIE0],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        EIIEvsEIIE0 = struct();
        EIIEvsEIIE0.X = X;
        EIIEvsEIIE0.Y = Y;
        EIIEvsEIIE0.T = T;
        EIIEvsEIIE0.AUROC = AUROC;
        SubTypeROCs.EIIEvsEIIE0 = EIIEvsEIIE0;
    else
        SubTypeROCs.EIIEvsEIIE0 = [];
    end
    
    
    
    lw = 2;
    fz = 16;
    
    if (plotROC == true)
        
        figure
        legendNames = cell(1,1); ii = 1;
        Colors = {[0 0.6 0], ... % EE1
                  [0 0.8 0], ... % EE2
                  [0.3010 0.7450 0.9330], ... % IE
                  [0.6 0 0], ... % II1
                  [0.8 0 0], ... % II2
                  [0.4940 0.1840 0.5560], ... % EI
                  [0 0.4470 0.7410]}; % EIIE
        
        if (isstruct(SubTypeROCs.EE1vsEE0))
            plot(SubTypeROCs.EE1vsEE0.X,SubTypeROCs.EE1vsEE0.Y, 'Linewidth',lw, 'Color',Colors{1})
            hold on
            legendNames{ii} = 'e $\rightarrow$ e'; ii = ii + 1;
        end
        
        if (isstruct(SubTypeROCs.EE2vsEE0))
            plot(SubTypeROCs.EE2vsEE0.X,SubTypeROCs.EE2vsEE0.Y, 'Linewidth',lw, 'Color',Colors{2})
            hold on
            legendNames{ii} = 'e $\leftrightarrow$ e'; ii = ii + 1;
        end
        
        if (isstruct(SubTypeROCs.IEvsEIIE0))
            plot(SubTypeROCs.IEvsEIIE0.X,SubTypeROCs.IEvsEIIE0.Y, 'Linewidth',lw, 'Color',Colors{3})
            hold on
            legendNames{ii} = 'e $\rightarrow$ i'; ii = ii + 1;
        end
        
        if (isstruct(SubTypeROCs.II1vsII0))
            plot(SubTypeROCs.II1vsII0.X,SubTypeROCs.II1vsII0.Y, 'Linewidth',lw, 'Color',Colors{4})
            hold on
            legendNames{ii} = 'i $\rightarrow$ i'; ii = ii + 1;
        end
        
        if (isstruct(SubTypeROCs.II2vsII0))
            plot(SubTypeROCs.II2vsII0.X,SubTypeROCs.II2vsII0.Y, 'Linewidth',lw, 'Color',Colors{5})
            hold on
            legendNames{ii} = 'i $\leftrightarrow$ i'; ii = ii + 1;
        end
        
        if (isstruct(SubTypeROCs.EIvsEIIE0))
            plot(SubTypeROCs.EIvsEIIE0.X,SubTypeROCs.EIvsEIIE0.Y, 'Linewidth',lw, 'Color',Colors{6})
            hold on
            legendNames{ii} = 'i $\rightarrow$ e'; ii = ii + 1;
        end
        
        if (isstruct(SubTypeROCs.EIIEvsEIIE0))
            plot(SubTypeROCs.EIIEvsEIIE0.X,SubTypeROCs.EIIEvsEIIE0.Y, 'Linewidth',lw, 'Color',Colors{7})
            hold on
            legendNames{ii} = 'e $\leftrightarrow$ i'; ii = ii + 1;
        end
        
        plot(0:1,0:1, 'r--', 'Linewidth',lw)
        box off
        title('Subtypes vs. Null Groups')
        legend(legendNames, 'interpreter','latex')
        set(gca,'LineWidth',lw)
        set(gca,'FontSize',fz)
    end
end

