function evaluator = BernsteinEvaluator(p,T)
    evaluator = cell(size(p,2),1);
    for i = 1:size(p,2)
        evaluator{i} = @(t)BernsteinEval(p(:,i),T,t);
    end
end