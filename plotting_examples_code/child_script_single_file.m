%% To be called by parent script

% Get left and right eyes templates from image 30 - DO NOT CHANGE THE
% '30.mat' FILE
imgTemplateInfo = load(append(path, '30.mat'));
imgTemplate = double(imgTemplateInfo.cjdata.image);
imgTemplate = (imgTemplate - min(imgTemplate(:))) ./ max(imgTemplate(:));
template1 = imgTemplate(54:140, 164:245);
template2 = imgTemplate(54:140, 294:375);
templateSize = size(template1);

% % Get image to detect tumor from - CHANGE THIS TO THE DESIRED IMAGE
% imgInfo = load(append(path, '31.mat'));
img = double(imgInfo.cjdata.image);
img = (img - min(img(:))) ./ max(img(:));

% Find left and right eyes in image
C1 = normxcorr2(template1, img);
[maxVal1, maxIdx1] = max(C1(:));
C2 = normxcorr2(template2, img);
[maxVal2, maxIdx2] = max(C2(:));

% Binarize image with low threshold to separate brain from background
imgBin = imbinarize(img, 0.1);

% Fill holes from binarized image
imgBinFill = imfill(imgBin, 'holes');

% Remove outer edge from binarized image, corresponds to removing skull
se = strel('disk', 30);
imgEroded = imerode(imgBinFill, se);

% Remove skull from original image
imgNoSkull = imgEroded .* img;

% Remove eyes from image and low-pass filter
if maxVal1 > 0.7
    [r, c] = ind2sub(size(C1), maxIdx1);
    imgNoSkull(round(r-templateSize(1)):r, round(c-templateSize(2)):c) = 0;
end
if maxVal2 > 0.7
    [r, c] = ind2sub(size(C1), maxIdx2);
    imgNoSkull(round(r-templateSize(1)):r, round(c-templateSize(2)):c) = 0;
end
imgFiltered = imgaussfilt(imgNoSkull, 5);
imgFiltered = imfilter(imgFiltered, fspecial('average', 15));

% Find threshold for Otsu's method
thresh = OtsuThresh(imgFiltered);

% Intensity transformation and thresholding
imgThresholded = 10*imgFiltered.^6;
imgThresholded = (imgThresholded - min(imgThresholded(:))) ./ max(imgThresholded(:));
imgThresholded = imbinarize(imgThresholded, thresh);

% Remove very large and very small components
comp = bwconncomp(imgThresholded);
numPixels = cellfun(@numel,comp.PixelIdxList);
[~, numRegions] = size(numPixels);
for z = 1:numRegions
    if numPixels(z) < 500 || numPixels(z) > 20000
        imgThresholded(comp.PixelIdxList{z}) = 0;
    end
end

% Remove components with high standard deviation
comp = bwconncomp(imgThresholded);
numPixels = cellfun(@numel,comp.PixelIdxList);
[~, numRegions] = size(numPixels);
for z = 1:numRegions
    if std2(img(comp.PixelIdxList{z})) > 0.08
        imgThresholded(comp.PixelIdxList{z}) = 0;
    end
end

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
imgTumorHighlited = img;
imgTumorHighlited(tumorBoundaries == 1) = 0;
figure(fig_num)
imshow(cat(3, imgThresholded, zeros(size(img)), zeros(size(img))) + ...
    cat(3, tumorBoundsImg, tumorBoundsImg ,tumorBoundsImg))
title('Detected Tumor');
saveas(gcf, fig_name_found)

% original
originalTumorBoundsImg = img;
originalTumorBoundsImg(imgInfo.cjdata.tumorMask == 1) = 0;
% PLOT ORIGINAL TUMOR BOUNDARIES
figure(fig_num + size(best_files, 1) + size(worst_files, 1) + 1)
imshow(cat(3, imgInfo.cjdata.tumorMask, zeros(size(img)), zeros(size(img))) + ...
    cat(3, originalTumorBoundsImg, originalTumorBoundsImg ,originalTumorBoundsImg))
title('Actual Tumor');
saveas(gcf, fig_name_actual)


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
    thresh = graythresh(newImg);
end