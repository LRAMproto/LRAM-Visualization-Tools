classdef Robot < hgsetget
    
    properties
        root = [];
        links = [];
        joints = [];
    end
    
    methods
        function AddLinks(obj, links)
            obj.links = union(obj.links, links);
        end
        function AddJoints(obj, joints)
            obj.joints = union(obj.joints, joints);            
        end
        
        function SetRoot(obj, root)
           obj.root = root; 
        end
    end
    
end

