
function [sf,sfCorr,sfInd] = Gen_FFSpikes_OrientRate_DistCov(Nf,T,r,c,q,stimOrient,sigmaR,sigmaC)
    
    rfCorr = r * (1-q);
    rfInd = r * q;
    p0 = c;
    
    sigmaP = sigmaC/sqrt(2);
    
    neurOrients = (1:Nf)/Nf;
    
    % Generate spike trains for ffwd layer
    % Generate spikes for each neuron
    nspikes = poissrnd( rfCorr / p0 * T );

    % Allocate
    nsf=poissrnd(Nf * rfCorr * T * 1.2); % can this logic be improved? too tired to tell
    sfCorr = zeros(2,nsf);

    % Get all original spike times...
    spiketimes = rand([1,nspikes]) * T;
    
    % Separate into uniform and gaussian orientaitons
    spikeOrients = rand([1,nspikes]);

    tic
    ind = 0; % I think starting at 0 is more natural, bet either way
    for i=1:nspikes

        % Note that I replaced the th1 you had with 0. That was probably
        % just a typo. The probability should be maximized at 0 distance. 

        % Vectorize probabilities
        prob = p0 * WrappedGauss(spikeOrients(i) - neurOrients, ...
                                                0, sigmaP, 3);

        % An index, j, is in temp with probability prob(j).
        temp=find(rand(size(prob))<prob);
        sfCorr(1,ind+1:ind+numel(temp))=spiketimes(i);% Add random numbers to spk times here
        sfCorr(2,ind+1:ind+numel(temp))=temp;
        ind=ind+numel(temp);
    end

    % Sort by spike time
    [~,I] = sort(sfCorr(1,:));
    sfCorr = sfCorr(:,I);

    % Get rid of padded zeros
    sfCorr = sfCorr(:,sfCorr(1,:)>0);
    
    
    
    % Now generate the independent layer
    rfInd = rfInd * WrappedGauss(neurOrients, stimOrient, sigmaR, 3);
    nsfInd = poissrnd(Nf * mean(rfInd) * T * 1.2);

    % Allocate
    sfInd = zeros(2,nsfInd);

    % Generate spikes for each neuron
    start = 1;
    for j=1:Nf
        nspikes = poissrnd(rfInd(j) * T);
        spiketimes = rand([1,nspikes]) * T;
        start = start + nspikes;
        sfInd(1,start-nspikes:start-1) = spiketimes;
        sfInd(2,start-nspikes:start-1) = j;
    end

    % Sort by spike time
    [~,I] = sort(sfInd(1,:));
    sfInd = sfInd(:,I);

    % Get rid of padded zeros
    sfInd = sfInd(:,sfInd(1,:)>0);
    
    
    
    % Stick them together...
    sf = [sfCorr  sfInd];
    
    % Sort by spike time
    [~,I] = sort(sf(1,:));
    sf = sf(:,I);
end

