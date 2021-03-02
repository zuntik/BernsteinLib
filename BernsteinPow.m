function new_p = BernsteinPow(p, y, choose_mat, varargin)
    if y == 0
        new_p = ones(1,size(p,2));
        return
    end
    temp_p = BernsteinPow(p,floor(y/2));
    if rem(y,2) == 0
        if nargin < 3
            new_p = BernsteinMul(temp_p,temp_p);
        else
            new_p = BernsteinMul(temp_p,temp_p,choose_mat);
        end
    else
        if nargin < 3
            new_p = BernsteinMul(p,BernsteinMul(temp_p,temp_p));
        else
            new_p = BernsteinMul(p,BernsteinMul(temp_p,temp_p, choose_mat), choose_mat);
        end
    end
end