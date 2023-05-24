function start = DetectStart(frame_energy, cross_thre_rate, noise_power, frame_len, snr_start)
    if (nargin < 5)
        snr_start = 1;
    end
    energy_start = [];
    i = 2;
    noise_energy = snr_start * noise_power * frame_len;
    while i < length(frame_energy)
        if  frame_energy(i) - frame_energy(i - 1) > noise_energy
            energy_start = [energy_start, i - 1];
            i = i + 25;
            continue
        end
        i = i + 1;
    end

    thre_start = [];
    hold_len = 9;
    for i = 1: 1: length(cross_thre_rate) - hold_len
        if cross_thre_rate(i) == 0 && ...
                sum(cross_thre_rate(i + 1: i + hold_len) ~= 0) == hold_len
            thre_start = [thre_start, i];
        end
    end

    temp_start = ArrayMerge(thre_start, energy_start);
    start = [temp_start(1)];
    for i = 2: 1: length(temp_start)
        if temp_start(i) - temp_start(i - 1) > 20
            start = [start, temp_start(i)];
        end
    end
end

