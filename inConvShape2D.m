function indexes = inConvShape2D(points,shape)
    indexes = false(size(points,1),1);

    for i = 1:length(indexes)
        indexes(i) = gjk2D(ConvexPolygon(points(i,:)),shape);
    end
end