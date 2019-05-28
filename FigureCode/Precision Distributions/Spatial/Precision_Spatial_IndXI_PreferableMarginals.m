
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))

    
%% Get Simulation Parameters and Generate Network
N = 2e3;

SimPar = LoadBaseSimPar('Pyle2016_RealPart','Spatial','direct',N,1e3, 'Pscale',2, 'warn',false);
SimPar.J = SimPar.J * 0.01;
q = [SimPar.qe SimPar.qi];
V = SimPar.J.^2 * 0.00001;
SimPar.V = V;

% SimPar.alphaEE = 0.05;
% SimPar.alphaEI = 0.05;
% SimPar.alphaIE = 0.05;
% SimPar.alphaII = 0.05;

% SimPar.alphaEE = 0.15;
% SimPar.alphaEI = 0.15;
% SimPar.alphaIE = 0.15;
% SimPar.alphaII = 0.15;

% SimPar.alphaEE = 0.4;
% SimPar.alphaEI = 0.4;
% SimPar.alphaIE = 0.4;
% SimPar.alphaII = 0.4;

SimPar.alphaEE = 0.2;
SimPar.alphaEI = 0.2;
SimPar.alphaIE = 0.2;
SimPar.alphaII = 0.2;

Networks = GenBlockSpatial_RandJ(SimPar);
W = full(Networks.J);

Ne = SimPar.Ne;
Ni = SimPar.Ni;

% [qe,qi,qx,N,Ne,Ni,Nx,J,Jx,P,Px,rx,T,Tburn,dt,Nt,NtBurn,Cme,Cmi,gLe,gLi,ELe,ELi,Vth,Vre,Vlb,DeltaT,VT,a,b, ...
%             tauw,taue,taui,taux,PSPs,PSPXs,alphaEE,alphaEI,alphaIE,alphaII,alphaEX,alphaIX] = UnPackSimPar(SimPar);
% 
% [Jinds,Jweights,J0,Jfinds,Jfweights,Jf0] = GenBlockSpatial_v2(Ne,Ni,Nx,...
%     J,Jx,V,zeros(2,1),P,Px,alphaEE,alphaEI,alphaIE,alphaII,alphaEX,alphaIX);
% 
% W = AdjCountC(N,N,Jinds,J0,Jweights);


%% Get Precision, Distances, and Bidirectional IDs
prec = W + W' - (W'*W); % parentheses necessary to keep form symmetric

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
SubTypePrecROCs = GetEISubTypeROCs(prec,BiDirIds,true);
title('ROC from Precision')

SubTypeDistROCs = GetEISubTypeROCs(distances,BiDirIds,true);
title('ROC from Distance')

SubTypePrecAUROCs = ExtractAUROCs(SubTypePrecROCs);
SubTypeDistAUROCs = ExtractAUROCs(SubTypeDistROCs);

[SubTypePrecAUROCs SubTypeDistAUROCs]


%% Save Data
%clear W SubTypeROCs BiDirIds SubTypeValues prec
%save('Figure Data/Precision_ER_IndXI_tempData.mat')
