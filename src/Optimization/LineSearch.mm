MinimizeInterval := proc(
	               f::procedure,
	               R::Vector, 
				   epsilon::float, 
				   imax::float,
				   X :: Vector,
				   f_X :: Vector,
				   params :: Vector,
				   Xopt :: Vector,
				   n :: integer)

		    local phi, 
		          a, 
		          b,
				      c1,
				      c2, 
							flag1,
							flag2,
		          X1::Vector, 
		          X2::Vector, 
		          i::integer, 
		          j::integer,
		          F1::Vector, 
		          F2::Vector;

        for i to n do
				  X1[i] := 0;
					X2[i] := 0;
					F1[i] := 0;
					F2[i] := 0;
				end do;

		    a:=R[1];
		    b:=R[2];

		    phi := (sqrt(5.) - 1)/2:

        i := 0;
		    while abs(b - a) > epsilon and i < imax do
		       c1 := phi*a + (1 - phi)*b;
		       c2 := (1 - phi)*a + phi*b;
		       for j from 1 to n do
		          X1[j] := X[j] - c1 * f_X[j]:
		          X2[j] := X[j] - c2 * f_X[j]:
		       end do:
		       flag1 := f(X1,params,F1);
		       flag2 := f(X2,params,F2);
					 if flag1 = 0 and flag2 = 0 then
		         if F1[1] < F2[1] then
		           b := c2;
		         else
  		         a := c1;
		         end if;
					 elif flag1 = 0 then
             b := c2; # if c2 steps outside of the feasible set, make it the upper bound
					 else 
					   b := c1; # if c1 steps outside of the feasible set, make it the upper bound
					 end if;
			   i := i+1;
		    end do:  
            
			  c1 := (a+b)/2;            
			  for j from 1 to n do
			    Xopt[j]:=X[j] - c1 * f_X[j];
			  end do;

		    return;
end proc:
