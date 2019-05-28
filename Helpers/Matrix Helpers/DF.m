
% DFCov = DF(mat,Inds,Ne)
%
% Takes the mean-field of the covariance or adjacency matrix "mat".

% The "Inds" are really only required to identify the neuron type (E/I) in 
% the event that some subpopulation is being considered. For example, if
% the covariance matrix estimation is being done on neurons with > 1 Hz 
% firing rate, which may not include the entire population.

function DFCov = DF(mat,Inds,Ne)
    
    nc = numel(Inds);
    
    eInds = (Inds<=Ne);
    iInds = (Inds>Ne);

    Diag = mat(1:(nc+1):end); % For ignoring diagonal elements...
    
    EDiag = Diag(eInds);
    IDiag = Diag(iInds);

    DFCov = zeros(1,2);
    DFCov(1) = mean(EDiag);
    DFCov(2) = mean(IDiag);
    
    warning('DF will be removed in future release. See doc MF for more details.')
end

