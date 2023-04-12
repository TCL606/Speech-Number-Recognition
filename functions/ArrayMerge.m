function merge_arr = ArrayMerge(arr1, arr2)
    merge_arr = zeros(length(arr1) + length(arr2), 1);
    i = 1; m = 1; k = 1;
    while i <= length(merge_arr)
        if k <= length(arr2) && m <= length(arr1)
            if arr1(m) <= arr2(k) 
                merge_arr(i) = arr1(m);
                m = m + 1;
            else
                merge_arr(i) = arr2(k);
                k = k + 1;
            end
            i = i + 1;
        elseif k > length(arr2)
            merge_arr(end - length(arr1) + m: end) = arr1(m: end);
            break
        else
            merge_arr(end - length(arr2) + k: end) = arr2(k: end);
            break
        end
    end
end

