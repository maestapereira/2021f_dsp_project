clear
clc


% Path has to be a string to a folder containing only images to be
% processed, in a .mat format. Nothing else can be inside this folder,
% including other folders, images with different formats, etc. The folder
% must contain the file '30.mat', as it is used as a template to remove
% eyes.
path = strcat('C:\Users\smaes\OneDrive\to_be_desktop\', ...
    'columbia_masters\2021_f\dsp\dsp_project\2021f_dsp_project\data\tumor_data\');
directory = dir(path);
[numImg, ~] = size(directory);

% Get left and right eyes templates from image 30
imgTemplateInfo = load(append(path, '30.mat'));
imgTemplate = double(imgTemplateInfo.cjdata.image);
imgTemplate = (imgTemplate - min(imgTemplate(:))) ./ max(imgTemplate(:));
template1 = imgTemplate(54:140, 164:245);
template2 = imgTemplate(54:140, 294:375);
templateSize = size(template1);

TPtotal = 0;
FPtotal = 0;
TNtotal = 0;
FNtotal = 0;

% save tp and fn for each image
all_TP = zeros(numImg-2, 1);
all_FP = zeros(numImg-2, 1);
all_TN = zeros(numImg-2, 1);
all_FN = zeros(numImg-2, 1);
countTotal = 0;
for image = 3:numImg
    % Get image to detect tumor from
    imgInfo = load(append(path, directory(image).name));
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

    % Calculate error types
    tumorMask = imgInfo.cjdata.tumorMask;
    [TP, FP, TN, FN, count] = calculateError(imgThresholded, tumorMask, imgBinFill);
    % save each image
    all_TP(image-2, 1) = TP;
    all_FP(image-2, 1) = FP;
    all_TN(image-2, 1) = TN;
    all_FN(image-2, 1) = FN;
    % save sum
    TPtotal = TPtotal + TP;
    FPtotal = FPtotal + FP;
    TNtotal= TNtotal + TN;
    FNtotal = FNtotal + FN;
    countTotal = countTotal + count;
end


function [TP, FP, TN, FN, count] = calculateError(predicted, truth, binSkull)
    [r, c] = size(predicted);
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;
    count = 0;
    for i = 1:r
        for j = 1:c
            if binSkull(i, j)
                count = count + 1;
                if predicted(i, j)
                    if truth(i, j)
                        TP = TP + 1;
                    else
                        FP = FP + 1;
                    end
                else
                    if truth(i, j)
                        FN = FN + 1;
                    else
                        TN = TN + 1;
                    end
                end
            end
        end
    end
end

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