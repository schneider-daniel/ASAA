# Illumination-invariant image processing
This repository provides a Matlab-based software project that will be used in the course "Illumination-invariant image processing" in the course ***"Automotive Sensors and Actuators (ASAA)"*** in the summer semester 2024. 

The provided software can be used to address robust (with respect to different lighting situations) segmentation, e.g. to identify a potentially drivable area in front of a car. Furthermore, we demonstrate the application of the pinhole camera model to determine the distance of an object identified (using YOLOV4/Darknet) in front of the camera. Assuming that the object fits in the ground plane (Z=0), we can estimate the distance (X, Y) of the object (from pixel) with a monocular camera system. 


<div style="text-align:center">
    <img src="doc/segmentation_1.png">
</div>

## Color space converstion
TODO
## Road segmentation flow

<div style="text-align:center">
    <img src="doc/principle_flow-road_segmentation.png">
</div>

## Color pattern
TODO
## Probability-based color segmentation
TODO
## Software requirements
All functions are tested on Matlab 2024a. 

## Literature
- [Rotaru et al.](https://link.springer.com/article/10.1007/s11554-008-0078-9)
- [Sotelo et al.](https://link.springer.com/article/10.1023/B:AURO.0000008673.96984.28)