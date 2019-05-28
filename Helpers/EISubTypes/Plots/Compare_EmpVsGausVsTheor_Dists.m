
function EmpDens = Compare_EmpVsGausVsTheor_Dists(SubTypeValues,SubTypeMeans, ...
                                                     SubTypeStds,SubTypeTheorMeans,SubTypeTheorStds)
    
    %% Get Kernel Densitiy Estimates as well as a Guassian with the empirical mean/std
    %  then a theoretical Guassian
    [YY_EE0,XX_EE0] = ksdensity(SubTypeValues.EE0);
    gaus_est_EE0 = normpdf(XX_EE0,SubTypeMeans.EE0,SubTypeStds.EE0);
    gaus_theor_EE0 = normpdf(XX_EE0,SubTypeTheorMeans.EE0,SubTypeTheorStds.EE0);

    [YY_EE1,XX_EE1] = ksdensity(SubTypeValues.EE1);
    gaus_est_EE1 = normpdf(XX_EE1,SubTypeMeans.EE1,SubTypeStds.EE1);
    gaus_theor_EE1 = normpdf(XX_EE1,SubTypeTheorMeans.EE1,SubTypeTheorStds.EE1);
    
    [YY_EE2,XX_EE2] = ksdensity(SubTypeValues.EE2);
    gaus_est_EE2 = normpdf(XX_EE2,SubTypeMeans.EE2,SubTypeStds.EE2);
    gaus_theor_EE2 = normpdf(XX_EE2,SubTypeTheorMeans.EE2,SubTypeTheorStds.EE2);
    
    [YY_II0,XX_II0] = ksdensity(SubTypeValues.II0);
    gaus_est_II0 = normpdf(XX_II0,SubTypeMeans.II0,SubTypeStds.II0);
    gaus_theor_II0 = normpdf(XX_II0,SubTypeTheorMeans.II0,SubTypeTheorStds.II0);

    [YY_II1,XX_II1] = ksdensity(SubTypeValues.II1);
    gaus_est_II1 = normpdf(XX_II1,SubTypeMeans.II1,SubTypeStds.II1);
    gaus_theor_II1 = normpdf(XX_II1,SubTypeTheorMeans.II1,SubTypeTheorStds.II1);
    
    [YY_II2,XX_II2] = ksdensity(SubTypeValues.II2);
    gaus_est_II2 = normpdf(XX_II2,SubTypeMeans.II2,SubTypeStds.II2);
    gaus_theor_II2 = normpdf(XX_II2,SubTypeTheorMeans.II2,SubTypeTheorStds.II2);
    
    [YY_EIIE0,XX_EIIE0] = ksdensity(SubTypeValues.EIIE0);
    gaus_est_EIIE0 = normpdf(XX_EIIE0,SubTypeMeans.EIIE0,SubTypeStds.EIIE0);
    gaus_theor_EIIE0 = normpdf(XX_EIIE0,SubTypeTheorMeans.EIIE0,SubTypeTheorStds.EIIE0);
    
    [YY_EI,XX_EI] = ksdensity(SubTypeValues.EI);
    gaus_est_EI = normpdf(XX_EI,SubTypeMeans.EI,SubTypeStds.EI);
    gaus_theor_EI = normpdf(XX_EI,SubTypeTheorMeans.EI,SubTypeTheorStds.EI);
    
    [YY_IE,XX_IE] = ksdensity(SubTypeValues.IE);
    gaus_est_IE = normpdf(XX_IE,SubTypeMeans.IE,SubTypeStds.IE);
    gaus_theor_IE = normpdf(XX_IE,SubTypeTheorMeans.IE,SubTypeTheorStds.IE);
    
    [YY_EIIE,XX_EIIE] = ksdensity(SubTypeValues.EIIE);
    gaus_est_EIIE = normpdf(XX_EIIE,SubTypeMeans.EIIE,SubTypeStds.EIIE);
    gaus_theor_EIIE = normpdf(XX_EIIE,SubTypeTheorMeans.EIIE,SubTypeTheorStds.EIIE);
    
    
    %% Plot Distributions
    lw = 2;
    fs = 16;
    
    Colors = {[0 0.6 0], ... % EE1
          [0 0.8 0], ... % EE2
          [0.3010 0.7450 0.9330], ... % IE
          [0.6 0 0], ... % II1
          [0.8 0 0], ... % II2
          [0.4940 0.1840 0.5560], ... % EI
          [0 0.4470 0.7410]}; % EIIE
              
    set(0,'defaulttextinterpreter','latex')
    figure
    subplot(2,4,1)
    plot(XX_EE0,YY_EE0, 'k', 'Linewidth',lw)
    hold on
    plot(XX_EE0,gaus_est_EE0, '--', 'Linewidth',lw, 'Color',[0 0 0.2])
    plot(XX_EE0,gaus_theor_EE0, ':', 'Linewidth',lw, 'Color',[0 0 0.4])
    title('e $\not\rightarrow$ e - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,2)
    plot(XX_EE1,YY_EE1, 'Linewidth',lw, 'Color',Colors{1})
    hold on
    plot(XX_EE1,gaus_est_EE1, '--', 'Linewidth',lw, 'Color',Colors{1})
    plot(XX_EE1,gaus_theor_EE1, ':', 'Linewidth',lw, 'Color',Colors{1})
    title('e $\rightarrow$ e - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,3)
    plot(XX_EE2,YY_EE2, 'k', 'Linewidth',lw, 'Color',Colors{2})
    hold on
    plot(XX_EE2,gaus_est_EE2, '--', 'Linewidth',lw, 'Color',Colors{2})
    plot(XX_EE2,gaus_theor_EE2, ':', 'Linewidth',lw, 'Color',Colors{2})
    title('e $\leftrightarrow$ e - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,4)
    plot(XX_EE0,YY_EE0, 'k', 'Linewidth',lw)
    hold on
    plot(XX_EE1,YY_EE1, 'Linewidth',lw, 'Color',Colors{1})
    plot(XX_EE2,YY_EE2, 'Linewidth',lw, 'Color',Colors{2})
    title('Excitatory - Empirical')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,5)
    plot(XX_II0,YY_II0, 'k', 'Linewidth',lw)
    hold on
    plot(XX_II0,gaus_est_II0, '--', 'Linewidth',lw, 'Color',[0 0 0.2])
    plot(XX_II0,gaus_theor_II0, ':', 'Linewidth',lw, 'Color',[0 0 0.4])
    title('i $\not\rightarrow$ i - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,6)
    plot(XX_II1,YY_II1, 'Linewidth',lw, 'Color',Colors{4})
    hold on
    plot(XX_II1,gaus_est_II1, '--', 'Linewidth',lw, 'Color',Colors{4})
    plot(XX_II1,gaus_theor_II1, ':', 'Linewidth',lw, 'Color',Colors{4})
    title('i $\rightarrow$ i - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,7)
    plot(XX_II2,YY_II2, 'k', 'Linewidth',lw, 'Color',Colors{5})
    hold on
    plot(XX_II2,gaus_est_II2, '--', 'Linewidth',lw, 'Color',Colors{5})
    plot(XX_II2,gaus_theor_II2, ':', 'Linewidth',lw, 'Color',Colors{5})
    title('i $\leftrightarrow$ i - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,4,8)
    plot(XX_II0,YY_II0, 'k', 'Linewidth',lw)
    hold on
    plot(XX_II1,YY_II1, 'Linewidth',lw, 'Color',Colors{4})
    plot(XX_II2,YY_II2, 'Linewidth',lw, 'Color',Colors{5})
    title('Inhibitory - Empirical')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    
    figure
    subplot(2,3,1)
    plot(XX_EIIE0,YY_EIIE0, 'k', 'Linewidth',lw)
    hold on
    plot(XX_EIIE0,gaus_est_EIIE0, '--', 'Linewidth',lw, 'Color',[0 0 0.2])
    plot(XX_EIIE0,gaus_theor_EIIE0, ':', 'Linewidth',lw, 'Color',[0 0 0.4])
    title('e $\not\rightarrow$ i - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,3,2)
    plot(XX_EI,YY_EI, 'Linewidth',lw, 'Color',Colors{6})
    hold on
    plot(XX_EI,gaus_est_EI, '--', 'Linewidth',lw, 'Color',Colors{6})
    plot(XX_EI,gaus_theor_EI, ':', 'Linewidth',lw, 'Color',Colors{6})
    title('i $\rightarrow$ e - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,3,4)
    plot(XX_IE,YY_IE, 'Linewidth',lw, 'Color',Colors{3})
    hold on
    plot(XX_IE,gaus_est_IE, '--', 'Linewidth',lw, 'Color',Colors{3})
    plot(XX_IE,gaus_theor_IE, ':', 'Linewidth',lw, 'Color',Colors{3})
    title('e $\rightarrow$ i - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,3,5)
    plot(XX_EIIE,YY_EIIE, 'Linewidth',lw, 'Color',Colors{1})
    hold on
    plot(XX_EIIE,gaus_est_EIIE, '--', 'Linewidth',lw, 'Color',Colors{1})
    plot(XX_EIIE,gaus_theor_EIIE, ':', 'Linewidth',lw, 'Color',Colors{1})
    title('e $\leftrightarrow$ i - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    subplot(2,3,6)
    plot(XX_EIIE0,YY_EIIE0, 'k', 'Linewidth',lw)
    hold on
    plot(XX_EI,YY_EI, 'Linewidth',lw, 'Color',Colors{6})
    plot(XX_IE,YY_IE, 'Linewidth',lw, 'Color',Colors{3})
    plot(XX_EIIE,YY_EIIE, 'Linewidth',lw, 'Color',Colors{7})
    title('Mixed - All')
    box off
    set(gca,'LineWidth',lw)
    set(gca,'FontSize',fs)
    
    
    %% Fill return struct
    EmpDens = struct();
    EmpDens.EE0 = [XX_EE0,YY_EE0];
    EmpDens.EE1 = [XX_EE1,YY_EE1];
    EmpDens.EE2 = [XX_EE2,YY_EE2];
    EmpDens.II0 = [XX_II0,YY_II0];
    EmpDens.II1 = [XX_II1,YY_II1];
    EmpDens.II2 = [XX_II2,YY_II2];
    EmpDens.EIIE0 = [XX_EIIE0,YY_EIIE0];
    EmpDens.EI = [XX_EI,YY_EI];
    EmpDens.IE = [XX_IE,YY_IE];
    EmpDens.EIIE = [XX_EIIE,YY_EIIE];
end

