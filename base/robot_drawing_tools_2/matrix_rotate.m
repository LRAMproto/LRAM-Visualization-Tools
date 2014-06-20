function [Xnew,Ynew] = matrix_rotate(X,Y,theta,origin)
% Rotates a set of patch coordinates and returns the results

if length(origin) ~= 2
    error('Origin must be a 2-0dimensional vector of x and y.');
end

%fprintf('X origin: %f, y Origin: %f\n',origin(1),origin(2));

x = X'-origin(1);
y = Y'-origin(1);

sintheta = sin(-theta);
costheta = cos(-theta);
rot = [...
    costheta sintheta;...
    -sintheta costheta;...
    ];
dims = [x;y];
result = rot*dims;
Xnew = result(1,:)+origin(1);
Ynew = result(2,:)+origin(2);

end

