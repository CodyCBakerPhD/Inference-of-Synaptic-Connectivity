
% [CF,CDF] = CF(mat,Inds,Ne)
%
% Takes the variance-field and variance-diagonal-field of 'mat'.

% The "Inds" are really only required to identify the neuron type (E/I) in 
% the event that some subpopulation is being considered. For example, if
% the covariance matrix estimation is being done on neurons with > 1 Hz 
% firing rate, which may not include the entire population.

function [CF,CFOR] = CF2(mat,Inds,Ne,nk)
    
    if (nargin == 3)
        nk = 2;
    end

    nc = numel(Inds);
    Ni = nc - Ne;
    
    eInds = find(Inds<=Ne);
    iInds = find(Inds>Ne);
    
    mat(1:(nc+1):nc^2) = inf; % For ignoring diagonal elements...
    
    
    %% EEEE
    krange = 1:nk;
    
    nEle = sum((Ne-krange).*(Ne-1-krange)) / 2;
    EE_cov_prep = zeros(nEle,2);
%     ii = 1;
%     for k=krange
%     for alpha=1:(Ne-1)
%     for beta=(alpha+1):(Ne-k)
%         EE_cov_prep(ii,1) = mat( alpha,beta );
%         EE_cov_prep(ii,2) = mat( alpha,beta+k );
%         ii = ii + 1;
%     end
%     end
%     end

    tempCov = cov(EE_cov_prep);
    ceeee = tempCov(1,2);
    
    
    %% EEEI
    %EI_cov_prep = zeros((Ne-1)*Ni,2);
    EI_cov_prep = zeros(1,2);
    temp_ceeei = zeros(1,50);
    ii = 1;
%     for alpha=1:1%(Ne-Ni)
%     for m=1:Ni
%         EI_cov_prep(ii,1) = mat( alpha,alpha+m );
%         EI_cov_prep(ii,2) = mat( alpha,Ne+m );
%         ii = ii + 1;
%     end
%     end
    for alpha=1:Ni%(Ne-Ni)
        EI_cov_prep = zeros(1,2);
        ii = 1;
    for m=1:Ni
        EI_cov_prep(ii,1) = mat( alpha,alpha+1 );
        EI_cov_prep(ii,2) = mat( alpha,Ne+m );
        ii = ii + 1;
    end
    tempCov = mycov(EI_cov_prep,[3.2400 2.4300]*nc); % custom testing
    temp_ceeei(alpha) = tempCov(1,2);
    end

    %tempCov = cov(EI_cov_prep);
    %tempCov = mycov(EI_cov_prep,[3.2400 2.4300]*nc); % custom testing
    %ceeei = tempCov(1,2);
    ceeei = mean(temp_ceeei);
    
    %% EEEI offrows
    %EI_cov_prep = zeros((Ne-1)*Ni,2);
    EI_cov_prep = zeros(1,2);
    ii = 1;
%     for alpha=1:1%(Ne-Ni)
%     for m=2:Ni
%         EI_cov_prep(ii,1) = mat( alpha,alpha+m );
%         EI_cov_prep(ii,2) = mat( alpha+1,Ne+m );
%         ii = ii + 1;
%     end
%     end
    for alpha=1:1%(Ne-Ni)
    for m=2:Ni
        EI_cov_prep(ii,1) = mat( alpha,alpha+1 );
        EI_cov_prep(ii,2) = mat( alpha+2,Ne+m );
        ii = ii + 1;
    end
    end

    %tempCov = cov(EI_cov_prep);
    tempCov = mycov(EI_cov_prep,[3.2400 2.4300]*nc); % custom testing
    ceeeiOR = tempCov(1,2);
    
    
    %% EEEE OR
    krange = 1:nk;
    
    nEle = sum((Ne-krange).*(Ne-1-krange)) / 2;
    EE_cov_prep = zeros(nEle,2);
    ii = 1;
%     for k=krange
%     for alpha=1:(Ne-1)
%     for beta=(alpha+1):(Ne-k-1)
%         EE_cov_prep(ii,1) = mat( alpha,beta );
%         EE_cov_prep(ii,2) = mat( alpha+2,beta+k+1 );
%         ii = ii + 1;
%     end
%     end
%     end

    %tempCov = cov(EE_cov_prep);
    ceeeeOR = tempCov(1,2);
    
    
    %%
    CF = zeros(4);
    CF(1,1) = ceeee;
    CF(1,2) = ceeei;
    
    CFOR = zeros(4);
    CFOR(1,1) = ceeeeOR;
    CFOR(1,2) = ceeeiOR;
end

