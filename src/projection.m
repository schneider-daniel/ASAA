function projection(image, sensor, world_x, world_y, u_, v_)

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
displayText = sprintf('(%.2f m, %.2f m)', [world_X, world_Y]);
Pix2WorldImg = insertText(Pix2WorldImg, [u_ v_] + 5,displayText);
% Display the image
figure
imshow(Pix2WorldImg)
title('Pixel 2 World projection')

end

