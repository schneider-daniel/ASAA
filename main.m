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

inputImage = imread('img/0001.png');
inputVideo = "./video/ASAA_2024-04-08-11-52-43_9.mp4";

% Load calibration parameter from previous calibration session
load("C:\Users\daniel.schneider\Documents\ADAS\ASAA_2024\calib\cameraParams.mat");

% Set extrinsic parameter of the camera
height      = 1.923;     % mounting height in meters from the ground
pitch       = -1.2;        % pitch of the camera in degrees
roll        = 0;        % roll of the camera in degrees
yaw         = 0;    % yaw of the camera in degrees
mounting    = [0, -0.4];

mode = 'projection'; % 'calib', 'projection', 'road_segmentation', 'object_segmentation', 'all'


switch(mode)
    case 'calib'
        cameraCalibrator

    case 'projection'
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
            794, 1186);

    case 'road_segmentation'
        roadSegmentation(inputVideo, 12, 300, 80, 850, 1.3, 0.4)

    case 'object_segmentation'
        % Create monocoluar camera sensor
        camIntrinsics = cameraIntrinsics(cameraParams.FocalLength, ...
            cameraParams.PrincipalPoint, cameraParams.ImageSize);

        sensor = monoCamera(camIntrinsics, ...
            height, 'SensorLocation', mounting, ...
            'Pitch', pitch, 'Roll', roll, 'Yaw', yaw);

        objectSegmentation(inputVideo, cameraParams, sensor, 120, 'csp-darknet53-coco', ...
            0, 0, ...
            0, 0, 0, 0, 0, 0); %csp-darknet53-coco

    case 'all'
        % Create monocoluar camera sensor
        camIntrinsics = cameraIntrinsics(cameraParams.FocalLength, ...
            cameraParams.PrincipalPoint, cameraParams.ImageSize);

        sensor = monoCamera(camIntrinsics, ...
            height, 'SensorLocation', mounting, ...
            'Pitch', pitch, 'Roll', roll, 'Yaw', yaw);

        objectSegmentation(inputVideo, cameraParams, sensor, 2, 'csp-darknet53-coco', ...
            1, 1, ...
            12, 300, 80, 850, 1.3, 0.4); %csp-darknet53-coco tiny-yolov4-coco
end