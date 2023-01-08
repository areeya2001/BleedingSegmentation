
rootPath = 'C:\Users\areey\ปี 4\bleeding_cluster_2\results';
cd(rootPath)

imagefiles = dir('C:\Users\areey\ปี 4\bleeding_cluster_2\results\*.png');
countFiles = length(imagefiles); 

mkdir BW;

cd BW
for i = 1:countFiles
 currentfilename = imagefiles(i).name;
 img = imread(currentfilename);
 BW = im2bw(img,0.1);
 disp(currentfilename)
 clusterName =  strrep(currentfilename, '.png', '');
 clusterNameStr = sprintf('%s',clusterName);
 imwrite(BW,[clusterNameStr '.jpg']);
end
