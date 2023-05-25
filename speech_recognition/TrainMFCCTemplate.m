function mfcc_template = TrainMFCCTemplate(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                        mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, template_num, snr)
    % wav: signals containing only single tone
    % frame_time: ms
    % frame_shift_time: ms
    % Fs: sample frequency
    % noise_power: power of noise signal
    % mfcc_win_len:
    % mfcc_shift_len:
    % n_mfcc: dim of mfcc feature
    % n_mel: number of mel filter bank
    % template_num: DTW num
    % snr: expected snr
    %
    % mfcc_template

    frame_len = frame_time / 1000 * Fs;
    frame_shift_len = frame_shift_time / 1000 * Fs;
    [~, cross_thre_rate, frame_energy] = AnalyzeSpeech(wav, frame_time, frame_shift_time, Fs, noise_power, snr);
    start = DetectStart(frame_energy, cross_thre_rate, noise_power, frame_len, snr);
    final_end = DetectEnd(start(1), frame_energy, cross_thre_rate, noise_power, frame_len);
    start_time_num = (start(1) - 1) * frame_shift_len + floor(frame_shift_len / 2);
    end_time_num = (final_end(1) - 1)* frame_shift_len + floor(frame_shift_len / 2);
    
    mfcc = CalMFCC(wav(start_time_num: end_time_num), mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, Fs);
    [~, template_temp] = TrainDTW(mfcc, template_num);
    mfcc_template = template_temp;
end

