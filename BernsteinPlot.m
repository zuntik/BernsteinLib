function [curveplot,pointsplot] = BernsteinPlot(p,T,varargin)
    hold on
    parser = inputParser;
    addParameter(parser,'PlotControlPoints',true);
    addParameter(parser,'AddArrows',false);
    addParameter(parser,'LineWidth',0.1);
    addParameter(parser,'filledpoints',false);
    parse(parser,varargin{:});
    
    [ n, dim ] = size(p);
    if dim == 1
        curveplot=fplot(@(times)arrayfun(@(t)(BernsteinEval(p,T,t)),times),[0 T],'LineWidth',parser.Results.LineWidth);
        if parser.Results.PlotControlPoints
            if parser.Results.filledpoints
                pointsplot=scatter(0:T/(n-1):T, p,'filled');
            else
                pointsplot=scatter(0:T/(n-1):T,p);
            end
        end
    elseif dim == 2
        xt = @(times)arrayfun(@(t)BernsteinEval(p(:,1),T,t),times);
        yt = @(times)arrayfun(@(t)BernsteinEval(p(:,2),T,t),times);
        curveplot=fplot(xt,yt,[0 T],'LineWidth',parser.Results.LineWidth);
        if parser.Results.PlotControlPoints
            if parser.Results.filledpoints
                pointsplot=scatter(p(:,1)',p(:,2)','filled');
            else
                pointsplot=scatter(p(:,1)',p(:,2)');
            end
        end
        dp = BernsteinDeriv(p,T);
        for i = 0:9
            grad = BernsteinEval(dp,T,T*i/10);
            if parser.Results.AddArrows
                quiver(xt(T*i/10),yt(T*i/10),grad(1)/2,grad(2)/2,1,'linewidth',2,'color','r','MaxHeadSize',10);
            end
        end
        xlabel('Position x (m)');
        ylabel('Position y (m)');
    elseif dim == 3
        %xt = @(t) BernsteinEval(p(:,1),T,t);
        xt = @(times)arrayfun(@(t)BernsteinEval(p(:,1),T,t),times);
        %yt = @(t) BernsteinEval(p(:,2),T,t);
        yt = @(times)arrayfun(@(t)BernsteinEval(p(:,2),T,t),times);
        %zt = @(t) BernsteinEval(p(:,3),T,t);
        zt = @(times)arrayfun(@(t)BernsteinEval(p(:,3),T,t),times);
        curveplot=fplot3(xt,yt,zt,[0 T],'LineWidth',parser.Results.LineWidth);
        view(3);
        if parser.Results.PlotControlPoints
            if parser.Results.filledpoints
                pointsplot=scatter3(p(:,1)',p(:,2)',p(:,3)','filled');
            else
                pointsplot=scatter3(p(:,1)',p(:,2)',p(:,3)');
            end
        end
        view(3);
    end
end

