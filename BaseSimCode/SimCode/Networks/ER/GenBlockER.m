
function Networks = GenBlockER(SimPar)
    
    N = SimPar.N;
    Ne = SimPar.Ne;
    Ni = SimPar.Ni;
    
    Jm = SimPar.J / sqrt(N);
    Vm = SimPar.V / N;
    sm = sqrt(Vm);
    
    P = SimPar.P;
    
    if (sm(1,1) ~= 0) % use first element to decide
        Jmee_dist = makedist('normal',Jm(1,1),sm(1,1));
        Jmee_tdist = truncate(Jmee_dist,0,Inf); % Dale's Law
        Jmei_dist = makedist('normal',Jm(1,2),sm(1,2));
        Jmei_tdist = truncate(Jmei_dist,-Inf,0); % Dale's Law
        Jmie_dist = makedist('normal',Jm(2,1),sm(2,1));
        Jmie_tdist = truncate(Jmie_dist,0,Inf); % Dale's Law
        Jmii_dist = makedist('normal',Jm(2,2),sm(2,2));
        Jmii_tdist = truncate(Jmii_dist,-Inf,0); % Dale's Law

        J = [sparse(random(Jmee_tdist,[Ne Ne]).*binornd(1,P(1,1),Ne,Ne)) ...
             sparse(random(Jmei_tdist,[Ne Ni]).*binornd(1,P(1,2),Ne,Ni)); ...
             sparse(random(Jmie_tdist,[Ni Ne]).*binornd(1,P(2,1),Ni,Ne)) ...
             sparse(random(Jmii_tdist,[Ni Ni]).*binornd(1,P(2,2),Ni,Ni))];
    else
        J = [Jm(1,1) * binornd(1,P(1,1),Ne,Ne) ...
             Jm(1,2) * binornd(1,P(1,2),Ne,Ni); ...
             Jm(2,1) * binornd(1,P(2,1),Ni,Ne) ...
             Jm(2,2) * binornd(1,P(2,2),Ni,Ni)];
    end
    
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
        if (sxm(1) == 0) % Strange error that had never occured before...
            Jxme_tdist = Jxme_dist;
        else
            Jxme_tdist = truncate(Jxme_dist,0,Inf);
        end
        Jxmi_dist = makedist('normal',Jxm(2),sxm(2));
        if (sxm(2) == 0) % Strange error that had never occured before...
            Jxmi_tdist = Jxmi_dist;
        else
            Jxmi_tdist = truncate(Jxmi_dist,0,Inf);
        end

        Jx = [sparse(random(Jxme_tdist,[Ne Nx]).*binornd(1,Px(1),Ne,Nx));
              sparse(random(Jxmi_tdist,[Ni Nx]).*binornd(1,Px(2),Ni,Nx))];
        
        Networks.Jx = Jx;
    end


end

