function objectSegmentation(videoFile, cameraParams, sensor, everyImg, model, ...
    saveImg, roadSeg, ...
    samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh)
% OBJECTSEGMENTATION Performs object detection and segmentation on a video file.
%
%   OBJECTSEGMENTATION(VIDEOFILE, CAMERAPARAMS, SENSOR, EVERYIMG, MODEL, ...
%       SAVEIMG, ROADSEG, SAMPLEPOINTS, ROIWIDTH, ROIHEIGHT, ROIOFFSET, SEGTHRESH, HORTHRESH)
%   reads frames from the video file VIDEOFILE, performs object detection
%   using YOLOv4 model specified by MODEL, computes locations of detected
%   objects in the world coordinate system using SENSOR parameters, and
%   optionally performs road segmentation. It saves annotated frames as images
%   and displays them if SAVEIMG is set to 1.
%
%   Parameters:
%   - VIDEOFILE: Path to the input video file.
%   - CAMERAPARAMS: Camera parameters for undistorting the frame.
%   - SENSOR: Sensor parameters used to compute object locations.
%   - EVERYIMG: Interval for processing frames (e.g., every 10th frame).
%   - MODEL: YOLOv4 model for object detection (e.g., 'csp-darknet53-coco').
%   - SAVEIMG: Flag to indicate whether to save annotated frames (0 or 1).
%   - ROADSEG: Flag to indicate whether to perform road segmentation (0 or 1).
%   - SAMPLEPOINTS: Number of sample points for color pattern generation.
%   - ROIWIDTH: Width of the region of interest (ROI) for sampling.
%   - ROIHEIGHT: Height of the region of interest (ROI) for sampling.
%   - ROIOFFSET: Vertical offset from the bottom of the frame to place the ROI.
%   - SEGTHRESH: Segmentation threshold for HSI image.
%   - HORTHRESH: Horizontal threshold to ignore the sky.
%
detector = yolov4ObjectDetector(model); % csp-darknet53-coco tiny-yolov4-coco
outputFolder = './img/detections/';

vidObj = VideoReader(videoFile);
numFrames = vidObj.NumFrames;

for frameIndex = 1:everyImg:numFrames
    frame = read(vidObj, frameIndex);

    % Undistort the frame
    frame = undistortImage(frame, cameraParams);

    % Reduce the search space
    top_offset = 1000; % Distance from the top of the frame
    bottom_offset = 400; % Distance from the bottom of the frame

    roi_height = size(frame, 1) - top_offset - bottom_offset;
    roi_width = size(frame, 2);
    roi = [0, top_offset, roi_width, roi_height];
    
    % Crop the frame to the ROI
    roi_frame = imcrop(frame, roi);
 
    % Perform object detection within the ROI
    [bboxes, scores, labels] = detect(detector, roi_frame);
    
    % Adjust bounding box coordinates to match original frame coordinates
    bboxes(:, 2) = bboxes(:, 2) + top_offset; % Adjust x-coordinate

    %[bboxes,scores,labels] = detect(detector, frame);
    locations = computeVehicleLocations(bboxes, sensor);

    % roadSegmentation
    if roadSeg == 1
        frame = colorSegmentation(frame, samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh);
    end
    
    for i = 1:size(locations, 1)
        location = locations(i, :);
        class = labels(i, :);
        score = scores(i, :);
        bbox = bboxes(i, :);

        label = sprintf('X=%0.2f, Y=%0.2f, %0.2f%%, %s', location(1), location(2),score*100, class);
        frame = insertObjectAnnotation(frame, 'rectangle', bbox, label, 'AnnotationColor','red');
    end

    imshow(frame);
    if saveImg == 1
        outputFilename = sprintf('%s%06d.png', outputFolder, frameIndex);
        imwrite(frame, outputFilename);
    end
end


end

