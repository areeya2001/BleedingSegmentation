function ColorFeatures_Lab
opengl software
imds = imageDatastore('C:\Users\areey\project\imagedata\*.png');
imgs = readall(imds);

for i = 1:48
    img = readimage(imds,i);
    %figure,imshow(img),title('Original image');
    %[filepath,name,ext] = fileparts(file)
    %imds.Files{i}
end
%%
for i = 3:3
img = readimage(imds,i);

% Classify Colors in RBG Color Space Using K-Means Clustering
nColors = 4; 
L = imsegkmeans(img,nColors);
B = labeloverlay(img,L);
figure;imshow(B);title("Labeled Image RGB")

% Convert Image from RGB Color Space to L*a*b* Color Space
lab_img = rgb2lab(img);
ab = lab_img(:,:,2:3);
ab = im2single(ab);

% repeat the clustering 4 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',4);
% figure,imshow(pixel_labels,[])
% title('Image Labeled by Cluster Index'); 
B2 = labeloverlay(img,pixel_labels);
%imshow(B2)
title("Labeled Image a*b*")
Dc = "C:\Users\areey\ปี 4\code\savecluster\cluster_"+i;
DcFormat = sprintf('%s',Dc);

mask1 = pixel_labels==1;
cluster1 = img .* uint8(mask1);
figure,imshow(cluster1)
title('Objects in Cluster 1');
%imwrite(cluster1,[DcFormat 'cluster1.jpg']);

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
%%
% Use V Component of HSV separate brightness

% inclight = rgb2gray(cluster3);
% figure;imshow(inclight);title("increase the brightness")
Lab_Image = rgb2lab(cluster3);
% h_image = hsvImage(:,:,1); %H Component
% s_image = hsvImage(:,:,2); %S Component
% v_image = hsvImage(:,:,3); %V Component

L = Lab_Image(:,:,1);
L_red = L.*double(mask3);
L_red = rescale(L_red);
idx_light_red = imbinarize(nonzeros(L_red));

red_idx = find(mask3);
mask_dark_red = mask3;
mask_dark_red(red_idx(idx_light_red)) = 0;

red_zone = img.*uint8(mask_dark_red);
figure;imshow(red_zone)
title("bleeding")
