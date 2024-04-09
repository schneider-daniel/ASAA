function roadSegmentation(videoFile, samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh)
% ROADSEGMENTATION Performs road segmentation on a video file.
%
%   ROADSEGMENTATION(VIDEOFILE, SAMPLEPOINTS, ROIWIDTH, ROIHEIGHT, ROIOFFSET, SEGTHRESH, HORTHRESH)
%   reads frames from the video file VIDEOFILE and performs road segmentation
%   using colorSegmentation function with the specified parameters.
%
%   Parameters:
%   - VIDEOFILE: Path to the input video file.
%   - SAMPLEPOINTS: Samples taken to generate color pattern.
%   - ROIWIDTH: Width of the area to take color pattern.
%   - ROIHEIGHT: Height of the area to take color pattern.
%   - ROIOFFSET: Offset from the image bottom to place the area.
%   - SEGTHRESH: Segmentation threshold.
%   - HORTHRESH: Horizontal threshold to ignore the sky.
%
%   Example:
%   roadSegmentation('example_video.mp4', 100, 50, 50, 20, 0.5, 0.3)
%
%   See also: COLORSEGMENTATION

videoObj = VideoReader(videoFile);

% Loop over each frame in the video
while hasFrame(videoObj)
    frame = colorSegmentation(readFrame(videoObj), samplePoints, ROIwidth, ROIheight, ROIoffset, SegThresh, HorThresh);

    imshow(frame);
    title('Masked Frame');
end


end

