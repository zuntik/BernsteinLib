function new_cp = BernsteinDegrElev(cp, m)
	% Performs degree elevation of curve defined by cp to M
	% INPUT
	% cp: matrix N x dim
	% M: new desired order
	% OUTPUT
	% new_cp: new control points for new order

	[num_points,~, num_levels] = size(cp);    
    n = num_points-1;
    
    if n==m
        return
    end
    assert(m>n,'new degree not greater than current');
    
    ElevMat = BernsteinDegrElevMat(n, m);
    
    new_cp = cell(1,1,num_levels);
    for i = 1:num_levels
        new_cp{1,1,i} = ElevMat*cp(:,:,i);
    end
    new_cp = cell2mat(new_cp);
    
end