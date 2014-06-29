classdef TrackingPoint < hgsetget
    % Tracks an arbitrary point in a Link, and it's relative position in
    % the world.
    
    properties
        name
        parentLink
        localPosition = [0 0];
        worldPosition = [0 0];        
    end
    
    methods
    end
    
end

