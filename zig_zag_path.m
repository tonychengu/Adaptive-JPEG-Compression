function z = zig_zag_path(I)
   I_flip = flip(I,2);
   z = [0];
   for i = 7:-1:-7
        if rem(i,2) == 0
            z = [z;diag(I_flip,i)];
        else
            z = [z;flip(diag(I_flip,i))];
        end
   end
   z = z(2:end);
end