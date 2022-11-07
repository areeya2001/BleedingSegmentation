kmeanNum = 4;
% ไฟล์รูปภาพต้นฉบับ
imagefiles = dir('.\imagedata\*.png');
countFiles = length(imagefiles); 

% สำหรับเปลี่ยนที่เก็บรูป cluster
rootPath =  "C:\Users\areey\ปี 4\bleeding_cluster_1";
rootPathClusterExist = dir(rootPath);

cd(rootPath)

cd results
% Read all file
% prompt = "Do you want create folder? Y/N [Y]: ";
% createFolder = input(prompt,"s");
percentageAccept = 0.50;
for imageData = 1:48

            is_cluster_bleeding_idx = [];
            currentfilename = imagefiles(imageData).name;
            img = imread(currentfilename);
            lab_img = rgb2lab(img);
            ab = lab_img(:,:,1:3);
            img2Sigle = im2single(ab);
            pixel_labels = imsegkmeans(img2Sigle,kmeanNum,'NumAttempts',4); 
            isMuitlBleed = 0;
% check red pixel
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

% Case blood cluster Image >= 2 
            if percentRed >= percentageAccept && percentRed2 >= percentageAccept  && isMuitlBleed == 0
                disp("Hey 1 = 2")
                 isMuitlBleed = 1;
                 is_cluster_bleeding_idx(1) = 1;
                 is_cluster_bleeding_idx(2) = 2;
            end

            if percentRed >= percentageAccept && percentRed3 >= percentageAccept  && isMuitlBleed == 0
                disp("Hey 1 = 3")
                 isMuitlBleed = 1;
                 is_cluster_bleeding_idx(1) = 1;
                 is_cluster_bleeding_idx(2) = 3;
            end

            if percentRed >= percentageAccept && percentRed4 >= percentageAccept && isMuitlBleed == 0
                disp("Hey 1 = 4")
                 is_cluster_bleeding_idx(1) = 1;
                 is_cluster_bleeding_idx(2) = 4;
                 isMuitlBleed = 1;
                
            end

            if percentRed2 >= percentageAccept && percentRed3 >= percentageAccept  && isMuitlBleed == 0
                disp("Hey 2 = 3")
                 isMuitlBleed = 1;
                 is_cluster_bleeding_idx(1) = 2; 
                 is_cluster_bleeding_idx(2) = 3;
            end

            if percentRed2 >= percentageAccept && percentRed4 >= percentageAccept  && isMuitlBleed == 0
                disp("Hey 2 = 4")
                 is_cluster_bleeding_idx(1) = 2;
                 is_cluster_bleeding_idx(2) = 4;
                 isMuitlBleed = 1;
            end

            if percentRed3 >= percentageAccept && percentRed4 >= percentageAccept  && isMuitlBleed == 0
                disp("Hey 3 = 4")
                 isMuitlBleed = 1;
                 is_cluster_bleeding_idx(1) = 3;
                 is_cluster_bleeding_idx(2) = 4;
            end

 %   Case Non Blood Cluster Muti image
            if isMuitlBleed == 0
                if percentRed >= percentageAccept
                    disp('Cluster 1')
                    level = graythresh(cluster1);
                    disp(level)
                    Lab_Image = rgb2lab(cluster1);

                    L = Lab_Image(:,:,1);
                    L_red = L.*double(mask1);
                    L_red = rescale(L_red);
                    idx_light_red = imbinarize(nonzeros(L_red));
                    
                    red_idx = find(mask1);
                    mask_dark_red = mask1;
                    mask_dark_red(red_idx(idx_light_red)) = 0;
                    
                    red_zone = img.*uint8(mask_dark_red);
