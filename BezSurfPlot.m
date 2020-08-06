function BezSurfPlot(cpts)

	[x,y] = meshgrid(0:0.1:1,0:0.1:1);
	z = zeros(11,11);

	for i = 1:11
		for j = 1:11
			z(i,j) = BezierSurface(cpts,x(i,j),y(i,j));
		end
	end

	figure, grid on
	surf(x,y,z);

end

function val = BezierSurface(cpts,u,v)

	[n,m] = size(cpts);
	m = m-1;
	n = n-1;

	val = 0;
	for i = 0:n
		for j = 0:m
			val = val + BernsteinBasis(i,n,u)*BernsteinBasis(j,m,v)*cpts(i+1,j+1);
		end
	end

end
