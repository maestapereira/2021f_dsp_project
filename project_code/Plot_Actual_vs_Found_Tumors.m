%% Plot actual tumor vs found tumor
% must be run after running the script Project_Individual_Figure.m

% original
originalTumorBoundsImg = img;
originalTumorBoundsImg(imgInfo.cjdata.tumorMask == 1) = 0;
% PLOT ORIGINAL TUMOR BOUNDARIES
figure(20)
imshow(cat(3, imgInfo.cjdata.tumorMask, zeros(size(img)), zeros(size(img))) + ...
    cat(3, originalTumorBoundsImg, originalTumorBoundsImg ,originalTumorBoundsImg))
title('Original Tumor');

% found
tumorBoundsImg = img;
tumorBoundsImg(imgThresholded == 1) = 0;

figure(21)
imshow(cat(3, imgThresholded, zeros(size(img)), zeros(size(img))) + ...
    cat(3, tumorBoundsImg, tumorBoundsImg ,tumorBoundsImg))
title('Found Tumor');