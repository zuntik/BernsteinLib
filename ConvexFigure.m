classdef (Abstract) ConvexFigure 
    methods (Abstract)
        point = support(obj,direction);
        plot(obj);
    end
end
