
function sx = GenMIPSpikes(SimPar)
    
    rx = SimPar.rx;
    c = SimPar.c;
    T = SimPar.T;
    Nx = SimPar.Nx;
    taujitter = SimPar.jitter;
    
    % Make correlated Poisson spike times for ffwd layer
    rm = rx / c; % Firing rate of mother process
    nstm = poissrnd(rm * T); % Number of mother spikes
    stm = rand(nstm,1) * T; % spike times of mother process    
    maxnsx = T * rx * Nx * 1.2; % Max num spikes
    sx = zeros(2,maxnsx);
    ns = 0;
    
    for j=1:Nx  % For each ffwd spike train
        ns0 = binornd(nstm,c); % Number of spikes for this spike train
        st = randsample(stm,ns0); % Sample spike times randomly
        st = st + taujitter * randn(size(st)); % jitter spike times
        st = st(st > 0 & st < T); % Get rid of out-of-bounds times
        ns0 = numel(st); % Re-compute spike count
        sx(1,ns+1:ns+ns0) = st; % Set the spike times and indices        
        sx(2,ns+1:ns+ns0) = j;
        ns = ns + ns0;
    end
    
    % Get rid of padded zeros
    sx = sx(:,sx(1,:)>0);
    
    % Sort by spike time
    [~,I] = sort(sx(1,:));
    sx = sx(:,I);
    nspikeX = size(sx,2);
end

