% Global variable
kmeanNum = 4; % กำหนดค่าของ KMean
percentageAccept = 0.50; % กำหนดค่าของเปอร์เซ็นต์ยอมรับ 


% ไฟล์รูปภาพต้นฉบับ
imagefiles = dir('.\imagedata\*.png');
countFiles = length(imagefiles); 

% สำหรับเปลี่ยนที่เก็บรูป cluster
rootPath =  "C:\Users\areey\ปี 4\bleeding_cluster_1";
rootPathClusterExist = dir(rootPath);

% Read all file
prompt = "Do you want create folder? Y/N [Y]: ";
createFolder = input(prompt,"s");

if createFolder == "Y"
    for imageData = 1:countFiles

        is_cluster_bleeding_idx = [];
        currentfilename = imagefiles(imageData).name;
        img = imread(currentfilename);
        lab_img = rgb2lab(img);
        ab = lab_img(:,:,1:3);
        img2Sigle = im2single(ab);
        pixel_labels = imsegkmeans(img2Sigle,kmeanNum,'NumAttempts',4); 
        isMuitlBleed = 0;

        
        mask1 = pixel_labels==1;
        cluster1 = img .* uint8(mask1);
        redPoints = cluster1(:,:,1)>=85 & cluster1(:,:,2)<=55 & cluster1(:,:,3)<=255;
        percentRed = 100*(sum(sum(redPoints))/(size(cluster1,1)*size(cluster1,2)));
        
        mask2 = pixel_labels==2;
        cluster2 = img .* uint8(mask2);
        redPoints2 = cluster2(:,:,1)>=85 & cluster2(:,:,2)<=55 & cluster2(:,:,3)<=255;
        percentRed2 = 100*(sum(sum(redPoints2))/(size(cluster2,1)*size(cluster2,2)));
        
        mask3 = pixel_labels==3;
        cluster3 = img .* uint8(mask3);
        redPoints3 = cluster3(:,:,1)>=85 & cluster3(:,:,2)<=55 & cluster3(:,:,3)<=255;
        percentRed3 = 100*(sum(sum(redPoints3))/(size(cluster3,1)*size(cluster3,2)));
        
        mask4 = pixel_labels==4;
        cluster4 = img .* uint8(mask4);
        redPoints4 = cluster4(:,:,1)>=85 & cluster4(:,:,2)<=55 & cluster4(:,:,3)<=255;
        percentRed4 = 100*(sum(sum(redPoints4))/(size(cluster4,1)*size(cluster4,2)));

    end
end