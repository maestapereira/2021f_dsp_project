clear
clc

path = 'C:\\Users\\smaes\\OneDrive\\to_be_desktop\\columbia_masters\\2021_f\\dsp\\dsp_project\\';

imgInfo = load(append(path, '150.mat'));
img = double(imgInfo.cjdata.image);
img = (img - min(img(:))) ./ max(img(:));

a = imgInfo.cjdata.tumorMask;
b = a .* img;
c = im2bw(img, 0.38);
% figure(1)
% imshow(binary(img, 125, 125, 0.35, 0.5))

figure(2)
imshow(img)


function [bwImg] = binary(img, windowRows, windowColumns, lowThresh, Upthresh)
    [r, c] = size(img);
    kernel = ones(windowRows, windowColumns) / (windowRows * windowColumns);
    avgImg = imfilter(img, kernel);
    bwImg = zeros(r, c);
    for i = 1:r
        for j = 1:c
            if img(i, j) < Upthresh && img(i, j) > lowThresh
                bwImg(i, j) = 1;
            end
        end
    end
end
