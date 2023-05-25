clear all; close all; clc;

Fs = 16000;
rec_time = 2;
signals = zeros(10, rec_time * Fs);
pre_len = round(0.5 * Fs);
path = "E:\清华\大三春\语音信号处理\SpeechAnalysis\resource\";
cover = 1;
num = 0: 1: 9;
is_plot = 0;
record = 0;

if record == 1
    nBits = 16;
    nChannel = 1;
    for i = num
        disp("Preparing for recording ...");
        pause(1);
        signals(i + 1, :) = RecordWav(Fs, nBits, nChannel, rec_time, strcat(path, num2str(i), ".wav"), cover);
        clc;
    end
else
    for i = num 
        [signals(i + 1, :), Fs] = audioread(strcat(path, num2str(i), ".wav"));
        if is_plot == 1
            plot(signals(i + 1, :));
            title(i + 1);
            waitfor(gcf);
        end
    end
end

N = 320;
hop = 160;
n_mfcc = 23;
n_mel = 30;
template_num = 5;
mfcc_templates = zeros(10, n_mfcc, template_num);
frame_time = 20; % ms
frame_shift_time = 10; % ms
frame_len = frame_time / 1000 * Fs;
frame_shift_len = frame_shift_time / 1000 * Fs;

for i = num
    noise = signals(i + 1, 1: pre_len);
    noise_power = sum(noise .^ 2) / length(noise);
    wav = signals(i + 1, pre_len + 1: end);
    [~, cross_thre_rate, frame_energy] = AnalyzeSpeech(wav, frame_time, frame_shift_time, Fs, noise_power, 3);
    start = DetectStart(frame_energy, cross_thre_rate, noise_power, frame_len, 3);
    final_end = DetectEnd(start(1), frame_energy, cross_thre_rate, noise_power, frame_len);
    start_time = (start(1) - 1) * frame_shift_len + floor(frame_shift_len / 2);
    end_time = (final_end(1) - 1)* frame_shift_len + floor(frame_shift_len / 2);
    
    mfcc = CalMFCC(wav(start_time: end_time), N, hop, n_mfcc, n_mel, Fs);
    [cut, template_temp] = TrainDTW(mfcc, template_num);
    mfcc_templates(i + 1, :, :) = template_temp;
    
    if is_plot
        plot(wav);
        hold on
        scatter([start_time, end_time], [wav(start_time), wav(end_time)], "filled");
        hold off
        title(i);
        waitfor(gca);
    end
end

[test_audio, ~] = audioread("../resource/test_10.wav");
noise = test_audio(1: pre_len);
noise_power = sum(noise .^ 2) / length(noise);
wav = test_audio(pre_len + 1: end);
[~, cross_thre_rate, frame_energy] = AnalyzeSpeech(wav, frame_time, frame_shift_time, Fs, noise_power, 3);
start = DetectStart(frame_energy, cross_thre_rate, noise_power, frame_len, 3);
final_end = DetectEnd(start, frame_energy, cross_thre_rate, noise_power, frame_len);
start_time = (start - 1) * frame_shift_len + floor(frame_shift_len / 2);
end_time = (final_end - 1)* frame_shift_len + floor(frame_shift_len / 2);
    
for k = 1: 1: min(length(end_time), length(start_time))
    if is_plot
        plot(wav);
        hold on
        scatter([start_time(k), end_time(k)], [wav(start_time(k)), wav(end_time(k))], "filled");
        hold off
        waitfor(gca);
    end
    mfcc = CalMFCC(wav(start_time(k): end_time(k)), N, hop, n_mfcc, n_mel, Fs);
    dist = zeros(1, 10);
    for i = num
        template = squeeze(mfcc_templates(i + 1, :, :));
        [cut, dist(i + 1)] = DTW(mfcc, template);  
    end
    [~, min_idx] = min(dist);
    disp(min_idx - 1);
end
