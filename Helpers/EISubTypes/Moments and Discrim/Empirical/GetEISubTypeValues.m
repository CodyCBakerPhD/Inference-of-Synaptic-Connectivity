
% Assumes 2 pop E/I

function [SubTypeValues,indsOut] = GetEISubTypeValues(Mat,BiDirIds,nNeurPlot_or_indsIn)
    
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
    EE1ids = strcmp(BiDirIds,'EE1');
    EE2ids = strcmp(BiDirIds,'EE2');
    
    II0ids = strcmp(BiDirIds,'II0');
    II1ids = strcmp(BiDirIds,'II1');
    II2ids = strcmp(BiDirIds,'II2');
    
    EIIE0ids = strcmp(BiDirIds,'EIIE0');
    EIids = strcmp(BiDirIds,'EI');
    IEids = strcmp(BiDirIds,'IE');
    EIIEids = strcmp(BiDirIds,'EIIE');
    
    SubTypeValues = struct();
    
    if ( any(EE0ids(:)) )
        Mat_EE0 = Mat(EE0ids);
        SubTypeValues.EE0 = Mat_EE0;
    else
        SubTypeValues.EE0 = [];
    end
    
    if ( any(EE1ids(:)) )
        Mat_EE1 = Mat(EE1ids);
        SubTypeValues.EE1 = Mat_EE1;
    else
        SubTypeValues.EE1 = [];
    end
    
    if ( any(EE2ids(:)) )
        Mat_EE2 = Mat(EE2ids);
        SubTypeValues.EE2 = Mat_EE2;
    else
        SubTypeValues.EE2 = [];
    end

    if ( any(II0ids(:)) )
        Mat_II0 = Mat(II0ids);
        SubTypeValues.II0 = Mat_II0;
    else
        SubTypeValues.II0 = [];
    end
    
    if ( any(II1ids(:)) )
        Mat_II1 = Mat(II1ids);
        SubTypeValues.II1 = Mat_II1;
    else
        SubTypeValues.II1 = [];
    end
    
    if ( any(II2ids(:)) )
        Mat_II2 = Mat(II2ids);
        SubTypeValues.II2 = Mat_II2;
    else
        SubTypeValues.II2 = [];
    end
    
    if ( any(EIIE0ids(:)) )
        Mat_EIIE0 = Mat(EIIE0ids);
        SubTypeValues.EIIE0 = Mat_EIIE0;
    else
        SubTypeValues.EIIE0 = [];
    end
    
    if ( any(EIids(:)) )
        Mat_EI = Mat(EIids);
        SubTypeValues.EI = Mat_EI;
    else
        SubTypeValues.EI = [];
    end
    
    if ( any(IEids(:)) )
        Mat_IE = Mat(IEids);
        SubTypeValues.IE = Mat_IE;
    else
        SubTypeValues.IE = [];
    end

    if ( any(EIIEids(:)) )
        Mat_EIIE = Mat(EIIEids);
        SubTypeValues.EIIE = Mat_EIIE;
    else
        SubTypeValues.EIIE = [];
    end
end

