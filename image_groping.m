kmeanNum = 4;
imagefiles = dir('.\imagedata\*.png');
countFiles = length(imagefiles); 

% สำหรับเปลี่ยนที่เก็บรูป cluster
rootPath =  "C:\Users\areey\ปี 4\bleeding_cluster_1";
rootPathClusterExist = dir(rootPath);

% Read all file
prompt = "Do you want create folder? Y/N [Y]: ";
createFolder = input(prompt,"s");

prompt2 = "Do you want use image red_zone ? Y/N: ";
useRedZone = input(prompt2,"s");

if createFolder == "Y"
      for imageData = 2:2
            currentfilename = imagefiles(imageData).name;
            img = imread(currentfilename);
            lab_img = rgb2lab(img);
            ab = lab_img(:,:,1:3);
            img2Sigle = im2single(ab);
            pixel_labels = imsegkmeans(img2Sigle,kmeanNum,'NumAttempts',4); 

%             cd(rootPath);
%             folderName = strrep(currentfilename, '.png', '');
%             mkdir(folderName)
%             intoFolder = rootPath+"\"+folderName;
%             cd(intoFolder);


            fprintf('============ File Name %s ==========',currentfilename);
            fprintf('\n')

            is_cluster_bleeding_idx = [];

            for kmeanIndex = 1:4

                mask = pixel_labels==kmeanIndex;
                cluster = img .* uint8(mask);

                redPoints = cluster(:,:,1)>=85 & cluster(:,:,2)<=55 & cluster(:,:,3)<=255;
                percentRed = 100*(sum(sum(redPoints))/(size(cluster,1)*size(cluster,2)));

                if percentRed >= 0.50
                     is_cluster_bleeding_idx = [is_cluster_bleeding_idx,kmeanIndex];
                end
                fprintf('Cluster %d\n',kmeanIndex)
                fprintf('Image has %d red pixels\n',sum(sum(redPoints)))
                fprintf('Image is %.2f percent red\n',percentRed)
                rgbRed1 = uint8(cat(3,redPoints,redPoints,redPoints)).*cluster;      
            end

            if length(is_cluster_bleeding_idx) > 1
                     mask1 = pixel_labels==is_cluster_bleeding_idx(1);
                     cluster1 = img .* uint8(mask1);

                     mask2 = pixel_labels==is_cluster_bleeding_idx(2);
                     cluster2 = img .* uint8(mask2);

                     image2cluster = imadd(cluster1,cluster2);
                    figure,imshow(image2cluster) 
            end
       

      end
%       End for
end
% end if