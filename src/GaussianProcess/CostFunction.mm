CostFunction := proc(X,y,logtheta,n,N,JacobianVector)
    local CovMat, CovMatInv, DetCovMat;
    
    CovMat := Matrix(N);
    CovMatInv := Matrix(N);

    CovarianceMatrix(X,logtheta,n,N,CovMat);
    DetCovMat := PDMatrixInverse(CovMat,N,CovMatInv);

    return log(DetCovMat)+y^%T.CovMatInv.y+n*log(2*evalf(Pi));

end proc;