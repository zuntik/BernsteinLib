function [new_p] = BernsteinAntiDeriv(p,T,p0)
    %make sure everything is is columns
    [ n, dim ] = size(p);
    if n==1 && dim ~= 1
        p = p';
        [ n, ~ ] = size(p);
        p0 = p0.';
    end
    n = n-1;
    
    [mat,vec] = BernsteinAntiDerivMat(n,T,p0);
    new_p = mat*p+vec;

end