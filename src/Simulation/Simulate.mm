# Results := Simulate(Model, Inputs)

Simulate := proc(Model, Inputs, {SimulationTime := 1, TimeStep := 0.1})
   local Results,
         ModelExports,
         States,
         Derivatives,
         ControlInputs,
         Outputs,
         Equations,
         AuxVariables,
         InitialConditions,
         ModelParameters,
         XH,
         UH,
         YH,
         N,
         nx,
         nu,
         ny := 0,
         i,
         j,
         dsn,
         t := ':-t';

   ModelExports := {exports(Model)};

   # State variables
   if ':-States' in ModelExports then
      States := Model:-States;
      nx := numelems(States);
   else
      States := [];
      nx := 0;
   end if;

   # Derivatives of state variables
   if ':-Derivatives' in ModelExports then
      Derivatives := Model:-Derivatives;
   end if;

   # Model parameters
   if ':-Parameters' in ModelExports then
      ModelParameters := Model:-Parameters;
   else
      ModelParameters := [];
   end if;

   # Model equations
   if ':-Equations' in ModelExports then
      Equations := Model:-Equations;
   end if;

   # Initial conditions
   if ':-InitialConditions' in ModelExports then
      InitialConditions := States(0)=~Model:-InitialConditions;
   else
      InitialConditions := States(0)=~[seq(0,i=1..nx)];
   end if;

   # Outputs
   if ':-Outputs' in ModelExports then
      Outputs := Model:-Outputs;
      ny := numelems(Outputs);
   else
      Outputs := [];
      ny := 0;
   end if;
   
   # Control inputs
   if ':-ControlInputs' in ModelExports then
      ControlInputs := Model:-ControlInputs;
      nu := numelems(ControlInputs);
   else
      ControlInputs := [];
      nu := 0;
   end if;
   
   # Number of simulation steps
   N := ceil(SimulationTime/TimeStep);

   UH := Matrix(N,nu);

   if _params['Inputs'] = NULL then
      for i to N do
          for j to nu do
              UH[i,j] := rand(evalf(Model:-ControlLowerBound[j])..evalf(Model:-ControlUpperBound[j]))();
          end do;
      end do;
   else
      for i to N do
          UH[i,..] := eval(Model:-ControlInputs((i-1)*TimeStep), eval(Inputs, t=(i-1)*TimeStep));
      end do;
   end if;

   # Auxiliary variables
   AuxVariables := convert(indets(Equations,':-name') 
                           minus {seq(States)} 
                           minus {seq(Derivatives)} 
                           minus {seq(ControlInputs)} 
                           minus {seq(lhs~(ModelParameters))}, ':-list');

   # Substitue parameters
   Equations := eval(Equations, ModelParameters);

   # Add time
   Equations := eval(Equations, [seq(States=~States(t)), seq(ControlInputs=~ControlInputs(t)), seq(AuxVariables=~AuxVariables(t))]); 
 
   # Substitute derivatives
   Equations := eval(Equations, Derivatives=~map(diff,States(t),t));
   
   XH := Matrix(N+1,nx);
   YH := Matrix(N,ny);

   XH[1,..] := Vector(rhs~(InitialConditions))^%T;
   YH[1,..] := Vector(eval(Outputs,[seq(States=~[seq(XH[1,..])]),seq(ControlInputs=~[seq(UH[1,..])])]))^%T;

   for i to N-1 do
       dsn := dsolve([seq(eval(Equations, ControlInputs(t)=~[seq(UH[i,..])])), seq(InitialConditions)], ':-numeric', States(t),':-range'=i*TimeStep..(i+1)*TimeStep);
       XH[i+1,..] := Vector(eval(States(t),dsn((i-1)*TimeStep)))^%T;
       YH[i+1,..] := Vector(eval(eval(Outputs,[seq(States=~States(t)),seq(ControlInputs=~ControlInputs(t))]),dsn((i-1)*TimeStep)))^%T;
       InitialConditions := States((i+1)*TimeStep)=~[seq(0,j=1..nx)];
   end do; 
   
   Results := Record(':-StateHistory' = XH, ':-InputHistory' = UH, ':-OutputHistory' = YH);
   return Results;

end proc;