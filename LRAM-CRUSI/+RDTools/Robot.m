classdef Robot < hgsetget
    
    properties
        displayAxis = []
        root = [];
        links = [];
        joints = [];
        servos = [];
        linkMap = containers.Map();
        jointMap = containers.Map();

    end
    
    methods
        function AddLinks(self, links)
            assert(isa(links,'RDTools.Link') || isa(links,'RDTools.Joint'));
            self.links = union(self.links, links);
            for k=1:length(self.links)
                self.linkMap(self.links(k).name) = self.links(k);
            end            
        end
        
        function AddJoints(self, joints)
            assert(isa(joints,'RDTools.Joint'));            
            self.joints = union(self.joints, joints);
            
            for k=1:length(self.joints)
                self.jointMap(self.joints(k).name) = self.joints(k);
            end                       
            
        end
        
        function ConnectObjects(self)
            for k=1:length(self.joints)
                plink = self.linkMap(self.joints(k).parentLink);
                clink = self.linkMap(self.joints(k).childLink);
                self.joints(k).parentLink = plink;
                self.joints(k).childLink = clink;
            end
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

