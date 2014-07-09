classdef Animation < hgsetget
    %ANIMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        recorder;
        saveDirectory = '';
        videoFile = 'untitled.avi';
        displayFigure;
        updateFcn;
        frames = []
        imgCount = 0;
    end
    
    methods
        function obj = Animation(name,directory,displayFigure)
            obj.name = name;
            obj.saveDirectory = directory;
            obj.displayFigure = displayFigure;
        end
        
        function RenderFrame(obj)
            filename = sprintf('%s/%s%d.png',obj.saveDirectory,obj.name,obj.imgCount);
            print(obj.displayFigure,filename,'-dpng');            
            obj.imgCount = obj.imgCount + 1;
        end
        
        function RunUpdateFcn(obj)
            obj.updateFcn();
        end
        
        function OutputToVideo(obj)
            vidObj = VideoWriter([savedirectory,savefile]);
            open(vidObj);
            
            
        end
        
    end
    
end

