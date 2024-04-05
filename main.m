%% ------------------------------------------------------------------------
%
% DESCRIPTION:
%   This script applies the contect of the lecture in
%   Automotive Sensors and Actuators (ASAA) in summer term 2024 on the
%   context of image processing and color image processing in general.
%
%
% REQUIRED FILES:
%   src/pix2world.m
%   src/world2pix.m
%   src/projection.m
%   src/roadSegmentation.m
%   src/colorSegmentation.m
%   src/objectSegmentation.m
%
% SEE ALSO:
%   openExample('driving/VisualPerceptionUsingMonoCameraExample')
%
% AUTHOR:
%   Daniel Schneider
%   University of Applied Sciences Kempten
%   daniel.schneider@hs-kempten.de
%
% CREATED:
%   02/04/2024
%
% LAST MODIFIED:
%   05/04/2024
%
% ------------------------------------------------------------------------

% Workspace preparation
close all;
clear;
clc;
addpath(genpath('./src'))

inputImage = imread('img/frame_2400.png');
inputVideo = "./video/ASAA_resized.mp4";

% Set extrinsic parameter of the camera
height      = 1.89;     % mounting height in meters from the ground
pitch       = 2;        % pitch of the camera in degrees
roll        = 4;        % roll of the camera in degrees
yaw         = -12.4;    % yaw of the camera in degrees
mounting    = [0, -0.4];

mode = 'all'; % 'calib', 'projection', 'road_segmentation', 'object_segmentation', 'all'

switch(mode)
    case 'calib'
        cameraCalibrator
    case 'projection'
        % Load calibration parameter from previous calibration session
        load("C:\Users\daniel.schneider\Documents\ADAS\camera_calib_a6\camera_4\cameraParams.mat");

        % Instanciate monocoluar camera sensor
        camIntrinsics = cameraIntrinsics(cameraParams.FocalLength, ...
            cameraParams.PrincipalPoint, cameraParams.ImageSize);

        sensor = monoCamera(camIntrinsics, ...
            height, 'SensorLocation', mounting, ...
            'Pitch', pitch, 'Roll', roll, 'Yaw', yaw);

        % Display the original image
        figure
        imshow(inputImage)
        title('Original image')

        % Point projection
        projection(undistortImage(inputImage, cameraParams), sensor, ...
            10, 0, ...
            123, 568);

    case 'road_segmentation'
        roadSegmentation(inputVideo, 12, 300, 80, 100, 1.4, 0.4)

    case 'object_segmentation'
        % Load calibration parameter from previous calibration session
        load("C:\Users\daniel.schneider\Documents\ADAS\camera_calib_a6\camera_4\cameraParams.mat");
        
        % Instanciate monocoluar camera sensor
        camIntrinsics = cameraIntrinsics(cameraParams.FocalLength, ...
            cameraParams.PrincipalPoint, cameraParams.ImageSize);

        sensor = monoCamera(camIntrinsics, ...
            height, 'SensorLocation', mounting, ...
            'Pitch', pitch, 'Roll', roll, 'Yaw', yaw);

        objectSegmentation(inputVideo, cameraParams, sensor, 120, 'csp-darknet53-coco', ...
            0, 0, ...
            0, 0, 0, 0, 0, 0); %csp-darknet53-coco

    case 'all'
        % Load calibration parameter from previous calibration session
        load("C:\Users\daniel.schneider\Documents\ADAS\camera_calib_a6\camera_4\cameraParams.mat");
        
        % Instanciate monocoluar camera sensor
        camIntrinsics = cameraIntrinsics(cameraParams.FocalLength, ...
            cameraParams.PrincipalPoint, cameraParams.ImageSize);

        sensor = monoCamera(camIntrinsics, ...
            height, 'SensorLocation', mounting, ...
            'Pitch', pitch, 'Roll', roll, 'Yaw', yaw);

        objectSegmentation(inputVideo, cameraParams, sensor, 120, 'tiny-yolov4-coco', ...
            0, 1, ...
            12, 300, 80, 100, 1.2, 0.4); %csp-darknet53-coco
end