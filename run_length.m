function r = run_length(z)
    k = find(z~=0);
    if length(k) ~= 0
        r = [z(k(1))];
        for i = 2:length(k)
            if (k(i) - k(i-1)) == 1
                r = [r z(k(i))];
            else
                r = [r [0 k(i)-k(i-1)-1 z(k(i))]];
            end
        end
        r = [r [0 64-k(end)]];
    else
        r = [0 64];
    end

end