
function SimPar = LoadPyle2016_RealPart(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn)

    SimPar = struct();
    SimPar.NetType = NetType;
    SimPar.FFType = FFType;
    
    XIcheck = ( ~strcmp(FFType,'direct') );
    

    %% ------------------------- RECURRENT NETWORK PARAMETERS -------------------------- %

    % Ratio of neurons in exc, inh, ffwd pops
    SimPar.qe = 0.8;
    SimPar.qi = 0.2;
    
    % Number of neuronsThe rounding is to enfoce integer conditions later on...
    SimPar.N = N;
    SimPar.Ne = round(N * SimPar.qe);
    SimPar.Ni = N - SimPar.Ne;

    % Synaptic proportions and weights
    SimPar.psi = [0.1 -0.6; 0.45 -1];
    
    SimPar.k1 = 500 * Fscale / Pscale;
    SimPar.k2 = 0; % Original paper had fixed synaptic strengths
    
    SimPar.J = SimPar.psi * SimPar.k1; % mV
    SimPar.V = SimPar.psi.^2 * SimPar.k2; % mV^2
    
    % Connection probabilities
    SimPar.P = [0.05 0.05; 0.05 0.05] * Pscale;
    
    switch NetType
        case 'CER'
            SimPar.k2 = 0.2 * SimPar.k1; % CER needs non-zero k2 to work, so defaults to 20% of k1
            SimPar.V = SimPar.J.^2 * SimPar.k2;
            
            SimPar.rho = 0.2; % Global default for CER
        case 'HDER'
            SimPar.xi = 1/4;
            SimPar.mu = 5;
        case 'Spatial'
            SimPar.alphaEE = 0.1;
            SimPar.alphaEI = 0.1;
            SimPar.alphaIE = 0.05;
            SimPar.alphaII = 0.05;
            
            if (XIcheck)
                SimPar.alphaEX = 0.1;
                SimPar.alphaIX = 0.1;
            end
    end
    
    %------------------------ END NETWORK PARAMETERS -------------------------%


    %% -------------------------- FF NET PARAMETERS -------------------------- %
    
    if (XIcheck) % not direct input
        SimPar.qx = 0.2 * qxscale;
        SimPar.Nx = round(N * SimPar.qx);
            
        SimPar.kx1 = 270 * Fscale / (Pscale * qxscale);
        SimPar.kx2 = 0; % Original paper used direct, to this is just for consistency with k2
        
        SimPar.psix = [4/3; 1];
        
        SimPar.Jx = SimPar.psix * SimPar.kx1; % mV
        SimPar.Vx = SimPar.psix.^2 * SimPar.kx2; % mV^2
        
        SimPar.Px = [0.05; 0.05] * Pscale;
    end
    
    switch FFType
        case 'direct'
            SimPar.F = [0.036; 0.027] * Fscale * sqrt(N);
            SimPar.SigmaE = 0.09; % mv/ms - magnitude constant over N, chosen to match MF of asynch
            SimPar.SigmaI = 0.0675; % mv/ms
        case 'asynchronous'
            % Mean rate of neurons in ffwd pop
            SimPar.rx = 0.01; % kHz
        case 'correlated'
            % Mean rate of neurons in ffwd pop
            SimPar.rx = 0.01; % kHz
            SimPar.c = 0.1; % Global default for MIP
            SimPar.jitter = 5; % ms, technically just the std of a zero-mean Gaussian
    end

    %------------------------- END FF NET PARAMETERS -------------------------%


    %% --------------------------- TIME PARAMETERS --------------------------- %
    
    SimPar.T = T;
    SimPar.Tburn = 500; % ms
    SimPar.dt = .1;
    SimPar.Nt = round(T/SimPar.dt);
    SimPar.NtBurn = round( (T-SimPar.Tburn) / SimPar.dt);

    %------------------------- END TIME PARAMETERS ---------------------------%


    %% -------------------------- NEURON PARAMETERS -------------------------- %
    NeuronParams = struct();
    
    NeuronParams.Cme = 1; % Cm=1 and gL=1/taum gives the correct leak
    NeuronParams.Cmi = NeuronParams.Cme;
    NeuronParams.gLe = 1/15; % reciprocate due to convenience notation
    NeuronParams.gLi = NeuronParams.gLe;
    NeuronParams.ELe = -72;
    NeuronParams.ELi = NeuronParams.ELe;
    NeuronParams.Vth = -50;
    NeuronParams.Vre = -75;
    NeuronParams.Vlb = -100; % Effectively no lower boundary on voltage
    NeuronParams.tauref = 0.5;  % No refractory period
    NeuronParams.DeltaT = 2; % This is for EIF, won't matter for LIF
    NeuronParams.VT = -55; % If VT-Vth>>DeltaT, then the EIF is effectively LIF
    NeuronParams.a = 0;
    NeuronParams.b = 0;
    NeuronParams.tauw = 150;
    
    % Synaptic timescales
    NeuronParams.taue = 8;
    NeuronParams.taui = 4;
    NeuronParams.taux = 10;
    
    SimPar.NeuronParams = NeuronParams;

    % Random initial voltages - for Spiking simulations
    SimPar.V01 = rand(sum(N),1) * (NeuronParams.Vth - NeuronParams.Vre) + NeuronParams.Vre;

    %------------------------ END NEURON PARAMETERS --------------------------%


    %% ------------------------ FORM SIMPAR STRUCT ---------------------------- %

    % Check the PSP's and warn if not in range
    v=GetPSP(SimPar.NeuronParams.Cme,SimPar.NeuronParams.taue,0,SimPar.J(1,1), ...
                 SimPar.NeuronParams.gLe,SimPar.NeuronParams.ELe,100,SimPar.dt);EEPSP=max(v)-min(v);
    v=GetPSP(SimPar.NeuronParams.Cme,SimPar.NeuronParams.taue,0,SimPar.J(2,1), ...
                 SimPar.NeuronParams.gLe,SimPar.NeuronParams.ELe,100,SimPar.dt);IEPSP=max(v)-min(v);
    v=GetPSP(SimPar.NeuronParams.Cmi,SimPar.NeuronParams.taui,0,SimPar.J(1,2), ...
                 SimPar.NeuronParams.gLi,SimPar.NeuronParams.ELi,100,SimPar.dt);EIPSP=max(v)-min(v);
    v=GetPSP(SimPar.NeuronParams.Cmi,SimPar.NeuronParams.taui,0,SimPar.J(2,2), ...
                 SimPar.NeuronParams.gLi,SimPar.NeuronParams.ELi,100,SimPar.dt);IIPSP=max(v)-min(v);
                                                        
    SimPar.PSPs = [EEPSP EIPSP; IEPSP IIPSP];
    
    if (XIcheck)
        v=GetPSP(SimPar.NeuronParams.Cme,SimPar.NeuronParams.taux,0,SimPar.Jx(1), ...
                 SimPar.NeuronParams.gLe,SimPar.NeuronParams.ELe,100,SimPar.dt);EXPSP=max(v)-min(v);
        v=GetPSP(SimPar.NeuronParams.Cme,SimPar.NeuronParams.taux,0,SimPar.Jx(2), ...
                 SimPar.NeuronParams.gLe,SimPar.NeuronParams.ELe,100,SimPar.dt);IXPSP=max(v)-min(v);
        SimPar.PSPXs = [EXPSP; IXPSP];
    end

    if ( (any(SimPar.PSPs(:) < 0.1) || any(SimPar.PSPs(:) > 1)) && warn == true )
        warning('PSPs may fall outside normal range - check values!')
    end
    
    
end

