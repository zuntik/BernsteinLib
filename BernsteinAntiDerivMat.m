function [mat,vec] =  BernsteinAntiDerivMat(n,T,p0)

mat = tril(ones(n+2,n+1).*(T/(n+1)),-1);
vec = p0;

end
