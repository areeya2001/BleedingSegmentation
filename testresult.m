close all
folder1 = ('C:\Users\areey\project\imageprediction\4_Accuracyhigh');
folder2 = ('C:\Users\areey\project\code_kn\data\annotations');

for i = 1:48
L = imread(image2);
C = im2uint8(L);
% imshow(C);
% I = imread(C);%output
X = imread(image3);%GT
% imshow(X);
% imshow(C);
FN = imsubtract(X,C); 
FP = imsubtract(C,X);
E = immultiply(C,X);
E = uint8( E(:,:,[1 1 1]) * 255 );
E = repmat(E,[1,1,3]);
E  = E(:,:,[ 1 1 1]);
FN = uint8( FN(:,:,[1 1 1]) * 255 );
FN = repmat(FN,[1,1,3]);
redChannel = FN(:,:,1);
greenChannel = FN(:,:,2);
blueChannel = FN(:,:,3);

FP = uint8( FP(:,:,[1 1 1]) * 255 );
FP = repmat(FP,[1,1,3]);
redChannel1 = FP(:,:,1);
greenChannel1 = FP(:,:,2);
blueChannel1= FP(:,:,3);
thresholdValue = 254; % Whatever you define white as.

whitePixels = redChannel > thresholdValue & greenChannel > thresholdValue & blueChannel > thresholdValue;
redChannel(whitePixels) = 255;
greenChannel(whitePixels) = 0;
blueChannel(whitePixels) = 0;
newRGBImage = cat(3, redChannel, greenChannel, blueChannel);

whitePixels1 = blueChannel1 > thresholdValue & greenChannel1 > thresholdValue & redChannel1 > thresholdValue;
redChannel1(whitePixels1) = 0;
greenChannel1(whitePixels1) = 0;
blueChannel1(whitePixels1) = 255;
newRGBImage1 = cat(3, redChannel1, greenChannel1, blueChannel1);
F = imadd(newRGBImage,newRGBImage1);
G = imadd(F,E);
total = G;
figure; imshow(G);
end
%imwrite(G,['C:\Users\areey\project\result\labeloutput2\vascular298.png']);
