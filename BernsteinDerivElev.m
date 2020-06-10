function [new_p] = BernsteinDerivElev(p,T)
    new_p = BernsteinDeriv(BernsteinDegrElev(p,size(p,1)),T);
    %new_p = BernsteinDegrElev(BernsteinDeriv(p,T),size(p,1));
end