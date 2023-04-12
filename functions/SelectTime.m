function time_select = SelectTime(frame_len, frame_shift_len, time)
    offset = floor(frame_shift_len / 2);
    time_select = time([offset: frame_shift_len : length(time) - frame_len + offset]);
end

