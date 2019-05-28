
% Assumes 2 pop E/I

function SubTypeMeans = GetEISubTypeStds(Mat,BiDirIds)
    
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
    
    SubTypeMeans = struct();
    
    if ( any(EE0ids(:)) )
        Mat_EE0 = Mat(EE0ids);
        SubTypeMeans.EE0 = std(Mat_EE0);
    end
    
    if ( any(EE1ids(:)) )
        Mat_EE1 = Mat(EE1ids);
        SubTypeMeans.EE1 = std(Mat_EE1);
    end
    
    if ( any(EE2ids(:)) )
        Mat_EE2 = Mat(EE2ids);
        SubTypeMeans.EE2 = std(Mat_EE2);
    end

    if ( any(II0ids(:)) )
        Mat_II0 = Mat(II0ids);
        SubTypeMeans.II0 = std(Mat_II0);
    end
    
    if ( any(II1ids(:)) )
        Mat_II1 = Mat(II1ids);
        SubTypeMeans.II1 = std(Mat_II1);
    end
    
    if ( any(II2ids(:)) )
        Mat_II2 = Mat(II2ids);
        SubTypeMeans.II2 = std(Mat_II2);
    end
    
    if ( any(EIIE0ids(:)) )
        Mat_EIIE0 = Mat(EIIE0ids);
        SubTypeMeans.EIIE0 = std(Mat_EIIE0);
    end
    
    if ( any(EIids(:)) )
        Mat_EI = Mat(EIids);
        SubTypeMeans.EI = std(Mat_EI);
    end
    
    if ( any(IEids(:)) )
        Mat_IE = Mat(IEids);
        SubTypeMeans.IE = std(Mat_IE);
    end

    if ( any(EIIEids(:)) )
        Mat_EIIE = Mat(EIIEids);
        SubTypeMeans.EIIE = std(Mat_EIIE);
    end
end

