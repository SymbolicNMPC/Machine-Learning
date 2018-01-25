Norm2 := proc (x::Vector, n::integer)  :: float:
   local i::integer, M::float:=0.0;
   for i to n do
   	M := M + x[i]*x[i];
   end do;
   return sqrt(M); 
end proc: