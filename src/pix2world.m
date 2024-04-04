function [X, Y] = pix2world(u, v, monoCam)
%PIX2WORLD Converts pixel coordinates to world coordinates using a monocular camera model.
%
%   [X, Y] = PIX2WORLD(u, v, monoCam) converts the given pixel coordinates (u, v)
%   to world coordinates (X, Y) using the monocular camera model specified by monoCam.
%
%   Inputs:
%   - u: Horizontal pixel coordinate.
%   - v: Vertical pixel coordinate.
%   - monoCam: Monocular camera object containing camera parameters.
%
%   Outputs:
%   - X: X-coordinate in world space.
%   - Y: Y-coordinate in world space.
%
%   Example:
%   [X, Y] = pix2world(u, v, monoCam);
%
%   See also: imageToVehicle

% Compute world coordinates using imageToVehicle function
world = imageToVehicle(monoCam, [u, v]);

% Extract X and Y from the world coordinates
X = world(1);
Y = world(2);
end
