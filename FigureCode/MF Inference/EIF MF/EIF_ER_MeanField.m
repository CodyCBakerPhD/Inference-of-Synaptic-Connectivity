
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))

load EIF_ER_MFSim_N2.00e4_T3.00e5.mat


%%
%CSSMF = MF(CSS,1:SimPar.N,SimPar.Ne);
Kbar = SimPar.J .* SimPar.P;
Kxbar = SimPar.Jx .* SimPar.Px;
Q = [SimPar.qe 0; 0 SimPar.qi];

CXXMF_Est = Kbar * Q * CSSMF * Q * Kbar';
CXXMF_Theor = SimPar.c * SimPar.rx * SimPar.qx^2 * (Kxbar * Kxbar');

[CXXMF_Est nan(2,1) CXXMF_Theor * SimPar.N / 100]
[CXXMF_Est nan(2,1) CXXMF_Theor * CXXMF_Est(2,2) / CXXMF_Theor(2,2)]
(CXXMF_Theor*1e3) ./ CXXMF_Est


%% Rank one approx of CXXMF_Est, which is rank 2 but we want to show that it is CLOSE to rank one
[U, S, V] = svd(CXXMF_Est);
k = 1;
CXXMF_Est_RankOneApprox = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';

CXXMF_Est_RankOneExtra = CXXMF_Est - CXXMF_Est_RankOneApprox;

abs(CXXMF_Est_RankOneExtra) ./ abs(CXXMF_Est)

% just need to replicate this on experimental data?


%%
arithMean = mean([CXXMF_Est(1,1) CXXMF_Est(1,2) CXXMF_Est(2,2)]);
aHat = CXXMF_Est(1,1) / arithMean;
bHat = CXXMF_Est(2,2) / arithMean;
cHat = CXXMF_Est(1,2) / arithMean;

lw = 2;
fs = 16;
ms = 30;

figure
plot(aHat*bHat,cHat^2,'k.', 'markersize',ms)
hold on
plot(0:1,0:1,'k--', 'linewidth',lw)
set(gca,'fontsize',fs)
set(gca,'linewidth',lw)
box off




