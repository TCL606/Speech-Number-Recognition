clear all; close all; clc;

record = 0;
Fs = 16000;
rec_time = 2;
signals = zeros(10, rec_time * Fs);
path = "E:\清华\大三春\语音信号处理\SpeechAnalysis\resource\";
num = 0: 1: 9;

if record == 1
    nBits = 16;
    nChannel = 1;
    for i = num
        disp("Preparing for recording ...");
        pause(1);
        signals(i + 1, :) = Record(Fs, nBits, nChannel, rec_time, strcat(path, num2str(i), ".wav"));
        clc;
    end
else
    for i = num 
        [Fs, signals(i + 1, :)] = audioread(strcat(path, num2str(i), ".wav"));
    end
end


% N = 1024;
% hop = 512;
% n_mfcc = 13;
% n_mel = 16;
% fs = 16000;
% 
% mfcc = CalMFCC(signal, N, hop, n_mfcc, n_mel, fs);

