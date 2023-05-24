function cut_points = TrainDTW(features, count)
    % features: (dim, T)
    % count: num of templates
    % cut_points: (1, count + 1), which is [1, ..., T]
    
    sz = size(features);
    dim = sz(1);
    len = sz(2);

    cut_points = zeros(1, count + 1);
    cut_points(1) = 1;
    cut_points(end) = len;
    for i = 1: 1: count - 1
        cut_points(i + 1) = round(len / count) * i;
    end

    last_cut_points = zeros(1, count + 1);
    last_cut_points(1) = 1;
    last_cut_points(end) = len;

    cluster_vecs = zeros(dim, count);
    while sum(abs(cut_points - last_cut_points)) > 0
        for i = 1: 1: count - 1
            last_cut_points(i + 1) = cut_points(i + 1);
        end
        
        for i = 1: 1: count
            cluster_vecs(i) = sum(features(:, cut_points(i): cut_points(i + 1))) / (cut_points(i + 1) - cut_points(i) + 1);
        end
        
        cut_points(1: end - 1) = DTW(features, cluster_vecs);
    end
end

