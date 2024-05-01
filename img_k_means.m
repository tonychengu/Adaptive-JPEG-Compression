function seg = img_k_means(I, k)
    [rows, cols] = size(I);
    [X, Y] = meshgrid(1:cols, 1:rows);
    X = X(:);
    Y = Y(:);
    intensities = double(reshape(I, [], 1));
    
    weight = 0.22;  % weight of the importance of index
    data = [intensities, weight * X, weight * Y];
    
    % Perform k-means
    [idx, C] = kmeans(data, k);
    
    % Reshape the group back to 2d image
    seg = reshape(idx, size(I));
end
    