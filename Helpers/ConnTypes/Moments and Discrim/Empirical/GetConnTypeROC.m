
% For plotting, figure is assumed to be open

function ROC = GetConnTypeROC(prec,BiDirIds,plotROC)

    if (nargin == 2)
        plotROC = false;
    end
    
    N = size(prec,1);
    if (N > 5e3)
        nUse = 5e3; % hardcoded for eps output
    else
        nUse = N;
    end
    
    ConnTypeValues = GetConnTypeValues(prec,BiDirIds,nUse);
    
    if (any(ConnTypeValues.Conn))
        [X,Y,T,AUROC] = perfcurve([ones(numel(ConnTypeValues.Conn),1); ...
                                   zeros(numel(ConnTypeValues.Null),1)], ...
                                                        [ConnTypeValues.Conn; ConnTypeValues.Null],1);
        if (AUROC < 0.5)
            X = 1 - X;
            Y = 1 - Y;
            AUROC = 1 - AUROC;
        end
        
        ROC = struct();
        ROC.X = X;
        ROC.Y = Y;
        ROC.T = T;
        ROC.AUROC = AUROC;
        
        lw = 2;
        fz = 16;

        if (plotROC == true)

            figure
            
            plot(ROC.X,ROC.Y, 'k-', 'Linewidth',lw)
            hold on
            plot(0:1,0:1, 'r--', 'Linewidth',lw)
            box off
            title('Connected vs. Null Group')
            set(gca,'LineWidth',lw)
            set(gca,'FontSize',fz)
        end
    else
        ROC = [];
    end
end

