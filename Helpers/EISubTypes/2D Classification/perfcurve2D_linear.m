
% labels are 0 and 1, 1 positive by default (cant be changed atm)

function [AllAUROC,OptOrient,OptShift,OptROC,OptAUROC,TPR,FPR,angles,shifts] = perfcurve2D_linear(labels,score1,score2,nBins)

    switch nargin
        case 3
            % default nxbins and nybins
            nBins = 10;
        otherwise
            if (nargin > 4)
                error('Too many arguments to percurve2D!')
            elseif (nargin < 2)
                error('Too few arguments to percurve2D!')
            end
    end
    
    if (~isequal(size(score1),size(score2)))
        error('Score vectors must be of same size!');
    end
    
    
    % Get intervals
    angles = linspace(0,pi,nBins);
    shifts = zeros(nBins,nBins);
    
    nlabels = numel(labels);
    nPos = sum(labels);
    nNeg = nlabels - nPos;
    guessCount = zeros(nBins,nBins);
    
    TPR = zeros(nBins);
    FPR = zeros(nBins);
    
    for i=1:nBins
        if (angles(i) >= 0 && angles(i) < pi/2)
            slope = tan(angles(i));
            kstart = min(score2) - slope * max(score1);
            kend = max(score2) - slope * min(score1);
            shifts(i,:) = linspace(kstart,kend,nBins);
            
            for j=1:nBins
                Guess = zeros(nlabels,1);
                Guess(score2 <= slope * score1 + shifts(i,j)) = 1; % below the line
                guessCount(i,j) = sum(Guess);
                
                TP = (Guess == 1) & (labels == 1);
                FP = (Guess == 1) & (labels == 0);

                TPR(i,j) = sum(TP) / nPos;
                FPR(i,j) = sum(FP) / nNeg;
            end
        else
            slope = tan(angles(i));
            kstart = min(score2) - slope * min(score1);
            kend = max(score2) - slope * max(score1);
            shifts(i,:) = linspace(kstart,kend,nBins);
            
            for j=1:nBins
                Guess = zeros(nlabels,1);
                Guess(score2 <= slope * score1 + shifts(i,j)) = 1; % below the line
                guessCount(i,j) = sum(Guess);
                
                TP = (Guess == 1) & (labels == 1);
                FP = (Guess == 1) & (labels == 0);

                TPR(i,j) = sum(TP) / nPos;
                FPR(i,j) = sum(FP) / nNeg;
            end
        end
    end
    
    AllAUROC = zeros(1,nBins);
    
    for i=1:nBins
        AllAUROC(i) = trapz(TPR(i,:),FPR(i,:));
    end
    
    AntiClassIds = (AllAUROC < 0.5);
    
    AllAUROC = max(AllAUROC,1 - AllAUROC);
    
    bestAngleInd = (AllAUROC == max(AllAUROC));
    OptOrient = angles(bestAngleInd);
    bestGuessCounts = guessCount(bestAngleInd,:);
    
    if (AntiClassIds(bestAngleInd) == 1)
        OptROC = 1 - [TPR(bestAngleInd,:); FPR(bestAngleInd,:)];
        bestShiftsFunc = abs(bestGuessCounts - nPos);
    else
        OptROC = [TPR(bestAngleInd,:); FPR(bestAngleInd,:)];
        bestShiftsFunc = abs(bestGuessCounts - nNeg);
    end
    
    bestShiftInd = (bestShiftsFunc == min(bestShiftsFunc));
    OptShift = shifts(bestAngleInd,bestShiftInd);
    OptAUROC = AllAUROC(bestAngleInd);

    %OptAUROC = trapz(OptROC(1,:),OptROC(2,:));
    
%     figure
%     subplot(1,4,1)
%     imagesc(linOrient,linOrient,flipud(TPR'))
%     xlabel('Angle')
%     ylabel('Shift')
%     zlabel('TPR')
%     title('TPR(Angle,Shift)')
%     set(gca,'YTickLabel',[]);
%     set(gca,'YTick',[])
%     
%     subplot(1,4,2)
%     imagesc(linOrient,linOrient,flipud(FPR'))
%     xlabel('Angle')
%     ylabel('Shift')
%     zlabel('FPR')
%     title('FPR(Angle,Shift)')
%     set(gca,'YTickLabel',[]);
%     set(gca,'YTick',[])
%     
%     subplot(1,4,3)
%     plot(linOrient,AllAUROC)
%     xlabel('Angle')
%     ylabel('AUROC')
%     title('AUROC vs. Angle')
%     
%     subplot(1,4,4)
%     plot(OptROC(1,:),OptROC(2,:))
%     xlabel('FPR')
%     ylabel('TPR')
%     title( sprintf('ROC at Angle = %0.2f $\pi$',OptOrient/pi), 'interpreter','latex' )
%     set(gca,'YTickLabel',[]);
%     set(gca,'YTick',[])
end

