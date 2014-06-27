function [Xnew,Ynew] = matrix_rotate(X,Y,theta,origin)
% Rotates a set of patch coordinates and returns the results
% X: Matrix representing X Data

% TODO: Decide: should I package the results of this into a struct?
% FIXME: Modify translation to accept multiple-column patch coordinate data.

if length(origin) ~= 2
    error('Origin must be a 2-0dimensional vector of x and y.');
end

% FIXME: Modify Matrix rotation so that a rotation can be applied to
% itself.

x = X'-origin(1);
y = Y'-origin(1);

% FIXME: Check if rotation matrix is accurate.
sintheta = sin(-theta);
costheta = cos(-theta);
rot = [...
    costheta sintheta;...
    -sintheta costheta;...
    ];
dims = [x;y];
result = rot*dims;

Xnew = (result(1,:)+origin(1))';
Ynew = (result(2,:)+origin(2))';

end

