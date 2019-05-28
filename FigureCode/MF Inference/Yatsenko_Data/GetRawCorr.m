
load ../PV-data_Copy.mat
addpath(genpath('../../../Helpers'))


%%
LongTimeExp = [2:2:6 7:2:21];
nLongTimeExp = numel(LongTimeExp);
nOrs = 2;
nData = nLongTimeExp * nOrs;

RawCorrs = cell(nData,1);
MeanRawMFCorrs = zeros(2,2,nData);
StdRawMFCorrs = zeros(2,2,nData);
SteRawMFCorrs = zeros(2,2,nData);

c = 1;
for i=LongTimeExp
    temp1 = data(i).trace_segments;
    
    for j=1:nOrs
        temp2 = squeeze(temp1(:,j,:,:)); % by orientation
        nNeur = size(temp2,3);
        PVPos = strcmp(data(i).celltypes,'PV');
        [~,PVPosOrder] = sort(PVPos);
        nPVNeg = sum(PVPos == 0);
        covSamps = zeros(nNeur);
        nTimeSamps = size(temp2,1);
        
        for k=1:nTimeSamps % avg the covariance sampled from trials over all time
            temp3 = squeeze(temp2(k,:,:));
            covSamps = covSamps + nancov(temp3);
        end
        
        covSamps = covSamps / nTimeSamps;
        
        [~,corrSamps] = cov2corr(covSamps);
        
        RawCorrs{c} = corrSamps(PVPosOrder,PVPosOrder);
        MeanRawMFCorrs(:,:,c) = MF(RawCorrs{c},1:nNeur,nPVNeg);
        StdRawMFCorrs(:,:,c) = sqrt(VF(RawCorrs{c},1:nNeur,nPVNeg));
        
        nPVPos = nNeur - nPVNeg;
        SteRawMFCorrs(:,:,c) = StdRawMFCorrs(:,:,c) ./ sqrt([nPVNeg^2 nPVNeg*nPVPos; ...
                                                                           nPVNeg*nPVPos nPVPos^2]);
        c = c + 1;
    end
end


%%
save 'RawMFCorrs.mat' 'MeanRawMFCorrs' 'StdRawMFCorrs' 'SteRawMFCorrs'
