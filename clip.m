function val = clip(a, upper, lower)
    val = a;
    if val > upper
        val = upper;
    elseif val < lower
        val = lower;
    end
    return
end
