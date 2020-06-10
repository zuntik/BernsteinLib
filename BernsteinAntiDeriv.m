function [new_p] = BernsteinAntiDeriv(p,T,p0)
    %make sure everything is is columns
    [mat,vec] = BernsteinAntiDerivMat(size(p,1)-1,T,p0);
    new_p = mat*p+vec;

end