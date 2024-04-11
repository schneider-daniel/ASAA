function mask = probSeg(img, cm, saveImg, showImg)

[H, S, ~] = rgb2hsv(img);

H = int32(1 + (360 - 1) .* H); % Normalize from 0;1 to 0;360
S = int32(1 + (100 - 1) .* S); % Normalize from 0;1 to 0;100

img = rgb2gray(img);
% Provide color model

% Applying the segmentation
mask = zeros(size(img, 1), size(img, 2));
[rows, cols, ~] = size(img);

for i = 1:rows
    for j = 1:cols
        mask(i, j) = cm(H(i, j), S(i, j));
    end
end

% Convert to uint8 format if not already
mask = uint8(mask);

% Create a 3-channel image by replicating the grayscale image along the third dimension
img_rgb = repmat(uint8(img), [1, 1, 3]);

% Set the red channel of the image to the mask
img_rgb(:,:,1) = img_rgb(:,:,1) + mask; % Mask
img_rgb(:,:,2) = img_rgb(:,:,2) .* (1 - mask/255);
img_rgb(:,:,3) = img_rgb(:,:,3) .* (1 - mask/255);

if saveImg
    imwrite(img_rgb, "./color_model/applied_cm.png");
end

if showImg
    imshow(img_rgb)
end



end

