
function SubTypeTheorVars = GetEISubTypeTheorVars(SimPar)
    
    N = SimPar.N;
    P = SimPar.P;
    J = SimPar.J;
    Vm = SimPar.V / N;
    
    W_bar = J .* P;
    W_barbar = P .* (J.^2 .* (1 - P));
    
    q = [SimPar.qe SimPar.qi];
    
    SubTypeTheorVars = struct('EE0',[],'EE1',[],'EE2',[],'II0',[],'II1',[],'II2',[], ...
                                                      'EIIE0',[],'EI',[],'IE',[],'EIIE',[]);

    SubTypeTheorVars.EE0 = 0;
    for c=1:2
        SubTypeTheorVars.EE0 = SubTypeTheorVars.EE0 ...
                                         + (1/N - 2/N^2) * q(c) * (W_barbar(c,1) * W_barbar(c,1) ...
                                     + W_bar(c,1)^2 * W_barbar(c,1) + W_barbar(c,1) * W_bar(c,1)^2);
    end

    SubTypeTheorVars.EE1 = Vm(1,1) + SubTypeTheorVars.EE0;
    SubTypeTheorVars.EE2 = 2 * Vm(1,1) + SubTypeTheorVars.EE0;


    SubTypeTheorVars.II0 = 0;
    for c=1:2
        SubTypeTheorVars.II0 = SubTypeTheorVars.II0 ...
                                         + (1/N - 2/N^2) * q(c) * (W_barbar(c,2) * W_barbar(c,2) ...
                                     + W_bar(c,2)^2 * W_barbar(c,2) + W_barbar(c,2) * W_bar(c,2)^2);
    end

    SubTypeTheorVars.II1 = Vm(2,2) + SubTypeTheorVars.II0;
    SubTypeTheorVars.II2 = 2 * Vm(2,2) + SubTypeTheorVars.II0;


    SubTypeTheorVars.EIIE0 = 0;
    for c=1:2
        SubTypeTheorVars.EIIE0 = SubTypeTheorVars.EIIE0 ...
                                         + (1/N - 2/N^2) * q(c) * (W_barbar(c,1) * W_barbar(c,2) ...
                                     + W_bar(c,1)^2 * W_barbar(c,2) + W_barbar(c,1) * W_bar(c,2)^2);
    end

    SubTypeTheorVars.EI = Vm(1,2) + SubTypeTheorVars.EIIE0;
    SubTypeTheorVars.IE = Vm(2,1) + SubTypeTheorVars.EIIE0;
    SubTypeTheorVars.EIIE = Vm(1,2) + Vm(2,1) + SubTypeTheorVars.EIIE0;
end

