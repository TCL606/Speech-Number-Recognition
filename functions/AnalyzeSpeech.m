function [cross_zero_rate, cross_thre_rate, frame_energy] = AnalyzeSpeech(wav_del_dc, frame_time, frame_shift_time, Fs, noise_power, snr)
    % time: ms; Fs: Hz
    if (nargin < 6)
        snr = 90;
    end
    wav_len = length(wav_del_dc);
    frame_len = frame_time / 1000 * Fs;
    frame_shift_len = frame_shift_time / 1000 * Fs;
    cross_zero_rate = zeros(round((wav_len - frame_len) / frame_shift_len) + 1, 1); 
    cross_thre_rate = zeros(round((wav_len - frame_len) / frame_shift_len) + 1, 1); 
    frame_energy = zeros(round((wav_len - frame_len) / frame_shift_len) + 1, 1); 
    thre = snr * noise_power;
    k = 1;
    for i = 1: frame_shift_len : wav_len - frame_len + 1
        frame = wav_del_dc(i: i + frame_shift_len - 1);
        cross_zero_num = DetectCrossThre(frame, 0);
        cross_zero_rate(k) = cross_zero_num / frame_time;
        cross_thre_num = DetectCrossThre(frame, thre);
        cross_thre_rate(k) = cross_thre_num / frame_time;
        frame_energy(k) = sum(frame .^ 2);
        k = k + 1;
    end
end

