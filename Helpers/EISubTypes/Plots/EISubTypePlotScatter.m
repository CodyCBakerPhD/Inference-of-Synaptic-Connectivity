
% Does not assume figure is open

function EISubTypePlotScatter(Value,Measure,BiDirIds,Colors)
    
    if (nargin == 3) % Colors not passed
        Colors = GetEISubTypeColors;
    end
    
    N = size(Value,1);
    if (N > 230)
        nPlot = 230; % hardcoded for eps output
    else
        nPlot = N;
    end
    
    [SubTypeValue,inds] = GetEISubTypeValues(Value,BiDirIds,nPlot);
    SubTypeMeasure = GetEISubTypeValues(Measure,BiDirIds,inds);
    
    
    
    % Plot
    lw = 2;
    fs = 16;
    
    figure
    legendNames = cell(1,1); ii = 1;
    handles = [];

    if(~isempty( SubTypeMeasure.EE0 ))
        subplot(1,3,1)
        h1 = plot(SubTypeValue.EE0,SubTypeMeasure.EE0, 'k.');
        hold on
        legendNames{ii} = '$e,i \not\rightarrow e,i$';
        handles(ii) = h1;
        ii = ii + 1;
    end
    
    if(~isempty( SubTypeMeasure.EE1 ))
        subplot(1,3,1)
        h2 = plot(SubTypeValue.EE1,SubTypeMeasure.EE1, '.', 'Color',Colors{1});
        hold on
        legendNames{ii} = '$e \rightarrow e$';
        handles(ii) = h2;
        ii = ii + 1;
    end
    
    if(~isempty( SubTypeMeasure.EE2 ))
        subplot(1,3,1)
        h3 = plot(SubTypeValue.EE2,SubTypeMeasure.EE2, '.', 'Color',Colors{2});
        hold on
        legendNames{ii} = '$e \leftrightarrow e$';
        handles(ii) = h3;
        ii = ii + 1;
    end
    
    axis([-0.1*SubTypeMeasure.EE2(1) Inf -Inf Inf])
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    if(~isempty( SubTypeMeasure.II0 ))
        subplot(1,3,2)
        plot(SubTypeValue.II0,SubTypeMeasure.II0, 'k.');
        hold on
    end
    
    if(~isempty( SubTypeMeasure.II1 ))
        subplot(1,3,2)
        h5 = plot(SubTypeValue.II1,SubTypeMeasure.II1, '.', 'Color',Colors{4});
        hold on
        legendNames{ii} = '$i \rightarrow i$';
        handles(ii) = h5;
        ii = ii + 1;
    end
    
    if(~isempty( SubTypeMeasure.II2 ))
        subplot(1,3,2)
        h6 = plot(SubTypeValue.II2,SubTypeMeasure.II2, '.', 'Color',Colors{5});
        hold on
        legendNames{ii} = '$i \leftrightarrow i$';
        handles(ii) = h6;
        ii = ii + 1;
    end
    
    axis([-Inf 0.1*abs(SubTypeMeasure.II2(1)) -Inf Inf])
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    if(~isempty( SubTypeMeasure.EIIE0 ))
        subplot(1,3,3)
        plot(SubTypeValue.EIIE0,SubTypeMeasure.EIIE0, 'k.');
        hold on
    end
    
    if(~isempty( SubTypeMeasure.EI ))
        subplot(1,3,3)
        h8 = plot(SubTypeValue.EI,SubTypeMeasure.EI, '.', 'Color',Colors{3});
        hold on
        legendNames{ii} = '$e \rightarrow i$';
        handles(ii) = h8;
        ii = ii + 1;
    end
    
    if(~isempty( SubTypeMeasure.IE ))
        subplot(1,3,3)
        h9 = plot(SubTypeValue.IE,SubTypeMeasure.IE, '.', 'Color',Colors{6});
        hold on
        legendNames{ii} = '$i \rightarrow e$';
        handles(ii) = h9;
        ii = ii + 1;
    end
    
    if(~isempty( SubTypeMeasure.EIIE ))
        subplot(1,3,3)
        h10 = plot(SubTypeValue.EIIE,SubTypeMeasure.EIIE, '.', 'Color',Colors{7});
        hold on
        legendNames{ii} = '$e \leftrightarrow i$';
        handles(ii) = h10;
        ii = ii + 1;
    end
    
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    [~,objh] = legend(handles,legendNames, 'interpreter','latex', 'orientation','horizontal');
    objhl = findobj(objh, 'type', 'line'); %// objects of legend of type line
    set(objhl, 'Markersize', 30);
end

