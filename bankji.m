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
    %  เปลี่ยนบรรทัดที่ 44 เป็น countFolderCluster หากต้องการที่จะเอาทุกโฟล์เดอร์
    for folderClusterIndex = 3:5
        clusterFolderPath = clusterFolder(folderClusterIndex).name;
        intoFolderEachCluster = rootPath+"\"+clusterFolderPath;
        cd(intoFolderEachCluster)

        clusterInFolder = imageDatastore("./*.jpg");
        imageInClusterFolder = readall(clusterInFolder);
        fprintf('Folder %s',intoFolderEachCluster);
        fprintf('\n')
        for redPixelCluster = 1:4
            imgInFolder = readimage(clusterInFolder,redPixelCluster);
            
            redPoints = imgInFolder(:,:,1)>=130 & imgInFolder(:,:,2)<=60 & imgInFolder(:,:,3)<=100;
            percentRed = 100*(sum(sum(redPoints))/(size(imgInFolder,1)*size(imgInFolder,2)));

            if(percentRed >= 0.50)
                mkdir assumeBleeding
                copyfile(sprintf('cluster%d.jpg',redPixelCluster),'./assumeBleeding/')
            end
            fprintf('Image has %d red pixels\n',sum(sum(redPoints)))
            fprintf('Image is %.2f percent red\n',percentRed)
            rgbRed1 = uint8(cat(3,redPoints,redPoints,redPoints)).*imgInFolder;
        end

        cd("../")
    end

end
