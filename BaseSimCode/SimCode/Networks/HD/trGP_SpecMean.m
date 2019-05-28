
function [trd,numIter] = trGP_SpecMean(SimPar,NMAX,TOL)

    switch nargin
        case 1
            NMAX = 1e3;
            TOL = 1e-7;
        case 2
            if (floor(NMAX) == NMAX) % passed arg is NMAX. TOL is not assumed to be an integer.
                TOL = 1e-7;
            else
                NMAX = 1e3;
                TOL = NMAX;
            end
    end

    N = SimPar.N;
    xi = SimPar.xi;
    mu = SimPar.mu;
    
    Pbar = mean(SimPar.P(:));
    
    
    % Get initial guess for a
    siga = (Pbar*N-mu)*(1-xi);

    d = makedist('GeneralizedPareto',xi,siga,mu);
    trd = truncate(d,mu,N);
    
    ma = trd.mean / N;
    
    
    % Get initial guess for b
    sigb = siga * 1.1;
    
    d = makedist('GeneralizedPareto',xi,sigb,mu);
    trd = truncate(d,mu,N);
    
    mb = trd.mean / N;
    
    j = 1;
    while mb <= Pbar
        sigb = siga * (1.1 + j * 0.1);
        j = j + 1;
        
        d = makedist('GeneralizedPareto',xi,sigb,mu);
        trd = truncate(d,mu,N);
    
        mb = trd.mean / N;
        
        if (mb > 1)
            error('mb loop exceeded bound!')
        end
    end
    
    
    % Bisect to find optimal sig for target m / N of p
    NMAX = 1e3; TOL = 1e-7;
    
    numIter = 1;
    while numIter <= NMAX
        sigc = (siga + sigb) / 2;
        
        d = makedist('GeneralizedPareto',xi,sigc,mu);
        trd = truncate(d,mu,N);
    
        mc = trd.mean / N;
        
        if ((mc - Pbar) == 0) || ((sigb - siga) / 2 < TOL)
            break
        end
        
        numIter = numIter + 1;
        
        if (sign(mc - Pbar) == sign(ma - Pbar))
            siga = sigc;
        else
            sigb = sigc;
        end
    end
    
    if numIter > NMAX
        error('bisection hit NMAX!')
    end 
end

