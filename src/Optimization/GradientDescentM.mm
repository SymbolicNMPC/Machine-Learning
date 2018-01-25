GradientDescentM := proc (f :: procedure,
                         J :: procedure,
                         X0::Vector,
						 M::Vector,
					     epsilon::float,
					     imax::posint,
					     smax::positive,
					     params::Vector,
					     n::integer,
					     X :: Vector
					    )

				   local i::integer, 
				         j::integer,
				         f_X::Vector,
						 dX::Vector,
                         Xopt::Vector,
				         StepBounds::Vector,
						 Step::Vector,
						 fH::Vector; 
				         
					f_X := Vector(n);
					Xopt := Vector(n);
					dX := Vector(n);
					fH := Vector(imax); 
				    Step := Vector(imax); 

					StepBounds := Vector(2);
                    StepBounds[2] := smax;
				   
				    for i to n do
				     X[i] := X0[i];
				    	f_X[i] := 2.0*epsilon;
				    end do; 

				    for i to imax while Norm2(f_X, n) > epsilon do 
				       J(X, params, f_X);
					  for j from 1 to n do
			             dX[j] := M[j]*f_X[j];
					  end do;
				      Step[i], fH[i] := MinimizeIntervalM(f, StepBounds, epsilon, imax, X, dX, params, Xopt, n); 

				      for j from 1 to n do
				         X[j] := Xopt[j];
				      end do:
				    end do; 

				    return Step, fH;
end proc:
