function newvertices = sortvertices(vertices)

    [~,order] = sort(atan2(vertices(:,2)-mean(vertices(:,2)),vertices(:,1)-mean(vertices(:,1))));
    
    newvertices = vertices(order,:);
    
end