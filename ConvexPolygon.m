classdef ConvexPolygon
    % a 2D convex shape defined by points
    
    properties
        matrix_orig
        matrix
        % x1 y1
        % x2 y2
        % ...
        % xN yN
    end
        
    methods
        function obj = ConvexPolygon(mat)
            obj.matrix_orig = mat;
            %obj.matrix = uniquetol(mat(grahamscan(mat),:),'ByRows',true);
            obj.matrix = uniquetol(mat,'ByRows',true);
            if length(obj.matrix) > 3
                obj.matrix = obj.matrix(convhull(obj.matrix,'simplify',true),:);
            end
        end

        function point = support(obj,direction)
            perpdir = [-direction(2);direction(1)];
            dotprod=obj.matrix*direction;
            paralelcandidates = obj.matrix(dotprod==max(dotprod),:);
            dotprod_perp = paralelcandidates*perpdir;
            [~,argmax] = max(dotprod_perp);
            point = paralelcandidates(argmax,:).';
        end
        
        function plot(obj) 
            hold on
            if length(obj.matrix)>=3
                plot(polyshape(obj.matrix));
            else
                scatter(obj.matrix_orig(:,1),obj.matrix_orig(:,2));
            end
        end

    end
end
