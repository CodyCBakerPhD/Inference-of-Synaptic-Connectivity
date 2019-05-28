
function [avg,err] = plotSmoothing(oldBins,newBins,oldY)
    
    thbins=newBins;
    nthbins = numel(thbins);
    avg=zeros(nthbins,1);
    err=zeros(nthbins,1);
    [~,I]=histc(oldBins,thbins);
    for j=1:nthbins
       avg(j)=mean(oldY(I==j));
       err(j)=std(oldY(I==j))/sqrt(nnz(I==j)); 
    end
end