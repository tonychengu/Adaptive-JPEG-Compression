function a = myQ(X)
[m, n] = size(X);
a = zeros(m, n);
totalVar = var(X,0,'all');
for i = 1:8:m
    for j = 1:8:n
        currVar = var(X(i:i+7,j:j+7),0,'all');
        quality = 1 / (1 + exp(totalVar - currVar));%sigmoid(currVar - totalVar);
        quality = clip(quality, 0.25, 0.95);
        Q = q_factor(quality*100);
        a(i:i+7,j:j+7) = Q.* round( (X(i:i+7,j:j+7)./Q) );
    end
end
end
