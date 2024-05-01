function gvar = group_var(I, idx, k)
    I_flat = I(:);
    gvar = zeros(1, k);
    gstd = zeros(1, k);
    for i = 1:k
       gvar(i) = var(I_flat(idx == i));
       gstd(i) = std(I_flat(idx == i));
    end
end