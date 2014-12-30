classdef Robot < hgsetget
    
    properties
        displayAxis = []
        root = [];
        links = [];
        joints = [];
        servos = [];
        
    end
    
    methods
        function AddLinks(self, links)
            assert(isa(links,'RDTools.Link') || isa(links,'RDTools.Joint'));
            self.links = union(self.links, links);
        end
        function AddJoints(self, joints)
            assert(isa(joints,'RDTools.Joint'));            
            self.joints = union(self.joints, joints);            
        end
        
        function SetRoot(self, root)
           self.root = root; 
        end
        
        function AddServos(self, servos)
           self.servos = union(self.servos, servos); 
        end
        
        function LoadToAxis(self, ax)
            assert(~isempty(self.root))
            self.displayAxis = ax;
            self.root.GenVisual(ax);  
            self.UpdateVisual();            
        end
        
        function UpdateVisual(self)
            self.root.UpdateVisual(makehgtform());
        end
    end
    
end

