function cof = GetLPCoefficient(frame, P)
    % Durbin Recursion Algorithm
    % frame: speech signal after a window function
    % P: the degree, which is a positive integer
    
    R = xcorr(frame, P)';
    R = R(P + 1: end);
    Bm2 = zeros(1, P + 1); 
    alpha = zeros(1, P + 1);
    alpha_last = zeros(1, P + 1);
    Bm2(1) = R(1);
    alpha(1) = 1;
    for m = 2: 1: P + 1
        alpha_inv = [alpha(m - 1: -1: 1), zeros(1, P + 1 - m)];
        Km = - sum(alpha_inv .* R(2: end)) / Bm2(m - 1); 
        Bm2_temp = (1 - Km ^ 2) * Bm2(m - 1);
        Bm2(m) = Bm2_temp;
        alpha_last(1: end) = alpha(1: end);
        for i = 2: 1: m
            if i == m
                alpha(i) = Km;
            else
                alpha(i) = alpha_last(i) + Km * alpha_last(m - i + 1);
            end
        end
    end
    cof = alpha;
end

