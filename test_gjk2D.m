close all;

p1 = [0 0; 0 1; 1 1; 1 0];
p2 = [2 0; 2 1; 3 1; 3 0]+[0 0.75];

p1 = [0 0; 0 1; 1 1; 1 0];
p2 = p1+[0.5 0.5];

p1 = [4 11; 9 9; 4 5];
p2 = [5 7; 12 7; 10 2; 7 3]+[4 3];

p1 = [0.1 0.1];
p2 = [1 1];

shape1=ConvexPolygon(p1);
shape2=ConvexPolygon(p2);
shape2 = ConvexCircle(1,[ 2 2 ]);

figure, hold on, axis equal
shape1.plot();
shape2.plot();
tic
[d,intersection,simplex] = gjk2D(shape1,shape2);
toc

disp(intersection)

if intersection
    x = arrayfun(@(x)simplex{x}.P(1),1:length(simplex));
    y = arrayfun(@(x)simplex{x}.P(2),1:length(simplex));
    if length(simplex) > 3
        plot(polyshape(x,y))
    else
        plot(x,y,'LineWidth',2)
    end
    scatter(0,0,'filled')
else
    scatter([simplex.s1(1) simplex.s2(1)],[simplex.s1(2) simplex.s2(2)],'filled')
end
