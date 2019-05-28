
% BiDirIds = GetBiDirIds(W,N,Ne)
%
% For a blockwise directed adjacency matrix W, return the string Ids
% of values resulting from the equation
%       W + W'
% and thus corresponding to one of 8 groups:
%       'EE1'-'EE2'-'II1'-'II2'-'EI'-'IE'-'EIIE'-'Z'
% where 1 or 2 represents unidirectional and bidirectional connections.

% This function is mostly for use on randomly weighted adjacencies, since
% the 8 groups under static weights form deterministic values...

function BiDirIds = GetBiDirIds(W,N,Ne)
    
    temp = 1*(W ~= 0);
    
    Eids = 1:Ne;
    Iids = (Ne+1):N;
    
    temp(Eids,Eids) = temp(Eids,Eids) * 1;
    temp(Eids,Iids) = temp(Eids,Iids) * 3;
    temp(Iids,Eids) = temp(Iids,Eids) * 5;
    temp(Iids,Iids) = temp(Iids,Iids) * 7;
    
    temp2 = temp + temp';
    temp2( logical(tril(ones(N))) ) = nan;
    
    BiDirIds = strings(N,N);
    
    BiDirIds(temp2 == 1) = 'EE1';
    BiDirIds(temp2 == 2) = 'EE2';
    BiDirIds(temp2 == 7) = 'II1';
    BiDirIds(temp2 == 14) = 'II2';
    BiDirIds(temp2 == 3) = 'EI';
    BiDirIds(temp2 == 5) = 'IE';
    BiDirIds(temp2 == 8) = 'EIIE';
    
    % assign different zero groups
    Ni = N - Ne;
    IEZMat = nan(Ne,Ni);
    IIZMat = nan(Ni);
    EEZMat = nan(Ne);
    temp2EE = [temp2(Eids,Eids) IEZMat ; IEZMat' IIZMat];
    temp2EI = [EEZMat temp2(Eids,Iids) ; IEZMat' IIZMat];
    temp2II = [EEZMat IEZMat ; IEZMat' temp2(Iids,Iids)];
    BiDirIds(temp2EE == 0) = 'EE0';
    BiDirIds(temp2EI == 0) = 'EIIE0';
    BiDirIds(temp2II == 0) = 'II0';
end




