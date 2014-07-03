function position = maximize_second_monitor(fig)
% Maximizes a display window in a second monitor, provided that the
% monitors are aligned at the bottom edge of the screen.
%
% maximize_second_monitor(FH): attempts to move the figure with the handle
% of FH to a second connected monitor.

% Determines the boundries of the monitors on the screen
p = get(0,'monitorpositions');
% Checks to see if there is actually a second monitor connected.
if isequal(size(p),[1,4])
    error('Only one monitor detected. Please connect secnd monitor.');
end
% Calculates width and height.
[width, height] = getwh(p);
% Computes the new position to set the monitor at.
position = [p(2,1),p(1,2),width,height];
% Sets the position. If this is displaying incorrectly, try repositioning
% the monitor in your OS, then restarting MATLAB.
set(fig,'position',position);
end

function [width, height] = getwh(p)
% Calculates width and height of a monitor from its minimum and maximum
% edges.
width = p(2,3)-p(2,1)+1;
height = p(2,4)-p(2,2)+1;

    end