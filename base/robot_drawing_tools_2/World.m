classdef World
% A Class describing the world in which everything exists.
    
    properties
        name = 'World'
        ax
        joints
        links
    end
    
    methods
        function obj = World(ax,links,joints)
            % Generates a world object given the axis, links, and joints.
            obj.ax = ax;
            obj.links = links;
            obj.joints = joints;
        end
        function MakeJointTree(obj)
            % Makes a Joint Tree for use in positioning all objects.
            for i = 1:length(obj.joints)
                for j = 1:length(obj.joints)
                    if strcmp(obj.joints(j).child,obj.joints(i).parent)
                        obj.joints(i).parentjoint = obj.joints(j);
                    end
                end                
            end
            
        end
        
        function LinkObjects(obj)
            % links runtime Link objects to runtime Joint objects
            for i = 1:length(obj.joints)
                parent_found = 0;
                child_found = 0;
                for j = 1:length(obj.links)
                    if strcmp(obj.links(j).name, obj.joints(i).parent)
                        parent_found = 1;
                        obj.joints(i).parentdata = obj.links(j);
                    end
                    if strcmp(obj.links(j).name, obj.joints(i).child)
                        child_found = 1;
                        obj.joints(i).childdata = obj.links(j);
                    end
                    if parent_found == 1 && child_found == 1
                        break;
                    end
                end
                if parent_found == 0
                    disp('Check Parent Links for ');
                    disp(obj.joints(i));
                    error('Parent Link Not Found');
                end
                if child_found == 0
                    disp('Check Child Links for ');
                    disp(obj.joints(i));
                    error('Child Link Not Found');
                end
            end

        end

        function UpdateVisual(obj)
            for i = 1:length(obj.joints)
                child = obj.joints(i).childdata;
                xdata = child.vertices.xdata;
                ydata = child.vertices.ydata;
                
                [xdata,ydata] = matrix_rotate(xdata,ydata,child.origin_angle,child.origin_angle_pivot_point);
                xdata = xdata + child.origin(1);
                ydata = ydata + child.origin(2);
                
                cj = obj.joints(i);

                while ~isempty(cj)
                    [xdata,ydata] = matrix_rotate(xdata',ydata',cj.angle,cj.pivot_point);
                     xdata = xdata + cj.origin(1);
                     ydata = ydata + cj.origin(2);
                     xdata = xdata + cj.position(1);
                     ydata = ydata + cj.position(2);
%                      xdata = xdata+cj.parentdata.origin(1);
%                      ydata = ydata+cj.parentdata.origin(2);
                    cj = cj.parentjoint;
                end
                
                set(child.visual,'XData',xdata,'YData',ydata);
            end
        end
        
        function LoadAll(obj)
            % Link all Objects Together
            obj.LinkObjects();
            % Establishes a Joint Tree for use of rendering everything in
            % the correct order
            obj.MakeJointTree();
            % Loads the Simulation
                       
            for i = 1:length(obj.links)
                obj.links(i).GeneratePoints;
                patchdata = patch(...
                    'Parent',obj.ax,...
                    'XData',obj.links(i).vertices.xdata+obj.links(i).origin(1),...
                    'YData',obj.links(i).vertices.ydata+obj.links(i).origin(2),...
                    'EdgeAlpha',0,...
                    'FaceColor',obj.links(i).fillcolor);
                set(obj.links(i),'visual',patchdata);
            end        
            obj.UpdateVisual();                            
        end
%% Display Functions        
        function DisplayJoints(obj)
            disp('Joints:');
            for i = 1:length(obj.joints)
                disp(obj.joints(i));
            end
        end
        
        function DisplayLinks(obj)
            disp('Links:');
            for i = 1:length(obj.links)
                disp(obj.links(i));
            end
        end
        
        function DisplayAll(obj)
            obj.DisplayLinks;
            obj.DisplayJoints;
        end
    end
end

