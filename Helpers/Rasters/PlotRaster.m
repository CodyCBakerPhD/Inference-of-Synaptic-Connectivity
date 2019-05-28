
% PlotRaster(s,nPlot,tPlot)
%
% Spikes s should be N x nSteps (Nt)
% Plots a raster of nPlot randomly sambled neurons from t=0 to tPlot
%
% CODE IS INCOMPLETE

function PlotRaster(s,nPlot,tPlot)
    
    N = size(s,1);
    T = size(s,2);
    
    if nPlot <= N
        subN = SimPar.N; % Default, currently no way to change...
        sSub = s.s;
    else
        subN = 1e3; % Default, currently no way to change...
        sSub = s(:, ismember(s(2,:), randperm(N,nPlot)));
        uniq = unique(sSub(2,:));
        sSub(2,:) = changem( sSub(2,:), 1:numel(uniq) , uniq );
    end
    
    subplot(2,2,2)
    plot( sSub(1,:), sSub(2,:), '.', 'MarkerSize',7)
    title( sprintf('%d Recurrent',subN) )
    
    
    
    if SimPar.Nf <= 1e2
        subN = round(SimPar.Nf / 2); % Default, currently no way to change...
        sfSub = s.sf(:, ismember(s.sf(2,:), randperm(SimPar.Nf,subN)));
        sfSub(2,:) = changem( sfSub(2,:),1:subN, unique(sfSub(2,:)) );

    else
        subN = 1e2; % Default, currently no way to change...
        sfSub = s.sf(:, ismember(s.sf(2,:), randperm(SimPar.Nf,subN)));
        sfSub(2,:) = changem( sfSub(2,:),1:subN, unique(sfSub(2,:)) );
    end
    
    subplot(2,2,3)
    plot( sfSub(1,:), sfSub(2,:), '.', 'MarkerSize',5)
    title( sprintf('%d Feedforward',subN) )
    
    
    if SimPar.N <= 1e2
        subN = round(SimPar.N / 2); % Default, currently no way to change...
        sSub = s.s(:, ismember(s.s(2,:), randperm(SimPar.N,subN)));
        sSub(2,:) = changem( sSub(2,:),1:subN, unique(sSub(2,:)) );

    else
        subN = 1e2; % Default, currently no way to change...
        sSub = s.s(:, ismember(s.s(2,:), randperm(SimPar.N,subN)));
        uniq = unique(sSub(2,:));
        sSub(2,:) = changem( sSub(2,:),1:numel(uniq), uniq );
    end
    
    subplot(2,2,4)
    plot( sSub(1,:), sSub(2,:), '.', 'MarkerSize',7)
    title( sprintf('%d Recurrent',subN) )
end

