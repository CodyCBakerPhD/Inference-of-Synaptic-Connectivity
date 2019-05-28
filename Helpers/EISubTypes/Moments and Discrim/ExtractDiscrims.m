
function SubTypeDiscrims_Vec = ExtractDiscrims(SubTypeDiscrims)
    
    SubTypeDiscrims_Vec = nan(9,1);
    
    SubTypeDiscrims_Vec(1) = SubTypeDiscrims.EE1vsEE0;
    SubTypeDiscrims_Vec(2) = SubTypeDiscrims.EE2vsEE0;
    
%     if(isstruct(SubTypeDiscrims.EE2vsEE1))
%         SubTypeDiscrims_Vec(3) = SubTypeDiscrims.EE2vsEE1;
%     end
    
    SubTypeDiscrims_Vec(4) = SubTypeDiscrims.II1vsII0;
    SubTypeDiscrims_Vec(5) = SubTypeDiscrims.II2vsII0;
    
%     if(isstruct(SubTypeDiscrims.II2vsII1))
%         SubTypeDiscrims_Vec(6) = SubTypeDiscrims.II2vsII1;
%     end
    
    SubTypeDiscrims_Vec(7) = SubTypeDiscrims.EIvsEIIE0;
    SubTypeDiscrims_Vec(8) = SubTypeDiscrims.IEvsEIIE0;
    SubTypeDiscrims_Vec(9) = SubTypeDiscrims.EIIEvsEIIE0;
end

