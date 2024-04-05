function objectSegmentation(videoFile, cameraParams, sensor, everyImg, model, ...
    saveImg, roadSeg, ...
    samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh)

detector = yolov4ObjectDetector(model); % csp-darknet53-coco tiny-yolov4-coco
outputFolder = './img/detections/';

vidObj = VideoReader(videoFile);
numFrames = vidObj.NumFrames;

for frameIndex = 1:everyImg:numFrames
    frame = read(vidObj, frameIndex);

    % Undistort the frame
    frame = undistortImage(frame, cameraParams);
    [bboxes,scores,labels] = detect(detector, frame);

    locations = computeVehicleLocations(bboxes, sensor);

    for i = 1:size(locations, 1)
        location = locations(i, :);
        class = labels(i, :);
        score = scores(i, :);
        bbox = bboxes(i, :);

        label = sprintf('X=%0.2f, Y=%0.2f, %0.2f%%, %s', ...
            location(1), location(2),score*100,  class);

        frame = insertObjectAnnotation(frame, ...
            'rectangle', bbox, label, 'AnnotationColor','red');
    end

    % roadSegmentation
    if roadSeg == 1
        frame = colorSegmentation(frame, samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh); 
    end

    imshow(frame);
    if saveImg == 1
        outputFilename = sprintf('%s%06d.png', outputFolder, frameIndex);
        imwrite(frame, outputFilename);
    end
end


end

