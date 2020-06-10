function [points] = BernsteinEval(p,T,times)
% a function to evaluate a bezier curve with control points given by p
%   p contains the control points in the following example form:
%     x1 y1 
%     x2 y2
%     x3 y3
%   T is the time length of the curve
%   times are the points to evaluate

    if size(p,2)==1
        points = arrayfun(@(t)BernsteinEvalMat(size(p,1)-1,T,t)*p,times);
    else
        points = BernsteinEvalMat(size(p,1)-1,T,times(:))*p;
    end
    
end