
function sf = Generate_FF_Spikes(rf,Nf,T)

    % Upper bound on number of spikes (for all processes)
    % '1.2' is for safety?
    nsf = poissrnd(Nf * rf * T * 1.2);

    % Allocate
    sf = zeros(2,nsf);

    % Generate spikes for each neuron
    start = 1;
    for j=1:Nf
        nspikes = poissrnd(rf * T);
        spiketimes = rand([1,nspikes]) * T;
        start = start + nspikes;
        sf(1,start-nspikes:start-1) = spiketimes;
        sf(2,start-nspikes:start-1) = j;
    end

    % Sort by spike time
    [~,I] = sort(sf(1,:));
    sf = sf(:,I);

    % Get rid of padded zeros
    sf = sf(:,sf(1,:)>0);
end

