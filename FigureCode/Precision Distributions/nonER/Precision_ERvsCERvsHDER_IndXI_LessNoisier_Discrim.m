
addpath(genpath('../../../Helpers'))
addpath(genpath('../../../BaseSimCode'))


%%
N = 5e3;
T = 1e3; % technically this goes unused until the explicit dynamics section
nSamples = 4; % multiple of number of cores, ideally

k1 = 2.5; % 'weak'
k2 = 1.25; % 'high noise'

ER_SubTypeDiscrims = zeros(9,nSamples);
CER_SubTypeDiscrims = zeros(9,nSamples);
HDERin_SubTypeDiscrims = zeros(9,nSamples);
HDERout_SubTypeDiscrims = zeros(9,nSamples);


%%
parfor (j=1:nSamples,2)
    %% Get Simulation Parameters and Generate Networks
    CER_SimPar = LoadBaseSimPar('Pyle2016_RealPart','CER','direct',N,T, 'Pscale',2, 'warn',false);
    CER_SimPar.J = CER_SimPar.psi * k1;
    CER_SimPar.V = CER_SimPar.psi.^2 * k2;

    CER_SimPar.rho = 0.2;
    
    HDER_SimPar = LoadBaseSimPar('Pyle2016_RealPart','HDER','direct',N,T, 'Pscale',2, 'warn',false);
    HDER_SimPar.J = HDER_SimPar.psi * k1;
    HDER_SimPar.V = HDER_SimPar.psi.^2 * k2;

    ERNetwork = GenBlockER(CER_SimPar);
    CERNetwork = GenBlockCER(CER_SimPar);
    HDERinNetwork = GenBlockHD(HDER_SimPar,'in');
    HDERoutNetwork = GenBlockHD(HDER_SimPar,'out');


    %% Get Adjacency Matrices
    ER_W = full(ERNetwork.J);
    CER_W = full(CERNetwork.J);
    HDERin_W = full(HDERinNetwork.J);
    HDERout_W = full(HDERoutNetwork.J);

    Ne = CER_SimPar.Ne;


    %% Get precision
    ER_prec = ER_W + ER_W' - (ER_W'*ER_W); % parentheses necessary to keep form symmetric
    CER_prec = CER_W + CER_W' - (CER_W'*CER_W);
    HDERin_prec = HDERin_W + HDERin_W' - (HDERin_W'*HDERin_W);
    HDERout_prec = HDERout_W + HDERout_W' - (HDERout_W'*HDERout_W);


    %% Extra EE unidir
    ER_BiDirIds = GetBiDirIds(ER_W,N,Ne);
    CER_BiDirIds = GetBiDirIds(CER_W,N,Ne);
    HDERin_BiDirIds = GetBiDirIds(HDERin_W,N,Ne);
    HDERout_BiDirIds = GetBiDirIds(HDERout_W,N,Ne);


    %% Get ROC for each subtype
    ER_means = GetEISubTypeMeans(ER_prec,ER_BiDirIds);
    ER_vars = GetEISubTypeVars(ER_prec,ER_BiDirIds);
    
    CER_means = GetEISubTypeMeans(CER_prec,CER_BiDirIds);
    CER_vars = GetEISubTypeVars(CER_prec,CER_BiDirIds);
    
    HDERin_means = GetEISubTypeMeans(HDERin_prec,HDERin_BiDirIds);
    HDERin_vars = GetEISubTypeVars(HDERin_prec,HDERin_BiDirIds);
    
    HDERout_means = GetEISubTypeMeans(HDERout_prec,HDERout_BiDirIds);
    HDERout_vars = GetEISubTypeVars(HDERout_prec,HDERout_BiDirIds);
    
    temp_ER_SubTypeDiscrims = GetEISubTypeDiscrim(ER_means,ER_vars);
    temp_CER_SubTypeDiscrims = GetEISubTypeDiscrim(CER_means,CER_vars);
    temp_HDERin_SubTypeDiscrims = GetEISubTypeDiscrim(HDERin_means,HDERin_vars);
    temp_HDERout_SubTypeDiscrims = GetEISubTypeDiscrim(HDERout_means,HDERout_vars);
    
    ER_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_ER_SubTypeDiscrims);
    CER_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_CER_SubTypeDiscrims);
    HDERin_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_HDERin_SubTypeDiscrims);
    HDERout_SubTypeDiscrims(:,j) = ExtractDiscrims(temp_HDERout_SubTypeDiscrims);
    
    
end


%%
lw = 2;
fs = 16;
set(0,'defaulttextInterpreter','latex')

ER_SubTypeDiscrims = abs(ER_SubTypeDiscrims);
CER_SubTypeDiscrims = abs(CER_SubTypeDiscrims);
HDERin_SubTypeDiscrims = abs(HDERin_SubTypeDiscrims);
HDERout_SubTypeDiscrims = abs(HDERout_SubTypeDiscrims);

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
p2 = bar(2,mean(CER_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(2,:));
p3 = bar(3,mean(HDERin_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(3,:));
p4 = bar(4,mean(HDERout_SubTypeDiscrims(1,:)),1, 'FaceColor',Colors(4,:));

bar(5,mean(ER_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(1,:))
bar(6,mean(CER_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(2,:))
bar(7,mean(HDERin_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(3,:))
bar(8,mean(HDERout_SubTypeDiscrims(2,:)),1, 'FaceColor',Colors(4,:))

bar(9,mean(ER_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(1,:))
bar(10,mean(CER_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(2,:))
bar(11,mean(HDERin_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(3,:))
bar(12,mean(HDERout_SubTypeDiscrims(4,:)),1, 'FaceColor',Colors(4,:))

bar(13,mean(ER_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(1,:))
bar(14,mean(CER_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(2,:))
bar(15,mean(HDERin_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(3,:))
bar(16,mean(HDERout_SubTypeDiscrims(5,:)),1, 'FaceColor',Colors(4,:))

bar(17,mean(ER_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(1,:))
bar(18,mean(CER_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(2,:))
bar(19,mean(HDERin_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(3,:))
bar(20,mean(HDERout_SubTypeDiscrims(7,:)),1, 'FaceColor',Colors(4,:))

bar(21,mean(ER_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(1,:))
bar(22,mean(CER_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(2,:))
bar(23,mean(HDERin_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(3,:))
bar(24,mean(HDERout_SubTypeDiscrims(8,:)),1, 'FaceColor',Colors(4,:))

bar(25,mean(ER_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(1,:))
bar(26,mean(CER_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(2,:))
bar(27,mean(HDERin_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(3,:))
bar(28,mean(HDERout_SubTypeDiscrims(9,:)),1, 'FaceColor',Colors(4,:))

title(strcat('e $\rightarrow$ e   e $\leftrightarrow$ e   i $\rightarrow$ i', ...
             'i $\leftrightarrow$ i   i $\rightarrow$ e   e $\rightarrow$ i', ...
             'e $\leftrightarrow$ i'))
ylabel('Discriminability')
axis([0.5 28.5 -Inf Inf])
box off
set(gca,'LineWidth',lw)
set(gca,'FontSize',fs)
%set(gca,'XTick',[1 2 3 4],'XTickLabel',{'ER','CER','HD-in','HD-out'});
legend([p1 p2 p3 p4],{'ER','CER','HD-in','HD-out'})


%%
%clear W SubTypeROCs BiDirIds SubTypeValues prec
%save('Figure Data/Scatter_Dist_ROC_IndXI_Noisier_Data.mat')


