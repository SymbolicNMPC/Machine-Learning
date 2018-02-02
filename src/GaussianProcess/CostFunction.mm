CostFunction := proc(X,y,logtheta,n,N,JacobianVector)
    local CovMat, CovMatInv, DetCovMat, IM, i, j, k, alpha, W, dC, thetai;
    
    CovMat := Matrix(N);
    CovMatInv := Matrix(N);
    dC := Matrix(N);
    IM := LinearAlgebra:-IdentityMatrix(N);

    CovarianceMatrix(X,logtheta,n,N,CovMat);
    DetCovMat := PDMatrixInverse(CovMat,N,CovMatInv);

    alpha := CovMatInv.y;
    W := CovMatInv-alpha.alpha^+;
    
    for i to n+2 do
        thetai := exp(logtheta[i]);

        if i <= n then
            SquaredDistance((1/thetai)*Matrix(X[i,..]),(1/thetai)*Matrix(X[i,..]),1,N,N,dC);
            dC := dC*~CovMat;
        elif i=n+1 then
            dC := 2*(CovMat-exp(2*logtheta[n+2])*IM);
        else
            dC := 2*thetai^2*IM;
        end if;
            
        dC := W*~dC;
        JacobianVector[i] := 0;
        for j to N do
            for k to N do
                JacobianVector[i] := JacobianVector[i] + 0.5*dC[j,k];
            end do;
        end do;
    end do;

    return 0.5*(log(DetCovMat)+y^%T.alpha+n*log(2*evalf(Pi)));

end proc;