KernelFunction := proc(X1,X2,logtheta,n,N1,N2,K)
   local theta::Vector,
         V::Vector,
         i,
         j,
         k;

   for i to n+1 do
      theta[i] := exp(logtheta[i]);
   end do;

   for i to N1 do
   	for j to N2 do
   		for k to n do
   		   V[k] := (X1[k,i]-X2[k,j])/theta[k];
   		end do;
   		K[i,j]:=theta[n+1]^2*exp(-DotProduct(V,V,n)/2);
   	end do;
   end do;
   return K;
end proc:
