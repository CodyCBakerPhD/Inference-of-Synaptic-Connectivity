
function SubTypeAUROCs = ExtractAUROCs(SubTypeROCs)
    
    SubTypeAUROCs = nan(7,1);
    
    if(isstruct(SubTypeROCs.EE1vsEE0))
        SubTypeAUROCs(1) = SubTypeROCs.EE1vsEE0.AUROC;
    end
    
    if(isstruct(SubTypeROCs.EE2vsEE0))
        SubTypeAUROCs(2) = SubTypeROCs.EE2vsEE0.AUROC;
    end
    
    if(isstruct(SubTypeROCs.II1vsII0))
        SubTypeAUROCs(3) = SubTypeROCs.II1vsII0.AUROC;
    end
    
    if(isstruct(SubTypeROCs.II2vsII0))
        SubTypeAUROCs(4) = SubTypeROCs.II2vsII0.AUROC;
    end
    
    if(isstruct(SubTypeROCs.EIvsEIIE0))
        SubTypeAUROCs(5) = SubTypeROCs.EIvsEIIE0.AUROC;
    end
    
    if(isstruct(SubTypeROCs.IEvsEIIE0))
        SubTypeAUROCs(6) = SubTypeROCs.IEvsEIIE0.AUROC;
    end
    
    if(isstruct(SubTypeROCs.EIIEvsEIIE0))
        SubTypeAUROCs(7) = SubTypeROCs.EIIEvsEIIE0.AUROC;
    end
end

