
% This version averages the results from nSamples using the same W but
% different OU processes

addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))


%% Get SimPar and Network
N = 5e2;

Tbegin = 5e5;
Tincr = 5e5;
Tend = 3e7;

Trange = Tbegin:Tincr:Tend;
numT = numel(Trange);

winsize = 250;

nSamples = 4;

sigma = 0.1;

SubTypeAUROCs = zeros(7,numT,nSamples);
SubTypeDiscrims = zeros(7,numT,nSamples);

rall = cell(1,nSamples);
for j=1:nSamples
    rall{j} = zeros(N,numT * Tincr / winsize);
end


%% Get Simulation parameters
SimPar = LoadBaseSimPar('Pyle2016_RealPart','ER','direct',N,1e3, 'Pscale',2, 'warn',false);

% Weak strength, low noise regime
SimPar.k1 = 2.5;
SimPar.k2 = 6.25e-5;

SimPar.J = SimPar.psi * SimPar.k1;
SimPar.V = SimPar.psi.^2 * SimPar.k2;

tau = 1;


%% Get network
Network = GenBlockER(SimPar);
W = full(Network.J);

Gamma = sigma * eye(N);

A = eye(N) - W;
Aeigs = eig(A);

if (any(real(Aeigs) <= 0))
    warning('A might not be PD')
end
    

%% Run OU process and store temporally averaged rate vector
dt = SimPar.dt;

parfor j=1:nSamples
r0 = zeros(N,1);
tic
for t=1:numT
    
    thisTincr = ((t - 1) * Tincr / winsize + 1):(t * Tincr / winsize);
    
    [r,~] = OUSim(W,Gamma,tau,Tincr,dt,'winsize',winsize,'r0',r0);
    r0 = r(:,end); % update next initial conditions as final step of latest process
    rall{j}(1:N,thisTincr) = r; % update total process with latest
    
    fprintf('%d of %d simulation steps completed! (Iteration took: %0.2f s) \n',t,numT,toc)
    tic
end
end
fprintf('\n')


%% Get AUROC's from subsampling past time course
prec = cell(1,nSamples);
BiDirIds = GetBiDirIds(W,N,SimPar.Ne);

parfor j=1:nSamples
for t=1:numT
    
    UpTothisTincr = 1:(t * Tincr / winsize);
    

    %% Estimate precision
    S = cov(rall{j}(:,UpTothisTincr)');
    prec{j} = S \ eye(N);


    %% Get ROC and AUROC, and Discriminability
    SubTypeROCs = GetEISubTypeROCs(prec{j},BiDirIds,false);

    SubTypeAUROCs(:,t,j) = ExtractAUROCs(SubTypeROCs);
    
    SubTypeMeans = GetEISubTypeMeans(prec{j},BiDirIds);
    SubTypeVars = GetEISubTypeVars(prec{j},BiDirIds);
    SubTypeDiscrims(:,t,j) = cell2mat(struct2cell( GetEISubTypeDiscrim(SubTypeMeans,SubTypeVars) ));
    

end
end

save('OU_ER_IndXI_vsT_temp.mat','SubTypeAUROCs','prec','BiDirIds')


%% Plot AUROC vs T
set(0,'defaulttextinterpreter','latex')
titles = {'$E \rightarrow E$','$E \leftrightarrow E$', ...
          '$I \rightarrow I$','$I \leftrightarrow I$', ...
          '$I \rightarrow E$', '$E \rightarrow I$', '$E \leftrightarrow I$'};

lw = 2;
fs = 16;

mSubTypeAUROCs = mean(SubTypeAUROCs,3);
seSubTypeAUROCs = std(SubTypeAUROCs,[],3) / sqrt(nSamples);

mSubTypeDiscrims = mean(SubTypeDiscrims,3);

SubTypeTheorMeans = GetEISubTypeTheorMeans(SimPar);
SubTypeTheorStds = GetEISubTypeTheorStds(SimPar);
SubTypeTheorVars = GetEISubTypeTheorVars(SimPar);

SubTypeTheorDiscrimFromTheorVals = GetEISubTypeDiscrim(SubTypeTheorMeans,SubTypeTheorVars);
SubTypeTheorAUROCsFromTheorVals = GetEISubTypeTheorAUROC(SubTypeTheorDiscrimFromTheorVals);
theorAUROCvec = cell2mat(struct2cell(SubTypeTheorAUROCsFromTheorVals));

theorDiscrimvec = cell2mat(struct2cell(SubTypeTheorDiscrimFromTheorVals));

figure
j = 1;
for i=1:7
    subplot(2,4,j)
    plot(Trange, mSubTypeAUROCs(i,:), 'b-', 'Linewidth',lw)
    hold on
    plot(Trange, theorAUROCvec(j)*ones(1,numT), 'b--', 'Linewidth',lw)
    box off
    title(titles{j})
    xlabel('T (ms)')
    ylabel('AUROC')
    set(gca,'Linewidth',lw)
    set(gca,'Fontsize',fs)
    j = j + 1;
end

% Just to see how large the standard errors are
figure
j = 1;
for i=1:7
    subplot(2,4,j)
    errorbar(Trange, mSubTypeAUROCs(i,:), seSubTypeAUROCs(i,:), 'Linewidth',lw)
    box off
    title(titles{j})
    xlabel('T (ms)')
    ylabel('AUROC')
    set(gca,'Linewidth',lw)
    set(gca,'Fontsize',fs)
    j = j + 1;
end

% Plot Psi_inf based on AUROC
figure
j = 1;
for i=1:7
    subplot(2,4,j)
    plot(Trange, mSubTypeAUROCs(i,:) / theorAUROCvec(j), 'b-', 'Linewidth',lw)
    box off
    title(titles{j})
    xlabel('T (ms)')
    ylabel('$\psi_{opt}$')
    set(gca,'Linewidth',lw)
    set(gca,'Fontsize',fs)
    j = j + 1;
end

% Plot Psi_inf based on discrim
cols = GetEISubTypeColors;

figure
for i=1:7
    plot(Trange, (mSubTypeDiscrims(i,:) / theorDiscrimvec(i)), 'Linewidth',lw, 'Color',cols{i})
    hold on
end
box off
title('% Optimal Discriminability')
xlabel('T (ms)')
ylabel('$\psi_{opt}$')
set(gca,'Linewidth',lw)
set(gca,'Fontsize',fs)
legend(titles,'interpreter','latex')

figure
for i=1:7
    plot(Trange, (mSubTypeAUROCs(i,:) / theorAUROCvec(i)), 'Linewidth',lw, 'Color',cols{i})
    hold on
end
box off
title('% Optimal AUROC')
xlabel('T (ms)')
ylabel('$\psi_{opt}$')
set(gca,'Linewidth',lw)
set(gca,'Fontsize',fs)
legend(titles,'interpreter','latex')

SubTypeROCs = GetEISubTypeROCs(prec{1},BiDirIds,true);