%                   figure;imshow(red_zone)

                    clusterName =  strrep(currentfilename, '.png', '');
                    clusterNameStr = sprintf('%s',clusterName);
                    imwrite(red_zone,[clusterNameStr '.png']);

                end
                if percentRed2 >= percentageAccept
                    
                    disp('Cluster 2')
                    Lab_Image = rgb2lab(cluster2);

                    L = Lab_Image(:,:,1);
                    L_red = L.*double(mask2);
                    L_red = rescale(L_red);
                    idx_light_red = imbinarize(nonzeros(L_red));
                    
                    red_idx = find(mask2);
                    mask_dark_red = mask2;
                    mask_dark_red(red_idx(idx_light_red)) = 0;
                    
                    red_zone = img.*uint8(mask_dark_red);
                    clusterName =  strrep(currentfilename, '.png', '');
                    clusterNameStr = sprintf('%s',clusterName);
                    imwrite(red_zone,[clusterNameStr '.png']);

                end
                if percentRed3 >= percentageAccept
                   
                    disp('Cluster 3')
                    Lab_Image = rgb2lab(cluster3);

                    L = Lab_Image(:,:,1);
                    L_red = L.*double(mask3);
                    L_red = rescale(L_red);
                    idx_light_red = imbinarize(nonzeros(L_red));
                    
                    red_idx = find(mask3);
                    mask_dark_red = mask3;
                    mask_dark_red(red_idx(idx_light_red)) = 0;
                    
                    red_zone = img.*uint8(mask_dark_red);
                   
                    clusterName =  strrep(currentfilename, '.png', '');
                    clusterNameStr = sprintf('%s',clusterName);
                    imwrite(red_zone,[clusterNameStr '.png']);

                end
                if percentRed4 >= percentageAccept
                   
                    disp('Cluster 4')

                    Lab_Image = rgb2lab(cluster4);
                    L = Lab_Image(:,:,1);
                    L_red = L.*double(mask4);
                    L_red = rescale(L_red);
                    idx_light_red = imbinarize(nonzeros(L_red));
                    
                    red_idx = find(mask4);
                    mask_dark_red = mask4;
                    mask_dark_red(red_idx(idx_light_red)) = 0;
                    
                    red_zone = img.*uint8(mask_dark_red);

                    clusterName =  strrep(currentfilename, '.png', '');
                    clusterNameStr = sprintf('%s',clusterName);
                    imwrite(red_zone,[clusterNameStr '.png']);

                end
            elseif isMuitlBleed == 1

                    disp('Cluster two Cluster')

                     mask1 = pixel_labels==is_cluster_bleeding_idx(1);
                     mask2 = pixel_labels==is_cluster_bleeding_idx(2);

                     maskMerge = double(mask1)+double(mask2);

                     clusterMerged = img .* uint8(maskMerge);

%                     figure,imshow(clusterMerged)
                     % save cluster blood combine
%                     clusterName =  strrep(currentfilename, '.png', '');
%                     clusterNameStr = sprintf('%s',clusterName);
%                     imwrite(red_zone,[clusterNameStr '.png']); 
                     

                      I = rgb2hsv(clusterMerged);

                    % Define thresholds for channel 1 based on histogram settings
                    channel1Min = 0.000;
                    channel1Max = 1.000;
                    
                    % Define thresholds for channel 2 based on histogram settings
                    channel2Min = 0.712;
                    channel2Max = 1.000;
                    
                    % Define thresholds for channel 3 based on histogram settings
                    channel3Min = 0.000;
                    channel3Max = 0.947;
                    
                    % Create mask based on chosen histogram thresholds
                    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
                    BW = sliderBW;

                    maskedRGBImage = clusterMerged;

                    maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

                    clusterName =  strrep(currentfilename, '.png', '');
                    clusterNameStr = sprintf('%s',clusterName);
                    imwrite(clusterMerged,[clusterNameStr '.png']);

