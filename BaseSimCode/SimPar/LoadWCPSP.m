
% For weakly coupled (WC) post-synaptic potential (PSP) optimized networks.
% Really only supports up to N=3e2.

function SimPar = LoadWCPSP(NetType,FFType,N,T)
    
    ProjName = 'Functional Connectivity'; % Where it saves...
    ExpName = 'Benchmarks';
    
    NeurType = 'TrousdalePSP'; % Just a name, really...
    % Corresponds to this setSimPar file!

    warn = true; % if you want to see warnings or not, mainly for new PSP stuff

    % ------------------------- NETWORK PARAMETERS -------------------------- %

    % Number of neurons in exc, inh, ffwd pops
    % The rounding is to enfoce integer conditions later on...
    qe = 0.8;
    qi = 0.2;
    qf = 0.05; % need to keep Nf non zero for C code...
    
    Ne = round(N * qe);
    Ni = N - Ne;
    Nf = round(N * qf);

    % Synaptic weights
    FScale = 1.5;
    denserScale = 8;

    J = [2 -1.1; 1.2 -1.6]; % ||(J .* p) * r || must be << ||F||
    Jf = [120; 120] * FScale / sqrt(N); % mV
    % Jf calculated from Mathematica script on CRC

    % Connection probabilities
    P = [0.05 0.05; 0.05 0.05] * denserScale;
    Pf = [0.05; 0.05] * denserScale; % higher than 1 means lots of multi-edges

    % in and out degrees - only used with NetType = 'InOut'
    inDegDist = 'exp';
    outDegDist = 'bin';

    % Spatial widths
    alphaEE=.05;
    alphaEI=.05;
    alphaIE=.05;
    alphaII=.05;
    alphaEF=.1;
    alphaIF=.1;

    % Small world stuff
    beta = 0.02; % re-wiring probability...

    % Clustered stuff - EE only...
    numClusters = 3;
    REE = 2.5; % ratio of pin / pout

    %------------------------ END NETWORK PARAMETERS -------------------------%



    % -------------------------- FF NET PARAMETERS -------------------------- %

    % Mean rate of neurons in ffwd pop
    rf = 0.005; % 1/ms
    c = 0.1; % Correlation of processes

    % jitter to spike times - only used if using MIP
    jitter = 5; % ms, technically just the std of a zero-mean Gaussian

    % Noise options
    % SigmaE = 0.03 * FScale * sqrt(N); % mv/ms - magnitude chosen to match with F
    % SigmaI = 0.03 * FScale * sqrt(N); % mv/ms

    SigmaE = 3; % mv/ms - magnitude constant over N, chosen to match F at N=1e4
    SigmaI = 3; % mv/ms


    F = [0.2; 0.2] * sqrt(N); % No longer any sqrt(N) on this

    %------------------------- END FF NET PARAMETERS -------------------------%



    % --------------------------- TIME PARAMETERS --------------------------- %

    % Long Time update
    maxT = T; % Specifiable, but should evenly divide T.

    Tburn = 500;
    dt = 0.1;
    Nt = round(maxT/dt);
    NTburn = round( (maxT-Tburn) / dt);

    %------------------------- END TIME PARAMETERS ---------------------------%



    % -------------------------- NEURON PARAMETERS -------------------------- %

    % The code is for an EIF, but params can be made into those for an LIF
    Cme=1; % Cm=1 and gL=1/taum gives the correct leak
    Cmi=Cme;
    gLe=1/15; % reciprocate due to convenience notation
    gLi=gLe;
    ELe=-72;
    ELi=ELe;
    Vth=-50; % much higher than previous...
    Vre=-75;
    Vlb=-100; % Effectively no lower boundary on voltage
    tauref=0.5;  % No refractory period
    Iapp=0;    % No external input (put E0 term here to use it)
    DeltaT=2;  % This is for EIF, won't matter for LIF
    VT=-55;    % If VT-Vth>>DeltaT, then the EIF is effectively LIF
    a=0;
    b=0;
    tauw=150;

    % Need to store params into a vector with E and I params on each row
    NeuronParams=[Cme gLe ELe Vth Vre Vlb tauref Iapp DeltaT VT a b tauw;
                  Cmi gLi ELi Vth Vre Vlb tauref Iapp DeltaT VT a b tauw];

    % Synaptic timescales
    tauF=10;
    taue=8;
    taui=4;

    % Random initial voltages
    V01 = rand(sum(N),1) * (Vth - Vre) + Vre;

    %------------------------ END NEURON PARAMETERS --------------------------%



    %------------------------ FORM SIMPAR STRUCT -----------------------------%

    % Check the PSP's and warn if not in range
    v=GetPSP(Cme,taue,0,J(1,1),gLe,ELe,100,dt);EEPSP=max(v)-min(v);
    v=GetPSP(Cme,taue,0,J(2,1),gLe,ELe,100,dt);IEPSP=max(v)-min(v);
    v=GetPSP(Cmi,taui,0,J(1,2),gLi,ELi,100,dt);EIPSP=max(v)-min(v);
    v=GetPSP(Cmi,taui,0,J(2,2),gLi,ELi,100,dt);IIPSP=max(v)-min(v);
    v=GetPSP(Cme,tauF,0,Jf(1),gLe,ELe,100,dt);EFPSP=max(v)-min(v);
    v=GetPSP(Cme,tauF,0,Jf(2),gLe,ELe,100,dt);IFPSP=max(v)-min(v);

    PSPs = [EEPSP EIPSP; IEPSP IIPSP];
    PSPFs = [EFPSP; IFPSP];

    if ( any(PSPs(:) < 0.1) || any(PSPs(:) > 1) && warn == true )
        warning('PSPs may fall outside normal range - check values!')
    end



    % Basic struct
    SimPar = struct( ...
        ... % Saving parameers ...
        'ProjName',ProjName, 'ExpName',ExpName, ...
        ... % Network parameters ...
        'NetType',NetType, 'Ne',Ne, 'Ni',Ni, 'Nf',Nf, 'N',N, ...
        'J',J, 'Jf',Jf, 'P',P, 'Pf',Pf, ...
        'qe',qe, 'qi',qi, 'qf',qf, ...
        'inDegDist',inDegDist, 'outDegDist',outDegDist, ...
        'alphaEE',alphaEE, 'alphaEI',alphaEI, 'alphaIE',alphaIE, ...
        'alphaII',alphaII, 'alphaEF',alphaEF, 'alphaIF',alphaIF, ...
        'beta',beta, ...
        'numClusters',numClusters', 'REE',REE, ...
        'PSPs',PSPs, 'PSPFs',PSPFs, ...
        ... % FF Net parameters ...
        'FFType',FFType, 'rf',rf, 'c',c, 'jitter',jitter, ...
        ... % Time parameters ...
        'T',T, 'Tburn',Tburn, 'dt',dt, 'Nt',Nt, 'NTburn',NTburn, 'maxT',maxT, ...
        ... % Neuron parameters ...
        'NeurType',NeurType, 'NeuronParams',NeuronParams, 'tauF',tauF, ...
        'taue',taue, 'taui',taui, ...
        'V01',V01, 'SigmaE',SigmaE, 'SigmaI',SigmaI, 'F',F);
end

