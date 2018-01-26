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
description "Machine learning ";
option package;

export CovarianceMatrix,
       KernelFunction,
       Simulate;

$include "Simulation/Simulate.mm"
$include "GuassianProcess/KernelFunction.mm"
$include "GuassianProcess/CovarianceMatrix.mm"

end module; # MachineLearning
