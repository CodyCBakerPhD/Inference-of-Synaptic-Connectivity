
clear
close all

addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))


%% Get Simulation Parameters
N = 2e4; % Number of neurons

% Sim time and time step
T = 3e5;

SimPar = LoadBaseSimPar('Pyle2016_RealPart','ER','correlated',N,T, 'Pscale',2, 'warn',false);

SimPar.NeuronParams.a = 0;
SimPar.NeuronParams.b = 0.05; % Small amount of adaptation
SimPar.NeuronParams.tauref = 1;
SimPar.NeuronParams.DeltaT = 1;

% White noise input strength; approximation to expectation of CXX
tempSig = sqrt( SimPar.qx * (SimPar.Nx - 1) * SimPar.rx * SimPar.c * SimPar.Jx.^2 .* SimPar.Px.^2 ...
                            + SimPar.qx * SimPar.rx * SimPar.Jx.^2 .* SimPar.Px.^2 );
SimPar.sigmae = tempSig(1) / 3;
SimPar.sigmai = tempSig(2) / 3;

SimPar.NeuronParams.b = 0.1;

winsize = 250; % ms


%% Get network
tic
Network = GenBlockER(SimPar);
W = Network.J;
Wx = Network.Jx;
tGen = toc;
fprintf('\nTime to generate connections: %.2f sec\n',tGen)


%% Run simulation
tic
[s,sx,mTotalInput] = EIFSim(SimPar,W,'Wx',Wx);
tSim = toc;
fprintf('Time for simulation: %.2f min\n\n',tSim/60)
    

%% Get Rates and Plot Raster
rates = hist(s(2,s(1,:) > 250),1:N) / (T - 250);
xrates = hist(sx(2,sx(1,:) > 250),1:SimPar.Nx) / (T - 250);

PlotRasterSmall(s,SimPar,1e2)


%% Plot rate distributions
Eids = 1:SimPar.Ne;
Iids = (SimPar.Ne+1):N;

figure
subplot(1,2,1)
histogram(rates(Eids)*1e3)
xlabel('Rates (Hz)')
title('Excitatory')

subplot(1,2,2)
histogram(rates(Iids)*1e3)
xlabel('Rates (Hz)')
title('Inhibitory')


%% Balance Rate Diagnostics
Wbar = SimPar.J .* SimPar.P;
Wxbar = SimPar.Jx .* SimPar.Px;
Q = [SimPar.qe 0; 0 SimPar.qi];
Fbar = Wxbar * SimPar.qx * SimPar.rx;

balRates = -inv(Wbar * Q) * Fbar * 1e3; % in Hz

meanExcRate = mean(rates(Eids)) * 1e3;
meanInhRate = mean(rates(Iids)) * 1e3;

fprintf('\nMean Excitatory Rate = %0.2f Hz\t', meanExcRate)
fprintf('Balance Excitatory Rate = %0.2f Hz\t', balRates(1))
fprintf('Relative Error = %0.2f%%\n', abs(meanExcRate - balRates(1)) / balRates(1) * 100)

fprintf('Mean Inhibitory Rate = %0.2f Hz\t', meanInhRate)
fprintf('Balance Inhibitory Rate = %0.2f Hz\t', balRates(2))
fprintf('Relative Error = %0.2f%%\n\n', abs(meanInhRate - balRates(2)) / balRates(2) * 100)


%% Get Spike Count Covariance and Gain Fit
CSS = Robs_SpikeCountCov(s,N,250,T-250,winsize); % 250 is hardcoded burn period

Ne = SimPar.Ne;

f = fittype('(a*(I-th)+b*(I-th).^2).*(I>th)','independent','I');
efit = fit(mTotalInput(Eids), rates(Eids)', f, 'StartPoint',[0 .001 -.1]);
fe = @(I)((efit.a*(I-efit.th)+efit.b*(I-efit.th).^2).*(I > efit.th));

ifit = fit(mTotalInput(Iids), rates(Iids)', f, 'StartPoint',[0 .001 -.1]);
fi = @(I)((ifit.a*(I-ifit.th)+ifit.b*(I-ifit.th).^2).*(I > ifit.th));

feprime = @(I)((efit.a*I+2*efit.b*(I-efit.th)).*(I > efit.th));
ge = feprime(mTotalInput(1:Ne));

fiprime = @(I)((ifit.a*I+2*ifit.b*(I-ifit.th)).*(I > ifit.th));
gi = fiprime(mTotalInput(Ne+1:N));

g = [ge;gi];
G = diag(g);


%% Balance Covariance Diagnostic
Wxbar = SimPar.Px .* SimPar.Jx;
sxsxbar = SimPar.rx * SimPar.c;
XXbar = Wxbar * SimPar.qx * sxsxbar * SimPar.qx * Wxbar';

Wbar = SimPar.P .* SimPar.J;
invWbar = inv(Wbar * Q);
Q = [SimPar.qe 0; 0 SimPar.qi];

balCovs = invWbar * XXbar * invWbar' * winsize;

MFCov = MF(CSS,1:N,SimPar.Ne);

fprintf('\nMean EE Covariance = %0.2f\t', MFCov(1,1))
fprintf('Balance EE Covariance = %0.2f\t', balCovs(1,1))
fprintf('Relative Error = %0.2f%%\n', abs(MFCov(1,1) - balCovs(1,1)) / balCovs(1,1) * 100)

fprintf('Mean EI Covariance = %0.2f\t', MFCov(1,2))
fprintf('Balance EI Covariance = %0.2f\t', balCovs(1,2))
fprintf('Relative Error = %0.2f%%\n', abs(MFCov(1,2) - balCovs(1,2)) / balCovs(1,2) * 100)

fprintf('Mean II Covariance = %0.2f\t', MFCov(2,2))
fprintf('Balance II Covariance = %0.2f\t', balCovs(2,2))
fprintf('Relative Error = %0.2f%%\n\n', abs(MFCov(2,2) - balCovs(2,2)) / balCovs(2,2) * 100)


%%
savename = sprintf('EIF_ER_MFSim_N%1.2e_T%1.2e.mat',N,T);
CSSMF = MF(CSS,1:SimPar.N,SimPar.Ne);
save(savename, 'CSSMF', 'SimPar')


