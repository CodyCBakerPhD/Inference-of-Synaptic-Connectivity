
addpath(genpath('../../../../Helpers'))
addpath(genpath('../../../../BaseSimCode'))

    
%% Get Simulation Parameters and Generate Network
N = 2e3;
T = 1e3; % technically this goes unused until the explicit dynamics section

SimPar = LoadBaseSimPar('Pyle2016_RealPart','HDER','direct',N,T, 'Pscale',2, 'warn',false);

% Weak strength, low noise regime
SimPar.k1 = 2.5;
SimPar.k2 = 6.25e-5;

SimPar.J = SimPar.psi * SimPar.k1;
SimPar.V = SimPar.psi.^2 * SimPar.k2;

Network = GenBlockHD(SimPar,'out');
W = full(Network.J);


%% Get Precision and Bidirectional IDs
prec = W + W' - (W'*W); % parentheses necessary to keep form symmetric

BiDirIds = GetBiDirIds(W,N,SimPar.Ne);


%% Get Empirical and Theoretical Moments
SubTypeMeans = GetEISubTypeMeans(prec,BiDirIds);
SubTypeStds = GetEISubTypeStds(prec,BiDirIds);
SubTypeVars = GetEISubTypeVars(prec,BiDirIds);
SubTypeValues = GetEISubTypeValues(prec,BiDirIds);

SubTypeTheorMeans = GetEISubTypeTheorMeans(SimPar);
SubTypeTheorStds = GetEISubTypeTheorStds(SimPar);
SubTypeTheorVars = GetEISubTypeTheorVars(SimPar);


%% Configure Unlabeled Scatterplot and Distribution - Comment out if not wanted
lw = 4;
fs = 25;
set(0,'defaulttextinterpreter','latex')

nplot = 3e4; % Number of scatter points
pp = randperm(N*(N-1),nplot);
nBins = 3e2;
prec_OD = prec;
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
EISubTypePlotScatter(prec,BDStr,BiDirIds)


%% Separated Distributions
EISubTypePlotGaussDistributions(prec,BiDirIds)


%% Get and Plot Distributional Data
EmpDens = Compare_EmpVsGausVsTheor_Dists(SubTypeValues,SubTypeMeans, ...
                                                    SubTypeStds,SubTypeTheorMeans,SubTypeTheorStds);


%% Get ROC for each subtype
SubTypeROCs = GetEISubTypeROCs(prec,BiDirIds,true);
%saveas(gcf,'../XI Figures/IndXI.fig')

SubTypeAUROCs = ExtractAUROCs(SubTypeROCs);


%% Get Empirical and Theoretical Discriminability
SubTypeDiscrim = GetEISubTypeDiscrim(SubTypeMeans,SubTypeVars);
SubTypeTheorDiscrimFromTheorVals = GetEISubTypeDiscrim(SubTypeTheorMeans,SubTypeTheorVars);
SubTypeTheorDiscrimFromSimPar = GetEISubTypeDiscrim(SimPar);

SubTypeTheorAUROCsFromTheorVals = GetEISubTypeTheorAUROC(SubTypeTheorDiscrimFromTheorVals);
SubTypeTheorAUROCsFromSimPar = GetEISubTypeTheorAUROC(SubTypeTheorDiscrimFromSimPar);


%% Compare Discriminability
Compare_EmpVsTheor_Discrim(SubTypeDiscrim,SubTypeTheorDiscrimFromTheorVals)


%% Save Data
%clear W SubTypeROCs BiDirIds SubTypeValues prec
%save('Figure Data/Precision_ER_IndXI_tempData.mat')


