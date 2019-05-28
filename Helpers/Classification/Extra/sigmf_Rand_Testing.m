
nSamples = 1e3;
mu = 0.5;
sd = 0.1;

% fit parameter
prop = 0.1;

samp = mu + sd.*randn([1, nSamples]);


%%
syms a x
maxSteep = a/4;
s1 = solve( a*exp(-a*(x-mu))/(1+exp(-a*(x-mu))) == prop * maxSteep, x);
s2 = solve(s1 == quantile(samp,prop), a);
a = abs(double(s2));

%%
% coeff by mathematica! need to setup solver here...
sigmoid = sigmf(samp, [a mu]);
figure
plot(sort(samp), sort(sigmoid),'.')



% sigmoid = sigmf(samp, [1000*sd mu]);
% figure
% plot(sort(samp), sort(sigmoid),'.')
% 
% 
% 
% sigmoid = sigmf(samp, [100*sd mu]);
% figure
% plot(sort(samp), sort(sigmoid),'.')
% 
% 
% 
% sigmoid = sigmf(samp, [sd/100 mu]);
% figure
% plot(sort(samp), sort(sigmoid),'.')
% 
% 
% 
% sigmoid = sigmf(samp, [sd/1000 mu]);
% figure
% plot(sort(samp), sort(sigmoid),'.')


