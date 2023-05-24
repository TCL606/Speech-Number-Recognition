function signal = RecordWav(Fs, nBits, nChannel, time, filename, cover)
    if (nargin < 6)
        cover = 0;
    end
    recObj = audiorecorder(Fs, nBits, nChannel);

    disp('Start speaking.')
    recordblocking(recObj, time);
    disp('End of Recording.');
    
    myRecording = getaudiodata(recObj);
    
    if cover > 0 || exist(filename, 'file') == 0
        audiowrite(filename, myRecording, Fs);
    end
    
    signal = myRecording;
end

