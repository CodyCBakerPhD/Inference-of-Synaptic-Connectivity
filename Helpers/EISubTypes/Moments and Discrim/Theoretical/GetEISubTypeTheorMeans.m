
% Get the theoretical means of the Erdos-Renyi linear precision
% distributions across EI subtypes

function SubTypeTheorMeans = GetEISubTypeTheorMeans(SimPar)
    
    Jm = SimPar.J / sqrt(SimPar.N);
    W_bar = SimPar.J .* SimPar.P;
    
    q = [SimPar.qe SimPar.qi];
    
    SubTypeTheorMeans = struct();
    
    SubTypeTheorMeans.EE0 = -(1 - 2 / SimPar.N) ...
                                                      * (q(1) * W_bar(1,1)^2 + q(2) * W_bar(2,1)^2);
    SubTypeTheorMeans.EE1 = Jm(1,1) ...
                                 - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,1)^2 + q(2) * W_bar(2,1)^2);
    SubTypeTheorMeans.EE2 = 2 * Jm(1,1) ...
                                 - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,1)^2 + q(2) * W_bar(2,1)^2);

    SubTypeTheorMeans.II0 = -(1 - 2 / SimPar.N) ...
                                                      * (q(1) * W_bar(1,2)^2 + q(2) * W_bar(2,2)^2);
    SubTypeTheorMeans.II1 = Jm(2,2) ...
                                 - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,2)^2 + q(2) * W_bar(2,2)^2);
    SubTypeTheorMeans.II2 = 2 * Jm(2,2) ...
                                 - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,2)^2 + q(2) * W_bar(2,2)^2);

    SubTypeTheorMeans.EIIE0 = -(1 - 2 / SimPar.N) ...
                                * (q(1) * W_bar(1,2) * W_bar(1,1) + q(2) * W_bar(2,2) * W_bar(2,1));
    SubTypeTheorMeans.EI = Jm(1,2) - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,1) * W_bar(1,2) ...
                                                                  + q(2) * W_bar(2,1) * W_bar(2,2));
    SubTypeTheorMeans.IE = Jm(2,1) - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,2) * W_bar(1,1) ...
                                                                  + q(2) * W_bar(2,2) * W_bar(2,1));
    SubTypeTheorMeans.EIIE = Jm(1,2) + Jm(2,1) ...
                                         - (1 - 2 / SimPar.N) * (q(1) * W_bar(1,2) * W_bar(1,1) ...
                                                                  + q(2) * W_bar(2,2) * W_bar(2,1));
end

