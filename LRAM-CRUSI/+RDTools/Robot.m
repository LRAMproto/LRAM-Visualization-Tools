classdef Robot < hgsetget
    
    properties
        root = [];
        links = [];
        joints = [];
    end
    
    methods
        function AddLinks(self, links)
            assert(isa(links,'RDTools.Link'));
            self.links = union(self.links, links);
        end
        function AddJoints(self, joints)
            assert(isa(joints,'RDTools.Joint'));            
            self.joints = union(self.joints, joints);            
        end
        
        function SetRoot(self, root)
           self.root = root; 
        end
        
        function LoadToAxis(self, ax)
            assert(~isempty(self.root))
            self.root.GenVisual(ax);            
        end
    end
    
end

