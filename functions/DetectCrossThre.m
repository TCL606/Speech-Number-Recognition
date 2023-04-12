function cross_thre_num = DetectCrossThre(frame,thre)
    cross_thre_num = 0;
    for j = 2: 1: length(frame)
        if frame(j) > thre && frame(j - 1) < -thre ...
            || frame(j) < -thre && frame(j - 1) > thre
            cross_thre_num = cross_thre_num + 1;
        end
    end
end

