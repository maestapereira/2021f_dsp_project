%% Plot actual tumor vs found tumor
% must be run after running the script Project_Individual_Figure.m

figure(20)
subplot(2,2,1);
imshow(img);

% original
subplot(2,2,2);
originalTumorBoundsImg = img;
originalTumorBoundsImg(imgInfo.cjdata.tumorMask == 1) = 0;
% PLOT ORIGINAL TUMOR BOUNDARIES

imshow(cat(3, imgInfo.cjdata.tumorMask, zeros(size(img)), zeros(size(img))) + ...
    cat(3, originalTumorBoundsImg, originalTumorBoundsImg ,originalTumorBoundsImg))
% title('Original Tumor');

% found
tumorBoundsImg = img;
tumorBoundsImg(imgThresholded == 1) = 0;

subplot(2,2,3);
imshow(cat(3, imgThresholded, zeros(size(img)), zeros(size(img))) + ...
    cat(3, tumorBoundsImg, tumorBoundsImg ,tumorBoundsImg))
% title('Found Tumor');

% difference
tumorBoundsImg = img;
diff = imgInfo.cjdata.tumorMask-imgThresholded;
tumorBoundsImg(diff == 1) = 0;

subplot(2,2,4);
imshow(cat(3, diff, zeros(size(img)), zeros(size(img))) + ...
    cat(3, tumorBoundsImg, tumorBoundsImg ,tumorBoundsImg))
% title('Found Tumor');