function [d,intersection,simplex] = gjk2D(shape1,shape2,varargin)
%function [dist, pt1, pt2, simplex] = gjk2(shapeA,shapeB)

    % --- Input parsing
    p = inputParser;
    
    addParameter(p, 'epsilon', 1e-6, @isnumeric);
    addParameter(p, 'collcheckonly', false, @islogical);
    
    parse(p, varargin{:})
    epsilon = p.Results.epsilon;
    collcheckonly = p.Results.collcheckonly;
    % --- End input parsing


    %[S,pts] = supportwrapper(shape1,shape2,[1 0].');
    % point is a struct
    dir=[1;0];
    simplex={supportwrapper(shape1,shape2,dir)};

    dir = -dir;
    
    while true
        simplex{end+1} = supportwrapper(shape1,shape2,dir) ; %#ok<AGROW>
        if(dot(simplex{end}.P,dir)<=0)
            intersection=false;
            break
        end
        [intersection,simplex,dir] = containsorigin(simplex);
        if intersection
            break;
        end
    end

    if ~intersection
        if collcheckonly
            simplex = [];
            d=1;
        else
            simplex =mindist(simplex,shape1,shape2);
            d = norm(simplex.P);
        end
    else
        d = -1;
    end
    
end


function [intersection,simplex,d] = containsorigin(simplex)
    a = simplex{end};
    a0 = -a.P;
    if length(simplex) == 3
        b = simplex{end-1};
        c = simplex{end-2};
        ab = b.P - a.P;
        ac = c.P - a.P;
        abPerp = tripleProduct(ac,ab,ab);
        acPerp = tripleProduct(ab,ac,ac);
        if dot(abPerp,a0)> 0
            simplex(end-2) = [];
            d = abPerp;
        elseif dot(acPerp,a0) > 0
            simplex(end-1) = [];
            d = acPerp;
        else
            intersection=true;
            d = [];
            return
        end
    else
        b = simplex{1};
        ab = b.P - a.P;
%         if sum(abs(ab)) < 10e-10 && sum(abs(a.P)) > 10e-10
%             intersection = false;
%             d = [ 0; 0];
%             return            
%         end
        abPerp = tripleProduct(ab,a0,ab);
        d = abPerp;
        if ~any(d)
            intersection = true;
            return
        end

    end

    intersection=false;
end


function [point] = supportwrapper(shape1,shape2,D)
    % shapeA and shapeB are structs
    % D is a col
    point = struct();
    point.dir=D;
    point.s1=shape1.support(D);
    point.s2=shape2.support(-D);
    point.P=point.s1-point.s2;
    point.mag=norm(point.P);
end


function [vec] = tripleProduct(A,B,C)
    vec = B.*(dot(C,A))-A.*(dot(C,B));
end


function [closestPoint] = mindist(simplex,shape1,shape2)

    simplex = simplex(end-1:end);
    d = closestpointto0(simplex{1},simplex{2});
    
    while true
        d_sup = -d.P;
        if  norm(d_sup) < 1e-10
            error("shouldn't be here");
        end
        c = supportwrapper(shape1,shape2,d_sup);
        dc = dot(c.P,d_sup);
        da = dot(d_sup,simplex{2}.P);
        if dc-da<10e-6
            closestPoint = d;            
            return
        end
        p1 = closestpointto0(simplex{2},c);
        p2 = closestpointto0(c,simplex{1});
        
        if p1.P(1)^2+p1.P(2)^2 < p1.P(1)^2+p2.P(2)^2
            simplex{1}= c;
            d = p1;
        else
            simplex{2} = c;
            d = p2;
        end
    end

    
end


function closestPt = closestpointto0(A, B)
%DIST2LINE Finds the closest point on a line segment to the origin.
%
%   INPUTS
%   A: N dimensional point on the line segment AB.
%   B: N dimensional point on the line segment AB.
%
%   RETURNS
%   closestPt: N-D dimensional point on line segment AB which is closest to
%       the origin.
%   t: Weight used to solve for the point on the Bernstein polynomial,
%       where f(t) = (1-t)*A + t*B, t = [0, 1]

    L = B.P - A.P;
    if all(abs(L) < 1000*eps)
        closestPt = A;
        return
    end
    
    lambda2 = -dot(L,A.P)/dot(L,L);
    lambda1 = 1-lambda2;

    % If t is out of the range [0, 1] we are closest to A or B
    if lambda2 >= 1
        closestPt = B;
    elseif lambda2 < 0
        closestPt = A;
    else
        closestPt = struct();
        closestPt.P = lambda1*A.P + lambda2*B.P;
        closestPt.s1 = lambda1*A.s1 + lambda2*B.s1;
        closestPt.s2 = lambda1*A.s2 + lambda2*B.s2;        
    end
    
end

