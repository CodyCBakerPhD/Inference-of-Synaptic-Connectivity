
function PlotRates(smoothing,scaleN,EratesSamp,EratesBal,IratesSamp,IratesBal)
    
    lowN = min(scaleN);
    hiN = max(scaleN);
    temp = diff(scaleN);
    
    if ~isempty(temp)
        byN = temp(1);
    else
        byN = 0;
    end
    
    figure
    
    newBins = lowN:(byN*smoothing):hiN;

    [reVsN,reVsNErr] = plotSmoothing(scaleN,newBins,EratesSamp);
    [riVsN,riVsNErr] = plotSmoothing(scaleN,newBins,IratesSamp);
    [balEVsN,~] = plotSmoothing(scaleN,newBins,EratesBal);
    [balIVsN,~] = plotSmoothing(scaleN,newBins,IratesBal);

    plot(newBins,reVsN,'b-')
    errorbar(newBins,reVsN,reVsNErr)
    hold on
    plot(newBins,balEVsN,'b--')

    plot(newBins,riVsN,'r-')
    errorbar(newBins,riVsN,riVsNErr)
    hold on
    plot(newBins,balIVsN,'r--')

    title('Rates vs. N')
    xlabel('N')
    ylabel('Rate (Hz)')
end

