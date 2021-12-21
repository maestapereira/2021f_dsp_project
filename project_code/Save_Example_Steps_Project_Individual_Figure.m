clear
clc


% Path has to be a stirng to a folder containing the image to be processed,
% in a .mat format. The folder must contain the file '30.mat', as it is
% used as a template to remove eyes.
path = strcat('C:\Users\smaes\OneDrive\to_be_desktop\columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\data\tumor_data\');
img_path = 'C:\Users\smaes\OneDrive\to_be_desktop\columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\figures\';
% Get left and right eyes templates from image 30 - DO NOT CHANGE THE
% '30.mat' FILE
imgTemplateInfo = load(append(path, '30.mat'));
imgTemplate = double(imgTemplateInfo.cjdata.image);
imgTemplate = (imgTemplate - min(imgTemplate(:))) ./ max(imgTemplate(:));
template1 = imgTemplate(54:140, 164:245);
template2 = imgTemplate(54:140, 294:375);
templateSize = size(template1);
% PLOT ALGORITHM step 1
figure(1);
imshow(imgTemplate);
title('Step 1');
saveas(gcf, strcat(img_path, 'step1.jpg'))
% PLOT ALGORITHM step 2
figure(2);
subplot(1, 2, 1);
imshow(template1);
subplot(1, 2, 2);
imshow(template2);
title('Step 2');
saveas(gcf, strcat(img_path, 'step2.jpg'))

% Get image to detect tumor from - CHANGE THIS TO THE DESIRED IMAGE
imgInfo = load(append(path, '31.mat'));
img = double(imgInfo.cjdata.image);
% PLOT ALGORITHM step 3
figure(3);
imshow(img);
title('Step 3');
saveas(gcf, strcat(img_path, 'step3.jpg'))

img = (img - min(img(:))) ./ max(img(:));
% PLOT ALGORITHM step 4
figure(4);
imshow(img);
title('Step 4');
saveas(gcf, strcat(img_path, 'step4.jpg'))

% Find left and right eyes in image
C1 = normxcorr2(template1, img);
[maxVal1, maxIdx1] = max(C1(:));
C2 = normxcorr2(template2, img);
[maxVal2, maxIdx2] = max(C2(:));
% PLOT ALGORITHM step 5, example left eye
figure(5);
imshow(C1);
title('Step 5');
saveas(gcf, strcat(img_path, 'step5.jpg'))

% Binarize image with low threshold to separate brain from background
imgBin = imbinarize(img, 0.1);
% PLOT ALGORITHM step 6
figure(6);
imshow(imgBin);
title('Step 6');
saveas(gcf, strcat(img_path, 'step6.jpg'))

% Fill holes from binarized image
imgBinFill = imfill(imgBin, 'holes');
% PLOT ALGORITHM step 7
figure(7);
imshow(imgBinFill);
title('Step 7');
saveas(gcf, strcat(img_path, 'step7.jpg'))

% Remove outer edge from binarized image, corresponds to removing skull
se = strel('disk', 30);
imgEroded = imerode(imgBinFill, se);

% Remove skull from original image
imgNoSkull = imgEroded .* img;
% PLOT ALGORITHM step 8
figure(8);
subplot(1, 2, 1);
imshow(imgEroded);
subplot(1, 2, 2);
imshow(imgNoSkull);
title('Step 8');
saveas(gcf, strcat(img_path, 'step8.jpg'))

% Remove eyes from image and low-pass filter
if maxVal1 > 0.7
    [r, c] = ind2sub(size(C1), maxIdx1);
    imgNoSkull(round(r-templateSize(1)):r, round(c-templateSize(2)):c) = 0;
end
if maxVal2 > 0.7
    [r, c] = ind2sub(size(C1), maxIdx2);
    imgNoSkull(round(r-templateSize(1)):r, round(c-templateSize(2)):c) = 0;
end
% PLOT ALGORITHM step 9
figure(9);
imshow(imgNoSkull);
title('Step 9');
saveas(gcf, strcat(img_path, 'step9.jpg'))

imgFiltered = imgaussfilt(imgNoSkull, 5);
% PLOT ALGORITHM step 10
figure(10);
subplot(1, 2, 1);
imshow(imgFiltered);

imgFiltered = imfilter(imgFiltered, fspecial('average', 15));
% PLOT step 10 2nd image
subplot(1, 2, 2);
imshow(imgFiltered);
title('Step 10');
saveas(gcf, strcat(img_path, 'step10.jpg'))

% Find threshold for Otsu's method
thresh = OtsuThresh(imgFiltered);

% Intensity transformation and thresholding
imgThresholded = 10*imgFiltered.^6;
% PLOT ALGORITHM step 12
figure(12);
imshow(imgThresholded);
title('Step 12');
saveas(gcf, strcat(img_path, 'step12.jpg'))

imgThresholded = (imgThresholded - min(imgThresholded(:))) ./ max(imgThresholded(:));
% PLOT ALGORITHM step 13
figure(13);
imshow(imgThresholded);
title('Step 13');
saveas(gcf, strcat(img_path, 'step13.jpg'))

imgThresholded = imbinarize(imgThresholded, thresh);
% PLOT ALGORITHM step 14
figure(14);
imshow(imgThresholded);
title('Step 14');
saveas(gcf, strcat(img_path, 'step14.jpg'))

% Remove very large and very small components
comp = bwconncomp(imgThresholded);
numPixels = cellfun(@numel,comp.PixelIdxList);
[~, numRegions] = size(numPixels);
for z = 1:numRegions
    if numPixels(z) < 500 || numPixels(z) > 20000
        imgThresholded(comp.PixelIdxList{z}) = 0;
    end
end
% PLOT ALGORITHM step 15
figure(15);
imshow(imgThresholded);
title('Step 15');
saveas(gcf, strcat(img_path, 'step15.jpg'))

% Remove components with high standard deviation
comp = bwconncomp(imgThresholded);
numPixels = cellfun(@numel,comp.PixelIdxList);
[~, numRegions] = size(numPixels);
for z = 1:numRegions
    if std2(img(comp.PixelIdxList{z})) > 0.08
        imgThresholded(comp.PixelIdxList{z}) = 0;
    end
end
% PLOT ALGORITHM step 16
figure(16);
imshow(imgThresholded);
title('Step 16');
saveas(gcf, strcat(img_path, 'step16.jpg'))

% Highlight tumors found and show figure
boundaries = bwboundaries(imgThresholded);
[numComp, ~] = size(boundaries);
tumorBoundaries = zeros(size(img));
if ~isempty(boundaries)
    for i = 1:numComp
        bound = boundaries{i};
        [numPixelsBound, ~] = size(bound);
        for j = 1:numPixelsBound
         tumorBoundaries(bound(j, 1), bound(j, 2)) = 1;
        end
    end
else
    fprintf('No tumor detected\n')
end
% PLOT ALGORITHM step 17
figure(17);
imshow(imgThresholded);
title('Step 17');
saveas(gcf, strcat(img_path, 'step17.jpg'))

imgTumorHighlited = img;
imgTumorHighlited(tumorBoundaries == 1) = 0;
% PLOT ALGORITHM step 18
figure(18)
imshow(cat(3, tumorBoundaries, zeros(size(img)), zeros(size(img))) + ...
    cat(3, imgTumorHighlited, imgTumorHighlited ,imgTumorHighlited))
title('Detected Tumor Boundaries');
saveas(gcf, strcat(img_path, 'step18.jpg'))


% PLOT ORIGINAL TUMOR BOUNDARIES
temp = abs(diff(imgInfo.cjdata.tumorMask));
temp2 = zeros(size(img));
temp2(2:end, :) = temp;

originalTumorBoundsImg = img;
originalTumorBoundsImg(temp2 == 1) = 0;
figure(19)
imshow(cat(3, temp2, zeros(size(img)), zeros(size(img))) + ...
    cat(3, originalTumorBoundsImg, originalTumorBoundsImg ,originalTumorBoundsImg))
title('Original Tumor Boundaries');
saveas(gcf, strcat(img_path, 'original_bounds.jpg'))

function [thresh] = OtsuThresh(img)
    [r, c] = size(img);
    count = 0;
    for i = 1:r
        for j = 1:c
            if img(i, j) ~= 0
                count = count + 1;
            end
        end
    end
    
    newImg = zeros(count, 1);
    c2 = 1;
    for i = 1:r
        for j = 1:c
            if img(i, j) ~= 0
                newImg(c2) = img(i, j);
                c2 = c2 + 1;
            end
        end
    end
    % PLOT ALGORITHM step 11
    figure(11);
    imshow(newImg);
    saveas(gcf, 'C:\Users\smaes\OneDrive\to_be_desktop\columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\figures\step11.jpg')
    
    thresh = graythresh(newImg);
end