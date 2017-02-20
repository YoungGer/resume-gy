RGB = imread('yuanyuan.jpg');
GRAY = rgb2gray(RGB);
imshow(RGB)
imshow(GRAY)

figure()
subplot(2,2,1);imshow(GRAY);
subplot(2,2,2);imhist(GRAY);
subplot(2,2,3);imshow(255-GRAY);
subplot(2,2,4);imhist(255-GRAY);

% hist equalization
% 通过把图像像素均一分布，能够看到更多的细节
figure()
subplot(2,2,1);imshow(GRAY);
subplot(2,2,2);imhist(GRAY);
subplot(2,2,3);histeq(GRAY);
subplot(2,2,4);imhist(histeq(GRAY));

% hist matching

% spatial filteringccc

% median filter
I = GRAY;
J = imnoise(I,'salt & pepper',0.09);
K = medfilt2(J);

subplot(2,2,1);imshow(I);
subplot(2,2,2);imshow(J);
subplot(2,2,3);imshow(K);

% unsharp masking
% median filter will blur the edge, it's more obvious in the hist equalization
I = GRAY;
J = imnoise(I,'salt & pepper',0.09);
K = medfilt2(J);

subplot(3,2,1);imshow(I);
subplot(3,2,2);imshow(J);
subplot(3,2,3);imshow(K);
subplot(3,2,4);imshow(I-K);
subplot(3,2,5);imshow((I-K).^2);
subplot(3,2,6);histeq((I-K));

% gradient
% edge detection & color edge detection 

% blockproc
fun = @(block_struct) imresize(block_struct.data,0.15);
I = imread('pears.png');
I2 = blockproc(I,[100 100],fun);
figure;
imshow(I);
figure;
imshow(I2);

fun = @(block_struct) ...
   std2(block_struct.data) * ones(size(block_struct.data));
I2 = blockproc('moon.tif',[50 50],fun);
figure;
imshow('moon.tif');
figure;
imshow(I2,[]);

fun = @(block_struct) ...
   mean2(block_struct.data) * ones(size(block_struct.data));
I2 = blockproc('moon.tif',[50 50],fun);
figure;
imshow('moon.tif');
figure;
imshow(I2,[]);

I = imread('peppers.png');
fun = @(block_struct) block_struct.data(:,:,[2 1 3]);
blockproc(I,[50 50],fun,'Destination','grb_peppers.tif');
figure;
imshow('peppers.png');
figure;
imshow('grb_peppers.tif');

% video
xyloObj = VideoReader('xylophone.mp4');

nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);

% Read one frame at a time.
for k = 1 : nFrames
    im = read(xyloObj, k);

    % here we process the image im

    mov(k).cdata = im;
end

% Size a figure based on the video's width and height.
hf = figure;
set(hf, 'position', [150 150 vidWidth vidHeight])

% Play back the movie once at the video's frame rate.
movie(hf, mov, 1, xyloObj.FrameRate);


