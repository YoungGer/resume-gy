%% 一些基本指令
I1  = imread('horse.jpg');
I2 = imread('yuanyuan.jpg');
imshow(I1)
imshow(I1scaled)
imshow(I2)
imwrite(I2,'yuanyaun2.png');


% init8 to double
I1scaled = im2double(I1);
% init8 to double
I1back = im2uint8(I1scaled);

% iamge filter
h = fspecial('average',[3,3]);
J = imfilter(I1,h);

%%  reducing the number of intensity levels in an image from 256 to 2
origin_im = imread('yuanyuan.jpg'); 
gray_im = rgb2gray(origin_im); 
imshow(origin_im)
figure()
imshow(gray_im)

for i=1:8
    p1 = 2^i
    imshow(uint8(floor(double(gray_im)/p1)*p1))
    pause
end


%% Overlap average
%  replace the value of every pixel by the average of the values in its 3x3 10*10 20*20 neighborhood.
fun = @(x) uint8(mean2(x(:)));
overlap_avg_3 = nlfilter(gray_im,[3 3],fun);
overlap_avg_10 = nlfilter(gray_im,[10 10],fun);
overlap_avg_20 = nlfilter(gray_im,[20 20],fun);
figure,imshow(gray_im),figure,imshow(overlap_avg_3),figure,imshow(overlap_avg_10),figure,imshow(overlap_avg_20);


%% Rotate the image by 45 and 90 degrees
r45 = imrotate(gray_im,45);
r90 = imrotate(gray_im,90);
figure,imshow(r45),figure,imshow(r90);

%% replace all corresponding 9 pixels by their average
%  5*5 7*7
fun = @(block_struct) uint8( mean2(block_struct.data(:))  * ones(block_struct.blockSize) );
block_avg_3 = blockproc(gray_im,[3 3],fun);
block_avg_5 = blockproc(gray_im,[5 5],fun);
block_avg_7 = blockproc(gray_im,[7 7],fun);
figure,imshow(gray_im),figure,imshow(block_avg_3),figure,imshow(block_avg_5),figure,imshow(block_avg_7);