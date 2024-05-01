function [Counts, gVar] = k_means_process(I, seg, k)
    % count number of groups in on 8 by 8 block
    [rows, cols] = size(seg);
    Counts = zeros(floor(rows/8), floor(cols)/8);
    for i = 1:8:rows-7
        for j = 1:8:cols-7
            Counts(floor(i/8)+1, floor(j/8)+1) = length(unique(seg(i:i+7 , j:j+7)));
        end
    end
    gVar = group_var(I, seg(:), k);
end