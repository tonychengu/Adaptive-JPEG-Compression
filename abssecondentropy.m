function H = abssecondentropy(I)
    M = size(I,1);
    N = size(I,2);
    f_min = 0;
    f_max = 255;
    C_i = abs(conv2([1,-1],[1],I,"valid"));
    C_j = abs(conv2([1],[1,-1],I,"valid"));
    %C_i = C_i(1:end-1,:);
    %C_j = C_j(:,1:end-1);
    p = zeros(f_max-f_min+1);
    for k = 1:M-1
        for l = 1:N-1
            p(C_i(k,l)-f_min+1,C_j(k,l)-f_min+1) =p(C_i(k,l)-f_min+1,C_j(k,l)-f_min+1)+1;
        end
    end
    % for i = 1:size(p,1)
    %     for j = 1:size(p,2)
    %         s = 0;
    %         for k = 1:M-1
    %             for l = 1:N-1
    %                 s = s + delta(f_min+i-1,C_i(k,l))*delta(f_min+j-1,C_j(k,l));
    %             end
    %         end
    %         p(i,j) = s;
    %     end
    % end
    p_normalized = p./sum(p,"all");
    H = 0;
    for i = 1:size(p_normalized,1)
        for j = 1:size(p_normalized,2)
            if p_normalized(i,j) ~= 0
                H = H+log2(p_normalized(i,j))*p_normalized(i,j);
            end
        end
    end
    H = -H;


end