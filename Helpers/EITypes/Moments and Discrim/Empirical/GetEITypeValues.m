
% Assumes 2 pop E/I

function [SubTypeValues,indsOut] = GetEITypeValues(Mat,BiDirIds,nNeurPlot_or_indsIn)
    
    N = size(Mat,1);
    
    if (nargin == 3) % nNeurPlot_or_indsIn passed
        if ( all(size(nNeurPlot_or_indsIn) == 1) ) % nNeurPlot passed
            qe = find(strcmp(BiDirIds(1,:),'EIIE0'),1) / N; % technically not exact estimate
            Ne = round(qe*N);
            Ni = round((1-qe)*N);

            if(N > 5e2)
                % Try to split nNeurPlot evenly between E/I
                if (nNeurPlot_or_indsIn/2 <= Ni)
                    inds = [randperm(Ne,nNeurPlot_or_indsIn/2) randperm(Ni,nNeurPlot_or_indsIn/2)+Ne];
                else
                    inds = [randperm(Ne,nNeurPlot_or_indsIn-Ni) (Ne+1):N];
                end
            else
                inds = 1:N;
            end
        else % inds passed
            inds = nNeurPlot_or_indsIn;
        end
    else % nNeurPlot_or_indsIn not passed
        inds = 1:N;
    end
    
    Mat = Mat(inds,inds);
    BiDirIds = BiDirIds(inds,inds);
    
    indsOut = inds;
    
    EE0ids = strcmp(BiDirIds,'EE0');
    EEConnIds = strcmp(BiDirIds,'EE1') | strcmp(BiDirIds,'EE2');
    
    II0ids = strcmp(BiDirIds,'II0');
    IIConnIds = strcmp(BiDirIds,'II1') | strcmp(BiDirIds,'II2');
    
    EIIE0ids = strcmp(BiDirIds,'EIIE0');
    EIConnIds = strcmp(BiDirIds,'EI') | strcmp(BiDirIds,'IE') | strcmp(BiDirIds,'EIIE');
    
    SubTypeValues = struct();
    
    if ( any(EE0ids(:)) )
        Mat_EE0 = Mat(EE0ids);
        SubTypeValues.EE0 = Mat_EE0;
    else
        SubTypeValues.EE0 = [];
    end
    
    if ( any(EEConnIds(:)) )
        Mat_EEConn = Mat(EEConnIds);
        SubTypeValues.EEConn = Mat_EEConn;
    else
        SubTypeValues.EEConn = [];
    end

    if ( any(II0ids(:)) )
        Mat_II0 = Mat(II0ids);
        SubTypeValues.II0 = Mat_II0;
    else
        SubTypeValues.II0 = [];
    end
    
    if ( any(IIConnIds(:)) )
        Mat_IIConn = Mat(IIConnIds);
        SubTypeValues.IIConn = Mat_IIConn;
    else
        SubTypeValues.IIConn = [];
    end
    
    if ( any(EIIE0ids(:)) )
        Mat_EIIE0 = Mat(EIIE0ids);
        SubTypeValues.EIIE0 = Mat_EIIE0;
    else
        SubTypeValues.EIIE0 = [];
    end
    
    if ( any(EIConnIds(:)) )
        Mat_EIConn = Mat(EIConnIds);
        SubTypeValues.EIConn = Mat_EIConn;
    else
        SubTypeValues.EIConn = [];
    end
end

