
% Omega(i,j) = bern(P(i,j)), P(i,j) = k_P e^(-epsilon^2 / sigma_P^2)
% epsilon = |theta(i) - theta(j)|_w
% sigma_P = slight rescaling of spatial width

function Networks = GenBlockSpatial_RandJ(SimPar)
    
    N = SimPar.N;
    Ne = SimPar.Ne;
    Ni = SimPar.Ni;
    
    Jm = SimPar.J / sqrt(N);
    Vm = SimPar.V / N;
    sm = sqrt(Vm);
    
    P = SimPar.P;

    Pwidths = [SimPar.alphaEE SimPar.alphaEI ; SimPar.alphaIE SimPar.alphaII];
    
    % Get neuron orientations in deterministic manner
    Orient = [(1:Ne)/Ne (1:Ni)/Ni];
    
    % Get wrapped distance matrix epsilion
    epsilonSqr = zeros(N);
    
    for i=1:N
        for j=1:N
            epsilonSqr(i,j) = min( abs(Orient(i) - Orient(j)), 1 - abs(Orient(i) - Orient(j)) )^2;
        end
    end
    
    % Get distance Gaussians for J and P
    kP = P ./ (Pwidths .* erf(sqrt(pi) ./ (4 * Pwidths)));
    sigmaPSqr = 4 * Pwidths.^2 / pi;
    
    eIDs = 1:Ne;
    iIDs = (Ne+1):N;
    
    Jmee_dist = makedist('normal',Jm(1,1),sm(1,1));
    Jmee_tdist = truncate(Jmee_dist,0,Inf); % Dale's Law
    Jmei_dist = makedist('normal',Jm(1,2),sm(1,2));
    Jmei_tdist = truncate(Jmei_dist,-Inf,0); % Dale's Law
    Jmie_dist = makedist('normal',Jm(2,1),sm(2,1));
    Jmie_tdist = truncate(Jmie_dist,0,Inf); % Dale's Law
    Jmii_dist = makedist('normal',Jm(2,2),sm(2,2));
    Jmii_tdist = truncate(Jmii_dist,-Inf,0); % Dale's Law
    
    GP = zeros(N);
    GP(eIDs,eIDs) = kP(1,1) * exp(-epsilonSqr(eIDs,eIDs) / sigmaPSqr(1,1));
    GP(eIDs,iIDs) = kP(1,2) * exp(-epsilonSqr(eIDs,iIDs) / sigmaPSqr(1,2));
    GP(iIDs,eIDs) = kP(2,1) * exp(-epsilonSqr(iIDs,eIDs) / sigmaPSqr(2,1));
    GP(iIDs,iIDs) = kP(2,2) * exp(-epsilonSqr(iIDs,iIDs) / sigmaPSqr(2,2));
    
    % Make networks
    J = [sparse(random(Jmee_tdist,[Ne Ne]).*binornd(1,GP(eIDs,eIDs),Ne,Ne)) ...
         sparse(random(Jmei_tdist,[Ne Ni]).*binornd(1,GP(eIDs,iIDs),Ne,Ni)); ...
         sparse(random(Jmie_tdist,[Ni Ne]).*binornd(1,GP(iIDs,eIDs),Ni,Ne)) ...
         sparse(random(Jmii_tdist,[Ni Ni]).*binornd(1,GP(iIDs,iIDs),Ni,Ni))];
    J(1:(N+1):end) = 0; % Remove self-loops

    Networks = struct();
    Networks.J = J;

     
     %% Make FF net if requested
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


