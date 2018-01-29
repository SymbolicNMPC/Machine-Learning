Mean := proc(X,n,N,m)
    local i;

    for i to n do
        m[i] := Mean1D(X[i,..],N);
    end do;

end proc;

Mean1D := proc(X,N)

    local s := 0, i;

    for i to N do
        s:=s+X[i];
    end do;

    return s/N;

end proc;