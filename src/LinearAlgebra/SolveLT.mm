SolveLT := proc(L,y,n,x)
    local i,j,s;
    for i to n do
        if i > 1 then
            s := add(L[i,j]*x[j],j=1..i-1);
        else
            s := 0;
        end if;

        x[i] := (y[i]-s)/L[i,i];
    end do;
end proc;