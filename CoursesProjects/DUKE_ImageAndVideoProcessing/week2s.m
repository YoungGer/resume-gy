RGB = imread('yuanyuan.jpg');
YCBCR = rgb2ycbcr(RGB);

% 显示RGB channel
R = RGB;
G = RGB;
B = RGB;
R(:,:,2:3) = 0;
G(:,:,[1,3]) = 0;
G(:,:,3) = 0;
B(:,:,1:2) = 0;
subplot(2,2,1);imshow(R);
subplot(2,2,2);imshow(G);
subplot(2,2,3);imshow(B);
subplot(2,2,4);imshow(RGB);

%显示Y Cb Cr channel
figure;
lb={'Y','Cb','Cr'};
for channel=1:3
subplot(1,3,channel)
YCBCR_C=YCBCR;
YCBCR_C(:,:,setdiff(1:3,channel))=intmax(class(YCBCR_C))/2;
imshow(ycbcr2rgb(YCBCR_C))
title([lb{channel} ' component'],'FontSize',18);
end

imshow(RGB)
imshow(YCBCR)

% 图像分割
RGB = imread('yuanyuan.jpg');
s = RGB(1:8,1:8,:);
imshow(s);

% RGB分解
R = RGB;
G = RGB;
B = RGB;
R(:,:,2:3) = 0;
G(:,:,[1,3]) = 0;
G(:,:,3) = 0;
B(:,:,1:2) = 0;
subplot(2,2,1);imshow(R);
subplot(2,2,2);imshow(G);
subplot(2,2,3);imshow(B);
subplot(2,2,4);imshow(RGB);
axis tight


% Y CB CR分解
YCBCR = rgb2ycbcr(RGB);
imshow(ycbcr2rgb(YCBCR))
figure;
lb={'Y','Cb','Cr'};
for channel=1:3
subplot(1,3,channel)
YCBCR_C=YCBCR;
YCBCR_C(:,:,setdiff(1:3,channel))=intmax(class(YCBCR_C))/2;
imshow(ycbcr2rgb(YCBCR_C))
title([lb{channel} ' component'],'FontSize',18);
end

%% DCT
% 全部一样的元素DCT后只有一个不等于0
X = uint8(ones(8)*220);
dct2(X)
imshow(X)
imshow(dct2(X))

% s变换DCT
s_y = YCBCR(1:8,1:8,1)
s_y_dct = dct2(s_y)
idct2(dct2(s_y))

% QUANTIZATION
QY =  [16 11 10 16 24 40 51 61 ; 
    12 12 14 19 26 58 60 55 ; 
    14 13 16 24 40 57 69 56 ; 
    14 17 22 29 51 87 80 62 ; 
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92; 
    49 64 78 87 103 121 120 101; 
    72 92 95 98 112 100 103 99];
QC = [17 18 24 47 99 99 99 99 ; 
    18 21 26 66 99 99 99 99 ; 
    24 26 56 99 99 99 99 99 ; 
    47 66 99 99 99 99 99 99 ; 
    99 99 99 99 99 99 99 99 ; 
    99 99 99 99 99 99 99 99 ; 
    99 99 99 99 99 99 99 99 ; 
    99 99 99 99 99 99 99 99];


s_y_dct_quan = uint8(floor(double(s_y_dct)./QY).*QY);

%% Huffman coding

s_y_dct_quan_huff = s_y_dct_quan(:);
whos s_y_dct_quan_huff

[symbols,p]=hist(s_y_dct_quan_huff,double(unique(s_y_dct_quan_huff)))
