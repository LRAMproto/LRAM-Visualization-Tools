classdef TrackingPoint < hgsetget
    % Tracks an arbitrary point in a Link, and it's relative position in
    % the world.
    
    properties
        name
        parent_link
        local_position = [0 0];
        world_position = [0 0];        
    end
    
    methods
    end
    
end

