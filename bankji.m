kmeanNum = 4;
% ไฟล์รูปภาพต้นฉบับ
imagefiles = dir('.\imagedata\*.png');
countFiles = length(imagefiles); 

% สำหรับเปลี่ยนที่เก็บรูป cluster
rootPath =  "C:\Users\areey\project\bank";
rootPathClusterExist = dir(rootPath);

% Read all file
prompt = "Do you want create folder? Y/N [Y]: ";
createFolder = input(prompt,"s");
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
                mask1 = pixel_labels==kmeanIndex;
                cluster = img .* uint8(mask1);
                %figure,imshow(bleeding)
                clusterName = "cluster"+kmeanIndex;
                clusterNameStr = sprintf('%s',clusterName);
                imwrite(cluster,[clusterNameStr '.jpg']);
            end
      end
end

if isempty(createFolder)
    cd(rootPath)
    clusterFolder = dir('.\*');
    countFolderCluster = length(clusterFolder); 

    for folderClusterIndex = 3:countFolderCluster
        clusterFolderPath = clusterFolder(folderClusterIndex).name;
        intoFolderEachCluster = rootPath+"\"+clusterFolderPath;
        disp(intoFolderEachCluster)
    end

end
