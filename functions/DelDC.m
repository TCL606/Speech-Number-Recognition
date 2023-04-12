function [wav_del_dc, wav_dc] = DelDC(wav)
    wav_dc = sum(wav) / length(wav);
    wav_del_dc = wav - wav_dc;
end

