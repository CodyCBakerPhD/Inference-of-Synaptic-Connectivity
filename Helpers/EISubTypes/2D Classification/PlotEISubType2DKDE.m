
% nPoints specifies discretization of square grid

function PlotEISubType2DKDE(SubTypeValues1,SubTypeValues2,nPoints)
    
    %% Combine partitions
    EE_Value1 = [SubTypeValues1.EE2; SubTypeValues1.EE1; SubTypeValues1.EE0];
    EE_Value2 = [SubTypeValues2.EE2; SubTypeValues2.EE1; SubTypeValues2.EE0];
    
    II_Value1 = [SubTypeValues1.II2; SubTypeValues1.II1; SubTypeValues1.II0];
    II_Value2 = [SubTypeValues2.II2; SubTypeValues2.II1; SubTypeValues2.II0];
    
    EI_Value1 = [SubTypeValues1.EIIE; SubTypeValues1.EI; SubTypeValues1.IE; SubTypeValues1.EIIE0];
    EI_Value2 = [SubTypeValues2.EIIE; SubTypeValues2.EI; SubTypeValues2.IE; SubTypeValues2.EIIE0];
    
    EE1vsEE0Value1 = [SubTypeValues1.EE1; SubTypeValues1.EE0];
    EE1vsEE0Value2 = [SubTypeValues2.EE1; SubTypeValues2.EE0];
    EE2vsEE0Value1 = [SubTypeValues1.EE2; SubTypeValues1.EE0];
    EE2vsEE0Value2 = [SubTypeValues2.EE2; SubTypeValues2.EE0];
    
    II1vsII0Value1 = [SubTypeValues1.II1; SubTypeValues1.II0];
    II1vsII0Value2 = [SubTypeValues2.II1; SubTypeValues2.II0];
    II2vsII0Value1 = [SubTypeValues1.II2; SubTypeValues1.II0];
    II2vsII0Value2 = [SubTypeValues2.II2; SubTypeValues2.II0];
    
    EIvsEIIE0Value1 = [SubTypeValues1.EI; SubTypeValues1.EIIE0];
    EIvsEIIE0Value2 = [SubTypeValues2.EI; SubTypeValues2.EIIE0];
    IEvsEIIE0Value1 = [SubTypeValues1.IE; SubTypeValues1.EIIE0];
    IEvsEIIE0Value2 = [SubTypeValues2.IE; SubTypeValues2.EIIE0];
    
    EIIEvsEIIE0Value1 = [SubTypeValues1.EIIE; SubTypeValues1.EIIE0];
    EIIEvsEIIE0Value2 = [SubTypeValues2.EIIE; SubTypeValues2.EIIE0];
    
    
    %% Get shared grids
    gridx1 = linspace(min(EE_Value1),max(EE_Value1),nPoints);
    gridx2 = linspace(min(EE_Value2),max(EE_Value2),nPoints);
    [x1,x2] = meshgrid(gridx1, gridx2);
    x1 = x1(:);
    x2 = x2(:);
    EE_pts = [x1 x2];
    
    gridx1 = linspace(min(II_Value1),max(II_Value1),nPoints);
    gridx2 = linspace(min(II_Value2),max(II_Value2),nPoints);
    [x1,x2] = meshgrid(gridx1, gridx2);
    x1 = x1(:);
    x2 = x2(:);
    II_pts = [x1 x2];
    
    gridx1 = linspace(min(EI_Value1),max(EI_Value1),nPoints);
    gridx2 = linspace(min(EI_Value2),max(EI_Value2),nPoints);
    [x1,x2] = meshgrid(gridx1, gridx2);
    x1 = x1(:);
    x2 = x2(:);
    EI_pts = [x1 x2];
    
    
    %% Get KDEs
    EE_unlab_2DKDE = ksdensity([EE_Value1 EE_Value2], EE_pts);
    EE0_2DKDE = ksdensity([SubTypeValues1.EE0 SubTypeValues2.EE0], EE_pts);
    EE1_2DKDE = ksdensity([SubTypeValues1.EE1 SubTypeValues2.EE1], EE_pts);
    EE2_2DKDE = ksdensity([SubTypeValues1.EE2 SubTypeValues2.EE2], EE_pts);
    
    II_unlab_2DKDE = ksdensity([II_Value1 II_Value2], II_pts);
    II0_2DKDE = ksdensity([SubTypeValues1.II0 SubTypeValues2.II0], II_pts);
    II1_2DKDE = ksdensity([SubTypeValues1.II1 SubTypeValues2.II1], II_pts);
    II2_2DKDE = ksdensity([SubTypeValues1.II2 SubTypeValues2.II2], II_pts);
    
    EI_unlab_2DKDE = ksdensity([EI_Value1 EI_Value2], EI_pts);
    EIIE0_2DKDE = ksdensity([SubTypeValues1.EIIE0 SubTypeValues2.EIIE0], EI_pts);
    EI_2DKDE = ksdensity([SubTypeValues1.EI SubTypeValues2.EI], EI_pts);
    IE_2DKDE = ksdensity([SubTypeValues1.IE SubTypeValues2.IE], EI_pts);
    EIIE_2DKDE = ksdensity([SubTypeValues1.EIIE SubTypeValues2.EIIE], EI_pts);
    
    
    %% Plot
    set(0,'defaulttextInterpreter','latex')
    
    figure
    subplot(3,4,1)
    imagesc(EE_pts(:,1),EE_pts(:,2),reshape(EE_unlab_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('EE - Unlabeled')
    
    subplot(3,4,2)
    imagesc(EE_pts(:,1),EE_pts(:,2),reshape(EE1_2DKDE - EE0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$E \rightarrow E$')
    
    subplot(3,4,3)
    imagesc(EE_pts(:,1),EE_pts(:,2),reshape(EE2_2DKDE - EE0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$E \leftrightarrow E$')
    
    subplot(3,4,5)
    imagesc(II_pts(:,1),II_pts(:,2),reshape(II_unlab_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('II - Unlabeled')
    
    subplot(3,4,6)
    imagesc(II_pts(:,1),II_pts(:,2),reshape(II1_2DKDE - II0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$I \rightarrow I$')
    
    subplot(3,4,7)
    imagesc(II_pts(:,1),II_pts(:,2),reshape(II2_2DKDE - II0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$I \leftrightarrow I$')

    subplot(3,4,9)
    imagesc(EI_pts(:,1),EI_pts(:,2),reshape(EI_unlab_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('EI - Unlabeled')
    
    subplot(3,4,10)
    imagesc(EI_pts(:,1),EI_pts(:,2),reshape(EI_2DKDE - EIIE0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$I \rightarrow E$')
    
    subplot(3,4,11)
    imagesc(EI_pts(:,1),EI_pts(:,2),reshape(IE_2DKDE - EIIE0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$E \rightarrow I$')
    
    subplot(3,4,4)
    imagesc(EI_pts(:,1),EI_pts(:,2),reshape(EIIE_2DKDE - EIIE0_2DKDE,[nPoints nPoints]))
    set(gca,'YDir','normal')
    xlabel('Score 1')
    ylabel('Score 2')
    title('$E \leftrightarrow I$')
    
    
end

