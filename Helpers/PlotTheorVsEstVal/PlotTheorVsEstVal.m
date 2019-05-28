
% [TheorGroups,EstValGroups] = PlotTheorVsEstVal(theor,estval,BiDirIds)
% [TheorGroups,EstValGroups] = PlotTheorVsEstVal(..., 'Name',Value)
%
% Plots the given theoretical values versus estimated ones. Colors based on group membership assigned via
% "BiDirIds", and controlled by option 'GroupBy'. Automatically detects matrix vs. list inputs, though they
% must all agree!
%
% Optional arguments:
%       Name        Value
%       'GroupBy'   'none', 'EI', 'block' (default), 'conn'
%
% See file for more information.

% GroupBy Value Descriptions
%       'none': simply plots the scatter all one color
%       'EI': colors by presynaptic neuron, either excitatory or inhibitory. For example, 'EE' and 'IE'
%             block edges are colored the same.
%       'block' (default): all possible blockwise subgroups are colored separately. In the event that there are no
%                such connections for a given graph (mainly bidirectional ones), the algorithm will automatically
%                not include it in the legend or color.
%       'conn': colors by two groups, connected and unconnected edge values. Anything in BiDirIds not equal to
%               'Z' is considered a single group.



%   Planning on adding several options for plot types and by group or not
% Currently default to coloring all 8 groups, if possible.
%   Maybe need to add some error checking on what happens if there is a
%   missing group? For large networks it will not be an issue, but
%   bidirection values occur p^2 less often...
%
% Also returns structs of all the values separated by group membership...

