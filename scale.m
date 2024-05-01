function val = scale(a, upper, lower)
    if a >= 1
        val = upper;
    elseif a <= 0
        val = lower;
    else
        val = (upper - lower) * a + lower;
    end
end
