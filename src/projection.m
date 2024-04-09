function projection(image, sensor, world_x, world_y, u_, v_)
% PROJECTION Performs world-to-pixel and pixel-to-world projections and visualizes the results.
%
%   PROJECTION(IMAGE, SENSOR, WORLD_X, WORLD_Y, U_, V_) performs world-to-pixel
%   and pixel-to-world projections using the provided sensor parameters. It
%   visualizes the projected pixels on the input image and displays the results.
%
%   Parameters:
%   - IMAGE: Input image for visualization.
%   - SENSOR: Sensor parameters for the projection.
%   - WORLD_X: X-coordinate in the world coordinate system.
%   - WORLD_Y: Y-coordinate in the world coordinate system.
%   - U_: Pixel coordinate in the image (u-coordinate).
%   - V_: Pixel coordinate in the image (v-coordinate).

[u, v] = world2pix(world_x, world_y, sensor);

% Draw the projected pixels on the image
distanceString = sprintf('X: %.1f meters, Y: %.1f meters', [world_x world_y]);
Wordl2PixImg = insertMarker(image, [u, v]);
Wordl2PixImg = insertText(Wordl2PixImg, [u, v] + 5,distanceString);

% Display the image
figure
imshow(Wordl2PixImg)
title('World 2 Pixel projection')

% Projection
[world_X, world_Y] = pix2world(u_, v_, sensor);
% Draw the given pixels on the image and augment it with world distance
Pix2WorldImg = insertMarker(image, [u_ v_]);
Pix2WorldImg = insertText(Pix2WorldImg, [u_ v_] + 5, ...
    sprintf('(%.2f m, %.2f m)', [world_X, world_Y]));

% Display the image
figure
imshow(Pix2WorldImg)
title('Pixel 2 World projection')

end

