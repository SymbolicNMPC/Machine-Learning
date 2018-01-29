SolveUT := proc(L,y,n,x)
    local i,j,s;
    for i from n to 1 by -1 do
        if i < n then
            s := add(L[i,j]*x[j],j=i+1..n);
        else
            s := 0;
        end if;
        x[i] := (y[i]-s)/L[i,i];
    end do;
end proc;