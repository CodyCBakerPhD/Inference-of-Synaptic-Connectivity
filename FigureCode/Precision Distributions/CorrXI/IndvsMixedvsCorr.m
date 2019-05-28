
clear
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))


%%
N = 2e3;
T = 1e3; % technically this goes unused until the explicit dynamics section
nSamples = 4; % multiple of number of cores
%nSamples = 1;

k1 = 2.5; % 'weak'
k2 = 6.25e-5; % 'low noise'
kx1 = 9 / 35;
kx2 = 23 / 35;

ER_SubTypeDiscrims = zeros(9,nSamples);
Corr_SRB_SubTypeDiscrims = zeros(9,nSamples);
Mixed_Rank1_SubTypeDiscrims = zeros(9,nSamples);
Mixed2_Rank1_SubTypeDiscrims = zeros(9,nSamples);

parfor (j=1:nSamples,2)
%for j=1:nSamples
    %% Get Simulation Parameters and Generate Networks
    % Case 4: Correlated spiking, sparse, random strength, blockwise Wx
    Corr_SRB_SimPar = LoadBaseSimPar('Pyle2016_RealPart','ER','correlated',N,T, 'Pscale',2, ...
                                                                        'qxscale',35, 'warn',false);
    
    Corr_SRB_SimPar.J = Corr_SRB_SimPar.psi * k1;
    Corr_SRB_SimPar.V = Corr_SRB_SimPar.psi.^2 * k2;
    Corr_SRB_SimPar.Jx = Corr_SRB_SimPar.psix * kx1;
    Corr_SRB_SimPar.Vx = Corr_SRB_SimPar.psix.^2 * kx2;
    
    % Case 5: Mixture of Rank-1 and Independent External Input
    Mixed_Rank1_SimPar = LoadBaseSimPar('Pyle2016_RealPart','ER','asynchronous',N,T, 'Pscale',2, ...
                                                                        'qxscale',35, 'warn',false);
    
    % Case 6: Combination of Low-Rank and Independent External Input
    Mixed2_Rank1_SimPar = LoadBaseSimPar('Pyle2016_RealPart','ER','asynchronous',N,T, 'Pscale',2, ...
                                                                                'warn',false);
    
    Mixed_Rank1_SimPar.Px = ones(2,1);
    Mixed_Rank1_SimPar.J = Mixed_Rank1_SimPar.psi * k1;
    Mixed_Rank1_SimPar.V = Mixed_Rank1_SimPar.psi.^2 * 0;
    Mixed_Rank1_SimPar.Jx = Mixed_Rank1_SimPar.psix * kx1;
    Mixed_Rank1_SimPar.Vx = Mixed_Rank1_SimPar.psix.^2 * kx2;
    
    
    %% Generate Networks, Get Adjacency Matrices, and Get External Input Covariance
    Nx = Corr_SRB_SimPar.Nx;
    I = eye(N);
    
    SRB_Networks = GenBlockER(Corr_SRB_SimPar);
    Mixed_Rank1_Networks = GenBlockER(Mixed_Rank1_SimPar);
    Mixed2_Rank1_Networks = GenBlockER(Mixed2_Rank1_SimPar);
    
    ER_W = full(SRB_Networks.J); % Use the same exact recurrent network for all parts
    SRB_Wx = full(SRB_Networks.Jx);
    Mixed_Rank1_Wx = full(Mixed_Rank1_Networks.Jx);
    Mixed2_Rank1_Wx = full(Mixed2_Rank1_Networks.Jx);
    
    Corr_sxsx = Corr_SRB_SimPar.c * Corr_SRB_SimPar.rx * ones(Nx);
    Corr_sxsx(1:(Nx+1):Nx^2) = Corr_SRB_SimPar.rx;
    
    Corr_SRB_Gamma = SRB_Wx * Corr_sxsx * SRB_Wx';
    Corr_SRB_Phi = inv(Corr_SRB_Gamma);
    
    Mixed_Rank1_Gamma = Mixed_Rank1_Wx * Mixed_Rank1_SimPar.rx * Mixed_Rank1_Wx' + I;
    Mixed_Rank1_Phi = inv(Mixed_Rank1_Gamma);
    
    
    Corr2_sxsx = Corr_SRB_SimPar.c * Corr_SRB_SimPar.rx * ones(Mixed2_Rank1_SimPar.Nx);
    Corr2_sxsx(1:(Mixed2_Rank1_SimPar.Nx+1):Mixed2_Rank1_SimPar.Nx^2) = Corr_SRB_SimPar.rx;
    
    Mixed2_Rank1_Gamma = Mixed2_Rank1_Wx * Corr2_sxsx * Mixed2_Rank1_Wx' + 10 * I;
    Mixed2_Rank1_Phi = inv(Mixed2_Rank1_Gamma);



    %% Get Precision and Bidirectional Indices
    Ne = Corr_SRB_SimPar.Ne;
    
    ER_prec = ER_W + ER_W' - (ER_W'*ER_W); % parentheses necessary to keep form symmetric
    Corr_SRB_prec = (I - ER_W') * Corr_SRB_Phi * (I - ER_W);
    Mixed_Rank1_prec = (I - ER_W') * Mixed_Rank1_Phi * (I - ER_W);
    Mixed2_Rank1_prec = (I - ER_W') * Mixed2_Rank1_Phi * (I - ER_W);
    
    ER_BiDirIds = GetBiDirIds(ER_W,N,Ne);


    %% Get Statistics and Discriminability
    ER_means = GetEISubTypeMeans(ER_prec,ER_BiDirIds);
    ER_vars = GetEISubTypeVars(ER_prec,ER_BiDirIds);
    
    Corr_SRB_means = GetEISubTypeMeans(Corr_SRB_prec,ER_BiDirIds);
    Corr_SRB_vars = GetEISubTypeVars(Corr_SRB_prec,ER_BiDirIds);
    
    Mixed_Rank1_means = GetEISubTypeMeans(Mixed_Rank1_prec,ER_BiDirIds);
    Mixed_Rank1_vars = GetEISubTypeVars(Mixed_Rank1_prec,ER_BiDirIds);
    
    Mixed2_Rank1_means = GetEISubTypeMeans(Mixed2_Rank1_prec,ER_BiDirIds);
    Mixed2_Rank1_vars = GetEISubTypeVars(Mixed2_Rank1_prec,ER_BiDirIds);
    
    temp_ER_SubTypeDiscrims = GetEISubTypeDiscrim(ER_means,ER_vars);
    temp_Corr_SRB_SubTypeDiscrims = GetEISubTypeDiscrim(Corr_SRB_means,Corr_SRB_vars);
    temp_Mixed_Rank1_SubTypeDiscrims = GetEISubTypeDiscrim(Mixed_Rank1_means,Mixed_Rank1_vars);
    temp_Mixed2_Rank1_SubTypeDiscrims = GetEISubTypeDiscrim(Mixed2_Rank1_means,Mixed2_Rank1_vars);
    
    ER_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_ER_SubTypeDiscrims);
    Corr_SRB_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_Corr_SRB_SubTypeDiscrims);
    Mixed_Rank1_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_Mixed_Rank1_SubTypeDiscrims);
    Mixed2_Rank1_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_Mixed2_Rank1_SubTypeDiscrims);
    
    
