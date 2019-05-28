
% This version does not allow voltage recording

function [s,sx,mTotalInput,V0] = EIFSim(SimPar,W,varargin)
    
    nvarargin = numel(varargin);
    
    % ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nvarargin,2) ~= 0 )
        error('Additional arguments to EIFSim must be passed as Name-Value pairings!')
    end
    % ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    % --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 2) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
                
        switch opts{i}
            case 'Wx'
                Wx = varargin{2*i};
            otherwise
                error('Unknown function option (%s) in LoadBaseSimPar.',opts{i})
        end
    end
    % ---------------- END ARGUMENT READ-IN ---------------- %
    

    
    % -------------- BEGIN DEFAULT ASSIGNMENT AND ERROR CHECKING -------------- %
    if ( ~exist('Wx','var') && ...  % Argument not specified
                      (strcmp(SimPar.FFType,'correlated') || strcmp(SimPar.FFType,'asynchronous')) )
        error('You must pass the feedforward network Wx since an external spiking type is specified!')
    end
    % --------------- END DEFAULT ASSIGNMENT AND ERROR CHECKING --------------- %

    
    %% Extract Simulation Parameters
    N = SimPar.N;
    Ne = SimPar.Ne;
    Ni = SimPar.Ni;
    T = SimPar.T;

    Cm = SimPar.NeuronParams.Cme;
    gL = SimPar.NeuronParams.gLe; % SimPar supports population based neuron parameters, but EIFSim does not
    EL = SimPar.NeuronParams.ELe;
    DeltaT = SimPar.NeuronParams.DeltaT;
    VT = SimPar.NeuronParams.VT;
    Vre = SimPar.NeuronParams.Vre;
    Vlb = SimPar.NeuronParams.Vlb;
    Vth = SimPar.NeuronParams.Vth;
    
    a = SimPar.NeuronParams.a;
    b = SimPar.NeuronParams.b;
    
    tauref = SimPar.NeuronParams.tauref;
    tauw = SimPar.NeuronParams.tauw;
    taue = SimPar.NeuronParams.taue;
    taui = SimPar.NeuronParams.taui;
    taux = SimPar.NeuronParams.taux;
    
    sigmae = SimPar.sigmae;
    sigmai = SimPar.sigmai;
    
    
    %% Feedforward type
    switch SimPar.FFType
        case 'correlated'
            % Make correlated Poisson spike times for ffwd layer
            sx = GenMIPSpikes(SimPar);
            nspikeX = size(sx,2);
    end


    % Maximum number of spikes for all neurons in simulation. Default is 50Hz across all neurons.
    % If there are more spikes, the simulation will terminate.
    maxns = ceil(.05 * N * T);


    %% Initialize
    
    % Indices of neurons from which to record currents, voltages; hardcoded
    Irecord = 1:N;
    numrecord = numel(Irecord);

    dt = SimPar.dt;
    time = dt:dt:T;
    
    % Time discretization of recordings. This can be coarser than the dt for the Euler solver.
    % If so, it will record the average current across each coarser time bin; hardcoded
    dtRecord = 250;
    nBinsRecord = round(dtRecord / dt);
    timeRecord = dtRecord:dtRecord:T;
    Ntrec = numel(timeRecord);
    
    Ie = zeros(N,1);
    Ii = zeros(N,1);
    Ix = zeros(N,1);
    w = zeros(N,1);
    IeRec = zeros(numrecord,Ntrec);
    IiRec = zeros(numrecord,Ntrec);
    IxRec = zeros(numrecord,Ntrec);
    
    iXspike = 1;
    s = zeros(2,maxns);
    nspike = 0;
    TooManySpikes = 0;
    
    % Integer division function
    IntDivide = @(n,k)(floor((n-1)/k)+1);
    
    refstate = zeros(N,1);
    Ntref = floor(tauref / dt);

    %% Random initial voltages
    V0 = rand(N,1) * (VT - Vre) + Vre;
    V = V0;
    
    
    %% Euler solver
    switch SimPar.FFType
        case {'correlated','asynchronous'}
            for i=1:numel(time)
                
                refstate = max(refstate - 1,0);
                    
                % Store recorded variables
                ii = IntDivide(i,nBinsRecord); 
                IeRec(:,ii) = IeRec(:,ii) + Ie(Irecord);
                IiRec(:,ii) = IiRec(:,ii) + Ii(Irecord);
                IxRec(:,ii) = IxRec(:,ii) + Ix(Irecord);
        
                % Additive noise
                noise = [sigmae*randn(Ne,1); sigmai*randn(Ni,1)] * sqrt(dt / Cm);

                % Euler update to V
                V = V + (dt / Cm) * (Ie + Ii + Ix ...
                                + gL * (EL-V) + gL * DeltaT * exp((V - VT) / DeltaT) - w) + noise;
                V = max(V,Vlb);
                
                V(refstate ~= 0) = Vre;
    
                w = w + (dt / tauw) * (a * (V - EL) - w);

                % Find which neurons spiked
                Ispike = find(V >= Vth);

                % Euler update to synaptic currents
                Ie = Ie - dt * Ie / taue;
                Ii = Ii - dt * Ii / taui;
                Ix = Ix - dt * Ix / taux;

                % If there are spikes
                if(~isempty(Ispike))

                    % Store spike times and neuron indices
                    if(nspike + numel(Ispike) <= maxns)
                        s(1,nspike+1:nspike+numel(Ispike)) = time(i);
                        s(2,nspike+1:nspike+numel(Ispike)) = Ispike;
                    else
                        TooManySpikes = 1;
                        break;
                    end

                    % Reset mem pot.
                    V(Ispike) = Vre;
                    
                    % Increment adaptation variable
                    w(Ispike) = w(Ispike) + b;
        
                    refstate(Ispike) = Ntref;

                    % Update synaptic currents
                    Ie = Ie + sum(W(:,Ispike(Ispike <= Ne)),2) / taue;
                    Ii = Ii + sum(W(:,Ispike(Ispike > Ne)),2) / taui;

                    % Update cumulative number of spikes
                    nspike = nspike + numel(Ispike);
                end

                % Propogate ffwd spikes
                while(sx(1,iXspike) <= time(i) && iXspike < nspikeX)
                    jpre = sx(2,iXspike);
                    Ix = Ix + Wx(:,jpre) / taux;
                    iXspike = iXspike + 1;
                end
            end
            if(TooManySpikes)
                warning('\nMax number spikes exceeded, simulation terminated at time t=%1.1f.\n',dt*i)
            end
            
            IeRec = IeRec / nBinsRecord; % Normalize recorded variables by # bins
            IiRec = IiRec / nBinsRecord;
            IxRec = IxRec / nBinsRecord;
    
            s = s(:,1:nspike); % Get rid of padding in s
    end
    
    mTotalInput = mean(IxRec + IeRec + IiRec,2);
end

