
% [X,Y,AUC] = ClassifyEIConOnEstVal(estval,BiDirIds)
%           = ClassifyEIConOnEstVal(..., 'Name',Value)
%
%       Name        Value
%       GroupBy     'none' (default), 'EI', 'block'
%       PlotCurve     boolean
%       CurveType   'ROC' (default) or 'PR'
%
% Trains a linear classifier specified by a future option on the estimated
% value values, using labels extracted from BiDirIds.

% add block case and
% Add error checking on wether or not there are no bidirectional
% componenets for certain subpops for block case

% add matrix vs. list passing
%     nrow = size(estval,1);
%     ncol = size(estval,2);
%     
%     if (nrow == ncol) % if given as mat, format to list... extend this later for directional case
%         N = nrow;
%         NaN_lowerTri = tril(NaN*ones(N,N));
% 
%         % OffDiag option
%         estval_OffDiag = estval - NaN_lowerTri;
% 
%         BiDirIds = BiDirIds(~isnan(estval_OffDiag));
%         estval_OffDiag = estval_OffDiag(~isnan(estval_OffDiag));
% 
%         estval = estval_OffDiag(:);
%     end

function [X,Y,AUC,Scores] = ClassifyConOnEstVal(estval,BiDirIds,varargin)
    
    % add varargin option for linear classifier method: defaulting to
    % logreg
    
    % add varargin option for by group or conn - default conn
    
    % add varargin option for wether or not to plot - default false
    PlotCurve = true;
    
    %% ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nargin,2) == 1 ) % not an odd number of args
        error( sprintf('You must pass an even number of arguments in ClassifyConOnEstVal. (%d recieved)!',nargin) )
    end
    %% ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    %% --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 2) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
        
        switch opts{i}
            case 'GroupBy'
                GroupBy = varargin{2*i};
            case 'PlotCurve'
                PlotCurve = varargin{2*i};
            case 'CurveType'
                CurveType = varargin{2*i};
            otherwise
                error( sprintf('Unknown function option (%s) in ClassifyConOnEstVal.',opts{i}) )
        end
    end
    %% ---------------- END ARGUMENT READ-IN ---------------- %
    
    
    
    %% -------------- BEGIN DEFAULT ASSIGNMENT -------------- %
    if ( exist('GroupBy','var') )
    switch GroupBy
        case 'none' % default
        case 'EI'
        case 'block'
        otherwise
            warning( sprintf('Unknown GroupBy request (%s) - defaulting to block!',GroupBy) )
            GroupBy = 'none';
    end
    else % Argument not specified
        GroupBy = 'none';
    end
    
    
    if ( exist('PlotCurve','var') )
    switch PlotCurve
        case true % default
        case false
        otherwise
            warning( sprintf('Unknown PlotCurve request (%s) - defaulting to true!',PlotCurve) )
            PlotCurve = true;
    end
    else % Argument not specified
        PlotCurve = true;
    end
    
    
    if ( exist('CurveType','var') )
    switch CurveType
        case 'ROC' % default
        case 'PR'
        otherwise
            warning( sprintf('Unknown CurveType request (%s) - defaulting to ROC!',CurveType) )
            CurveType = 'ROC';
    end
    else % Argument not specified
        CurveType = 'ROC';
    end
    %% --------------- END DEFAULT ASSIGNMENT --------------- %
    
    
    
    %% --------------- BEGIN ALGORITHM ---------------------- %
    
    % Current speed improvement by only subsampling the network causes
    % errors for EI/block types since sampling of inhibitory connections is
    % rare...
    
    switch GroupBy
        case 'none' % default
            nSamples = numel(estval);
            maxSamples = 3e6; % threshold currenntly hardcoded

            % this part assumes that we have lists, not matrices...
            if (nSamples > maxSamples)
                keepIds = randperm(0.1*nSamples);
                estval = estval(keepIds);
                BiDirIds = BiDirIds(keepIds);
            end
    
            [X,Y,AUC,Scores] = ClassifyConOnEstVal_NoGroups(estval,BiDirIds,CurveType,PlotCurve);
        case 'EI'
            [X,Y,AUC,Scores] = ClassifyConOnEstVal_EI(estval,BiDirIds,CurveType,PlotCurve);
        case 'block'
            [X,Y,AUC,Scores] = ClassifyConOnEstVal_Block(estval,BiDirIds,CurveType,PlotCurve);
    end
end



