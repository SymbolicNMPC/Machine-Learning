# Machine Learning

##
## Copyright (C) 2018 Maplesoft
## Authors:    Behzad Samadi <bsamadi@maplesoft.com>
## Created:    January 2018
## Version:    0.1
## Keywords:   Machine Learning, Maple, Code Generation, Reinforcement Learning, Gaussian Process Regression, Bayesian Optimizaiton
##
## Procedures:
##    Simulate
##

MachineLearning := module()
description "Machine learning";
option package;

export CovarianceMatrix,
       DotProduct,
       KernelFunction,
       Mean,
       Mean1D,
       Norm2,
       StandardDeviation,
       StandardDeviation1D,
       Simulate,
       SolveLT,
       SolveUT;

$include "Simulation/Simulate.mm"
$include "LinearAlgebra/DotProduct.mm"
$include "LinearAlgebra/Norm2.mm"
$include "LinearAlgebra/SolveLT.mm"
$include "LinearAlgebra/SolveUT.mm"
$include "GaussianProcess/CovarianceMatrix.mm"
$include "GaussianProcess/KernelFunction.mm"
$include "GaussianProcess/Mean.mm"
$include "GaussianProcess/StandardDeviation.mm"

end module; # MachineLearning
