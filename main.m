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
%   04/04/2024
%
% ------------------------------------------------------------------------

% Workspace preparation
close all; 
clear; 
clc; 
addpath(genpath('./src'))

%% ------------------------------------------------------------------------
% Part 1: Camera calibration
% ------------------------------------------------------------------------
%cameraCalibrator
load("calib\cameraParams.mat");


% Extrinsic parameter
height         = 0.94;    % mounting height in meters from the ground
pitch          = -2;      % pitch of the camera in degrees
roll           = 4;       % roll of the camera in degrees
yaw            = 0;       % yaw of the camera in degrees

% Instanciate monocoluar camera sensor
camIntrinsics = cameraIntrinsics(cameraParams.FocalLength, ...
                                 cameraParams.PrincipalPoint, ...
                                 cameraParams.ImageSize);

sensor        = monoCamera(camIntrinsics, ...
                           height, ...
                           'Pitch', pitch, ...
                           'Roll', roll, ...
                           'Yaw', yaw);

% Read image and display the original
img = imread('img/0001.png');

figure;
imshow(img);
title('Original image')


%% ------------------------- world2pix -----------------------------------
% Projection of a given point in world coordinates (X,Y,0) into 
% pixel coordinates (u,v)

WorldDistance = [2.5 -0.25];
% Projection
[u, v] = world2pix(WorldDistance(1), WorldDistance(2), sensor);
% Draw the projected pixels on the image
distanceString = sprintf('X: %.1f meters, Y: %.1f meters', WorldDistance);
Wordl2PixImg = insertMarker(img, [u, v]);
Wordl2PixImg = insertText(Wordl2PixImg, [u, v] + 5,distanceString);
% Display the image
figure
imshow(Wordl2PixImg)
title('World 2 Pixel projection')

%% ------------------------- pix2world -----------------------------------
% Projection of a pixel coordinate (u,v) into 
% world coordinates (X,Y,0)

ObjectPixel = [1280 1639];
% Projection
[world_X, world_Y] = pix2world(ObjectPixel(1), ObjectPixel(2), sensor);
% Draw the given pixels on the image and augment it with world distance
Pix2WorldImg = insertMarker(img, ObjectPixel);
displayText = sprintf('(%.2f m, %.2f m)', [world_X, world_Y]);
Pix2WorldImg = insertText(Pix2WorldImg, ObjectPixel + 5,displayText);
% Display the image
figure
imshow(Pix2WorldImg)
title('Pixel 2 World projection')
