
function NormMat = NormalizeByDiag(Mat)
    
    D = diag( diag(Mat) );
    Dinvsqrt = abs( sqrt( inv(D) ) );
    NormMat = Dinvsqrt * Mat * Dinvsqrt;
end

