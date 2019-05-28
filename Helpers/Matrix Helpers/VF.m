
% [VF,VDF] = MF(mat,Inds,Ne)
%
% Takes the variance-field and variance-diagonal-field of 'mat'.

% The "Inds" are really only required to identify the neuron type (E/I) in 
% the event that some subpopulation is being considered. For example, if
% the covariance matrix estimation is being done on neurons with > 1 Hz 
% firing rate, which may not include the entire population.

function [VF,VDF] = VF(mat,Inds,Ne)
    
    N = numel(Inds);
    Ni = N - Ne;
    
    eInds = find(Inds<=Ne);
    iInds = find(Inds>Ne);
    
    Diag = mat(1:(N+1):N^2);

    EE = mat(eInds,eInds);
    EE = EE( logical(triu(ones(Ne),1)) ); % extract upper diagonal
    EI = mat(eInds,iInds);
    IE = mat(iInds,eInds);
    II = mat(iInds,iInds);
    II = II( logical(triu(ones(Ni),1)) ); % extract upper diagonal

    VF = zeros(2);
    VF(1,1) = var( EE );
    VF(1,2) = var( EI(:) ); % No diagonal to remove...
    VF(2,1) = var( IE(:) );
    VF(2,2) = var( II );
    
    EDiag = Diag(eInds);
    IDiag = Diag(iInds);

    VDF = zeros(1,2);
    VDF(1) = var(EDiag);
    VDF(2) = var(IDiag);
end

