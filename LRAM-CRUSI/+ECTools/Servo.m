classdef Servo < hgsetget

    properties
        joint = [];
        voltage = 0;
        position = 0;
        velocity = 0;
        
        voltageUF = [];
        positionUF = [];
        velocityUF = [];
        
        voltageMF = [];
        positionMF = [];
        velocityMF = [];
        
    end
    
    methods
        function self = Servo(joint)
            self.joint = joint;
        end
        
        function UpdateParam(self, param, val)
            switch(param)
                case 'position'
                    self.position = val;
                    if ~isempty(self.positionUF)
                    self.positionUF(self, val);      
                    end
            end
            
            
        end
        
        function val = Measure(self, param)
            switch(param)
                case 'position'
                    if ~isempty(self.positionMF)
                    val = self.positionMF(self);
                    else
                        val = 0;
                    end
                    %TODO: Add Extra Parameters to Measure
            end
        end
        
        function RegMeasureFcn(self, fcnName, fcn)
            switch (fcnName)
                case 'voltage'
                    self.voltageMF = fcn;
                case 'position'
                    self.positionMF = fcn;
                case 'velocityMF'
                    self.velocityMF = fcn;
                otherwise
                    error(['parameter not recognized']);
            end
        end
        
        function RegUpdateFcn(self, fcnName, fcn)
            switch (fcnName)
                case 'voltage'
                    self.voltageUF = fcn;
                case 'position'
                    self.positionUF = fcn;
                case 'velocityMF'
                    self.velocityUF = fcn;
                otherwise
                    error(['parameter not recognized']);
            end
        end               
        
    end
    
    
end

