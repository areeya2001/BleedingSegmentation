kmeanNum = 4;
% ไฟล์รูปภาพต้นฉบับ
imagefiles = dir('.\imagedata\*.png');
countFiles = length(imagefiles); 

% สำหรับเปลี่ยนที่เก็บรูป cluster
rootPath =  "C:\Users\areey\ปี 4\bleeding_cluster_2";
rootPathClusterExist = dir(rootPath);

% Read all file
prompt = "Do you want create folder? Y/N [Y]: ";
createFolder = input(prompt,"s");

prompt2 = "Do you want use image red_zone ? Y/N: ";
useRedZone = input(prompt2,"s");

% wantCreateFile = "Create cluster file or show image S:(Show) F:(File)";
% useRedZone = input(prompt2,"s");

if createFolder == "Y"
      for imageData = 1:countFiles
            currentfilename = imagefiles(imageData).name;
            img = imread(currentfilename);
            lab_img = rgb2lab(img);
            ab = lab_img(:,:,1:3);
            img2Sigle = im2single(ab);
            pixel_labels = imsegkmeans(img2Sigle,kmeanNum,'NumAttempts',4); 

            cd(rootPath);
            folderName = strrep(currentfilename, '.png', '');
            mkdir(folderName)
            intoFolder = rootPath+"\"+folderName;
            cd(intoFolder);
    %         pathUse = sprintf('%s',pathString);
            for kmeanIndex = 1:4
                mask = pixel_labels==kmeanIndex;
                cluster = img .* uint8(mask);
                
                Lab_Image = rgb2lab(cluster);
                L = Lab_Image(:,:,1);
                L_red = L.*double(mask);
                L_red = rescale(L_red);
                idx_light_red = imbinarize(nonzeros(L_red));

                red_idx = find(mask);
                mask_dark_red = mask;
                mask_dark_red(red_idx(idx_light_red)) = 0;
                
                red_zone = img.*uint8(mask_dark_red);

                %figure,imshow(bleeding)
                clusterName = "cluster"+kmeanIndex;
                clusterNameStr = sprintf('%s',clusterName);
                if isempty(useRedZone)
                    imwrite(cluster,[clusterNameStr '.png']);
                elseif useRedZone == 'Y'
                    imwrite(red_zone,[clusterNameStr '.png']);
                else 
                   imwrite(cluster,[clusterNameStr '.png']);
                end 
            end
      end
end

disp('--- Preparing to analysis image bleeding 10s ---')
pause(10.0);

disp('Ready..')

 cd(rootPath)
    clusterFolder = dir('.\*');
    countFolderCluster = length(clusterFolder); 
    %  เปลี่ยนบรรทัดที่ 44 เป็น countFolderCluster หากต้องการที่จะเอาทุกโฟล์เดอร์
    for folderClusterIndex = 3:countFolderCluster
        clusterFolderPath = clusterFolder(folderClusterIndex).name;
        intoFolderEachCluster = rootPath+"\"+clusterFolderPath;
        cd(intoFolderEachCluster)

        clusterInFolder = imageDatastore("./*.png");
        imageInClusterFolder = readall(clusterInFolder);
        fprintf('Folder %s',intoFolderEachCluster);
        fprintf('\n')
        for redPixelCluster = 1:4
            imgInFolder = readimage(clusterInFolder,redPixelCluster);
            % find Red pixel each cluster
            redPoints = imgInFolder(:,:,1)>=85 & imgInFolder(:,:,2)<=55 & imgInFolder(:,:,3)<=255;
            percentRed = 100*(sum(sum(redPoints))/(size(imgInFolder,1)*size(imgInFolder,2)));

            if(percentRed >= 0.50)
                  if ~exist('./assumeBleeding', 'dir')
                       mkdir assumeBleeding
                  end
             copyfile(sprintf('cluster%d.png',redPixelCluster),'./assumeBleeding/')
            %figure,imshow(imgInFolder)
            end
            fprintf('Image has %d red pixels\n',sum(sum(redPoints)))
            fprintf('Image is %.2f percent red\n',percentRed)
            rgbRed1 = uint8(cat(3,redPoints,redPoints,redPoints)).*imgInFolder;
        end        
%          จบ loop 4 ครั้งอ่าน cluster 4 cluster

%            อย่าลืมเปิดหากต้องการทำทุกโฟล์เดอร์
       cd("../")
    end

