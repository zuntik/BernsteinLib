function [new_p] = BernsteinSum(p1,p2)

[ m, dim1 ] = size(p1);
[ n, dim2 ] = size(p2);

if dim1 ~= dim2
    error('dimentions don''t match');
end

if m>n
    p2 = BernsteinDegrElev(p2,m-1);
elseif n>m
    p1 = BernsteinDegrElev(p1,n-1);
end

new_p = p1+p2;

end