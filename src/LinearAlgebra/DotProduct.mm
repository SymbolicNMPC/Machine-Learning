DotProduct := proc(X1,X2,n)
   local i, dp;
   dp := 0;
   for i to n do
   	dp := dp + X1[i]*X2[i];
   end do;
   return dp;
end proc: