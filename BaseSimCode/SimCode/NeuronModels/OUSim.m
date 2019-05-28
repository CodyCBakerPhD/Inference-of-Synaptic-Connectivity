
% [r,x] = OUSim(W,Gamma,tau,T,dt,varargin)
%
% Simulates a multivariate OU process following deterministic transitions
% from the network 'W', with external input covariance 'Gamma', at timescale
% 'tau', and for total time length 'T' discretized at level 'dt'. For
% reference, the equation is
%
% tau dr = (I - W) dt + B eta(t)
%
% with eta(t) white noise (differential of Wiener process) and B B^T = Gamma.
%
% The simulator saves on memory by only simulating one window size increment at a time, storing
% this sub-process in 'x' and using the last value in each sub-process as the
% initial conditions of the next. In this case, the value of 'r' is actually the
% vector of the OU process temporally averaged by windows of the specified
% size, and 'x' is the last sub-process simulated at the level of 'dt'.
% 
% Name-Value Pairs
%   winsize = size of temporal averaging in units ms. Defaults to 250.
%   r0 = initial state of OU process. Defaults to 0 vector.

function [r,x] = OUSim(W,Gamma,tau,T,dt,varargin)

    N = size(W,1);
        
    % ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nargin,2) == 0 ) % not an even number of args
        error('You must pass an odd number of arguments in OUSim (%d recieved)!',nargin)
    end
    % ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    % --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 5) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
                
        switch opts{i}
            case 'winsize'
                winsize = varargin{2*i};
            case 'r0'
                r0 = varargin{2*i};
            otherwise
                error('Unknown function option (%s) in OUSim.',opts{i})
        end
    end
    % ---------------- END ARGUMENT READ-IN ---------------- %
    
    
    
    % -------------- BEGIN DEFAULT ASSIGNMENT AND ERROR CHECKING -------------- %
    if ( ~exist('winsize','var') ) % Argument not specified
        winsize = 250;
    else
        if (winsize <= 2*dt)
            error('Window size (%d) must be at least twice the discretization (%0.2f)~',winsize,dt)
        end
    end
    
    if ( ~exist('r0','var') ) % Argument not specified
        r0 = zeros(N,1);
    end
    
    if (~isequal(size(W),size(Gamma)))
        error('W and Gamma are not the same size!')
        % Technically this could be altered in the OU equation to allow different
        % numbers of white noise processes, etc... but that could also be mathematically
        % equivalent to just adjusting the external input covariance appropriately
    end
    % --------------- END DEFAULT ASSIGNMENT AND ERROR CHECKING --------------- %
    
    
    %%
    % Need to add error checking on dimensions
    
    if (~istril(Gamma) && ~istriu(Gamma))
        B = chol(Gamma); % Gamma = B B^T was passed
    else
        B = Gamma;
    end
    
    % Implement timescales
    A = (eye(N) - W) * dt / tau;
    B = B * sqrt(dt) / tau;
    
    
    nGroups = T / winsize;
    GroupSize = winsize / dt;
    
    r = zeros(N,nGroups);
    x = zeros(N,GroupSize);
    x(:,1) = r0;
    
    for j=1:nGroups
        
        % It is faster, but more memeory, to pre-allocate noise...
        noise = randn([N GroupSize]);
        
        % Euler steps
        for t=2:GroupSize
            x(:,t) = A * x(:,t-1) + B * noise(:,t);
        end
        
        % Temporally average
        r(:,j) = squeeze(sum(reshape(x',winsize/dt,[],size(x',2)),1));
        
        x(:,1) = x(:,end); % Continue IC as last point in process
    end
end

