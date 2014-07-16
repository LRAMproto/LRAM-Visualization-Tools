classdef World < hgsetget
    % A class describing an environment in which Robots are placed and
    % rendered in.
    %
    % Currently inherits from hgsetget to allow for set and get operations.
    
    properties
        %% Statically Defined Variables
        
        % Specifies name of world.        
        name = 'World'
        
        %% Runtime Defined Variables
        
        % This is an axes object that has been created before the World
        % is loaded.        
        displayAxis
        
        % all Robot objects in a simulation.
        robots
        
        % autoUpdate set to 1 to automatically update the world whenever a
        % a joint is moved. If set to zero, you must call UpdateVisual
        % manually. This might be helpful if you wanted to change a ton of
        % variables before rendering.
        autoUpdate = 1;
        
        % Debugging mode allows for specialized console messages to be
        % displayed wherever necessary.
        debugMode = 0;

        % records the amount of time it takes to update the world. Useful
        % for optimization purposes.        
        updateTimes = [];

        % Records the average time to update the world. Useful for
        % optimization purposes.        
        avgUpdateTime = 0;
        
    end
    
    methods
        function obj = World(displayAxis,robots)
            % Generates a world object given the axis, links, and joints.
            obj.displayAxis = displayAxis;
            obj.robots = robots;
        end
        
        function obj = set.robots(obj,bots)
            obj.robots = bots;
            for i=1:length(bots)
                set(bots(i),'world',obj);
            end
        end
        
        
        function MakeJointTree(obj)
            % Makes a Joint tree for use in positioning all objects.
            % (a Joint tree is just a set of joint objects connected in a
            % hierarchical fashion, so that each joint can potentially have
            % a parent joint).
            
            % Tells robots to connect all joints.
            for i = 1:length(obj.robots)
                obj.robots(i).MakeJointTree();
            end
        end
        
        function LinkObjects(obj)
            % links runtime Link objects to runtime Joint objects
            
            % Tells robots to link all objects together.
            for i = 1:length(obj.robots)
                obj.robots(i).LinkObjects();
                for j=1:length(obj.robots(i).links)
                    set(obj.robots(i).links(j),'world',obj);
                end
                
                for k=1:length(obj.robots(i).joints)
                    set(obj.robots(i).joints(k),'world',obj);
                end
            end
            
        end
        
        function UpdateVisual(obj)
            % Updates the visual simulation.
            if obj.debugMode == 1
                tic
            end
            
            for i = 1:length(obj.robots)
                obj.robots(i).UpdateVisual();
            end

            if obj.debugMode == 1
                updateTime = toc;
                obj.updateTimes = [obj.updateTimes,updateTime];
                obj.avgUpdateTime = ...
                    sum(obj.updateTimes) / length(obj.updateTimes);
            end            
            
        end
        
        function LoadAll(obj)
            % Loads all runtime world variables.
            
            % Link all Objects Together
            obj.LinkObjects();
            
            % Establishes a Joint Tree for use of rendering everything in
            % the correct order
            obj.MakeJointTree();
            
            % Loads the visual aspect of the simulation. Note that this
            % step positions all visual objects at the origin; UpdateVisual
            % is responsible for putting everything back where it needs to
            % be.
            for i = 1:length(obj.robots)
                obj.robots(i).LoadAll();
            end
            
            obj.UpdateVisual();
        end
        %% Display Functions
        function DisplayJoints(obj)
            % Displays information on all joint objects within a world.
            for i=1:length(obj.robots)
                obj.robots(i).DisplayJoints();
            end
        end
        function DisplayLinks(obj)
            % Displays information on all link objects within a world.
            for i=1:length(obj.robots)
                obj.robots(i).DisplayLinks();
            end            
        end
    	function DisplayAll(obj)
            % Displays information on all objects.
            obj.DisplayLinks;
            obj.DisplayJoints;
        end
    end
end

