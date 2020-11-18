function [new_p] = BernsteinMul(p1,p2, choose_mat, varargin)

    m = size(p1,1)-1;
    n = size(p2,1)-1;

    new_p = zeros(m+n+1,size(p1,2));

    for i = 0 : m+n 
        for j = max(0,i-n):min(m,i)
            if nargin < 3
                %new_p(i+1,:) = new_p(i+1,:) + (nchoosek(m,j)*nchoosek(n,i-j)/nchoosek(m+n,i)) .* p1(j+1,:) .* p2(i-j+1,:);
                new_p(i+1,:) = new_p(i+1,:) + nchoosek_mod(i,j)*nchoosek_mod(m+n-i,m-j).* p1(j+1,:) .* p2(i-j+1,:);
            else
                new_p(i+1,:) = new_p(i+1,:) + choose_mat(i+1,j+1)*nchoosek_mod(m+n-i,m-j).* p1(j+1,:) .* p2(i-j+1,:);
            end
        end
    end
    new_p = new_p./nchoosek_mod(m+n,n);

end