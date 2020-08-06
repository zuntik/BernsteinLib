function [dist, t, pt] = BernsteinMinDist2Shape(cpts,shape,varargin)

    % --- Input parsing
    p = inputParser;

    addParameter(p, 'epsilon', 1e-6, @isnumeric)

    parse(p, varargin{:})
    epsilon = p.Results.epsilon;
    % --- End input parsing


    maxiter = 10000;
    
    distL = gjk2D(ConvexPolygon(cpts(1  ,:)),shape);
    distH = gjk2D(ConvexPolygon(cpts(end,:)),shape);
    [maxmin,tmaxmin] = min([distL distH]);
    tmaxmin = tmaxmin-1;
    if maxmin<0
        mindist = -1;
    else
        mindist = gjk2D(ConvexPolygon(cpts),shape); % if mindist < 0 they intersect
    end
    segments = {struct('tL',0,'tH',1,'inL',distL<0,'inH',distH<0,'cpts',cpts,'completelyin',false,'mindist',mindist)};
    intersectpoints = [];
    
    for i = 1:maxiter
        
        % cut the segments
        % the segments structure contains tL,tH,cpts,coompletelyin and
        % mindist which may be < 0
        [segments,maxmin,tmaxmin] = splitsegments(segments,shape,maxmin,tmaxmin);

        % process the segments and trims those that don't matter
        %     this means checking which as "totally in the poly"
        %     those that are further than maxmin
        [segments,intersectpoints] = processsegments(segments,maxmin,intersectpoints,epsilon);

        % exit condition - if no more segments left to further divide
        if isempty(segments)
            break
        end

    end
    if i == maxiter
        warning('max iter met');
    end
    
    if ~isempty(intersectpoints)
        dist = -1;
        t = intersectpoints;
        pt = BernsteinEval(cpts,1,intersectpoints);
    else
        dist = maxmin;
        pt = BernsteinEval(cpts,1,tmaxmin);
        t = tmaxmin;
    end
    
end

function [cut_segments,maxmin,tmaxmin] = splitsegments(segments,poly,maxmin,tmaxmin)
    n = length(segments);
    cut_segments = cell(n*2,1);
    for seg_i = 1:n
        [cut_segs, mid_p] = my_deCasteljau(segments{seg_i}.cpts,0.5);
        cut_segments{seg_i  }.cpts = cut_segs(:,:,1);
        cut_segments{seg_i+n}.cpts = cut_segs(:,:,2);
        d_midp = gjk2D(ConvexPolygon(mid_p),poly);
        if d_midp<maxmin
            maxmin = d_midp;
            tmaxmin = (segments{seg_i}.tL+segments{seg_i}.tH)/2;
        end
        % first half
        if d_midp < 0 || segments{seg_i}.inL
            mindistFH = -1;
        else
            mindistFH = gjk2D(ConvexPolygon(cut_segs(:,:,1)),poly);
        end
        cut_segments{seg_i}.tL = segments{seg_i}.tL;
        cut_segments{seg_i}.tH = (segments{seg_i}.tL+segments{seg_i}.tH)/2;
        cut_segments{seg_i}.inL = segments{seg_i}.inL;
        cut_segments{seg_i}.inH = d_midp < 0;
        cut_segments{seg_i}.mindist = mindistFH;
        cut_segments{seg_i}.completelyin=d_midp<0&&segments{seg_i}.inL ...
            && all(inConvShape2D(cut_segments{seg_i}.cpts, poly));
        % second half
        if d_midp < 0 || segments{seg_i}.inH
            mindistSH = -1;
        else
            mindistSH = gjk2D(ConvexPolygon(cut_segs(:,:,2)),poly);
        end
        cut_segments{seg_i+n}.tL = (segments{seg_i}.tL+segments{seg_i}.tH)/2;
        cut_segments{seg_i+n}.tH = segments{seg_i}.tH;
        cut_segments{seg_i+n}.inL = d_midp < 0;
        cut_segments{seg_i+n}.inH = segments{seg_i}.inH;
        cut_segments{seg_i+n}.mindist = mindistSH;
        cut_segments{seg_i+n}.completelyin=d_midp<0&&segments{seg_i}.inH ...
            && all(inConvShape2D(cut_segments{seg_i+n}.cpts, poly));
    end
end

function [segmentsOut,intersectpoints] = processsegments(segmentsIn,maxmin,intersectpoints,epsilon)

    for seg_i = 1:length(segmentsIn)
        seg = segmentsIn{seg_i};
        if seg.completelyin || (maxmin < 0 && seg.mindist > 0) || (maxmin > 0 && (seg.mindist >= maxmin - epsilon) )
            segmentsIn{seg_i} = [];
        elseif xor(seg.inL,seg.inH) && sqrt(max(sum((seg.cpts-(sum(seg.cpts,1)/size(seg.cpts,1))).^2,2))) < 10e-6
            intersectpoints = [intersectpoints; seg.tL]; %#ok<AGROW>
            segmentsIn{seg_i} = [];
        end
    end
    
    segmentsOut = segmentsIn(~cellfun(@isempty,segmentsIn));
    
end
