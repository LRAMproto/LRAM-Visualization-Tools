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
        frames = {}
        imgCount = 0;
        userData = [];
        frameRate = 30;
    end
    
    methods
        function obj = Animation(name,directory,displayFigure)
            obj.name = name;
            obj.saveDirectory = directory;
            obj.displayFigure = displayFigure;
        end
        
        function Reset(obj)
            obj.frames = [];
        end
        
        function RenderFrame(obj)
%             filename = sprintf('%s/%s%d.png',obj.saveDirectory,obj.name,obj.imgCount);
%             print(obj.displayFigure,filename,'-dpng');
            
            imgCountStr = sprintf('%d',obj.imgCount);
            filename = fullfile(obj.saveDirectory,strcat(obj.name,imgCountStr,'.svg'));
            plot2svg(filename,obj.displayFigure);
            obj.imgCount = obj.imgCount + 1;
            if ~isa(filename,'char')
                error('frame filename not captured correctly.');
            end
            obj.frames{obj.imgCount} = filename;
        end
        
        function RunUpdateFcn(obj)
            obj.updateFcn(obj,obj.imgCount+1);
        end
        
        function OutputToVideo(obj)
            
            filepath = obj.videoFile;
            vidObj = VideoWriter(filepath);
            set(vidObj,'FrameRate',obj.frameRate);
            open(vidObj);
            for k = 1:length(obj.frames)
                tempFrame = fullfile(obj.saveDirectory,'temp.jpeg');
                svg2jpg(obj.frames{k},tempFrame);
                curFrame = imread(tempFrame);
                writeVideo(vidObj,curFrame);
            end
            close(vidObj);
            
        end
        
    end
    
end

