imagefiles = dir('C:\Users\areey\ปี 4\bleeding_cluster_2\results\BW\*.png');
countFiles = length(imagefiles); 

% สำหรับเปลี่ยนที่เก็บรูป cluster
rootPath =  "C:\Users\areey\ปี 4\bleeding_cluster_2\results\BW2";
rootPathClusterExist = dir(rootPath);

for imageData = 1:48
    cd(rootPath)
    currentfilename = imagefiles(imageData).name;
    img = imread(currentfilename);
    clusterName =  strrep(currentfilename, '.png', '');
    clusterNameStr = sprintf('%s',clusterName);
    imwrite(img,[clusterNameStr '.jpg']);
end