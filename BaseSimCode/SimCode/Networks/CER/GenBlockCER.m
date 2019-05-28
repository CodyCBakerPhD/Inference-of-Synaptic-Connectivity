
% v2: Removed support for blockwise P structure

function Networks = GenBlockCER(SimPar)
    
    N = SimPar.N;
    Ne = SimPar.Ne;
    Ni = SimPar.Ni;

    Jm = SimPar.J;
    Vm = SimPar.V;
    
    Pbar = mean(SimPar.P(:)); % Current version does not support blockwise P
    
    rho = SimPar.rho; % correlation between synaptic strength and degrees
    varbin = 2 * N * Pbar * (1 - Pbar);
    omega = Vm / 2;
        
    s = rho * sqrt(omega * varbin);
    aE = sqrt(omega(1,1) * omega(2,1));
    aI = sqrt(omega(1,2) * omega(2,2));

    sig1 = [omega(1,1) aE s(1,1); aE omega(2,1) s(2,1); s(1,1) s(2,1) varbin];
    sig2 = [omega(1,2) aI s(1,2); aI omega(2,2) s(2,2); s(1,2) s(2,2) varbin];

    low1 = [-Jm(1,1); -Jm(2,1); -Inf];
    up1 = [Inf; Inf; Inf];

    low2 = [-Inf; -Inf; -Inf];
    up2 = [-Jm(1,2); -Jm(2,2); Inf];

    [Lfull1,~,~,~] = cholperm(sig1,low1,up1); % outputs the permutation
    D = diag(Lfull1);
    while (any(D < eps))
        warning('Excitatory CER hierarchical covariance is not well-conditioned; applying regularization!')
        sig2 = sig2 + 0.01 * eye(3);
        [Lfull2,~,~,~] = cholperm(sig2,low2,up2); % outputs the permutation
        D = diag(Lfull2);
    end

    [Lfull2,~,~,~] = cholperm(sig2,low2,up2); % outputs the permutation
    D = diag(Lfull2);
    while (any(D < eps))
        warning('Inhibitory CER hierarchical covariance is not well-conditioned; applying regularization!')
        sig2 = sig2 + 0.01 * eye(3);
        [Lfull2,~,~,~] = cholperm(sig2,low2,up2); % outputs the permutation
        D = diag(Lfull2);
    end

    eta_d_E = [Jm(1,1) Jm(2,1) N*Pbar] + mvrandn(low1,up1,sig1,Ne)';
    eta_d_I = [Jm(1,2) Jm(2,2) N*Pbar] + mvrandn(low2,up2,sig2,Ni)';

    etaEE = eta_d_E(:,1);
    etaIE = eta_d_E(:,2);
    etaEI = eta_d_I(:,1);
    etaII = eta_d_I(:,2);
    d = [eta_d_E(:,3); eta_d_I(:,3)];
    clear eta_d_E eta_d_I
    
    % Need to add truncation
    Jee = mvnrnd(etaEE,ones(1,Ne)*omega(1,1),Ne);
    Jei = mvnrnd(etaEI,ones(1,Ni)*omega(1,2),Ne);
    Jie = mvnrnd(etaIE,ones(1,Ne)*omega(2,1),Ni);
    Jii = mvnrnd(etaII,ones(1,Ni)*omega(2,2),Ni);
    P = repmat(d'/N,[N 1]); % out degs
    
    eIDs = 1:Ne;
    iIDs = (Ne+1):N;

    J = [sparse(Jee.*binornd(1,P(eIDs,eIDs),Ne,Ne)) sparse(Jei.*binornd(1,P(eIDs,iIDs),Ne,Ni)); ...
         sparse(Jie.*binornd(1,P(iIDs,eIDs),Ni,Ne)) sparse(Jii.*binornd(1,P(iIDs,iIDs),Ni,Ni))] ...
                                                                                          / sqrt(N);
    J(1:(N+1):end) = 0; % remove self-loops

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

