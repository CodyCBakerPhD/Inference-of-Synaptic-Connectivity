
% [Distributions] = PlotEstValDists(EstValList,BiDirIdsList)
%                 = PlotEstValDists(...,'Name',value)
%
%       Name        value
%       ------      -----
%       method      'histdens' (default), 'hist', or 'kde'
%       GroupBy     'EI', 'con' (default), 'block' (not yet supported), or 'none'
%       nBins       positive integer
%       ShadeCurve  boolean
%
% Plots the resulting distributions (via method) of some given list of
% estimated values (EstValList), examples of which might be covariance,
% precision, or their normalized versions; all relative to their group
% membership (GroupBy), derived by BiDirIdsList.
%
% Also returns struct of distribution values.
%
% For more information, see comments in main function.

% method options: 'histdens' gives a line plot of values obtained via
% histcounts function. This will differ slightly in value to that of
% 'hist', though the primary difference is in plot appearence, which is
% obtained via the histogram function. 'kde' is simply ksdensity.

% WARNING: only EI GroupBy option is up to date with all options. Need to
% fill in others!

function [Distributions] = PlotEstValDists(EstValList,BiDirIdsList,varargin)
    
    %% ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nargin,2) == 1 ) % not an odd number of args
        error( sprintf('You must pass an even number of arguments in PlotEstValDists. (%d recieved)!',nargin) )
    end
    %% ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    %% --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 2) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
        
        switch opts{i}
            case 'method'
                method = varargin{2*i};
            case 'GroupBy'
                GroupBy = varargin{2*i};
            case 'nBins'
                nBins = varargin{2*i};
            case 'ShadeCurve'
                ShadeCurve = varargin{2*i};
            otherwise
                error( sprintf('Unknown function option (%s) in PlotEstValDists.',opts{i}) )
        end
    end
    %% ---------------- END ARGUMENT READ-IN ---------------- %
    
    
    
    %% -------------- BEGIN DEFAULT ASSIGNMENT -------------- %
    if ( exist('method','var') )
    switch method
        case 'histdens' % default
        case 'hist'
        case 'kde'
        otherwise
            warning( sprintf('Unknown method request (%s) - defaulting to block!',method) )
            method = 'histdens';
    end
    else % Argument not specified
        method = 'histdens';
    end
    
    
    if ( exist('GroupBy','var') )
    switch GroupBy
        case 'none'
        case 'EI'
        case 'block'
        case 'conn' % default
        otherwise
            warning( sprintf('Unknown GroupBy request (%s) - defaulting to conn!',GroupBy) )
            GroupBy = 'conn';
    end
    else % Argument not specified
        GroupBy = 'conn';
    end
    
    
    if ( exist('nBins','var') )
        if ( strcmp(method,'kde') )
            warning('"nBins" is specified, but "kde" option was passed. Argument unused.')
        end
    else
        nBins = 1e2; % default
    end
    
    
    if ( exist('ShadeCurve','var') )
    switch ShadeCurve
        case true
        case false
        otherwise
            warning( sprintf('Unknown ShadeCurve request (%s) - defaulting to false!',ShadeCurve) )
            ShadeCurve = false;
    end
        if ( strcmp(method,'hist') )
            warning('"ShadeCurve" is specified, but "hist" option was passed. Argument unused.')
        end
    else
        ShadeCurve = false; % default
    end
    %% --------------- END DEFAULT ASSIGNMENT --------------- %
    
    
    
    %% --------------- BEGIN ALGORITHM -------------------- %
    switch GroupBy
        case 'conn' % default
            %%
            switch method
                case 'histdens'
                    %%
                    [EstValDist,xx1] = histcounts(EstValList,nBins, 'Normalization','pdf');
                    [EstValDistCon,xx2] = histcounts(EstValList(BiDirIdsList ~= 'Z'),nBins, 'Normalization','pdf');
                    [EstValDistNonCon,xx3] = histcounts(EstValList(BiDirIdsList == 'Z'),nBins, 'Normalization','pdf');
                    
                    x1 = movsum(xx1,2)/2;
                    x1(1) = [];
                    x2 = movsum(xx2,2)/2;
                    x2(1) = [];
                    x3 = movsum(xx3,2)/2;
                    x3(1) = [];
                    
                    if (ShadeCurve == true)
                        figure
                        area(x1,EstValDist, 'FaceColor','k')


                        figure
                        area(x2,EstValDistCon, 'FaceColor',[0 1 0] * 0.5) % Dark green
                        hold on
                        area(x3,EstValDistNonCon, 'FaceColor', [1 0 0] * 0.8) % Darker red
                        legend('Connected','Non-Connected')
                    else
                        figure
                        plot(x1,EstValDist,'k')


                        figure
                        plot(x2,EstValDistCon, 'Color',[0 1 0] * 0.5) % Dark green
                        hold on
                        plot(x3,EstValDistNonCon, 'Color', [1 0 0] * 0.8) % Darker red
                        legend('Connected','Non-Connected')
                    end
                case 'hist'
                    %%
                    figure
                    EstValDist = histogram(EstValList,nBins, 'Normalization','pdf');
                    
                    figure
                    EstValDistCon = histogram(EstValList(BiDirIdsList ~= 'Z'),nBins, 'Normalization','pdf');
                    hold on
                    EstValDistNonCon = histogram(EstValList(BiDirIdsList == 'Z'),nBins, 'Normalization','pdf');
                    legend('Connected','Non-Connected')
                case 'kde'
                    %%
                    [EstValDist,x1] = ksdensity(EstValList);
                    [EstValDistCon,x2] = ksdensity(EstValList(BiDirIdsList ~= 'Z'));
                    [EstValDistNonCon,x3] = ksdensity(EstValList(BiDirIdsList == 'Z'));
                    
                    if (ShadeCurve == true)
                        figure
                        area(x1,EstValDist, 'FaceColor','k')


                        figure
                        area(x2,EstValDistCon, 'FaceColor',[0 1 0] * 0.5) % Dark green
                        hold on
                        area(x3,EstValDistNonCon, 'FaceColor', [1 0 0] * 0.8) % Darker red
                        legend('Connected','Non-Connected')
                    else
                        figure
                        plot(x1,EstValDist,'k')


                        figure
                        plot(x2,EstValDistCon, 'Color',[0 1 0] * 0.5) % Dark green
                        hold on
                        plot(x3,EstValDistNonCon, 'Color', [1 0 0] * 0.8) % Darker red
                        legend('Connected','Non-Connected')
                    end
            end % end switch method
            
            Distributions = struct('All',EstValDist, 'Con',EstValDistCon, 'NonCon',EstValDistNonCon);
        case 'EI'
            %%
            switch method
                case 'histdens'
                    %%
                    [EstValDist,xx1] = histcounts(EstValList,nBins, 'Normalization','pdf');
                    [EstValDistE,xx2] = histcounts(EstValList(BiDirIdsList == 'EE1' | BiDirIdsList == 'EE2' | ...
                                                               BiDirIdsList == 'IE'),nBins, 'Normalization','pdf');
                    [EstValDistI,xx3] = histcounts(EstValList(BiDirIdsList == 'II1' | BiDirIdsList == 'II2' | ...
                                                               BiDirIdsList == 'EI'),nBins, 'Normalization','pdf');
                    [EstValDistZ,xx4] = histcounts(EstValList(BiDirIdsList == 'Z'),nBins, 'Normalization','pdf');
                                                            
                    x1 = movsum(xx1,2)/2;
                    x1(1) = [];
                    x2 = movsum(xx2,2)/2;
                    x2(1) = [];
                    x3 = movsum(xx3,2)/2;
                    x3(1) = [];
                    x4 = movsum(xx4,2)/2;
                    x4(1) = [];
                    
                    if (ShadeCurve == true)
                        figure
                        area(x1,EstValDist, 'FaceColor','k')


                        figure
                        area(x2,EstValDistE, 'FaceColor',[0 1 0] * 0.5) % Dark green
                        hold on
                        area(x3,EstValDistI, 'FaceColor', [1 0 0] * 0.8) % Darker red
                        hold on
                        area(x4,EstValDistZ, 'FaceColor','k')
                        legend('E','I','Zero')
                    else
                        figure
                        plot(x1,EstValDist,'k')


                        figure
                        plot(x2,EstValDistE, 'Color',[0 1 0] * 0.5) % Dark green
                        hold on
                        plot(x3,EstValDistI, 'Color', [1 0 0] * 0.8) % Darker red
                        hold on
                        plot(x4,EstValDistZ,'k')
                        legend('E','I','Zero')
                    end
                case 'hist'
                    %%
                    figure
                    EstValDist = histogram(EstValList,nBins, 'Normalization','pdf');
                    
                    figure
                    EstValDistE = histogram(EstValList(BiDirIdsList == 'EE1' | BiDirIdsList == 'EE2' | ...
                                                               BiDirIdsList == 'IE'),nBins, 'Normalization','pdf');
                    hold on
                    EstValDistI = histogram(EstValList(BiDirIdsList == 'II1' | BiDirIdsList == 'II2' | ...
                                                               BiDirIdsList == 'EI'),nBins, 'Normalization','pdf');
                    hold on
                    EstValDistZ = histogram(EstValList(BiDirIdsList == 'Z'),nBins, 'Normalization','pdf');
                    legend('E','I','Zero')
                case 'kde'
                    %%
                    [EstValDist,x1] = ksdensity(EstValList);
                    [EstValDistE,x2] = ksdensity(EstValList(BiDirIdsList == 'EE1' | BiDirIdsList == 'EE2' | ...
                                                               BiDirIdsList == 'IE'));
                    [EstValDistI,x3] = ksdensity(EstValList(BiDirIdsList == 'II1' | BiDirIdsList == 'II2' | ...
                                                               BiDirIdsList == 'EI'));
                    [EstValDistZ,x4] = ksdensity(EstValList(BiDirIdsList == 'Z'));
                    
                    if (ShadeCurve == true)
                        figure
                        area(x1,EstValDist, 'FaceColor','k')


                        figure
                        area(x2,EstValDistE, 'FaceColor',[0 1 0] * 0.5) % Dark green
                        hold on
                        area(x3,EstValDistI, 'FaceColor', [1 0 0] * 0.8) % Darker red
                        hold on
                        area(x4,EstValDistZ, 'FaceColor','k')
                        legend('E','I','Zero')
                    else
                        figure
                        plot(x1,EstValDist,'k')


                        figure
                        plot(x2,EstValDistE, 'Color',[0 1 0] * 0.5) % Dark green
                        hold on
                        plot(x3,EstValDistI, 'Color', [1 0 0] * 0.8) % Darker red
                        hold on
                        plot(x4,EstValDistZ,'k')
                        legend('E','I','Zero')
                    end
            end
            
            
            Distributions = struct('All',EstValDist, 'E',EstValDistE, 'I',EstValDistI, 'Z',EstValDistZ);
        case 'block'
            error('Block option not yet supported in PlotEstValDists. Sorry!')
    end
end


