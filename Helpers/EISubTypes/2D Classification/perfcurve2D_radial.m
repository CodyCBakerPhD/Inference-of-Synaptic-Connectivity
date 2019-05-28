
% labels are 0 and 1, 1 positive by default (cant be changed atm)

function [ROC,AUROC] = perfcurve2D_radial(labels,score1,score2,nBins)

    switch nargin
        case 3
            % default nxbins and nybins
            nBins = 10;
        otherwise
            if (nargin > 4)
                error('Too many arguments to percurve2D_radial!')
            elseif (nargin < 2)
                error('Too few arguments to percurve2D_radial!')
            end
    end
    
    if (~isequal(size(score1),size(score2)))
        error('Score vectors must be of same size!');
    end
    
    
    % Get intervals
    nPoints = 1e2; % the default is 30, a bit too coarse for findig max
    edges = [min(score1) min(score2); max(score1) max(score2)];
    gridx1 = linspace(edges(1,1),edges(2,1),nPoints);
    gridx2 = linspace(edges(1,2),edges(2,2),nPoints);
    [x1,x2] = meshgrid(gridx1, gridx2);
    x1 = x1(:);
    x2 = x2(:);
    pts = [x1 x2];
    kde = ksdensity([score1 score2], pts);
    center = pts(kde == max(kde),:);
    
    maxrad = sqrt(norm([edges(1,1) edges(1,2)] - [edges(2,1) edges(2,2)])); % theoretical maximum radius of linear box
    
    t = linspace(0,maxrad,nBins); % discretized radial increase

    nlabels = numel(labels);
    nPos = sum(labels);
    nNeg = nlabels - nPos;
    
    TPR = zeros(1,nBins);
    FPR = zeros(1,nBins);
    
    for i=1:nBins
        Guess = zeros(nlabels,1);
        Guess( sqrt(vecnorm( ([score1 score2] - center)' )) <= t(i) ) = 1;
        TP = (Guess == 1) & (labels == 1);
        FP = (Guess == 1) & (labels == 0);

        TPR(i) = sum(TP) / nPos;
        FPR(i) = sum(FP) / nNeg;
    end
    
    ROC = [TPR; FPR];
    AUROC = trapz(ROC(1,:),ROC(2,:));
end

