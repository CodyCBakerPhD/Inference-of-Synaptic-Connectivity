
%% 
clear
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))

N = 2e3;
T = 3e7;

loadname = sprintf('EIF_ER_Correlated_N%1.2e_T%1.2e.mat',N,T);

load(loadname)
Ne = SimPar.Ne;
Nx = SimPar.Nx;

winsize = 250;


%%
BiDirIds = GetBiDirIds(W,N,Ne);

empPrec = -inv(CSS);

G = G + eye(N) * min(G(G ~= 0))*0.01;
gainSimplePrec = (G*W)' + (G*W) - ((G*W)' * (G*W));
dG = diag(G); mG = diag([mean(dG(1:Ne))*ones(1,Ne) mean(dG((Ne+1):N)*ones(1,N-Ne))]);
mGainSimplePrec = (mG*W)' + (mG*W) - (mG*W)' * (mG*W);

sx_sx = ones(Nx) * SimPar.c * SimPar.rx * winsize;
sx_sx(1:(Nx+1):Nx^2) = SimPar.rx * winsize;
Gamma = (Wx * sx_sx * Wx');
Gamma = Gamma + 1/3 * diag(diag(Gamma));
gainGamma = (Wx * sx_sx * Wx');
gainGamma = G*(gainGamma + 1/3 * diag(diag(gainGamma)))*G;
Phi = inv(Gamma);
gainPhi = inv(gainGamma);

fullPrecGainW = -Phi + (G*W)' * Phi + Phi * (G*W) - (G*W)' * Phi * (G*W);
fullPrecGainWandGainCXX = -gainPhi + (G*W)' * gainPhi + gainPhi * (G*W) - (G*W)' * gainPhi * (G*W);


%% vs T
Tmin = 3e5;
Tby = 2e5;
Tmax = T;
Tall = Tmin:Tby:Tmax;
nT = numel(Tall);

CSSvsT = cell(1,nT);
AUROCvsT = zeros(7,nT);

tic
for i=1:nT
    fprintf('Estimated %d of %d precision matrices. (%0.2f min elapsed)\n',i,nT,toc/60)
    
    CSSvsT{i} = Robs_SpikeCountCov(s(:,s(1,:) < Tall(i)),N,250,Tall(i)-250,winsize);
    
    tempPrec = inv(CSSvsT{i});
    tempSubTypeROCs = GetEISubTypeROCs(tempPrec,BiDirIds,false);
    AUROCvsT(:,i) = ExtractAUROCs(tempSubTypeROCs);
end


%% ROC curves
empSubTypeROCs = GetEISubTypeROCs(empPrec,BiDirIds,true);

gainSubTypeROCs = GetEISubTypeROCs(gainSimplePrec,BiDirIds,true);
meanGainSubTypeROCs = GetEISubTypeROCs(mGainSimplePrec,BiDirIds,true);

fullPrecGainWSubTypeROCs = GetEISubTypeROCs(fullPrecGainW,BiDirIds,true);
fullPrecGainWandGainCXXROCs = GetEISubTypeROCs(fullPrecGainWandGainCXX,BiDirIds,true);


empSubTypeAUROCs = ExtractAUROCs(empSubTypeROCs);

gainSubTypeAUROCs = ExtractAUROCs(gainSubTypeROCs);
meanGainSubTypeAUROCs = ExtractAUROCs(meanGainSubTypeROCs);

fullPrecGainWSubTypeAUROCs = ExtractAUROCs(fullPrecGainWSubTypeROCs);
fullPrecGainWandGainCXXAUROCs = ExtractAUROCs(fullPrecGainWandGainCXXROCs);

[empSubTypeAUROCs gainSubTypeAUROCs meanGainSubTypeAUROCs fullPrecGainWSubTypeAUROCs fullPrecGainWandGainCXXAUROCs]
                                                        
                                                        
%%
lw = 2;
fs = 16;

cols = GetEISubTypeColors;

set(0,'defaulttextinterpreter','latex')
titles = {'$e \rightarrow e$','$e \leftrightarrow e$', ...
          '$i \rightarrow i$','$i \leftrightarrow i$', ...
          '$i \rightarrow e$', '$e \rightarrow i$', '$e \leftrightarrow i$'};

figure
for i=1:7
    plot(Tall, (AUROCvsT(i,:) / empSubTypeAUROCs(i)), 'Linewidth',lw, 'Color',cols{i})
    hold on
end
box off
title('% Optimal AUROC')
xlabel('T (ms)')
ylabel('% final')
set(gca,'Linewidth',lw)
set(gca,'Fontsize',fs)
legend(titles,'interpreter','latex')


%% Get Empirical and Theoretical Moments
SubTypeMeans = GetEISubTypeMeans(empPrec,BiDirIds);
SubTypeStds = GetEISubTypeStds(empPrec,BiDirIds);
SubTypeVars = GetEISubTypeVars(empPrec,BiDirIds);
SubTypeValues = GetEISubTypeValues(empPrec,BiDirIds);


%% Configure Unlabeled Scatterplot and Distribution - Comment out if not wanted
lw = 4;
fs = 25;
set(0,'defaulttextinterpreter','latex')

nplot = 3e4; % Number of scatter points
pp = randperm(N*(N-1),nplot);
nBins = 3e2;
prec_OD = empPrec;
prec_OD(1:(N+1):end) = [];

BDStr = W + W';
BDStr_OD = BDStr;
BDStr_OD(1:(N+1):end) = [];
[unlab_yy,unlab_xx] = ksdensity(prec_OD(:),'NumPoints',nBins);

[unlab_null_yy,unlab_null_xx] = ksdensity(prec_OD(BDStr_OD == 0),'NumPoints',nBins);
[unlab_conn_yy,unlab_conn_xx] = ksdensity(prec_OD(BDStr_OD ~= 0),'NumPoints',nBins);


%% Plot Unlabeled Scatterplot and Distribution - Comment out if not wanted
figure
subplot(1,3,1)
plot(prec_OD(pp),BDStr_OD(pp),'k.')
xlabel('Precision')
ylabel('$\textbf{W} + \textbf{W}^{T}$')
box off
set(gca,'LineWidth',lw)
set(gca,'FontSize',fs)

subplot(1,3,2)
plot(unlab_xx,unlab_yy,'k', 'Linewidth',lw)
xlabel('Precision')
ylabel('Density')
box off
set(gca,'LineWidth',lw)
set(gca,'FontSize',fs)


subplot(1,3,3)
plot(unlab_null_xx,unlab_null_yy,'k', 'Linewidth',lw)
hold on
plot(unlab_conn_xx,unlab_conn_yy,'k:', 'Linewidth',lw)
xlabel('Precision')
ylabel('Densities')
box off
set(gca,'LineWidth',lw)
set(gca,'FontSize',fs)


%% Separated Scatterplots
EISubTypePlotScatter(empPrec,BDStr,BiDirIds)


%% Separated Distributions
EISubTypePlotGaussDistributions(empPrec,BiDirIds)

