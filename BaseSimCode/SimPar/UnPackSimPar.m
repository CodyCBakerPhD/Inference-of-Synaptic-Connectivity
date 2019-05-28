
% Direct
% [qe,qi,qx,N,Ne,Ni,Nx,J,Jx,P,Px,F,SigmaE,SigmaI,T,Tburn,dt,Nt,NtBurn,Cme,Cmi,gLe,gLi,ELe,ELi, ...
%                             Vth,Vre,Vlb,DeltaT,VT,a,b,tauw,taue,taui,taux,PSPs,PSPXs,...] = UnPackSimPar(SimPar);
%
% Spiking
% [qe,qi,qx,N,Ne,Ni,Nx,J,Jx,P,Px,rx,T,Tburn,dt,Nt,NtBurn,Cme,Cmi,gLe,gLi,ELe,ELi,Vth,Vre,Vlb,DeltaT,VT,a,b, ...
%                                                       tauw,taue,taui,taux,PSPs,PSPXs,...] = UnPackSimPar(SimPar);
%
% MIP
% [qe,qi,qx,N,Ne,Ni,Nx,J,Jx,P,Px,rx,c,jitter,T,Tburn,dt,Nt,NtBurn,Cme,Cmi,gLe,gLi,ELe,ELi, ...
%                                            Vth,Vre,Vlb,DeltaT,VT,a,b,tauw,PSPs,PSPXs,...] = UnPackSimPar(SimPar);
%
%
%
% Append the following special network parameters as necessary.
%
% In-Out
% [...,inDegDist,outDegDist]
%
% Spatial
% [...,alphaEE,alphaEI,alphaIE,alphaII,alphaEX,alphaIX]
%
% SW
% [...,beta]
%
% Clustered
% [...,numClusters,REE]


function varargout = UnPackSimPar(SimPar)
    
    i = 1;
    
    varargout{i} = SimPar.qe; i = i + 1;
    varargout{i} = SimPar.qi; i = i + 1;
    varargout{i} = SimPar.qx; i = i + 1;
    varargout{i} = SimPar.N; i = i + 1;
    varargout{i} = SimPar.Ne; i = i + 1;
    varargout{i} = SimPar.Ni; i = i + 1;
    varargout{i} = SimPar.Nx; i = i + 1;
    varargout{i} = SimPar.J; i = i + 1;
    varargout{i} = SimPar.Jx; i = i + 1;
    varargout{i} = SimPar.P; i = i + 1;
    varargout{i} = SimPar.Px; i = i + 1;
    
    switch SimPar.FFType
        case 'direct'
            varargout{i} = SimPar.F; i = i + 1;
            varargout{i} = SimPar.SigmaE; i = i + 1;
            varargout{i} = SimPar.SigmaI; i = i + 1;
        case 'spiking'
            varargout{i} = SimPar.rx; i = i + 1;
        case 'MIP'
            varargout{i} = SimPar.rx; i = i + 1;
            varargout{i} = SimPar.c; i = i + 1;
            varargout{i} = SimPar.jitter; i = i + 1;
    end
    
    varargout{i} = SimPar.T; i = i + 1;
    varargout{i} = SimPar.Tburn; i = i + 1;
    varargout{i} = SimPar.dt; i = i + 1;
    varargout{i} = SimPar.Nt; i = i + 1;
    varargout{i} = SimPar.NtBurn; i = i + 1;
    
    varargout{i} = SimPar.NeuronParams.Cme; i = i + 1;
    varargout{i} = SimPar.NeuronParams.Cmi; i = i + 1;
    varargout{i} = SimPar.NeuronParams.gLe; i = i + 1;
    varargout{i} = SimPar.NeuronParams.gLi; i = i + 1;
    varargout{i} = SimPar.NeuronParams.ELe; i = i + 1;
    varargout{i} = SimPar.NeuronParams.ELi; i = i + 1;
    varargout{i} = SimPar.NeuronParams.Vth; i = i + 1;
    varargout{i} = SimPar.NeuronParams.Vre; i = i + 1;
    varargout{i} = SimPar.NeuronParams.Vlb; i = i + 1;
    varargout{i} = SimPar.NeuronParams.DeltaT; i = i + 1;
    varargout{i} = SimPar.NeuronParams.VT; i = i + 1;
    varargout{i} = SimPar.NeuronParams.a; i = i + 1;
    varargout{i} = SimPar.NeuronParams.b; i = i + 1;
    varargout{i} = SimPar.NeuronParams.tauw; i = i + 1;

    varargout{i} = SimPar.taue; i = i + 1;
    varargout{i} = SimPar.taui; i = i + 1;
    varargout{i} = SimPar.taux; i = i + 1;
    
    varargout{i} = SimPar.PSPs; i = i + 1;
    varargout{i} = SimPar.PSPXs; i = i + 1;
    
    switch SimPar.NetType
        case 'InOut'
            varargout{i} = SimPar.inDegDist; i = i + 1;
            varargout{i} = SimPar.outDegDist;
        case 'Spatial'
            varargout{i} = SimPar.alphaEE; i = i + 1;
            varargout{i} = SimPar.alphaEI; i = i + 1;
            varargout{i} = SimPar.alphaIE; i = i + 1;
            varargout{i} = SimPar.alphaII; i = i + 1;
            varargout{i} = SimPar.alphaEX; i = i + 1;
            varargout{i} = SimPar.alphaIX;
        case 'SW'
            varargout{i} = SimPar.beta;
        case 'clustered'
            varargout{i} = SimPar.numClusters; i = i + 1;
            varargout{i} = SimPar.REE;
    end
end

