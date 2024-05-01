I = imread('man.tiff');
I = double(I);
T = dctmtx(8);
dct = @(block_struct) T * block_struct.data * T';
% this would pad image with zeros
B = blockproc(I,[8 8],dct);

%%
H = secondentropy(I);


%%

H_block = zeros(128);
for i = 1:128
    for j = 1:128
        I_x = I(1+(i-1)*8:i*8,1+(j-1)*8:j*8);
        H_block(i,j) = secondentropy(I_x);
    end
end

%%
[m, n] = size(B);
b = zeros(m, n);
for i = 1:8:m
    for j = 1:8:n
        quantity = 1 / (1 + exp(-H_block(round(i/8)+1,round(j/8)+1)/H));
        Q = q_factor(quantity*100);
        b(i:i+7,j:j+7) = Q.* round( (B(i:i+7,j:j+7)./Q) );
    end
end
%%
nnz(b)
idct = @(block_struct) T' * block_struct.data * T;
Iq = blockproc(b,[8 8],idct);
figure
imshow(Iq,[0,255])
diff1 = log10(norm(I - Iq, 'fro')^2 / norm(I, 'fro')^2);
diff = norm(I-Iq,2);

%% No Sigmoid
[m, n] = size(B);
b1 = zeros(m, n);
for i = 1:8:m
    for j = 1:8:n
        quantity = H_block(round(i/8)+1,round(j/8)+1)/H*100;
        Q = q_factor(quantity);
        b1(i:i+7,j:j+7) = Q.* round( (B(i:i+7,j:j+7)./Q) );
    end
end
nnz(b1)
idct = @(block_struct) T' * block_struct.data * T;
Iq1 = blockproc(b1,[8 8],idct);
figure
imshow(Iq1,[0,255])

%%
Q_50 = q_factor(50);
aq = blockproc(B,[8 8], @(block_struct) Q_50.* round((block_struct.data) ./ Q_50) );
idct2 = @(block_struct) T' * block_struct.data * T;
Iq2 = blockproc(aq,[8 8],idct2);
imshow(Iq2,[0 255]); truesize; title("JPEG method");
nnz(aq)
diff_JPEG = norm(I-aq,2);
%%
% m = size(I,1);
% k = 3;
% m1 = m + k*(m/8-1);
% I_new = zeros(m1)+255;
% for i = 1:8:m
%     for j = 1:8:m
%         I_new(i+round(i/8)*k:i+round(i/8)*k+7,j+round(j/8)*k:j+round(j/8)*k+7) = I(i:i+7,j:j+7);
%     end
% end
% imshow(I_new,[0,255])
% figure
% imshow(I,[0,255])

