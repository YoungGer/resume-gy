RGB = imread('yuanyuan.jpg');
I = rgb2gray(RGB);
I2G = imnoise(I,'gaussian',0.02);
I2 = imnoise(I,'salt & pepper',0.02);
I20 = imnoise(I,'salt & pepper',0.2)

%% 看一看不同的噪声
figure()
subplot(2,2,1);imshow(I);
subplot(2,2,2);imshow(I2G);
subplot(2,2,3);imshow(I2);
subplot(2,2,4);imshow(I20);

%% wiener filter
RGB = imread('saturn.png');
I = rgb2gray(RGB);
