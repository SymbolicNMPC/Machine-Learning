StandardDeviation := proc(X,n,N,sigma)
    local i;

    for i to n do
        sigma[i] := StandardDeviation1D(X[i,..],N);
    end do;

end proc;

StandardDeviation1D := proc(X,N)

    local s := 0, m, i;

    m := Mean1D(X,N);

    for i to N do
        s:=s+(X[i]-m)^2;
    end do;

    return sqrt(s/N);

end proc;