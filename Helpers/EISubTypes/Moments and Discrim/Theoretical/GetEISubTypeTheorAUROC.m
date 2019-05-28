
function SubTypeTheorAUROCs = GetEISubTypeTheorAUROC(SubTypeTheorDiscim)
    
    SubTypeTheorAUROCs = struct();
    
    SubTypeTheorAUROCs.EE1vsEE0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.EE1vsEE0) );
    SubTypeTheorAUROCs.EE2vsEE0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.EE2vsEE0) );
    SubTypeTheorAUROCs.II1vsII0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.II1vsII0) );
    SubTypeTheorAUROCs.II2vsII0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.II2vsII0) );
    SubTypeTheorAUROCs.EIvsEIIE0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.EIvsEIIE0) );
    SubTypeTheorAUROCs.IEvsEIIE0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.IEvsEIIE0) );
    SubTypeTheorAUROCs.EIIEvsEIIE0 = normcdf( 1/sqrt(2) * abs(SubTypeTheorDiscim.EIIEvsEIIE0) );
    
    SubTypeTheorAUROCs.EE1vsEE0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.EE1vsEE0) );
    SubTypeTheorAUROCs.EE2vsEE0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.EE2vsEE0) );
    SubTypeTheorAUROCs.II1vsII0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.II1vsII0) );
    SubTypeTheorAUROCs.II2vsII0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.II2vsII0) );
    SubTypeTheorAUROCs.EIvsEIIE0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.EIvsEIIE0) );
    SubTypeTheorAUROCs.IEvsEIIE0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.IEvsEIIE0) );
    SubTypeTheorAUROCs.EIIEvsEIIE0 = 1/2 * erfc( -1/sqrt(2) * abs(SubTypeTheorDiscim.EIIEvsEIIE0) );
end

