clear
close  all
% this will use my gtk2 alg and Calvin's too
addpath('Bernstein')
addpath('BeBOT_lib')

obstacle = [ 2 2; 3 1; 4 1.5; 3.5 3; 2.5 2.7];

cpts = [ 2 1; 3 1.3; 3.3 2.5; 3.4 2.6; 3.9 2; 4.5 3];
N = size(cpts,1)-1;
curvepoints = BernsteinCtrlPntsEval(N)*cpts;

figure,hold on
plot(polyshape(obstacle))
BernsteinPlot(cpts, 1);

tic

p1 = ConvexPolygon(obstacle);    
upmin = -inf;
sidemin = -inf;

allpoligons = cell(N);

for i = 1:N
    if i == 1
        vertices = [cpts(i:i+1,:);curvepoints(i+1,:)];
    elseif i == N
        vertices = [cpts(i:i+1,:);curvepoints(i,:)];
    else
        vertices = [cpts(i:i+1,:);curvepoints(i:i+1,:)];
    end
    allpoligons{i} = sortvertices(vertices);
    p2 = ConvexPolygon(vertices);
    [~,intersection,simplex] = gjk2D(p1,p2);
    if intersection
        support=@(d) p1.support(d)-p2.support(-d);
        vec_up = directed_epa(support, simplex, [0;1]);
        vec_side = directed_epa(support, simplex, [1;0]);
        if vec_up(2) > upmin 
            upmin = vec_up(2);
        end
        if vec_side(1) > sidemin
            sidemin = vec_side(1);
        end
    end
end

for i = 1:N
    plot(polyshape(allpoligons{i}));
    plot(polyshape(allpoligons{i}+[0 upmin]));
    plot(polyshape(allpoligons{i}+[sidemin 0]));
end

plot(polyshape(p1.matrix))

