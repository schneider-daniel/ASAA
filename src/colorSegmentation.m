function maskedFrame = colorSegmentation(frame, samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh)

SE = strel('disk', 3);
opacity = 0.8; % Drawing opacity

% Preallocate storage for sampled HSI values
sampledHSI = zeros(samplePoints, 3);

% Convert the frame to HSI color space
    frameHSI = rgb2hsv(frame);

    % Define area for sampling (bottom center)
    [height, width, ~] = size(frame);
    startX = max(1, floor((width - ROIwidth) / 2));
    endX = min(width, startX + ROIwidth);
    startY = max(1, height - ROIoffset - ROIheight + 1);
    endY = height-ROIoffset;

    % Sample pixels from the defined area
    xCoords = randi([startX, endX], 1, samplePoints);
    yCoords = randi([startY, endY], 1, samplePoints);

   
    % Extract HSI values from sampled pixels
    for i = 1:samplePoints
        sampleHSI = frameHSI(yCoords(i), xCoords(i), :);
        sampledHSI(i, :) = sampleHSI(:)';
    end

    % Calculate average HSI values
    avgHSI = mean(sampledHSI, 1);

    % SegThresh the HSI image using averaged values
    SegThreshedFrame = (frameHSI(:,:,1) < avgHSI(1)*SegThresh) & ...
        (frameHSI(:,:,2) < avgHSI(2)*SegThresh);

    % Set all values in SegThreshedFrame from x=0 to width=image_width and y=0 to y=image_height/2 to 0
    SegThreshedFrame(1:floor(height * HorThresh), :) = 0;

    % Erode and dilate the binary mask to remove noise
    SegThreshedFrame = imerode(SegThreshedFrame, SE);

    % Find connected components in the binary mask
    CC = bwconncomp(SegThreshedFrame);

    % Compute properties of connected components
    stats = regionprops(CC, 'Area');

    % Find the index of the largest component
    [~, maxIndex] = max([stats.Area]);

    % Create a binary mask containing only the largest connected component
    largestComponent = false(size(SegThreshedFrame));
    largestComponent(CC.PixelIdxList{maxIndex}) = true;

    % Invert the binary mask to get the area of interest
    binaryMask = largestComponent;

    % Replicate binary mask across all color channels
    binaryMask = cat(3, binaryMask, binaryMask, binaryMask);

    % Create a copy of the original frame
    maskedFrame = frame;

    % Set pixels in the area of interest to a teal color
    maskedFrame(binaryMask) = 255; % Set teal color to maximum intensity

    % Blend original frame with the mask using transparency
    maskedFrame = uint8(opacity * double(maskedFrame) + (1 - opacity) * double(binaryMask) * 255);

    % Display the masked frame
    imshow(maskedFrame);
    title('Masked Frame');
  
    
    % Draw rectangle around the sampling area
    rectangle('Position', [startX, startY, ROIwidth, ROIheight], 'EdgeColor', 'b', 'LineWidth', 1);
    

    % Draw 'x' markers at sample points
    hold on;
    plot(xCoords, yCoords, 'bx', 'MarkerSize', 2, 'LineWidth', 1);
    hold off;
    
    % Update display
    drawnow;

end

