function HSI = RGB2HSI(img)
% RGB2HSI converts an RGB image to HSI (Hue, Saturation, Intensity) color space.
%
%   HSI = RGB2HSI(IMG) converts the RGB image IMG to the HSI color space and
%   returns the HSI image.
%
%   Parameters:
%   - IMG: Input RGB image (uint8 or double) to be converted to HSI color space.
%
%   Returns:
%   - HSI: HSI image (double) with the same size as the input image, containing
%          the Hue, Saturation, and Intensity channels.
%
%   Example:
%   rgbImage = imread('example_image.jpg'); % Load RGB image

HSV = rgb2hsv(img);
I = double(img) / 255;

% Merging to HSI
HSI = zeros(size(img));
HSI(:,:,1) = HSV(:,:,1);
HSI(:,:,2) = HSV(:,:,2);
HSI(:,:,3) = sum(I, 3)./3;

end