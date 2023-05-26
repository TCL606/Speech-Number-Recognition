clear all; close all; clc;
addpath("../functions");
Fs = 16000;
rec_time = 2.5;
start_len = round(0.3 * Fs);
signals = zeros(10, round(rec_time * Fs) - start_len);
pre_len = round(0.2 * Fs);
path = "E:\清华\大三春\语音信号处理\SpeechAnalysis\resource\";
cover = 1;
num = 0: 1: 9;
is_plot = 1;
record = 0;

if record == 1
    nBits = 16;
    nChannel = 1;
    for i = num
        disp("Preparing for recording ...");
        pause(1);
        wav = RecordWav(Fs, nBits, nChannel, rec_time, strcat(path, num2str(i), ".wav"), cover);
        signals(i + 1, :) = wav(start_len + 1: end);
        clc;
    end
else
    for i = num 
        [wav, Fs] = audioread(strcat(path, num2str(i), ".wav"));
        signals(i + 1, :) = wav(start_len + 1: end);
%         if is_plot == 1
%             plot(signals(i + 1, :));
%             title(i);
%             waitfor(gcf);
%         end
    end
end

mfcc_win_len = 320;
mfcc_shift_len = 160;
n_mfcc = 23;
n_mel = 30;
template_num = 5;
mfcc_templates = zeros(10, n_mfcc, template_num);
frame_time = 20; % ms
frame_shift_time = 10; % ms
frame_len = frame_time / 1000 * Fs;
frame_shift_len = frame_shift_time / 1000 * Fs;
snr = 5;

for i = num
    noise = signals(i + 1, 1: pre_len);
    noise_power = sum(noise .^ 2) / length(noise);
    wav = signals(i + 1, pre_len + 1: end); 
    
    frame_len = frame_time / 1000 * Fs;
    frame_shift_len = frame_shift_time / 1000 * Fs;
    [~, cross_thre_rate, frame_energy] = AnalyzeSpeech(wav, frame_time, frame_shift_time, Fs, noise_power, snr);
    start = DetectStart(frame_energy, cross_thre_rate, noise_power, frame_len, snr);
    final_end = DetectEnd(start(1), frame_energy, cross_thre_rate, noise_power, frame_len);
    start_time_num = (start(1) - 1) * frame_shift_len + floor(frame_shift_len / 2);
    end_time_num = (final_end(1) - 1)* frame_shift_len + floor(frame_shift_len / 2);
    
    mfcc = CalMFCC(wav(start_time_num: end_time_num), mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, Fs);
    [~, template_temp] = TrainDTW(mfcc, template_num);
    mfcc_templates(i + 1, :, :) = template_temp;
    if is_plot
        plot(wav);
        hold on
        scatter([start_time_num, end_time_num], [wav(start_time_num), wav(end_time_num)], "filled");
        hold off
        title(i);
        waitfor(gca);
    end
end

[test_audio, ~] = audioread("../resource/test_265.wav");
test_audio = test_audio(start_len + 1: end);
noise = test_audio(1: pre_len);
noise_power = sum(noise .^ 2) / length(noise);
wav = test_audio(pre_len + 1: end);

[recog_idx, start_time_num, end_time_num] = Recognize(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                        mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, mfcc_templates, snr);
    
for k = 1: 1: min(length(start_time_num),length(end_time_num))
    if is_plot == 1
        plot(wav);
        hold on
        scatter([start_time_num(k), end_time_num(k)], [wav(start_time_num(k)), wav(end_time_num(k))], "filled");
        hold off
        waitfor(gca);
    end
end
disp(recog_idx - 1);
