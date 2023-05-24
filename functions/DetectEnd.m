function final_end = DetectEnd(start, frame_energy, cross_thre_rate, noise_power, frame_len, snr_end)
    if (nargin < 6)
        snr_end = 1;
    end
    thre_end = [];
    hold_len = 5;
    for i = start
        for j = i + 1: 1: length(cross_thre_rate) - hold_len
            if cross_thre_rate(j: j + hold_len) == 0
                thre_end = [thre_end, j];
                break
            end
        end
    end
    energy_end = [];
    for k = start
        i = k;
        while i < length(frame_energy) - hold_len
            if  frame_energy(i) > snr_end * noise_power * frame_len && sum(frame_energy(i + 1: i + hold_len) < snr_end * noise_power * frame_len) == hold_len
                energy_end = [energy_end, i + 1];
                break
                continue
            end
            i = i + 1;
        end
    end
    temp_end = ArrayMerge(thre_end, energy_end);
    if ~isempty(temp_end)
        final_end = [temp_end(end)];
    else
        final_end = length(frame_energy);
    end
    for i = 1: 1: length(temp_end) - 1
        if temp_end(end - i + 1) - temp_end(end - i) > 20
            final_end = [temp_end(end - i), final_end];
        end
    end
end

