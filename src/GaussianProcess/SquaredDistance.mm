SquaredDistance := proc(X1,X2,n,N1,N2,K)
   local V::Vector,
         i,
         j,
         k;

   for i to N1 do
   	for j to N2 do
   		for k to n do
   		   V[k] := X1[k,i]-X2[k,j];
   		end do;
   		K[i,j]:=DotProduct(V,V,n);
   	end do;
   end do;
   return K;
end proc:
