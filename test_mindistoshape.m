addpath('..\BeBOT_lib');
shape = [0 0 ; 1 0 ; 1 1 ; 0 1];
shape=[ 0.3 0.3; 0.3 0.7; 0.7 0.7; 0.7 0.3];
cpts= [ 0.5 4; 1 3; 1.5 1];
cpts = rand(5,2);
cpts = [
    0.9593    0.8407
    0.5472    0.2543
    0.1386    0.8143
    0.1493    0.2435
    0.2575    0.9293
];

% cpts = [
%     0.3-10e-7 0.5
%     0.3+10e-7 0.5
% ];

figure, hold on, axis equal
BernsteinPlot(cpts,1);
ConvexPolygon(shape).plot();

tic
[dist, t, pt] = MinDistBernstein2Polygon_extended(cpts.', shape.')
toc
tic
[dist, t, pt] = BernsteinMinDist2Shape(cpts,ConvexPolygon(shape));
toc


scatter(pt(:,1),pt(:,2),'filled')
