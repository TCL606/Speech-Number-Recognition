function [recog_idx, start_time_num, end_time_num] = Recognize(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                        mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, mfcc_templates, snr)
    % wav: signals containing only single tone
    % frame_time: ms
    % frame_shift_time: ms
    % Fs: sample frequency
    % noise_power: power of noise signal
    % mfcc_win_len:
    % mfcc_shift_len:
    % n_mfcc: dim of mfcc feature
    % n_mel: number of mel filter bank
    % mfcc_templates: template feature of size (num, n_mfcc, seq_len)
    % snr: expected snr
    %
    % mfcc_template

    frame_len = frame_time / 1000 * Fs;
    frame_shift_len = frame_shift_time / 1000 * Fs;
    [~, cross_thre_rate, frame_energy] = AnalyzeSpeech(wav, frame_time, frame_shift_time, Fs, noise_power, snr);
    start = DetectStart(frame_energy, cross_thre_rate, noise_power, frame_len, snr);
    final_end = DetectEnd(start, frame_energy, cross_thre_rate, noise_power, frame_len);
    start_time_num = (start - 1) * frame_shift_len + floor(frame_shift_len / 2);
    end_time_num = (final_end - 1)* frame_shift_len + floor(frame_shift_len / 2);
    
    recog_idx = [];
    for k = 1: 1: min(length(end_time_num), length(start_time_num))
%         if 1
%             plot(wav);
%             hold on
%             scatter([start_time(k), end_time(k)], [wav(start_time(k)), wav(end_time(k))], "filled");
%             hold off
%             waitfor(gca);
%         end
        mfcc = CalMFCC(wav(start_time_num(k): end_time_num(k)), mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, Fs);
        dist = zeros(1, size(mfcc_templates, 1));
        for i = 1: 1: size(mfcc_templates, 1)
            template = squeeze(mfcc_templates(i, :, :));
            [~, dist(i)] = DTW(mfcc, template);  
        end
        [~, min_idx] = min(dist);
        recog_idx = [recog_idx, min_idx];
    end
end

