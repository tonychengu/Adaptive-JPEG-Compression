function [a q_ref] = myQ(X, upper, lower, seg, counts, gVar)
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
%         if (j > 1 && i > 1) && (j < m-8 && i < n-8)
%             currVar = var(X(i-8:i+15,j-8:j+15),0,'all');
%         end
        quality = 0;
        if counts > 2
            quality = upper;
        elseif counts > 1
            quality = (upper + lower)/2;
        else
            groupVar = gVar(seg(i, j));
            %currVar = currVar / groupVar;
            currVar = currVar / totalVar;
            quality = 1 / (1 + exp(-(currVar - 1)));%sigmoid(currVar - totalVar);
            quality = scale(quality, upper, lower);
        end
        sig_ref(qi, qj) = quality;
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
