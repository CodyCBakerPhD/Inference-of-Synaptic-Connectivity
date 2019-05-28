
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))

    
%% Get Simulation Parameters and Generate Network
N = 2e3;
T = 1e3; % technically this goes unused until the explicit dynamics section

SimPar = LoadBaseSimPar('Pyle2016_RealPart','Spatial','direct',N,T, 'Pscale',2, 'warn',false);

% Weak strength, low noise regime
SimPar.k1 = 2.5;
SimPar.k2 = 6.25e-5;

SimPar.J = SimPar.psi * SimPar.k1;
SimPar.V = SimPar.psi.^2 * SimPar.k2;

alpha = 0.2; % spatial width

SimPar.alphaEE = alpha;
SimPar.alphaEI = alpha;
SimPar.alphaIE = alpha;
SimPar.alphaII = alpha;

Networks = GenBlockSpatial_RandJ(SimPar);
W = full(Networks.J);

Ne = SimPar.Ne;
Ni = SimPar.Ni;


%% Get Precision, Distances, and Bidirectional IDs
prec = W + W' - (W'*W); % parentheses necessary to keep form symmetric

Orient = [(1:Ne)/Ne (1:Ni)/Ni];
epsilonSqr = zeros(N);

for i=1:N
    for j=1:N
        epsilonSqr(i,j) = abs( min( abs(Orient(i) - Orient(j)), 1 - abs(Orient(i) - Orient(j)) ) );
    end
end

distances = epsilonSqr;

BiDirIds = GetBiDirIds(W,N,SimPar.Ne);


%% Get marginal ROC for each subtype
SubTypePrecROCs = GetEISubTypeROCs(prec,BiDirIds,true);
title('ROC from Precision')

SubTypeDistROCs = GetEISubTypeROCs(distances,BiDirIds,true);
title('ROC from Distance')

SubTypePrecAUROCs = ExtractAUROCs(SubTypePrecROCs);
SubTypeDistAUROCs = ExtractAUROCs(SubTypeDistROCs);


%% Prepare Data
SubTypePrecVals = GetEISubTypeValues(prec,BiDirIds);
SubTypeDistVals = GetEISubTypeValues(distances,BiDirIds);


%% Optimal Linear ROC curves on 2D space
[Linear_AUROCs,OptOrients,OptShifts,OptROCs,Linear_OptAUROCs] = GetSubType2DROC_Linear(...
                                                        SubTypeDistVals,SubTypePrecVals,1e2,true);

                                          
%% Radial ROC curve on 2D space
[Radial_ROCs,Radial_AUROCs] = GetSubType2DROC_Radial(SubTypeDistVals,SubTypePrecVals,1e2,true);


%% Plot 2D KDEs
lw = 2;
fs = 16;

PlotEISubType2DKDE(SubTypeDistVals,SubTypePrecVals,1e2)

subplot(3,4,2)
hold on
plot(0:1,(0:1)*tan(OptOrients.EE1) + OptShifts.EE1, 'r--', 'Linewidth',lw)

subplot(3,4,3)
hold on
plot(0:1,(0:1)*tan(OptOrients.EE2) + OptShifts.EE2, 'r--', 'Linewidth',lw)

subplot(3,4,6)
hold on
plot(0:1,(0:1)*tan(OptOrients.II1) + OptShifts.II1, 'r--', 'Linewidth',lw)

subplot(3,4,7)
hold on
plot(0:1,(0:1)*tan(OptOrients.II2) + OptShifts.II2, 'r--', 'Linewidth',lw)

subplot(3,4,10)
hold on
plot(0:1,(0:1)*tan(OptOrients.EI) + OptShifts.EI, 'r--', 'Linewidth',lw)

subplot(3,4,11)
hold on
plot(0:1,(0:1)*tan(OptOrients.IE) + OptShifts.IE, 'r--', 'Linewidth',lw)

subplot(3,4,4)
hold on
plot(0:1,(0:1)*tan(OptOrients.EIIE) + OptShifts.EIIE, 'r--', 'Linewidth',lw)



cols = GetEISubTypeColors();

subplot(3,4,12)
plot(OptROCs.EE1(1,:),OptROCs.EE1(2,:), 'Color',cols{1}, 'Linewidth',lw)
hold on
plot(OptROCs.EE2(1,:),OptROCs.EE2(2,:), 'Color',cols{2}, 'Linewidth',lw)
plot(OptROCs.II1(1,:),OptROCs.II1(2,:), 'Color',cols{3}, 'Linewidth',lw)
plot(OptROCs.II2(1,:),OptROCs.II2(2,:), 'Color',cols{4}, 'Linewidth',lw)
plot(OptROCs.EI(1,:),OptROCs.EI(2,:), 'Color',cols{5}, 'Linewidth',lw)
plot(OptROCs.IE(1,:),OptROCs.IE(2,:), 'Color',cols{6}, 'Linewidth',lw)
plot(OptROCs.EIIE(1,:),OptROCs.EIIE(2,:), 'Color',cols{7}, 'Linewidth',lw)
title('ROC for Optimal Linear Classifier')
box off
set(gca, 'Linewidth',lw)
set(gca, 'Fontsize',fs)


%% Display all three AUROCs in Console
Radial_AUROCs_vec = [Radial_AUROCs.EE1 Radial_AUROCs.EE2 Radial_AUROCs.II1 Radial_AUROCs.II2 ...
                 Radial_AUROCs.EI Radial_AUROCs.IE Radial_AUROCs.EIIE]';
Linear_OptAUROCs_vec = [Linear_OptAUROCs.EE1 Linear_OptAUROCs.EE2 Linear_OptAUROCs.II1 ...
                    Linear_OptAUROCs.II2  Linear_OptAUROCs.EI Linear_OptAUROCs.IE ...
                    Linear_OptAUROCs.EIIE]';

[SubTypePrecAUROCs SubTypeDistAUROCs Radial_AUROCs_vec Linear_OptAUROCs_vec]


%% Save Data
%clear W SubTypeROCs BiDirIds SubTypeValues prec
%save('Figure Data/Precision_ER_IndXI_tempData.mat')


