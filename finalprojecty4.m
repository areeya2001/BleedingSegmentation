function finalprojecty4
opengl software
imds = imageDatastore('C:\Users\areey\project\imagedata\*.png');
imgs = readall(imds);
%T = readtable('RGB.xlsx');
%disp(T);
%file = "E:\image project\.jpg";

for i = 1:1
    img = readimage(imds,i);
%     figure,imshow(img),title('Original image');
    %[filepath,name,ext] = fileparts(file)
    imds.Files{i};
end

for i = 10:10
img = readimage(imds,i);
lab_img = rgb2lab(img);
L = lab_img(:,:,1);
ab = lab_img(:,:,2:3);
ab = im2single(ab);
nColors = 4; 

Dc1 = "C:\Users\areey\project\result\LAB_img\lab_"+i;
DcFormat1 = sprintf('%s',Dc1);

figure,imshow(lab_img);
%imwrite(lab_img,[DcFormat1 'lab.png']);

Dc = "C:\Users\areey\project\resul1t\breeding_"+i;
DcFormat = sprintf('%s',Dc);

%repeat the clustering 4 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',4);
figure,imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');
%imwrite(pixel_labels,[DcFormat 'testl_labels.jpg']);


mask1 = pixel_labels==1;
cluster1 = img .* uint8(mask1);
figure,imshow(cluster1)
title('Objects in Cluster 1');
% imwrite(cluster1,[DcFormat 'cluster1.jpg']);

mask2 = pixel_labels==2;
cluster2 = img .* uint8(mask2);
figure,imshow(cluster2)
title('Objects in Cluster 2');
%imwrite(cluster2,[DcFormat 'cluster2.jpg']);

mask3 = pixel_labels==3;
cluster3 = img .* uint8(mask3);
figure,imshow(cluster3)
title('Objects in Cluster 3');
%imwrite(cluster3,[DcFormat 'cluster3.jpg']);

mask4 = pixel_labels==4;
cluster4 = img .* uint8(mask4);
figure,imshow(cluster4)
title('Objects in Cluster 4');
%imwrite(cluster4,[DcFormat 'cluster4.jpg']);
end

%% find Red pixel each cluster
% check red pixel of cluster1
redPoints1 = cluster1(:,:,1)>=130 & cluster1(:,:,2)<=60 & cluster1(:,:,3)<=100;
percentRed1 = 100*(sum(sum(redPoints1))/(size(cluster1,1)*size(cluster1,2)));
fprintf('Image has %d red pixels\n',sum(sum(redPoints1)))
fprintf('Image is %.2f percent red\n',percentRed1)
rgbRed1 = uint8(cat(3,redPoints1,redPoints1,redPoints1)).*cluster1;
%figure;imshow(rgbRed1)

% check red pixel of cluster2
redPoints2 = cluster2(:,:,1)>=130 & cluster2(:,:,2)<=60 & cluster2(:,:,3)<=100;
percentRed2 = 100*(sum(sum(redPoints2))/(size(cluster2,1)*size(cluster2,2)));
fprintf('Image has %d red pixels\n',sum(sum(redPoints2)))
fprintf('Image is %.2f percent red\n',percentRed2)
rgbRed2 = uint8(cat(3,redPoints2,redPoints2,redPoints2)).*cluster2;
%figure;imshow(rgbRed2)

% check red pixel of cluster3
redPoints3 = cluster3(:,:,1)>=130 & cluster3(:,:,2)<=60 & cluster3(:,:,3)<=100;
percentRed3 = 100*(sum(sum(redPoints3))/(size(cluster3,1)*size(cluster3,2)));
fprintf('Image has %d red pixels\n',sum(sum(redPoints3)))
fprintf('Image is %.2f percent red\n',percentRed3)
rgbRed3 = uint8(cat(3,redPoints3,redPoints3,redPoints3)).*cluster3;
%figure;imshow(rgbRed3)

% check red pixel of cluster4
redPoints4 = cluster4(:,:,1)>=130 & cluster4(:,:,2)<=60 & cluster4(:,:,3)<=100;
percentRed4 = 100*(sum(sum(redPoints4))/(size(cluster4,1)*size(cluster4,2)));
fprintf('Image has %d red pixels\n',sum(sum(redPoints4)))
fprintf('Image is %.2f percent red\n',percentRed4)
rgbRed3 = uint8(cat(3,redPoints4,redPoints4,redPoints4)).*cluster4;
%figure;imshow(rgbRed3)
%% findcoordination
% for i = 1:4
% img = readimage(imds,i);
% figure,imshow(img);
% [y1,x1] = find(img>0);
% [y2,x2] = find(img>0);
% [y3,x3] = find(img>0);
% [y4,x4] = find(img>0); 
% axis on
% hold on;
% coor1 = [x1  y1] ;
% coor2 = [x2  y2] ;
% coor3 = [x3  y3] ;
% coor4 = [x4  y4] ;
% pixelColor = impixel(i,x1,y1);
% pixelColor = impixel(i,x2,y2);
% pixelColor = impixel(i,x3,y3);
% pixelColor = impixel(i,x4,y4);
% end
% 
% %Check Region Blood
% for n=4:size(pixelColor)
%   pixRed = pixelColor(n,1);
%   pixGreen = pixelColor(n,2);
%   pixBlue = pixelColor(n,3);
% 
%   if (pixRed >= 128) && (pixRed <= 255)
%      if (pixGreen >= 0) && (pixGreen <= 34)
%      if (pixBlue >= 0) && (pixGreen <= 34)
%      figure,imshow(Blood);
%        plot(coor(n,1),coor1(n,2), 'b-o', 'MarkerSize', 0.1, 'LineWidth', 2);title('Plot Blood');
%         end
%       end
%   end
% end

%% improve evaluation
L = lab_img(:,:,1);
L_red = L.*double(mask3);
L_red = rescale(L_red);
idx_light_red = imbinarize(nonzeros(L_red));

red_idx = find(mask3);
mask_dark_red = mask3;
mask_dark_red(red_idx(idx_light_red)) = 0;

red_zone = img.*uint8(mask_dark_red);
figure;imshow(red_zone)
title("bleeding1")

L = lab_img(:,:,1);
L_red2 = L.*double(mask4);
L_red2 = rescale(L_red2);
idx_light_red2 = imbinarize(nonzeros(L_red2));

red_idx = find(mask4);
mask_dark_red2 = mask4;
mask_dark_red2(red_idx(idx_light_red2)) = 0;

red_zone2 = img.*uint8(mask_dark_red2);
figure;imshow(red_zone2)
title("bleeding2")
%% Plot Histogram of image data1
labimg1 = rgb2lab(cluster3);
L2 = labimg1(:,:,1);
a2 = labimg1(:,:,2);
b2 = labimg1(:,:,3);
figure;
subplot(2,2,1);
LHist = histogram(L2);
grid on;
title('L Histogram');

subplot(2,2,2);
aHist = histogram(a2);
grid on;
title('a Histogram');

subplot(2,2,3);
bHist = histogram(b2);
grid on;
title('b Histogram');

subplot(2,2,4);
imshow(cluster3);

%% Plot Histogram of image data1
labimg2 = rgb2lab(cluster4);
L2 = labimg2(:,:,1);
a2 = labimg2(:,:,2);
b2 = labimg2(:,:,3);
figure;
subplot(2,2,1);
LHist = histogram(L2);
grid on;
title('L Histogram');

subplot(2,2,2);
aHist = histogram(a2);
grid on;
title('a Histogram');

subplot(2,2,3);
bHist = histogram(b2);
grid on;
title('b Histogram');

subplot(2,2,4);
imshow(cluster4);


