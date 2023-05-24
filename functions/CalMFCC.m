function MFCCs = CalMFCC(signal, n_fft, hop_size, n_mfcc, n_mel, fs)
    % signal: signal to analyze
    % n_fft; FFT size
    % hop_size; hop size
    % n_mfcc; number of MFCCs
    % n_mel: number of filters
    % fs: sample frequency
    %
    % MFCC: MFCC feature of n_mfcc

    % Pre-emphasis:
    pre_emphasis = 0.98;
    signal = filter([1 - pre_emphasis], 1, signal);

    % Framing and windowing:
    frames = buffer(signal, n_fft, n_fft - hop_size);
    frames = frames .* hamming(n_fft);

    % FFT and power spectrum:
    spec = fft(frames, n_fft, 1);
    spec_power = 1.0 ./ (n_fft * abs(spec).^2 + 1e-8);
    
    % Mel filter bank
    mfb = GetMelFilterBank(n_mel, n_fft, fs);

    % Mel spectrum:
    mel_spec = mfb * spec_power;

    % MFCCs:
    MFCCs = dct(log(mel_spec));
    MFCCs = MFCCs(2: n_mfcc + 1, :); % Exclude 0th order coefficient

end