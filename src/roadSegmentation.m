function roadSegmentation(videoFile, samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh)

videoObj = VideoReader(videoFile);

% samplePoints: Samples taken to generate color pattern
% ROIwidth: Width of the area to take color pattern
% ROIheight: Height of the area to take color pattern
% ROIoffset: Offset from image bottom to place the area
% SegThresh: Segmentation SegThresh
% HorThresh: Set the horizontal SegThresh to ignore the sky

% Loop over each frame in the video
while hasFrame(videoObj)
    colorSegmentation(readFrame(videoObj), samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh);
end


end

