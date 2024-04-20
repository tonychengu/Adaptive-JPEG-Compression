function [a q_ref] = myQ(X)
[m, n] = size(X);
a = zeros(m, n);
q_ref = zeros(m/8, n/8);
var_ref = zeros(m/8, n/8);
sig_ref = zeros(m/8, n/8);
qi = 1;
qj = 1;
totalVar = var(X,0,'all');
for i = 1:8:m
    for j = 1:8:n
        currVar = var(X(i:i+7,j:j+7),0,'all');
        currVar = currVar / totalVar;
        quality = 1 / (1 + exp(currVar-1));%sigmoid(currVar - totalVar);
        sig_ref(qi, qj) = quality;
        quality = clip(quality, 0.55, 0.1);
        Q = q_factor(quality*100);
        q_ref(qi, qj) = quality*100;
        var_ref(qi, qj) = currVar;
        qj = qj+1;
        a(i:i+7,j:j+7) = Q.* round( (X(i:i+7,j:j+7)./Q) );
    end
    qi = qi+1;
    qj = 1;
end
end
