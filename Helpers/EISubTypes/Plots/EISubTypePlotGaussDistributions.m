
% Does not assume figure is open

function EISubTypePlotGaussDistributions(Measure,BiDirIds,Colors)
    
    if (nargin == 2) % Colors not passed
        Colors = {[0 0.6 0], ... % EE1
                  [0 0.8 0], ... % EE2
                  [0.3010 0.7450 0.9330], ... % IE
                  [0.6 0 0], ... % II1
                  [0.8 0 0], ... % II2
                  [0.4940 0.1840 0.5560], ... % EI
                  [0 0.4470 0.7410]}; % EIIE
    end
    
    SubTypeMeans = GetEISubTypeMeans(Measure,BiDirIds);
    SubTypeStds = GetEISubTypeStds(Measure,BiDirIds);
    
    % Plot
    lw = 2;
    fz = 16;
    
    numIncr = 1e3;
    
    figure
    legendNames = cell(1,1); ii = 1;
    handles = [];
    
    % assumes EE2 has elements...
    XX_EE = linspace(SubTypeMeans.EE0-5*SubTypeStds.EE0, SubTypeMeans.EE2+5*SubTypeStds.EE2, numIncr);
    
    % assumes II2 has elements...
    XX_II = linspace(SubTypeMeans.II2-5*SubTypeStds.II2, SubTypeMeans.II0+5*SubTypeStds.II0, numIncr);
    
    % assumes EE2 has elements...
    XX_EIIE = linspace(SubTypeMeans.EI-5*SubTypeStds.EI, SubTypeMeans.IE+5*SubTypeStds.IE, numIncr);

    if(any( SubTypeMeans.EE0 ))
        EE0Gauss = normpdf(XX_EE,SubTypeMeans.EE0,SubTypeStds.EE0);
        
        subplot(1,3,1)
        h1 = plot(XX_EE,EE0Gauss, 'k', 'Linewidth',lw);
        hold on
        legendNames{ii} = 'e,i $\not\rightarrow$ e,i';
        handles(ii) = h1;
        ii = ii + 1;
    end
    
    if(any( SubTypeMeans.EE1 ))
        EE1Gauss = normpdf(XX_EE,SubTypeMeans.EE1,SubTypeStds.EE1);
        
        subplot(1,3,1)
        h2 = plot(XX_EE,EE1Gauss, 'Color',Colors{1}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'e $\rightarrow$ e';
        handles(ii) = h2;
        ii = ii + 1;
    end
    
    if(any( SubTypeMeans.EE2 ))
        EE2Gauss = normpdf(XX_EE,SubTypeMeans.EE2,SubTypeStds.EE2);
        
        subplot(1,3,1)
        h3 = plot(XX_EE,EE2Gauss, 'Color',Colors{2}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'e $\leftrightarrow$ e';
        handles(ii) = h3;
        ii = ii + 1;
    end
    
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fz)
    
    if(any( SubTypeMeans.II0 ))
        II0Gauss = normpdf(XX_II,SubTypeMeans.II0,SubTypeStds.II0);
        
        subplot(1,3,2)
        plot(XX_II,II0Gauss, 'k', 'Linewidth',lw);
        hold on
    end
    
    if(any( SubTypeMeans.II1 ))
        II1Gauss = normpdf(XX_II,SubTypeMeans.II1,SubTypeStds.II1);
        
        subplot(1,3,2)
        h5 = plot(XX_II,II1Gauss, 'Color',Colors{4}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'i $\rightarrow$ i';
        handles(ii) = h5;
        ii = ii + 1;
    end
    
    if(any( SubTypeMeans.II2 ))
        II2Gauss = normpdf(XX_II,SubTypeMeans.II2,SubTypeStds.II2);
        
        subplot(1,3,2)
        h6 = plot(XX_II,II2Gauss, 'Color',Colors{5}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'i $\leftrightarrow$ i';
        handles(ii) = h6;
        ii = ii + 1;
    end
    
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fz)
    
    if(any( SubTypeMeans.EIIE0 ))
        EIIE0Gauss = normpdf(XX_EIIE,SubTypeMeans.EIIE0,SubTypeStds.EIIE0);
        
        subplot(1,3,3)
        plot(XX_EIIE,EIIE0Gauss, 'k', 'Linewidth',lw);
        hold on
    end
    
    if(any( SubTypeMeans.EI ))
        EIGauss = normpdf(XX_EIIE,SubTypeMeans.EI,SubTypeStds.EI);
        
        subplot(1,3,3)
        h8 = plot(XX_EIIE,EIGauss, 'Color',Colors{3}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'e $\rightarrow$ i';
        handles(ii) = h8;
        ii = ii + 1;
    end
    
    if(any( SubTypeMeans.IE ))
        IEGauss = normpdf(XX_EIIE,SubTypeMeans.IE,SubTypeStds.IE);
        
        subplot(1,3,3)
        h9 = plot(XX_EIIE,IEGauss, 'Color',Colors{6}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'i $\rightarrow$ e';
        handles(ii) = h9;
        ii = ii + 1;
    end
    
    if(any( SubTypeMeans.EIIE ))
        EIIEGauss = normpdf(XX_EIIE,SubTypeMeans.EIIE,SubTypeStds.EIIE);
        
        subplot(1,3,3)
        h10 = plot(XX_EIIE,EIIEGauss, 'Color',Colors{7}, 'Linewidth',lw);
        hold on
        legendNames{ii} = 'e $\leftrightarrow$ i';
        handles(ii) = h10;
        ii = ii + 1;
    end
    
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fz)
    
    [~,objh] = legend(handles,legendNames, 'interpreter','latex', 'orientation','horizontal');
    objhl = findobj(objh, 'type', 'line'); %// objects of legend of type line
    set(objhl, 'Markersize', 30);
end