%                     figure,imshow(maskedRGBImage)
%                      title('H S V Color')
% เริ่มของการปรับค่าความสะว่าง                 
%                     Lab_Image = rgb2lab(clusterMerged);
%                     L = Lab_Image(:,:,1);
%                     L_red = L.*maskMerge;
%                     L_red = rescale(L_red);
%                     idx_light_red = imbinarize(nonzeros(L_red));
% 
%                     red_idx = find(maskMerge);
%                     mask_dark_red = maskMerge;
%                     mask_dark_red(red_idx(idx_light_red)) = 0;
% 
%                     red_zone = img.*uint8(mask_dark_red);

%                     figure,imshow(red_zone)
%                     title('L A B Color')

% จบของการปรับค่าความสว่าง
                    

%                     level = graythresh(K)';
%                     disp(level)
% 
%                     I = rgb2hsv(K);
% 
%                     % Define thresholds for channel 1 based on histogram settings
%                     channel1Min = 0.000;
%                     channel1Max = 1.000;
%                     
%                     % Define thresholds for channel 2 based on histogram settings
%                     channel2Min = 0.712;
%                     channel2Max = 1.000;
%                     
%                     % Define thresholds for channel 3 based on histogram settings
%                     channel3Min = 0.000;
%                     channel3Max = 0.947;
%                     
%                     % Create mask based on chosen histogram thresholds
%                     sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
%                         (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
%                         (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
%                     BW = sliderBW;
% 
%                     maskedRGBImage = K;
% 
%                     maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
% 
%                     figure,imshow(maskedRGBImage)
                    
%                     Lab_Image = rgb2lab(K);
% 
%                     L = Lab_Image(:,:,1);
%                     
%                     maskMerge = double(mask1)+double(mask4);
%                     L_red = L.*maskMerge;
%                     L_red = rescale(L_red);
%                     idx_light_red = imbinarize(nonzeros(L_red));
% 
%                     red_idx = find(maskMerge);
%                     mask_dark_red = maskMerge;
%                     mask_dark_red(red_idx(idx_light_red)) = 0;
% 
%                     red_zone = img.*uint8(mask_dark_red);
% 
%                     figure,imshow(red_zone)
%                     L1 = Lab_Image(:,:,1);
%                     L_red1 = L1.*double(mask1);
%                     L_red1 = rescale(L_red1);
%                     idx_light_red1 = imbinarize(nonzeros(L_red1));
%                     
%                     red_idx1 = find(mask1);
%                     mask_dark_red1 = mask1;
%                     mask_dark_red1(red_idx1(idx_light_red1)) = 0;
%                     red_zone = img.*uint8(mask_dark_red1);
% 
%                     L2 = Lab_Image(:,:,1);
%                     L_red2 = L2.*double(mask4);
%                     L_red2 = rescale(L_red2);
%                     idx_light_red2 = imbinarize(nonzeros(L_red2));
%                     red_idx2 = find(mask4);
%                     mask_dark_red2 = mask4;
%                     mask_dark_red2(red_idx2(idx_light_red2)) = 0;
%                     
%                     red_zone2 = img.*uint8(mask_dark_red2);
% 
%                     mergeTwoMutibleed = imadd(red_zone,red_zone2);
%                     figure,imshow(K,[])
%                     title("bleeding")
%                    figure,imshow(K,[])
            else
                   disp('ínvalid')
            end

%            
                        

%             for kmeanIndex = 1:4
% 
%                 mask = pixel_labels==kmeanIndex;
%                 cluster = img .* uint8(mask);
% 
%                 redPoints = cluster(:,:,1)>=130 & cluster(:,:,2)<=60 & cluster(:,:,3)<=100;
%                 percentRed = 100*(sum(sum(redPoints))/(size(cluster,1)*size(cluster,2)));
% 
%                  if(percentRed >= percentageAccept)
%                         fprintf('Image has %d red pixels\n',sum(sum(redPoints)))
%                         fprintf('Image is %.2f percent red\n',percentRed)
%                         image_cluster = imadd(cluster);
%                  end
%             end
end