
% SimPar = LoadBaseSimPar(Name,NetType,FFType,N,T)
%
% Names:    Paper - Original usage
%           Pyle2016 - Erdos-Renyi balance rates, scale-free (in?)-degrees, direct FF with no noise.
%           Pyle2016_RealPart - Same as Pyle2016 but with perturbed J to give non-zero real part
%           Rosenbaum2017 - Spatial network, mean-field correlations, spiking FF, but no MIP.
%           Rosenbaum2017Fig1 - Similar to Rosenbaum2017, but for direct FF
%           WCPSP - Weakly coupled (WC), optimized for ideal post-synaptic potentials (PSP).
%
% NetType = 'ER', 'Spatial', 'CER'
% FFType = 'direct', 'asynchronous', 'correlated'
%
% N = number of neurons
% T = simulation time (ms)
%
% Note that SimPar synaptic strengths are not scaled by sqrt(N); this
% burden is left to the individual network generation algorithms.
%
% For more information, see additional comments in LoadBaseSimPar.m

% Code for loading well-known basic simulation values based on
% previous publications. The "Name" argument should correspond to one of the
% papers below. If you would like to add an additional paper to the
% database, please email Cody Baker (cbaker9@nd.edu).

% If some of the values of these parameters are desired to be different,
% but the user does not wish to use a custom SimPar, the default values
% from a Base SimPar can be easily modified after loading by simply setting
%       SimPar.Value = DesiredValue;
% after calling LoadBaseSimPar.

% We cannot guarantee that simulation parameters will give desireable
% results when run on network structures or FF types that were not in the
% original publications. For example: Rosenbaum2017 on an Erdos-Renyi network
% is known to give rate chaos.

% All base SimPars also contain values for alternative networks not used
% in the original publications, but are likely similar to other similar
% publications. The user may often wish to adjust these values for their
% specific needs. For example: Pyle2016_RealPart has spatial network parameters
% equivalent to Rosenbaum2017.

% Some base SimPars may contain different scaling values depending on FF
% input, for example Rosenbaum2017 values differ depending on FFtype
% 'direct' or 'spiking', as per figures 1 and 4 in their paper.

function SimPar = LoadBaseSimPar(Name,NetType,FFType,N,T,varargin)
    
    nvarargin = numel(varargin);
    
    % ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nvarargin,2) ~= 0 )
        error('Additional arguments to LoadBaseSimPar must be passed as Name-Value pairings!')
    end
    % ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    % --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 5) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
                
        switch opts{i}
            case 'Fscale'
                Fscale = varargin{2*i};
            case 'Pscale'
                Pscale = varargin{2*i};
            case 'qxscale'
                qxscale = varargin{2*i};
            case 'warn'
                warn = varargin{2*i};
            otherwise
                error('Unknown function option (%s) in LoadBaseSimPar.',opts{i})
        end
    end
    % ---------------- END ARGUMENT READ-IN ---------------- %
    

    
    % -------------- BEGIN DEFAULT ASSIGNMENT AND ERROR CHECKING -------------- %
    if ( ~exist('Fscale','var') ) % Argument not specified
        Fscale = 1;
    end
    
    if ( ~exist('Pscale','var') ) % Argument not specified
        Pscale = 1;
    end
    
    if ( ~exist('qxscale','var') ) % Argument not specified
        qxscale = 1;
    end
    
    if ( ~exist('warn','var') ) % Argument not specified
        warn = 1;
    end
    % --------------- END DEFAULT ASSIGNMENT AND ERROR CHECKING --------------- %
    
    
    %% Load selected SimPar - many of these commented out since not used in this paper
    switch Name
%         case 'Pyle2016'
%             warning('Pyle2016 J values yield purely imaginary eigenvalues. Use Pyle2016_RealPart for mildly perturbed values giving non-zero real part.')
%             SimPar = LoadPyle2016(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn);
        case 'Pyle2016_RealPart'
            SimPar = LoadPyle2016_RealPart(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn);
%         case 'Rosenbaum2017' % defaults to Fig 4 values
%             warning('Rosenbaum2017 has two sets of values corresponding to Figs. 1 and 4; defaulting to Fig. 4 values. To specify Fig. 1 values, request "Rosenbaum2017Fig1".')
%             SimPar = LoadRosenbaum2017Fig4(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn);
%         case 'Rosenbaum2017Fig1'
%             SimPar = LoadRosenbaum2017Fig1(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn);
%         case 'Rosenbaum2017Fig4'
%             SimPar = LoadRosenbaum2017Fig4(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn);
%         case 'WCPSP'
%             SimPar = LoadWCPSP(NetType,FFType,N,T,Fscale,Pscale,qxscale,warn);
    end
    
    
end

