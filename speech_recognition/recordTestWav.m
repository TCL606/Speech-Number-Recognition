clear all; close all; clc;

Fs = 16000;
rec_time = 2;
path = "E:\清华\大三春\语音信号处理\SpeechAnalysis\resource\";
nBits = 16;
nChannel = 1;
disp("Preparing for recording ...");
pause(1);
RecordWav(Fs, nBits, nChannel, rec_time, strcat(path, "test_6.wav"));
