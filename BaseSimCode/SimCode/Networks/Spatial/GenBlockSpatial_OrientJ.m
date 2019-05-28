
% Omega(i,j) = bern(P(i,j)), P(i,j) = k_P e^(-epsilon^2 / sigma_P^2)
% epsilon = |theta(i) - theta(j)|_w
% sigma_P = slight rescaling of spatial width

function Networks = GenBlockSpatial_OrientJ(SimPar)

    N = SimPar.N;
    Ne = SimPar.Ne;
    Ni = SimPar.Ni;
    
    Jm = SimPar.J / sqrt(N);
    Vm = SimPar.V / N;
    
    P = SimPar.P;
    
    Jwidths = [SimPar.alphaEE SimPar.alphaEI ; SimPar.alphaIE SimPar.alphaII];
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
    kJ = Jm ./ (Jwidths * erf(sqrt(pi) ./ (4 * Jwidths)));
    sigmaJSqr = 4 * Jwidths.^2 / pi;
    kP = P ./ (Pwidths * erf(sqrt(pi) ./ (4 * Pwidths)));
    sigmaPSqr = 4 * Pwidths.^2 / pi;
    
    eIDs = 1:Ne;
    iIDs = (Ne+1):N;
    
    GJ = zeros(N);
    GJ(eIDs,eIDs) = kJ(1,1) * exp(-epsilonSqr(eIDs,eIDs) / sigmaJSqr(1,1));
    GJ(eIDs,iIDs) = kJ(1,2) * exp(-epsilonSqr(eIDs,iIDs) / sigmaJSqr(1,2));
    GJ(iIDs,eIDs) = kJ(2,1) * exp(-epsilonSqr(iIDs,eIDs) / sigmaJSqr(2,1));
    GJ(iIDs,iIDs) = kJ(2,2) * exp(-epsilonSqr(iIDs,iIDs) / sigmaJSqr(2,2));
    
    GP = zeros(N);
    GP(eIDs,eIDs) = kP(1,1) * exp(-epsilonSqr(eIDs,eIDs) / sigmaPSqr(1,1));
    GP(eIDs,iIDs) = kP(1,2) * exp(-epsilonSqr(eIDs,iIDs) / sigmaPSqr(1,2));
    GP(iIDs,eIDs) = kP(2,1) * exp(-epsilonSqr(iIDs,eIDs) / sigmaPSqr(2,1));
    GP(iIDs,iIDs) = kP(2,2) * exp(-epsilonSqr(iIDs,iIDs) / sigmaPSqr(2,2));
    
    % Make networks
    J = [sparse(GJ(eIDs,eIDs).*binornd(1,GP(eIDs,eIDs),Ne,Ne)) ...
         sparse(GJ(eIDs,iIDs).*binornd(1,GP(eIDs,iIDs),Ne,Ni)); ...
         sparse(GJ(iIDs,eIDs).*binornd(1,GP(iIDs,eIDs),Ni,Ne)) ...
         sparse(GJ(iIDs,iIDs).*binornd(1,GP(iIDs,iIDs),Ni,Ni))];
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


