
function PlotRasterSmall(s,SimPar,numPlot)
    
    if SimPar.N <= numPlot
        subN = SimPar.N; % Default, currently no way to change...
        sSub = s(:, ismember(s(2,:), randperm(SimPar.N,subN)));
        sSub(2,:) = changem( sSub(2,:),1:subN, unique(sSub(2,:)) );

    else
        subN = numPlot; % Default, currently no way to change...
        sSub = s(:, ismember(s(2,:), randperm(SimPar.N,subN)));
        uniq = unique(sSub(2,:));
        sSub(2,:) = changem( sSub(2,:),1:numel(uniq), uniq );
    end
    
    plot( sSub(1,:), sSub(2,:), '.', 'MarkerSize',7)
    title( sprintf('%d Recurrent',subN) )
end

