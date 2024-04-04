function [u, v] = world2pix(x, y, monoCam)
%WORLD2PIX Converts world coordinates to pixel coordinates using a monocular camera model.
%
%   [u, v] = WORLD2PIX(x, y, monoCam) converts the given world coordinates (x, y)
%   to pixel coordinates (u, v) using the monocular camera model specified by monoCam.
%
%   Inputs:
%   - x: X-coordinate in world space.
%   - y: Y-coordinate in world space.
%   - monoCam: Monocular camera object containing camera parameters.
%
%   Outputs:
%   - u: Horizontal pixel coordinate.
%   - v: Vertical pixel coordinate.
%
%   Example:
%   [u, v] = world2pix(x, y, monoCam);
%
%   See also: vehicleToImage

% Compute pixel coordinates using vehicleToImage function
pix = vehicleToImage(monoCam, [x, y]);

% Extract u and v from the pixel coordinates
u = pix(1);
v = pix(2);
end


