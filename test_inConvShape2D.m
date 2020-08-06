p = [5 7; 12 7; 10 2; 7 3];
p = ConvexPolygon(p);

points = 10*rand(100,2);

intersections = false(size(points,1),1);
tic
for i=1:size(points,1)
    intersections(i) =  gjk2D(ConvexPolygon(points(i,:)),p) < 0;
end
toc

figure
p.plot();

plot(points(intersections,1),points(intersections,2),'r+') % points inside
plot(points(~intersections,1),points(~intersections,2),'bo') % points outside