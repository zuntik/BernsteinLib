function [dist,pt] = MinDistBernstein2Orig(cpts, Evalmat)

N = size(cpts,1)-1;

if nargin<2
    Evalmat = BernsteinCtrlPntsEval(N);
end

curvpts = Evalmat*cpts;

all_max_dists = ones(N,1)*Inf;
all_min_dists = ones(N,1)*-1;
all_closest_pts = cell(N,1);

for i= 1:N 
    [min_dist, max_dist,closest_pt,~] = calc_min_max_2_orig([cpts(i:i+1,:);curvpts(i:i+1,:)]);
    all_max_dists(i) = max_dist;
    all_min_dists(i) = min_dist;
    all_closest_pts{i} = closest_pt;
end

smallest_max_dist = min(all_max_dists);
interesting_min_dists = all_min_dists<smallest_max_dist;
[dist,where] = min(all_min_dists);
pt = all_closest_pts{where};

end


function [min_dist, max_dist,closest_pt,furthest_pt] = calc_min_max_2_orig(pgon)
    % works best for small pgons
    p = convhull(pgon);
    pgon = pgon(p(1:end-1),:);
    if inpolygon(0,0,pgon(:,1),pgon(:,2))
        min_dist = -1;
        max_dist = -1;
        return
    end
    norms_squared = sum(pgon.^2,2);
    % calculate minimum dist
    [~,closest_vert] = min(norms_squared);
    [max_dist,furthest_vert] = max(norms_squared);
    furthest_pt = pgon(furthest_vert,:);
    
    if closest_vert == 1
        prev = size(pgon,1);
    else
        prev = closest_vert-1;
    end
    next = rem(closest_vert,size(pgon,1))+1;
    
    closest_pt_A = mindist2line(pgon(prev,:),pgon(closest_vert,:));
    closest_pt_B = mindist2line(pgon(closest_vert,:),pgon(next,:));
    if sum(closest_pt_A.^2) > sum(closest_pt_B.^2)
        min_dist = norm(closest_pt_B);
        closest_pt = closest_pt_B;
    else
        min_dist = norm(closest_pt_A);
        closest_pt = closest_pt_A;
    end
    max_dist = sqrt(max_dist);
end


function closestPt = mindist2line(A,B)

    v = B - A;
    u = A;
    t = -dot(v,u) / dot(v,v);

    % If t is out of the range [0, 1] we are closest to A or B
    if t > 1
        closestPt = B;
    elseif t < 0
        closestPt = A;
    else
        closestPt = (1-t)*A + t*B;
    end
end