function [TheorGroups,EstValGroups] = PlotTheorVsEstVal(theor,estval,BiDirIds,varargin)
    
    % add varargin option for PlotType: 'scatter', 'bars'(better name?),
    % maybe circles too?
    % add varargin option for OffDiag - defaulting to true
    % add varargin option for by: 'groups' or 'conn' - defaulting to groups
    % add varargin option for plot title adjustment...
    
    %% ----------- BEGIN ERROR CHECK OF ARGUMENTS ----------- %
    if ( mod(nargin,2) ~= 1 ) % not an odd number of args
        error( sprintf('You must pass an odd number of arguments in PlotTheorVsEstVal. (%d recieved)!',nargin) )
    end
    %% ------------ END ERROR CHECK OF ARGUMENTS ------------ %
    
    
    
    %% --------------- BEGIN ARGUMENT READ-IN --------------- %
    nopts = (nargin - 3) / 2;
    opts = cell(1,nopts); % options chosen
    
    for i=1:nopts
        
        opts{i} = varargin{2*i-1};
        
        switch opts{i}
            case 'GroupBy'
                GroupBy = varargin{2*i};
            otherwise
                error( sprintf('Unknown function option (%s) in PlotTheorVsEstVal.',opts{i}) )
        end
    end
    %% ---------------- END ARGUMENT READ-IN ---------------- %
    
    
    
    %% -------------- BEGIN DEFAULT ASSIGNMENT -------------- %
    if ( exist('GroupBy','var') )
    switch GroupBy
        case 'none'
        case 'EI'
        case 'block' % default
        case 'conn'
        otherwise
            warning( sprintf('Unknown GroupBy request (%s) - defaulting to block!',GroupBy) )
            GroupBy = 'block';
    end
    else % Argument not specified
        GroupBy = 'block';
    end
    %% --------------- END DEFAULT ASSIGNMENT --------------- %
    
    
    
    %% -------------- BEGIN ALGORITHM -------------- %
    nrow = size(theor,1);
    ncol = size(theor,2);
    
    if (nrow == ncol) % matrix was passed. Will give twice the values!
        N = nrow;
        NaN_lowerTri = tril(NaN*ones(N,N));

        % OffDiag option
        theor_OffDiag = theor - NaN_lowerTri;
        cov_OffDiag = estval - NaN_lowerTri;

        BiDirIds_OffDiag = BiDirIds(~isnan(theor_OffDiag));
        theor_OffDiag = theor_OffDiag(~isnan(theor_OffDiag));
        cov_OffDiag = cov_OffDiag(~isnan(cov_OffDiag));



        %% GroupBy option - Matrices
        switch GroupBy
            case 'none'
            %%
            %%
            case 'EI'
            %%
            %%
            case 'block' % default
            %%
                % For coloring, get all 8 unique subgroups for both theor and cov
                theor_OffDiag_EE1 = theor_OffDiag(BiDirIds_OffDiag == 'EE1');
                theor_OffDiag_EE2 = theor_OffDiag(BiDirIds_OffDiag == 'EE2');

                theor_OffDiag_II1 = theor_OffDiag(BiDirIds_OffDiag == 'II1');
                theor_OffDiag_II2 = theor_OffDiag(BiDirIds_OffDiag == 'II2');

                theor_OffDiag_EI = theor_OffDiag(BiDirIds_OffDiag == 'EI');
                theor_OffDiag_IE = theor_OffDiag(BiDirIds_OffDiag == 'IE');

                theor_OffDiag_EIIE = theor_OffDiag(BiDirIds_OffDiag == 'EIIE');
                theor_OffDiag_Zero = theor_OffDiag(BiDirIds_OffDiag == 'Z');


                cov_OffDiag_EE1 = cov_OffDiag(BiDirIds_OffDiag == 'EE1');
                cov_OffDiag_EE2 = cov_OffDiag(BiDirIds_OffDiag == 'EE2');

                cov_OffDiag_II1 = cov_OffDiag(BiDirIds_OffDiag == 'II1');
                cov_OffDiag_II2 = cov_OffDiag(BiDirIds_OffDiag == 'II2');

                cov_OffDiag_EI = cov_OffDiag(BiDirIds_OffDiag == 'EI');
                cov_OffDiag_IE = cov_OffDiag(BiDirIds_OffDiag == 'IE');

                cov_OffDiag_EIIE = cov_OffDiag(BiDirIds_OffDiag == 'EIIE');
                cov_OffDiag_Zero = cov_OffDiag(BiDirIds_OffDiag == 'Z');
                
                % Plot color scatter
                lgd = cell(1,4); i = 1;
                figure
                plot(theor_OffDiag_EE1,cov_OffDiag_EE1,'.', 'Color',[0 1 0] * 0.5) % Dark green
                lgd{i} = 'EE1'; i = i + 1;
                hold on

                if ( ~isempty(theor_OffDiag_EE2) )
                    plot(theor_OffDiag_EE2,cov_OffDiag_EE2,'g.')
                    lgd{i} = 'EE2'; i = i + 1;
                    hold on
                end

                plot(theor_OffDiag_II1,cov_OffDiag_II1,'.', 'Color',[1 0 0] * 0.8) % Darker red
                lgd{i} = 'II1'; i = i + 1;
                hold on

                if ( ~isempty(theor_OffDiag_II2) )
                    plot(theor_OffDiag_II2,cov_OffDiag_II2,'.', 'Color',[0.95 0.2 0]) % Brighter red for contrast
                    lgd{i} = 'II2'; i = i + 1;
                    hold on
                end

                plot(theor_OffDiag_EI,cov_OffDiag_EI,'b.')
                lgd{i} = 'EI'; i = i + 1;
                hold on
                plot(theor_OffDiag_IE,cov_OffDiag_IE,'c.')
                lgd{i} = 'IE'; i = i + 1;
                hold on

                if ( ~isempty(theor_OffDiag_EIIE) )
                    plot(theor_OffDiag_EIIE,cov_OffDiag_EIIE,'m.')
                    lgd{i} = 'EIIE'; i = i + 1;
                    hold on
                end

                plot(theor_OffDiag_Zero,cov_OffDiag_Zero,'k.')
                lgd{i} = 'Zero'; i = i + 1;
                hold on
                title('Theor vs. Prec - Scatter')
                legend(lgd)
                
                TheorGroups = struct('EE1',theor_OffDiag_EE1, ...
                'EE2',theor_OffDiag_EE2, 'II1',theor_OffDiag_II1, ...
                'II2',theor_OffDiag_II2, 'EI',theor_OffDiag_EI, ...
                'IE',theor_OffDiag_IE, 'EIIE',theor_OffDiag_EIIE, ...
                                              'Z',theor_OffDiag_Zero);

                EstValGroups = struct('EE1',cov_OffDiag_EE1, ...
                'EE2',cov_OffDiag_EE2, 'II1',cov_OffDiag_II1, ...
                'II2',cov_OffDiag_II2, 'EI',cov_OffDiag_EI, ...
                'IE',cov_OffDiag_IE, 'EIIE',cov_OffDiag_EIIE, ...
                                              'Z',cov_OffDiag_Zero);
            %%
            case 'conn'
            %%
            %%
        end
        
    else % Gave inputs in list format...
        
        %% GroupBy option - Lists
        switch GroupBy
            case 'none'
                %%
            case 'EI'
                %%
                
                % Note: this skips EIIE bidirectional pairs both because
                % assigning them would mean plotting the same value twice
                % and because their covariance values are typically so
                % close to zero anyway...
                
                theor_E = theor(BiDirIds == 'EE1' | BiDirIds == 'EE2' | BiDirIds == 'IE');
                theor_I = theor(BiDirIds == 'II1' | BiDirIds == 'II2' | BiDirIds == 'EI');
                theor_Zero = theor(BiDirIds == 'Z');
                
                estval_E = estval(BiDirIds == 'EE1' | BiDirIds == 'EE2' | BiDirIds == 'IE');
                estval_I = estval(BiDirIds == 'II1' | BiDirIds == 'II2' | BiDirIds == 'EI');
                estval_Zero = estval(BiDirIds == 'Z');
                
                % Plot color scatter
                figure
                plot(theor_E,estval_E,'.', 'Color',[0 1 0] * 0.5) % Dark green
                hold on
                plot(theor_I,estval_I,'.', 'Color',[1 0 0] * 0.8) % Darker red
                hold on
                plot(theor_Zero,estval_Zero,'k.')
                title('Theor vs. Estimated Value - Scatter')
                legend('E','I','Unconnected')
                
                
                
                % Return structs of values
                TheorGroups = struct('E',theor_E, 'I',theor_I, 'Z',theor_Zero);

                EstValGroups = struct('E',estval_E, 'I',estval_I, 'Z',estval_Zero);
            case 'block' % default
                %%
                theor_OffDiag_EE1 = theor(BiDirIds == 'EE1');
                theor_OffDiag_EE2 = theor(BiDirIds == 'EE2');

                theor_OffDiag_II1 = theor(BiDirIds == 'II1');
                theor_OffDiag_II2 = theor(BiDirIds == 'II2');

                theor_OffDiag_EI = theor(BiDirIds == 'EI');
                theor_OffDiag_IE = theor(BiDirIds == 'IE');

                theor_OffDiag_EIIE = theor(BiDirIds == 'EIIE');
                theor_OffDiag_Zero = theor(BiDirIds == 'Z');


                cov_OffDiag_EE1 = estval(BiDirIds == 'EE1');
                cov_OffDiag_EE2 = estval(BiDirIds == 'EE2');

                cov_OffDiag_II1 = estval(BiDirIds == 'II1');
                cov_OffDiag_II2 = estval(BiDirIds == 'II2');

                cov_OffDiag_EI = estval(BiDirIds == 'EI');
                cov_OffDiag_IE = estval(BiDirIds == 'IE');

                cov_OffDiag_EIIE = estval(BiDirIds == 'EIIE');
                cov_OffDiag_Zero = estval(BiDirIds == 'Z');


                % Plot color scatter
                lgd = cell(1,4); i = 1;
                figure
                plot(theor_OffDiag_EE1,cov_OffDiag_EE1,'.', 'Color',[0 1 0] * 0.5) % Dark green
                lgd{i} = 'EE1'; i = i + 1;
                hold on

                if ( ~isempty(theor_OffDiag_EE2) )
                    plot(theor_OffDiag_EE2,cov_OffDiag_EE2,'g.')
                    lgd{i} = 'EE2'; i = i + 1;
                    hold on
                end

                plot(theor_OffDiag_II1,cov_OffDiag_II1,'.', 'Color',[1 0 0] * 0.8) % Darker red
                lgd{i} = 'II1'; i = i + 1;
                hold on

                if ( ~isempty(theor_OffDiag_II2) )
                    plot(theor_OffDiag_II2,cov_OffDiag_II2,'.', 'Color',[0.95 0.2 0]) % Brighter red for contrast
                    lgd{i} = 'II2'; i = i + 1;
                    hold on
                end

                plot(theor_OffDiag_EI,cov_OffDiag_EI,'b.')
                lgd{i} = 'EI'; i = i + 1;
                hold on
                plot(theor_OffDiag_IE,cov_OffDiag_IE,'c.')
                lgd{i} = 'IE'; i = i + 1;
                hold on

                if ( ~isempty(theor_OffDiag_EIIE) )
                    plot(theor_OffDiag_EIIE,cov_OffDiag_EIIE,'m.')
                    lgd{i} = 'EIIE'; i = i + 1;
                    hold on
                end

                plot(theor_OffDiag_Zero,cov_OffDiag_Zero,'k.')
                lgd{i} = 'Zero'; i = i + 1;
                hold on
                title('Theor vs. Prec - Scatter')
                legend(lgd)



                % Return structs of values
                TheorGroups = struct('EE1',theor_OffDiag_EE1, ...
                    'EE2',theor_OffDiag_EE2, 'II1',theor_OffDiag_II1, ...
                    'II2',theor_OffDiag_II2, 'EI',theor_OffDiag_EI, ...
                    'IE',theor_OffDiag_IE, 'EIIE',theor_OffDiag_EIIE, ...
                                                  'Z',theor_OffDiag_Zero);

                EstValGroups = struct('EE1',cov_OffDiag_EE1, ...
                    'EE2',cov_OffDiag_EE2, 'II1',cov_OffDiag_II1, ...
                    'II2',cov_OffDiag_II2, 'EI',cov_OffDiag_EI, ...
                    'IE',cov_OffDiag_IE, 'EIIE',cov_OffDiag_EIIE, ...
                                                  'Z',cov_OffDiag_Zero);
            case 'conn'
                %%
                %%
        end
        
    end % end list/mat check
end% end function


