function cut_points = DTW(features, cluster_vecs)
    % features: (dim, T)
    % cluster: (dim, count)
    % cut_points: (1, count), which is [1, ...]
    
    len = size(features, 2);
    count = size(cluster_vecs, 2);
    distance = zeros(1, count);
    path = zeros(count, count);
    distance(2: end) = inf;
    distance(1) = (features(:, 1) - cluster_vecs(:, 1)) ^ 2;
    path(:, 1) = 1;
    for j = 2: 1: len
        for k = count: -1: 1
            dist_temp = (features(:, j) - cluster_vecs(:, k)) ^ 2;
            if k == 1
                distance(1) = distance(1) + dist_temp;
            else
                if distance(k) > distance(k - 1)
                    distance(k) = distance(k - 1) + dist_temp;
                    path(k, :) = path(k - 1, :);
                    path(k, k) = j;
                else
                    distance(k) = distance(k) + dist_temp;
                end
            end
        end
    end
    cut_points = path(count, :);
end

