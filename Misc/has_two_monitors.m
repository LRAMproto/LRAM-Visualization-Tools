function result = has_two_monitors()
% Determines whether your current MATLAB installation has two monitors set
% up. This has some issues in the Unix verson of MATLAB.

result = isequal(size(get(0,'monitorpositions')),[2,4]);

end

