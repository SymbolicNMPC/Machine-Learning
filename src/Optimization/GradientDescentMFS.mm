GradientDescentMFS := proc (J :: procedure,
                          X0::Vector,
						  M::Vector,
					      epsilon::float,
					      imax::posint,
						  step::positive,
					      params::Vector,
					      n::integer,
					      X :: Vector
					     )

				   local i::integer, 
				         j::integer,
				         f_X::Vector;
				         
					f_X := Vector(n);
				   
				    for i to n do
				     X[i] := X0[i];
  			    	 f_X[i] := 2.0*epsilon;
				    end do; 

				    for i to imax while Norm2(f_X, n) > epsilon do 
 			          J(X, params, f_X);
				      for j from 1 to n do
				         X[j] := X[j]-step*M[j]*f_X[j];
				      end do:
				    end do; 

				    return;
end proc:
