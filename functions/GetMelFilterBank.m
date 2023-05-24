function H = GetMelFilterBank(n_mel, N, fs)
    % n_mel: number of filters
    % N: length of one filter
    % fs: sample frequency
    %
    % H: impulse response of filter bank
    
    fre_low = 0;
    fre_high = fs / 2;
    mel_low = 2595 * log10(1 + fre_low / 700);
    mel_high = 2595 * log10(1 + fre_high / 700);
    band_width = mel_high - mel_low;
    mel_equal = linspace(0, band_width, n_mel + 2);
    fre_equal_mel = 700 * (10 .^ (mel_equal / 2595) - 1);

    fre_equal_mel_idx = (N * fre_equal_mel) / fs;
    H = zeros(n_mel, N);
    freqs = 1: 1: N;
    for i = 2: 1: n_mel + 1 
        H(i - 1, :) = (fre_equal_mel_idx(i - 1) <= freqs & freqs <= fre_equal_mel_idx(i)) .* ((freqs - fre_equal_mel_idx(i - 1)) / (fre_equal_mel_idx(i) - fre_equal_mel_idx(i - 1))) + ...
                       (fre_equal_mel_idx(i) <= freqs & freqs <= fre_equal_mel_idx(i + 1)) .* ((fre_equal_mel_idx(i + 1) - freqs) / (fre_equal_mel_idx(i + 1) - fre_equal_mel_idx(i)));
    end
end

