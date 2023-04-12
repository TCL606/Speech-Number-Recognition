function base_w = DetectBaseOmega(frame, frame_shift, time_shift, Fs, high_fre, detect_len)
    % Phase Chase Method
    % frame: analyzed speech piece 
    % frame_shift: shifted analyzed speech piece
    % time_shift: number of shifted time points
    % Fs: sample frequency
    % high_fre: the largest possible frequency
    % detect_len: indicates how many points apart is considered a peak

    if (nargin < 6)
        detect_len = 5;
    end
    frame2 = frame .^ 2;
    frame2_HP = frame2(2: end) - frame2(1: end - 1);
    frame2_HP_fft = fft(frame2_HP);
    high_fre_idx = ceil(high_fre / (1 / length(frame) * Fs));
    frame2_HP_fft(high_fre_idx: end - high_fre_idx) = 0;
    frame2_HP_LP_fft = frame2_HP_fft;
    peak_idx = FindPeak(abs(frame2_HP_LP_fft), detect_len, 1);
    base_w_est = 2 * pi / length(frame2_HP) * (peak_idx - 1);
    phase_base = angle(frame2_HP_LP_fft(peak_idx));
    
    frame2_shift = frame_shift .^ 2;
    frame2_shift_HP = frame2_shift(2: end) - frame2_shift(1: end - 1);
    frame2_shift_HP_fft = fft(frame2_shift_HP);
    frame2_shift_HP_fft(high_fre_idx: end - high_fre_idx) = 0;
    frame2_shift_HP_LP_fft = frame2_shift_HP_fft;
    phase_base_after_shift = angle(frame2_shift_HP_LP_fft(peak_idx));
    
    delta_phi = phase_base_after_shift - phase_base - base_w_est * time_shift; 
    delta_phi = mod(delta_phi + pi, 2 * pi) - pi;
    delta_w = delta_phi / time_shift;
    base_w = base_w_est + delta_w;
end

