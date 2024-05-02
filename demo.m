directory = 'pic';
imageFiles = dir(fullfile(directory));
imageFiles = imageFiles(3:end);
images = cell(1,numel(imageFiles)); 
for i=1:numel(imageFiles)
    filename = fullfile(directory, imageFiles(i).name);
    images{i}=imread(filename);
end

%%
n = 2;
I = double(images{n});
T = dctmtx(8);
dct = @(block_struct) T * block_struct.data * T';
% this would pad image with zeros
B = blockproc(I,[8 8],dct);
%%
H = secondentropy(I);
[m,n]=size(I);
total = 511*511;
pixel_total = m*n;
x = round(pixel_total/total);
y = rem(pixel_total,total);
if x == 0
    H_max = -y*log2((x+1)/pixel_total)*(x+1)/pixel_total;
else
    H_max = -(total-y)*log2(x/pixel_total)*x/pixel_total - y*log2((x+1)/pixel_total)*(x+1)/pixel_total;
end

%%
H_block = zeros([m/8,n/8]);
for i = 1:size(H_block,1)
    for j = 1:size(H_block,2)
        I_x = I(1+(i-1)*8:i*8,1+(j-1)*8:j*8);
        H_block(i,j) = secondentropy(I_x);
    end
end
%%
b4 = zeros(m,n);
c4 = zeros(m,n);
r4 = 0;
q_max = max(0.55,H/H_max);
q_min = 0.2;
q_ref = zeros(m/8,n/8);
for i = 1:8:m
    for j = 1:8:n
        quantity = H_block(round(i/8)+1,round(j/8)+1)/6*100*(q_max-q_min)+q_min;
        q_ref(round(i/8)+1,round(j/8)+1)= quantity;
        Q = q_factor(quantity);
        b4(i:i+7,j:j+7) = Q.* round( (B(i:i+7,j:j+7)./Q) );
        c4(i:i+7,j:j+7) = round(B(i:i+7,j:j+7)./Q);
        r4 = r4+length(run_length(zig_zag_path(round(B(i:i+7,j:j+7)./Q))));
    end
end
%%
nnz(b4);
idct = @(block_struct) T' * block_struct.data * T;
Iq4 = blockproc(b4,[8 8],idct);
imshow(Iq4,[0,255])
log10(norm(I-Iq4,"Fro")^2)
%%
Q_50 = q_factor(50);
r = 0;
for i = 1:8:m
    for j = 1:8:n
        r = r +length(run_length(zig_zag_path(round(B(i:i+7,j:j+7)./Q_50))));
    end
end
aq = blockproc(B,[8 8], @(block_struct) Q_50.* round((block_struct.data) ./ Q_50) );
idct2 = @(block_struct) T' * block_struct.data * T;
Iq50 = blockproc(aq,[8 8],idct2);
figure
imshow(Iq50,[0 255]); truesize; title("JPEG method, Quality = 50");
nnz(aq)
log10(norm(I-Iq50,"Fro")^2)

