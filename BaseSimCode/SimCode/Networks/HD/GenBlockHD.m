
% Sampling without replacement is encouraged as the replacement effectively
% multi-counts connection strengths yielding multiple modes in the
% precision distributions [not yet implemented]

function Networks = GenBlockHD(SimPar,InOrOut)
    
    if (nargin == 1) % InOrOut not passed
       warning('Option "InOrOut" not passed in GenBlockHDER. Defaulting to "in"')
       InOrOut = 'In';
    end

    switch InOrOut
        case 'In'
        case 'in'
        case 'Out'
        case 'out'
        otherwise
            error('Unknown "InOrOut" option (%s)!',InOrOut)
    end

    N = SimPar.N;
    Ne = SimPar.Ne;
    Ni = SimPar.Ni;
    
    Jm = SimPar.J / sqrt(N);
    Vm = SimPar.V / N;
    Sm = sqrt(Vm);
    
    degdist = trGP_SpecMean(SimPar); % special numerical method for getting exact moment matching
    
    D = round( random(degdist,[1 N]) ); % round is necessary for randsample (input must be integer)
    
    Didx = false(N);
    for i=1:N
        Didx(i,1:D(i)) = true;
    end
    
    % vectorized randsample
    [~, randidx] = sort(rand(N, N), 2);
    temp = randidx;
    temp(Didx == false) = 0;
    temp2 = temp';
    SampledInds_to = temp2(temp2 ~= 0);
    SampledInds_from = rude(D,1:N);
    
    Omega = zeros(N);
    
    switch InOrOut
        case {'in','In'}
            Omega(sub2ind([N N],SampledInds_from,SampledInds_to')) = 1;
        case {'out','Out'}
            Omega(sub2ind([N N],SampledInds_to,SampledInds_from')) = 1;
    end
    
    jpdee = makedist('normal',Jm(1,1),Sm(1,1));
    jdist = truncate(jpdee,0,Inf); % Dale's law
    Jmee = random(jdist,[Ne Ne]);

    jpdei = makedist('normal',Jm(1,2),Sm(1,2));
    jdist = truncate(jpdei,-Inf,0); % Dale's law
    Jmei = random(jdist,[Ne Ni]);
    
    jpdie = makedist('normal',Jm(2,1),Sm(2,1));
    jdist = truncate(jpdie,0,Inf); % Dale's law
    Jmie = random(jdist,[Ni Ne]);
    
    jpdii = makedist('normal',Jm(2,2),Sm(2,2));
    jdist = truncate(jpdii,-Inf,0); % Dale's law
    Jmii = random(jdist,[Ni Ni]);
    
    eIds = 1:Ne;
    iIds = (Ne+1):N;
    
    J = [sparse(Jmee.*Omega(eIds,eIds)) sparse(Jmei.*Omega(eIds,iIds)); ...
         sparse(Jmie.*Omega(iIds,eIds)) sparse(Jmii.*Omega(iIds,iIds))];
    J(1:(N+1):end) = 0; % remove any and all self-loops

    Networks = struct();
    Networks.J = J;


    %% Make FF net if requested
    % Jx is still classical ER
    if (isfield(SimPar,'Jx'))
        Nx = SimPar.Nx;
        
        Jxm = SimPar.Jx / sqrt(N);
        Vxm = SimPar.Vx / N;
        sxm = sqrt(Vxm);
        
        Px = SimPar.Px;
        
        % Strictly excitatory FF strength
        Jxme_dist = makedist('normal',Jxm(1),sxm(1));
        Jxme_tdist = truncate(Jxme_dist,0,Inf);
        Jxmi_dist = makedist('normal',Jxm(2),sxm(2));
        Jxmi_tdist = truncate(Jxmi_dist,0,Inf);

        Jx = [sparse(random(Jxme_tdist,[Ne Nx]).*binornd(1,Px(1),Ne,Nx));
              sparse(random(Jxmi_tdist,[Ni Nx]).*binornd(1,Px(2),Ni,Nx))];
        
        Networks.Jx = Jx;
    end


end

