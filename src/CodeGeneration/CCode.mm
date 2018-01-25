# Code generation

CCode := proc(States, Costates, F_xuw, dF_xuw, CostFunc, JCF, dimx, dimu, dimw, N, Nc)
	local Fxuw, dFxuw, Fxuc, dFxuc, CostFunction, JacobianCF, CFc, JCFc, Code_str, Include, IncludeLines, i, j, defs, WL, optionsC,
    GD, GDc, MI, MIc, N2, N2c, mainMPC, mainc, n:=Nc*dimu, np:=dimx+N*dimw, ReturnStatement, fir;

    optionsC := ':-defaulttype' = ':-float', ':-deducereturn' = false, ':-deducetypes' = false, ':-coercetypes' = false, ':-output' = ':-string';

    # Vector field
    fir := ToInert(eval(F_xuw));
    ReturnStatement := indets(fir,specfunc(':-_Inert_LIST'))[1];
    Fxuw:=FromInert(subs(ReturnStatement=':-_Inert_RETURN'(ReturnStatement),fir)):

    # Jacobian of the vector field
    dFxuw:=codegen:-makeparam('grd',dF_xuw):

    # Cost function
    fir := ToInert(eval(CostFunc));
    ReturnStatement := indets(fir,specfunc(':-_Inert_STATSEQ'))[1];
    CostFunction := FromInert(subs(ReturnStatement=':-_Inert_STATSEQ'(op(ReturnStatement)[1..-2],':-_Inert_RETURN'(':-_Inert_INTPOS'(0))), fir));

    # Jacobian of the cost function (optimality conditions)
    JacobianCF := JCF:
         
    # Gradient descent
    GD := parse(StringTools:-SubstituteAll(convert(eval(':-OptimCode:-GradientDescent'),string),"OptimCode:-","C")):
    GD := RemoveParam(GD,':-f', ':-substitute' = false);
    GD := RemoveParam(GD,':-J', ':-substitute' = false):
    GD := ModifyArgs(GD,'CNorm2', 2);
    GD := ModifyArgs(GD,'CMinimizeInterval', 1);
    GD := ModifyArgs(GD,'CMinimizeInterval', 8);
    GD := RemoveParam(GD,':-n',n);
    GD := subs(':-J'=':-JacobianCF',eval(GD));

    # Minimize interval
    MI := parse(StringTools:-SubstituteAll(convert(eval(':-OptimCode:-MinimizeInterval'),string),"OptimCode:-","C")):
    MI := RemoveParam(MI,':-f', ':-substitute' = false);
    MI := RemoveParam(MI,':-n',n);
    MI := subs(':-f'=':-CostFunction',eval(MI));

    # Norm 2
    N2 := parse(StringTools:-SubstituteAll(convert(eval(':-OptimCode:-Norm2'),string),"OptimCode:-","C")):
    N2 := RemoveParam(N2, ':-n', n);

    # Main MPC
    mainMPC := parse(StringTools:-SubstituteAll(convert(eval(':-OptimCode:-MPCtrl'),string),"OptimCode:-","C"));

    WL := interface(warnlevel);
    interface(warnlevel=0);

    Fxuc := CodeGeneration:-C(Fxuw,optionsC);
    dFxuc := CodeGeneration:-C(dFxuw,optionsC);
    CFc := CodeGeneration:-C(CostFunction, ':-declare'=[':-U'::'Vector'(n), ':-Xn'::'Vector'(dimx), ':-f_X'::'vector'(n), ':-flag'::'integer', 
                                 seq(seq(MakeName(States[j],i)::'float', i=0..N-1),j=1..dimx),
                                 seq(seq(MakeName(Costates[j],i)::'float', i=0..N-1),j=1..dimx),
                                 seq(MakeName('F',i)::'Vector'(dimx), i=0..N-1), 
                                 seq(MakeName('dF',i)::'Matrix'(dimx,dimx+dimu),i=0..N) ], optionsC);
    JCFc := CodeGeneration:-C(JacobianCF, ':-declare'=[':-U'::'Vector'(n), ':-Xn'::'Vector'(dimx), ':-f_X'::'vector'(n),
                                 seq(seq(MakeName(States[j],i)::'float', i=0..N-1),j=1..dimx),
                                 seq(seq(MakeName(Costates[j],i)::'float', i=0..N-1),j=1..dimx),
                                 seq(MakeName(':-F',i)::'Vector'(dimx), i=0..N-1), 
                                 seq(MakeName(':-dF',i)::'Matrix'(dimx,dimx+dimu),i=0..N) ], optionsC);
    GDc := CodeGeneration:-C(GD,':-declare'=[':-f_X'::'Vector'(n),':-dX'::'Vector'(n),':-Xopt'::'Vector'(n),
                                             ':-M'::'Vector'(n),':-StepBounds'::'Vector'(2)], optionsC);
    MIc := CodeGeneration:-C(MI,':-declare'=[':-X1'::'Vector'(n),':-X2'::'Vector'(n),':-F1'::'Vector'(n),':-F2'::'Vector'(n), 
                                             ':-flag1'::'integer',':-flag2'::'integer'], optionsC);
    N2c := CodeGeneration:-C(N2,optionsC);
    mainc := CodeGeneration:-C(mainMPC,':-declare'=['Uopt'::'Vector'(n), 'U'::'Vector'(n), 'xW'::'Vector'(np), ':-M'::'Vector'(n)], optionsC);
     
    interface(warnlevel=WL);

    # Generate the C code
    Code_str := cat(Fxuc,dFxuc,CFc,JCFc,N2c,MIc,GDc,mainc):

    Code_str := StringTools:-SubstituteAll(Code_str,"CostFunctionC","CostFunction"):
    Code_str := StringTools:-SubstituteAll(Code_str,"N2","Norm2"):
    Code_str := StringTools:-SubstituteAll(Code_str,"CNorm2","Norm2"):
    Code_str := StringTools:-SubstituteAll(Code_str,"MI","MinimizeInterval"):
    Code_str := StringTools:-SubstituteAll(Code_str,"CMinimizeInterval","MinimizeInterval"):
    Code_str := StringTools:-SubstituteAll(Code_str,"GD","GradientDescent"):
    Code_str := StringTools:-SubstituteAll(Code_str,"CGradientDescent","GradientDescent"):
    Code_str := StringTools:-SubstituteAll(Code_str,"OCPC","JacobianCF"):
    Include:=[StringTools:-SearchAll("#include",Code_str)]:
    IncludeLines:= {seq(Code_str[Include[i]..Include[i]+StringTools:-Search("\n", Code_str[Include[i] .. -1])],i=1..numelems(Include))}:
    for i to numelems(IncludeLines) do
      Code_str := StringTools:-SubstituteAll(Code_str,IncludeLines[i],""):
    end do:
    defs := "#ifdef WMI_WINNT\n #define EXP __declspec(dllexport)\n #define M_DECL __stdcall\n #else\n #define EXP\n #define M_DECL\n #endif\n\n":
    Code_str := cat(seq(IncludeLines),defs,Code_str):
    Code_str := StringTools:-Substitute(Code_str,"void MPCmain","EXP void M_DECL MPCmain"):

    return Code_str;

	end proc:
