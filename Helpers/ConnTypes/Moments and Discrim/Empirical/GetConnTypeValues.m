
% Assumes 2 pop E/I

function [SubTypeValues,indsOut] = GetConnTypeValues(Mat,BiDirIds,nNeurPlot_or_indsIn)
    
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
    
    NullIds = strcmp(BiDirIds,'EE0') | strcmp(BiDirIds,'II0') | strcmp(BiDirIds,'EIIE0');
    ConnIds = strcmp(BiDirIds,'EE1') | strcmp(BiDirIds,'EE2') | strcmp(BiDirIds,'II1') ...
              | strcmp(BiDirIds,'II2') | strcmp(BiDirIds,'EI') | strcmp(BiDirIds,'IE') ...
              | strcmp(BiDirIds,'EIIE');
    
    SubTypeValues = struct();
    
    if ( any(NullIds(:)) )
        Mat_Null = Mat(NullIds);
        SubTypeValues.Null = Mat_Null;
    else
        SubTypeValues.Null = [];
    end
    
    if ( any(ConnIds(:)) )
        Mat_Conn = Mat(ConnIds);
        SubTypeValues.Conn = Mat_Conn;
    else
        SubTypeValues.Conn = [];
    end
end

