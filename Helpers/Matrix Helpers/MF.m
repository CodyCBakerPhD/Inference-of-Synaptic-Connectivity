
% [MF,MDF] = MF(mat,Inds,Ne)
%
% Returns the 2x2 mean-field and mean-diagonal-field of the matrix subset
% by 'Inds' with block-wise splitting point 'Ne'.

% The "Inds" are really only required to identify the neuron type (E/I) in 
% the event that some subpopulation is being considered. For example, if
% the covariance matrix estimation is being done on neurons with > 1 Hz 
% firing rate, which may not include the entire population.

function [MF,MDF] = MF(mat,Inds,Ne)
    
    nc = numel(Inds);
    
    eInds = find(Inds<=Ne);
    iInds = find(Inds>Ne);
    
    Diag = mat(1:(nc+1):nc^2); % For ignoring diagonal elements...
    mat(1:(nc+1):nc^2) = inf;

    EE = mat(eInds,eInds);
    EI = mat(eInds,iInds);
    IE = mat(iInds,eInds);
    II = mat(iInds,iInds);

    MF = zeros(2);
    MF(1,1) = mean( EE(EE ~= inf) );
    MF(1,2) = mean( EI(:) ); % No diagonal to remove...
    MF(2,1) = mean( IE(:) );
    MF(2,2) = mean( II(II ~= inf) );
    
    EDiag = Diag(eInds);
    IDiag = Diag(iInds);

    MDF = zeros(1,2);
    MDF(1) = mean(EDiag);
    MDF(2) = mean(IDiag);
end

