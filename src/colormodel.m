function mask = colormodel(pattern_directory)

files = dir(fullfile(pattern_directory, '*.PNG'));

H = [];
S = [];
I = [];

% Loop through each file
for k = 1:numel(files)
    % Read the image
    img = imread(fullfile(pattern_directory, files(k).name));
    
    % Convert image from RGB to HLS
    img = rgb2hsv(img);
    
    % Compute mean values of each channel
    H = [H; mean(img(:,:,1), 'all')];
    S = [S; mean(img(:,:,2), 'all')];
end

H = int32(H .* 360); % Normalize from 0;1 to 0;360
S = int32(S .* 100); % Normalize from 0;1 to 0;100

color_model = zeros(360, 100);

% Loop through each pair of H and S values
for i = 1:numel(H)
    % Increment corresponding bin in color_model
    color_model(H(i), S(i)) = color_model(H(i), S(i)) + 1;
end


% Define the kernel
kernel = ones(12, 12) / 2;

% Apply the filter
dst = filter2(kernel, color_model);

imwrite(dst, './color_model/cm_red.png');