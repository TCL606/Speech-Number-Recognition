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
snr = 3;

for i = num
    noise = signals(i + 1, 1: pre_len);
    noise_power = sum(noise .^ 2) / length(noise);
    wav = signals(i + 1, pre_len + 1: end); 
    mfcc_templates(i + 1, :, :) = TrainMFCCTemplate(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                        mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, template_num, snr);
    
    if is_plot
        plot(wav);
        hold on
        scatter([start_time, end_time], [wav(start_time), wav(end_time)], "filled");
        hold off
        title(i);
        waitfor(gca);
    end
end

[test_audio, ~] = audioread("../resource/test_123.wav");
noise = test_audio(1: pre_len);
noise_power = sum(noise .^ 2) / length(noise);
wav = test_audio(pre_len + 1: end);
[recog_idx, ~] = Recognize(wav, frame_time, frame_shift_time, Fs, noise_power, ...
                                        mfcc_win_len, mfcc_shift_len, n_mfcc, n_mel, mfcc_templates, snr);
disp(recog_idx - 1);
