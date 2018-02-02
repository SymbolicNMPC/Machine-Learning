PDMatrixInverse := proc(A::Matrix,
                        n::posint,
                        B::Matrix)
    local L, I, ei, i;
    
    I := LinearAlgebra:-IdentityMatrix(n);
    ei := Vector(n);

    L := LinearAlgebra:-LUDecomposition(A, ':-method'='Cholesky');
    for i to n do
        SolveLT(L,I[..,i],n,ei);
        B[..,i] := ei;
    end do;

    L := L^%T;
    for i to n do
        SolveUT(L,B[..,i],n,ei);
        B[..,i] := ei;
    end do;
    
    return mul(L[i,i],i=1..n)^2;

end proc;