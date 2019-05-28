
% [CF,CF_OR] = CF(mat,Inds,Ne)
%
% Takes the type-1 covariance-field and tests off-row pairs (theoretical zeros) of 'mat'.

% The "Inds" are really only required to identify the neuron type (E/I) in 
% the event that some subpopulation is being considered. For example, if
% the covariance matrix estimation is being done on neurons with > 1 Hz 
% firing rate, which may not include the entire population.

function [CF,CFOR] = CF1(mat1,mat2,Inds,Ne,mat1_bar,mat2_bar)

    N = numel(Inds);
    Ni = N - Ne;
    
    eInds = find(Inds<=Ne);
    iInds = find(Inds>Ne);
    
    
    %% EEEE
    m1 = mat1(N*(1:(Ne-1)) + (1:(Ne-1))) - mat1_bar(1,1);
    m2 = mean( mat2(1:(Ne-1),1:(Ne-1)),2 )' - mat2_bar(1,1); % loose approximation; shouldn't include diag or same neuron

    ceeee = mean( m1 .* m2 );
    
    
    %% EEEI
    m1 = mat1(N*(1:(Ne-1)) + (1:(Ne-1))) - mat1_bar(1,1);
    m2 = mean( mat2(1:(Ne-1),iInds),2 )' - mat2_bar(1,2);
    
    ceeei = mean( m1 .* m2 );
    
    
    %% EIEE
    m1 = mat2(N*(1:(Ne-1)) + (1:(Ne-1))) - mat2_bar(1,1);
    m2 = mean( mat1(1:(Ne-1),iInds),2 )' - mat1_bar(1,2);
    
    ceiee = mean( m1 .* m2 );
    
    
    %% EEEI offrows
    EE = mat1(eInds,eInds);
    EE = EE( logical(triu(ones(Ne),1)) );
    EI = mat2(eInds,iInds);
    EI = EI(:);
    
    k = Ne*Ni; % as many as above...
    ceeeiOR_samps = [randsample(EE,k,true) randsample(EI,k,true)];
    
    temp_ceeeiOR = cov( ceeeiOR_samps );
    ceeeiOR = temp_ceeeiOR(1,2);
    
    
    %% EIEI
    m1 = mat1(eInds,Ne+1) - mat1_bar(1,2);
    m2 = mean( mat2(1:Ne,iInds),2 )' - mat2_bar(1,2);

    ceiei = mean( m1 .* m2' );
    
    
    %% IIIE
    m1 = mat1(N*((Ne+1):(N-1)) + ((Ne+1):(N-1))) - mat1_bar(2,2);
    m2 = mean( mat2((Ne+1):(N-1),eInds),2 )' - mat2_bar(1,2);
    
    ciiie = mean( m1 .* m2 );
    
    
    %% IEII
    m1 = mat2(N*((Ne+1):(N-1)) + ((Ne+1):(N-1))) - mat2_bar(2,2);
    m2 = mean( mat1((Ne+1):(N-1),eInds),2 )' - mat1_bar(1,2);
    
    cieii = mean( m1 .* m2 );
    
    
    %% IIIE offrows
    II = mat1(iInds,iInds);
    II = II( logical(triu(ones(Ni),1)) );
    IE = mat2(iInds,eInds);
    IE = IE(:);
    
    k = Ne*Ni; % as many as above...
    ciiieOR_samps = [randsample(II,k,true) randsample(IE,k,true)];
    
    temp_ciiieOR = cov( ciiieOR_samps );
    ciiieOR = temp_ciiieOR(1,2);
    
    
    %% IIII
    m1 = mat1(N*((Ne+1):(N-1)) + ((Ne+1):(N-1))) - mat1_bar(2,2);
    m2 = mean( mat2((Ne+1):(N-1),(Ne+1):(N-1)),2 )' - mat2_bar(2,2); % loose approximation; shouldn't include diag or same neuron

    ciiii = mean( m1 .* m2 );
    
    
    %%
    CF = zeros(4);
    CF(1,1) = ceeee;
    CF(1,4) = ceiei;
    CF(4,1) = ceiei;
    CF(4,4) = ciiii;
    
    CF(1,2) = ceeei;
    CF(2,1) = ceeei;
    
    CF(1,3) = ceiee;
    CF(3,1) = ceiee;
    
    CF(2,4) = ciiie;
    CF(4,2) = ciiie;
    
    CF(3,4) = cieii;
    CF(4,3) = cieii;
    
    
    CFOR = zeros(4);
    CFOR(1,2) = ceeeiOR;
    CFOR(1,3) = ceeeiOR;
    CFOR(2,1) = ceeeiOR;
    CFOR(3,1) = ceeeiOR;
    
    CFOR(4,2) = ciiieOR;
    CFOR(4,3) = ciiieOR;
    CFOR(2,4) = ciiieOR;
    CFOR(3,4) = ciiieOR;
end

