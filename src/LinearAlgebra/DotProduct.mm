CovarianceMatrix := proc(X,logtheta,n,N,CovMat)
   local theta, i;

   theta := exp(logtheta[n+2]);

   KernelFunction(X,X,logtheta,n,N,N,CovMat);
   for i to N do
      CovMat[i,i]:=CovMat[i,i]+theta^2;
   end do;
end proc: