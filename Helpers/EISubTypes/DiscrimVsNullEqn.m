
function D = DiscrimVsNullEqn(SimPar,a,b,m)
    
    N = SimPar.N;
    J = SimPar.J * sqrt(N); % cancel scaling
    V = SimPar.V * N;
    P = SimPar.P;
    q = [SimPar.qe SimPar.qi];

    SumTerm = 0;
    for c=1:2
        SumTerm = SumTerm + q(c) * P(c,a) * P(c,b) * ( (V(c,a) + J(c,a)^2) * (V(c,b) + J(c,b)^2) ...
                                                          - P(c,a) * P(c,b) * J(c,a)^2 * J(c,b)^2 );
    end
    
    D = (J(a,b) + J(b,a) * (m == 2)) / sqrt( V(a,b) + V(b,a) * (m == 2) + (2 - 4 / N) * SumTerm );
end