end


%%
lw = 2;
fs = 16;
set(0,'defaulttextInterpreter','latex')

ER_SubTypeDiscrims = abs(ER_SubTypeDiscrims);
Corr_SRB_SubTypeDiscrims = abs(Corr_SRB_SubTypeDiscrims);
Mixed_Rank1_SubTypeDiscrims = abs(Mixed_Rank1_SubTypeDiscrims);
Mixed2_Rank1_SubTypeDiscrims = abs(Mixed2_Rank1_SubTypeDiscrims);

% MATLAB's default colors
Colors = [0         0.4470    0.7410
          0.8500    0.3250    0.0980
          0.9290    0.6940    0.1250
          0.4940    0.1840    0.5560
          0.4660    0.6740    0.1880
          0.3010    0.7450    0.9330
          0.6350    0.0780    0.1840];

figure
p1 = bar(1,mean(ER_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(1,:));
hold on
p2 = bar(2,mean(Mixed_Rank1_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(2,:));
p3 = bar(3,mean(Mixed2_Rank1_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(3,:));
p4 = bar(4,mean(Corr_SRB_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(4,:));

bar(5,mean(ER_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(1,:))
bar(6,mean(Mixed_Rank1_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(2,:))
bar(7,mean(Mixed2_Rank1_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(3,:))
bar(8,mean(Corr_SRB_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(4,:))

bar(9,mean(ER_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(1,:))
bar(10,mean(Mixed_Rank1_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(2,:))
bar(11,mean(Mixed2_Rank1_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(3,:))
bar(12,mean(Corr_SRB_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(4,:))

bar(13,mean(ER_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(1,:))
bar(14,mean(Mixed_Rank1_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(2,:))
bar(15,mean(Mixed2_Rank1_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(3,:))
bar(16,mean(Corr_SRB_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(4,:))

bar(17,mean(ER_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(1,:))
bar(18,mean(Mixed_Rank1_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(2,:))
bar(19,mean(Mixed2_Rank1_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(3,:))
bar(20,mean(Corr_SRB_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(4,:))

bar(21,mean(ER_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(1,:))
bar(22,mean(Mixed_Rank1_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(2,:))
bar(23,mean(Mixed2_Rank1_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(3,:))
bar(24,mean(Corr_SRB_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(4,:))

bar(25,mean(ER_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(1,:))
bar(26,mean(Mixed_Rank1_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(2,:))
bar(27,mean(Mixed2_Rank1_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(3,:))
bar(28,mean(Corr_SRB_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(4,:))

title(strcat('E $\rightarrow$ E   E $\leftrightarrow$ E   I $\rightarrow$ I', ...
             'I $\leftrightarrow$ I   I $\rightarrow$ E   E $\rightarrow$ I', ...
             'E $\leftrightarrow$ I'))
ylabel('Discriminability')
axis([0.5 28.5 -Inf Inf])
box off
set(gca,'LineWidth',lw)
set(gca,'FontSize',fs)
legend([p1 p2 p3 p4],{'Independent','Combination 1','Combination 2','Correlated'})


%%
%clear W SubTypeROCs BiDirIds SubTypeValues prec
%save('Figure Data/Scatter_Dist_ROC_IndXI_Noisier_Data.mat')


