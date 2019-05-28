
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))

    
%% Get Simulation Parameters and Generate Network
N = 2e3;

SimPar = LoadBaseSimPar('Pyle2016_RealPart','Spatial','direct',N,1e3, 'Pscale',2, 'warn',false);
SimPar.J = SimPar.J * 0.01;
q = [SimPar.qe SimPar.qi];
V = SimPar.J.^2 * 0.00001;
SimPar.V = V;

alphaRange = 0.02:0.01:1;
numAlpha = numel(alphaRange);

SubTypeDistAUROCs = zeros(7,numAlpha);

for k=1:numAlpha
    SimPar.alphaEE = alphaRange(k);
    SimPar.alphaEI = alphaRange(k);
    SimPar.alphaIE = alphaRange(k);
    SimPar.alphaII = alphaRange(k);

    Networks = GenBlockSpatial_RandJ(SimPar);
    W = full(Networks.J);

    Ne = SimPar.Ne;
    Ni = SimPar.Ni;


    %% Get Precision, Distances, and Bidirectional IDs
    Orient = [(1:Ne)/Ne (1:Ni)/Ni];
    epsilonSqr = zeros(N);

    for i=1:N
        for j=1:N
            epsilonSqr(i,j) = min( abs(Orient(i) - Orient(j)), 1 - abs(Orient(i) - Orient(j)) )^2;
        end
    end

    distances = epsilonSqr;

    BiDirIds = GetBiDirIds(W,N,SimPar.Ne);
    BDStr = W + W';


    %% Get ROC for each subtype

    SubTypeDistROCs = GetEISubTypeROCs(distances,BiDirIds,false);
    title('ROC from Distance')

    SubTypeDistAUROCs(:,k) = ExtractAUROCs(SubTypeDistROCs);

    % [SubTypePrecAUROCs SubTypeDistAUROCs]
end


%% Plot Discriminability versus Spatial Widths
cols = GetEISubTypeColors;
lw = 2;
fs = 16;

figure
plot(alphaRange,SubTypeDistAUROCs(1,:), 'Linewidth',lw)
%plot(alphaRange,SubTypeDistAUROCs(1,:), 'Color',cols{1}, 'Linewidth',lw)
% hold on
% plot(alphaRange,SubTypeDistAUROCs(2,:), 'Color',cols{2}, 'Linewidth',lw)
% plot(alphaRange,SubTypeDistAUROCs(4,:), 'Color',cols{3}, 'Linewidth',lw)
% plot(alphaRange,SubTypeDistAUROCs(5,:), 'Color',cols{4}, 'Linewidth',lw)
% plot(alphaRange,SubTypeDistAUROCs(7,:), 'Color',cols{5}, 'Linewidth',lw)
box off
set(gca,'Linewidth',lw)
set(gca,'Fontsize',fs)
