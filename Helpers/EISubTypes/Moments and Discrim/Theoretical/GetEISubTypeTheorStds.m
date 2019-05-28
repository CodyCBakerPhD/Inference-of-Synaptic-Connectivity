
function SubTypeTheorStds = GetEISubTypeTheorStds(SimPar)
    
    SubTypeTheorVars = GetEISubTypeTheorVars(SimPar);
    SubTypeTheorStds = struct();
    
    SubTypeTheorStds.EE0 = sqrt(SubTypeTheorVars.EE0);
    SubTypeTheorStds.EE1 = sqrt(SubTypeTheorVars.EE1);
    SubTypeTheorStds.EE2 = sqrt(SubTypeTheorVars.EE2);
    
    SubTypeTheorStds.II0 = sqrt(SubTypeTheorVars.II0);
    SubTypeTheorStds.II1 = sqrt(SubTypeTheorVars.II1);
    SubTypeTheorStds.II2 = sqrt(SubTypeTheorVars.II2);
    
    SubTypeTheorStds.EIIE0 = sqrt(SubTypeTheorVars.EIIE0);
    SubTypeTheorStds.EI = sqrt(SubTypeTheorVars.EI);
    SubTypeTheorStds.IE = sqrt(SubTypeTheorVars.IE);
    SubTypeTheorStds.EIIE = sqrt(SubTypeTheorVars.EIIE);
end

