classdef ConvexCircle
    
    properties
        r
        c
    end
        
    methods
        function obj = ConvexCircle(r,c)
            obj.r = r;
            obj.c = c;
        end

        function point = support(obj,direction)
            point = obj.c.'+(obj.r/norm(direction)).*direction;
        end
        
        function plot(obj) 
            assert(size(obj.c,2)==2);
            hold on
            t = 0:0.001:2*pi;
            plot(polyshape([obj.r .*cos(t)+obj.c(1);obj.r.*sin(t)+obj.c(2)].'));
        end

    end
end
