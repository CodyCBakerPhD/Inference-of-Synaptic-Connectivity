
addpath(genpath('../../../Helpers'))

load RawMFCorrs.mat
ngood = size(MeanRawMFCorrs,3);

% Data from V1 L2/3
JiangPSPs = [0.34 -0.48 ; 1.6 -0.68]; % Pyr/BC, mV
JiangConnProbs = [0.018 0.352; 0.186  0.468]; %  Pyr/BC

KBar_Est = JiangPSPs .* JiangConnProbs;
Q = [0.8 0; 0 0.2];

MeanRxBar_Est = cell(ngood,1);
SteRxBar_Est = cell(ngood,1);
for i=1:ngood
     MeanRxBar_Est{i} = KBar_Est * Q * MeanRawMFCorrs(:,:,i) * Q * KBar_Est';
     SteRxBar_Est{i} = sqrt(KBar_Est.^2 * Q.^2 * SteRawMFCorrs(:,:,i).^2 * Q.^2 * KBar_Est'.^2);
end


%%
downColSep = 0.8;
upColSep = 1.1;

BasicColor = {[0    0.4470    0.7410], ...
              [0.8500    0.3250    0.0980], ...
              [0.9290    0.6940    0.1250], ...
              [0.4940    0.1840    0.5560], ...
              [0.4660    0.6740    0.1880], ...
              [0.3010    0.7450    0.9330], ...
              [0.6350    0.0780    0.1840], ...
              [0.2500    0.2500    0.2500], ...
              [ 1.0000         0         0], ...
              [ 0.7500         0    0.7500], ...
              [ 0.7500    0.7500         0]};
          

Colors = cell(ngood,1);
for i=1:2:ngood % assume divisible by two
    Colors{i} = BasicColor{floor((i-1)/2)+1} * downColSep;
    Colors{i+1} = min(BasicColor{floor((i-1)/2)+1} * upColSep,1);
end


%% Normalize by Arithmetic Mean
arithmMean = zeros(ngood,1);
aHatMean = zeros(ngood,1);
bHatMean = zeros(ngood,1);
cHatMean = zeros(ngood,1);

aHatSte = zeros(ngood,1);
bHatSte = zeros(ngood,1);
cHatSte = zeros(ngood,1);

for i=1:ngood
    arithmMean(i) = mean([MeanRxBar_Est{i}(1,1) MeanRxBar_Est{i}(1,2) MeanRxBar_Est{i}(2,2)]);
        
    aHatMean(i) = MeanRxBar_Est{i}(1,1) / arithmMean(i);
    bHatMean(i) = MeanRxBar_Est{i}(2,2) / arithmMean(i);
    cHatMean(i) = MeanRxBar_Est{i}(1,2) / arithmMean(i);
    
    aHatSte(i) = SteRxBar_Est{i}(1,1) / arithmMean(i);
    bHatSte(i) = SteRxBar_Est{i}(2,2) / arithmMean(i);
    cHatSte(i) = SteRxBar_Est{i}(1,2) / arithmMean(i);
end


%% MF Corrs
lw = 2;
fs = 16;
ms = 10;

figure
for i=1:ngood
    meanPlotForm = [MeanRawMFCorrs(1,1,i) MeanRawMFCorrs(1,2,i) MeanRawMFCorrs(2,2,i)];
        
     plot([1 2 3], meanPlotForm, 'o--', 'marker','d', 'color',Colors{i}, 'markerfacecolor',Colors{i}, ...
                 'linewidth',lw, 'markersize',ms)
    hold on
end
box off
set(gca,'linewidth',lw)
set(gca,'fontsize',fs)


%% MF Corrs - With errorbars
lw = 2;
fs = 16;
ms = 10;

figure
for i=1:ngood
    meanPlotForm = [MeanRawMFCorrs(1,1,i) MeanRawMFCorrs(1,2,i) MeanRawMFCorrs(2,2,i)];
    stePlotForm = [SteRawMFCorrs(1,1,i) SteRawMFCorrs(1,2,i) SteRawMFCorrs(2,2,i)];
        
     plot([1 2 3], meanPlotForm, 'o--', 'marker','d', 'color',Colors{i}, 'markerfacecolor',Colors{i}, ...
                 'linewidth',lw, 'markersize',ms)
    hold on

    errorbar([1 2 3], meanPlotForm,stePlotForm, '--', 'color',Colors{i},'linewidth',lw)
end
box off
set(gca,'linewidth',lw)
set(gca,'fontsize',fs)



%% MF External Covs
lw = 2;
fs = 16;
ms = 10;

figure
for i=1:ngood
    meanPlotForm = [aHatMean(i) cHatMean(i) bHatMean(i)];
     plot([1 2 3], meanPlotForm, 'o--', 'marker','d', 'color',Colors{i}, 'markerfacecolor',Colors{i}, ...
                 'linewidth',lw, 'markersize',ms)
    hold on
end
box off
set(gca,'linewidth',lw)
set(gca,'fontsize',fs)


%% MF External Covs - With errorbars
lw = 2;
fs = 16;
ms = 10;

figure
for i=1:ngood
    meanPlotForm = [aHatMean(i) cHatMean(i) bHatMean(i)];
    stePlotForm = [aHatSte(i) cHatSte(i) bHatSte(i)];
    
     plot([1 2 3], meanPlotForm, 'o--', 'marker','d', 'color',Colors{i}, 'markerfacecolor',Colors{i}, ...
                 'linewidth',lw, 'markersize',ms)
    hold on
    
    errorbar([1 2 3], meanPlotForm,stePlotForm, '--','color',Colors{i},'linewidth',lw)
end
box off
set(gca,'linewidth',lw)
set(gca,'fontsize',fs)


%% Low-rank Figure
lw = 2;
fs = 16;
ms = 30;

figure
for i=1:ngood
    plot(aHatMean(i)*bHatMean(i),cHatMean(i)^2,'k.', 'markersize',ms, 'color',Colors{i})
    hold on
end
plot(0:2,0:2,'k--', 'linewidth',lw)
set(gca,'fontsize',fs)
set(gca,'linewidth',lw)
box off


%%
[nullRejected,p,ci,stats] = ttest2(aHatMean.*bHatMean,cHatMean.^2, 'Vartype','unequal')
%[nullRejected,p,ci,stats] = ttest2(aHat.*bHat,cHat.^2)

% H0: Means are equal
% nullRejected = 0 implies could not reject at 5%; system is rank 1
% nullRejected = 1 implies deviations are strong enough to claim system is rank 2

figure
subplot(1,2,1)
ksdensity(aHatMean.*bHatMean, 'kernel','epa', 'support','positive')
title('Density of $\hat{a} \hat{b}$','interpreter','latex')
set(gca,'fontsize',fs,'linewidth',lw)
box off

subplot(1,2,2)
ksdensity(cHatMean.^2, 'kernel','epa', 'support','positive')
title('Density of $\hat{c}^2$','interpreter','latex')
set(gca,'fontsize',fs,'linewidth',lw)
box off

 