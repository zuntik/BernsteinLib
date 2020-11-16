function [points] = BernsteinEval(p,T,times)
% a function to evaluate a bezier curve with control points given by p
%   p contains the control points in the following example form:
%     x1 y1 
%     x2 y2
%     x3 y3
%   T is the time length of the curve
%   times are the points to evaluate

    points = cell(1,1,size(p,3));
    for i = 1:size(p,3)
        if size(p,2)==1
            points{1,1,i} = arrayfun(@(t)BernsteinEvalMat(size(p(:,:,i),1)-1,T,t)*p(:,:,i),times);
        else
            points{1,1,i} = BernsteinEvalMat(size(p(:,:,i),1)-1,T,times(:))*p(:,:,i);
        end
    end
    points = cell2mat(points);
    
end