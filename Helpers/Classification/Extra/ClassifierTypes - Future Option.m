switch ClassifierType
        case 'logreg'
            logReg = mnrfit(abs(estval),labels+1); % +1 since it doesn't like zeros
            scores = mnrval(logReg,abs(estval));
            scores = scores(:,2); % 2 is pos class
        case 'lda'
            Mdl = fitcdiscr(abs(estval),labels);
            [~,scores,~] = predict(Mdl,labels);
            scores = scores(:,2); % 2 is pos class
        case 'none'
            scores = sigmf(abs(estval),[1/2 mean(abs(estval))]);
    end