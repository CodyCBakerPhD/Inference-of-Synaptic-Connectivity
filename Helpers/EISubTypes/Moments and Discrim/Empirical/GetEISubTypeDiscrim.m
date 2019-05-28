
function SubTypeDiscim = GetEISubTypeDiscrim(SubTypeMeans_OR_SimPar,SubTypeVars)
    
    if (nargin == 1) % SimPar is first arg
        SimPar = SubTypeMeans_OR_SimPar;
        
        SubTypeDiscim = struct();

        SubTypeDiscim.EE1vsEE0 = DiscrimVsNullEqn(SimPar,1,1,1);
        SubTypeDiscim.EE2vsEE0 = DiscrimVsNullEqn(SimPar,1,1,2);
        SubTypeDiscim.II1vsII0 = DiscrimVsNullEqn(SimPar,2,2,1);
        SubTypeDiscim.II2vsII0 = DiscrimVsNullEqn(SimPar,2,2,2);
        SubTypeDiscim.EIvsEIIE0 = DiscrimVsNullEqn(SimPar,1,2,1);
        SubTypeDiscim.IEvsEIIE0 = DiscrimVsNullEqn(SimPar,2,1,1);
        SubTypeDiscim.EIIEvsEIIE0 = DiscrimVsNullEqn(SimPar,1,2,2);
                                                          
    else % Both SubTypeMeans and SubTypeVars were passes... no error checking ATM for more args
        
        SubTypeMeans = SubTypeMeans_OR_SimPar;
    
        SubTypeDiscim = struct();

        SubTypeDiscim.EE1vsEE0 = (SubTypeMeans.EE1 - SubTypeMeans.EE0) ...
                                                      / sqrt( (SubTypeVars.EE1 + SubTypeVars.EE0) );

        SubTypeDiscim.EE2vsEE0 = (SubTypeMeans.EE2 - SubTypeMeans.EE0) ...
                                                      / sqrt( (SubTypeVars.EE2 + SubTypeVars.EE0) );
        SubTypeDiscim.II1vsII0 = (SubTypeMeans.II1 - SubTypeMeans.II0) ...
                                                      / sqrt( (SubTypeVars.II1 + SubTypeVars.II0) );
        SubTypeDiscim.II2vsII0 = (SubTypeMeans.II2 - SubTypeMeans.II0) ...
                                                      / sqrt( (SubTypeVars.II2 + SubTypeVars.II0) );
        SubTypeDiscim.EIvsEIIE0 = (SubTypeMeans.EI - SubTypeMeans.EIIE0) ...
                                                     / sqrt( (SubTypeVars.EI + SubTypeVars.EIIE0) );
        SubTypeDiscim.IEvsEIIE0 = (SubTypeMeans.IE - SubTypeMeans.EIIE0) ...
                                                     / sqrt( (SubTypeVars.IE + SubTypeVars.EIIE0) );
        SubTypeDiscim.EIIEvsEIIE0 = (SubTypeMeans.EIIE - SubTypeMeans.EIIE0) ...
                                                   / sqrt( (SubTypeVars.EIIE + SubTypeVars.EIIE0) );
    end
end

