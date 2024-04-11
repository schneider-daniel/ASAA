
%% ------------------------------------------------------------------------
%
% DESCRIPTION:
%   This script applies the contect of the lecture in
%   Automotive Sensors and Actuators (ASAA) in summer term 2024 on the
%   context of image processing and color image processing in general. With
%   this script, a color model is created from couple of batches. The
%   determined color model is than applied on an example image.
%
%
% REQUIRED FILES:
%   src/colormodel.m
%   src/probSeg.m
%
% AUTHOR:
%   Daniel Schneider
%   University of Applied Sciences Kempten
%   daniel.schneider@hs-kempten.de
%
% CREATED:
%   11/04/2024
%
% LAST MODIFIED:
%   11/04/2024
%
% ------------------------------------------------------------------------

close all;
clear;
clc;
addpath(genpath('./src'))

mode = 'generate_colormodel'; % generate_colormodel, apply_colormodel

switch(mode)
    case 'generate_colormodel'
        colormodel('./img/color_pattern');

    case 'apply_colormodel'
        img = imread('./color_model/to_process.PNG');
        cm = imread('./color_model/cm_red.png');

        probSeg(img, cm, 1, 1);
end
