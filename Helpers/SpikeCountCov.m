
% [result,Inds] = SpikeCount(SimPar,s,rates,CovOrPrec,ListOrMat)
%
% General purpose function for returning SpikeCount covariances,
% correlations, and precisions.
%
% CovOrPrec = 'c' or 'p'
% ListOrMat = 'l' or 'm'
% method: type of precision algorithm.
%   one of: 'glasso', 'classic'
% filtered = 1 or 0, decision of whether or not to filter the rates
%
% SimPar: simulation parameters corresponding to spikes
% s: spike trains
% sizeSubSample: size of subsamples - defaults to all firing neurons = N
% winsize: size of window for spike counting (not used in filter)
% rho: precision glasso penalty
% tauKc: filter timescale
% normalized: normalized elements? 0 or 1. Default 0.

function [result,Inds,counts,varargout] = SpikeCountCov(SimPar,s,rates,CovOrPrec,ListOrMat,varargin)

    % ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nargin,2) ~= 1 ) % not an even number of args
        error( sprintf('You must pass an odd number of arguments in SpikeCount. (%d recieved)!',nargin) )
    end
    
    % Add error checking on CovOrPrec and ListOrMat args...
    % ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    % --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 5) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
        
        switch opts{i}
            case 'numSubSamples' % If subsampling, pass this > 1
                numSubSamples = varargin{2*i};
            case 'sizeSubSample'
                sizeSubSample = varargin{2*i};
            case 'normalized' % Correlations vs. Covariance
                normalized = varargin{2*i};
            case 'filtered' % Exponential filter
                filtered = varargin{2*i};
            case 'tauKc' % Filter parameter
                tauKc = varargin{2*i};
            case 'winsize' % Used if not filtered
                winsize = varargin{2*i};
            case 'method' % For inversion
                method = varargin{2*i};
            case 'rho' % Inverse penalty; regularization term
                rho = varargin{2*i};
            case 'Inds'
                passedInds = true;
                Inds = varargin{2*i};
            case 'plotTrace' % Inverse penalty; regularization term
                plotTrace = varargin{2*i};
            case 'returnMeans' % Inverse penalty; regularization term
                returnMeans = varargin{2*i};
            otherwise
                error( sprintf('Unknown function option (%s) in SpikeCount.',opts{i}) )
        end
    end
    % ---------------- END ARGUMENT READ-IN ---------------- %
    
    
    
    % -------------- BEGIN DEFAULT ASSIGNMENT -------------- %
    if ( exist('numSubSamples','var') )
        if ( ~exist('sizeSubSample','var') )
            error('No sizeSubSample passed, even though numSubSamples specified in SpikeCount.')
        end
    else % Argument not specified
        numSubSamples = 1;
    end
    
    
    if ( exist('sizeSubSample','var') )
        if ( ~exist('numSubSamples','var') )
            warning('"numSubSample" is not passed, but "sizeSubSample" is specified. Defaulting to N.')
            sizeSubSample = SimPar.N;
        end
    else % Argument not specified
        sizeSubSample = SimPar.N;
    end
    
    
    if ( exist('normalized','var') )
        switch normalized
            case true
            case false
            otherwise
                warning( sprintf('Option "normalized" (%d) is not boolean... defaulting to false!',normalized) )
                normalized = false;
        end
    else % Argument not specified
        normalized = false;
    end
    
    
    if ( exist('filtered','var') )
        switch filtered
            case true
            case false
            otherwise
                error( sprintf('Unknown request for "filtered" paramater (%d). Defaulting to false.',filtered) )
                filtered = false;
        end
    else % Argument not specified
        filtered = false;
    end
    
    
    if ( exist('tauKc','var') )
        if ( filtered == false )
            warning('tauKc specified but "filtered" is false. Option unused.')
            tauKc = 0;
        end
    else % Argument not specified
        if ( filtered == true )
            warning('"filtered" is true, but tauKc is unspecified. Defaulting to 2!')
            tauKc = 2;
        end
    end
    
    
    if ( exist('winsize','var') )
        if ( filtered == true )
            warning('winsize specified but "filtered" is true. Option unused.')
            winsize = 0;
        end
    else % Argument not specified
        if ( filtered == false )
            warning('"filtered" is false, but winsize is unspecified. Defaulting to 200!')
            winsize = 200;
        end
    end
    
    
    if ( exist('method','var') )
        if ( CovOrPrec == 'c' )
            warning('Precision inference method is specified, but covariance is requested. Option unused.')
            method = '';
        end
    else % Argument not specified
        if ( CovOrPrec == 'p' )
            warning('Precision inference method is unspecified, and precision is requested. Defaulting to simple inverse.')
            method = 'simple';
        end
    end
    
    
    if ( exist('rho','var') )
        if ( CovOrPrec == 'c' )
            if (method == '')
                warning('Precision inference parameter is specified, method is also unspecified, but covariance is requested. Options unused.')
                rho = 0;
            else
                warning('Precision inference parameter is specified, method is specified, but covariance is requested. Options unused.')
                rho = 0;
            end
        end
    else % Argument not specified
        if ( CovOrPrec == 'p' )
            if ( strcmp(method,'simple') )
                %warning('Precision inference parameter (rho) is unspecified, simple method is specified, and precision is requested. Option unused.')
                % not sure how the above warning is useful...
                rho = 0;
            else
                warning('Precision inference parameter (rho) is unspecified, method is specified, and precision is requested. Defaulting to 0.02 !')
                rho = 0.02;
            end
        end
    end
    
    
    if ( ~exist('Inds','var') )
        passedInds = false;
    end
    
    
    if ( exist('plotTrace','var') )
        switch plotTrace
            case true
            case false
            otherwise
                error( sprintf('Unknown request for "plotTrace" paramater (%d). Defaulting to false.',plotTrace) )
                plotTrace = false;
        end
    else % Argument not specified
        plotTrace = false;
    end
    
    
    if ( exist('returnMeans','var') )
        switch returnMeans
            case true
            case false
            otherwise
                error( sprintf('Unknown request for "returnMeans" paramater (%d). Defaulting to false.',returnMeans) )
                returnMeans = false;
        end
    else % Argument not specified
        returnMeans = false;
    end
    % --------------- END DEFAULT ASSIGNMENT --------------- %
    
    
    
    % --------------- BEGIN SPIKECOUNT ALGORITHM --------------- %
    
    if (passedInds == false)
        % Find neurons with rates >= 1Hz
        Igood = find( rates > 1/1000 );

        % Randomly choose nc cells to use
        % their indices are stored in Inds
        numGood = numel(Igood);
        if (sizeSubSample > numGood)
            Inds = Igood;
        else
            temp = randperm(numGood,sizeSubSample);
            Inds = sort(Igood(temp));
        end
    else
        numGood = numel(Inds);
    end
    
    
    switch filtered
        case true % filtering
            tic
            dt2=1; % Hardcoded... maybe couple with winsize and require it for ST?
            
            % with dt2 = 1, this gives 4 time samples per neuron...
            % should negate all bias!
            %reasonableTime = SimPar.N * 4;
            
            % Don't need maximal time for ST
            %if (SimPar.T*SimPar.N > reasonableTime)
                %fT = reasonableTime;
            %end
            fT = SimPar.T;
            
            edgest = 0:dt2:fT;
            edgesi = (1:numGood+1)-.1;
            edges = {edgest,edgesi};
            
            sSub = s(:, ismember(s(2,:),Inds) );
            sSub(2,:) = changem( sSub(2,:),1:numGood,Inds);

            counts = hist3(sSub','Edges',edges);
            counts = counts(:,1:end-1);
            counts = counts(1:end-1,:);

            % Low-pass filter in 1D
            Kc = exp(-(dt2:dt2:6*tauKc)/tauKc); % 6 is also hardcoded?
            Kc = [0*Kc 1 Kc];
            Kc = Kc/sum(Kc);

            % Two-dim filter
            Kcc = zeros(size(counts,1)*2+1,numel(Kc));
            Kcc(size(counts,1)+1,:) = Kc;

            % Low-pass filter currents
            r = conv2(counts',Kcc,'same');
            
            if (plotTrace == true)
                figure
                for i=1:4
                    subplot(2,2,i)
                    plot(r(i,:))
                end
            end
            
            C = cov(r');
            
            if (returnMeans == true)
                varargout{1} = mean(r');
            end
            
            fprintf('Time to filter: %0.2f s\n',toc)
            
        case false % no filtering
            
            % Edges for histogram
            edgest = 0:winsize:SimPar.T;
            edgesi = (1:numGood+1)-.1;
            edges = {edgest,edgesi};
            
            % Subset spikes based on Inds
            sSub = s(:, ismember(s(2,:),Inds) );
            sSub(2,:) = changem( sSub(2,:),1:numGood,Inds);
            
            % Get 2D histogram of spike indices and times
            counts = hist3(sSub','Edges',edges);
            counts = counts(:,1:end-1);
            counts = counts(1:end-1,:);

            % Get rid of edges, and burn period
            % the last element in each
            % direction is zero
            if (size(counts,2) ~= numel(Inds))
                counts = counts( ceil(SimPar.Tburn / winsize):end-1,1:end-1 );
            else
                counts = counts( ceil(SimPar.Tburn / winsize):end-1,1:end );
            end

            % Store their spike counts
            C = cov(counts);
            
            if (returnMeans == true)
                varargout{1} = mean(counts);
            end
    end
    
    
    if ( CovOrPrec == 'p')
        tic
        switch method
            case 'simple'
                result = inv(C);
            case 'pinv'
                result = pinv(C);
            case 'poorMan'
                 % Add rho percent of the current value of the diagonal
                lambda = mean( diag(C) ) * rho;
                result = inv(lambda*eye(size(C,1))+C);
            case 'glasso'
                lambda = mean( diag(C) ) * rho;
                result = glasso(C, lambda);
            case 'pcor'
                result = partialcorr( counts );
            otherwise
                error('method must be one of "glasso", "graphicalLasso", or "classic" in SpikeCountPrecList')
        end
        fprintf('Time for inversion: %0.2f s\n',toc)
    else
        result = C;
    end
    
    
    if (normalized == true)
        result = NormalizeByDiag(result);
    end % end if norm
    

    if (ListOrMat == 'l')
        [II,JJ] = meshgrid(1:size(result,1),1:size(result,1));
        result = result(II>JJ & isfinite(result));
    end
end

