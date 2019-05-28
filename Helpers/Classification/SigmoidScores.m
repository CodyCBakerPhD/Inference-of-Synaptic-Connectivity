
function scores = SigmoidScores(estval)
    
    mu = mean(estval);
    prop = 0.1; % currently hardcoded...
    
    syms s0 x
    maxSteep = s0/4;
    s1 = solve( s0*exp(-s0*(x-mu))/(1+exp(-s0*(x-mu))) == prop * maxSteep, x);
    s2 = solve(s1 == quantile(estval,prop), s0);
    a = abs(double(s2));
    
    scores = sigmf(estval, [a mu]);
    
    
end

