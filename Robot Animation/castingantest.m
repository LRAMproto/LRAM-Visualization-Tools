function castingantest
previous = pwd;
cd(fileparts(mfilename('fullpath')))
frame_info = castingantest_create_elements();
frame_gen_function...
    = @(frame_info,tau) frameUpdateFcn(frame_info, tau);

% Declare timing
timing.duration = 3; % three second animation
timing.fps = 45;     % create frames for 30 fps animation
timing.pacing = @(y) cosspace(0,1,y); % Use a soft start and end, using the included softstart function
destination = 'casting animation';

[frame_info, endframe] = ...
    animation(frame_gen_function,frame_info,timing,destination,1,0);
if isfield(frame_info,'frames')
    if ~isempty(frame_info.frames)
    fmt = 'png';
    frame_info.frames = render_batch_svg(frame_info.frames,'format',fmt,'reference figure',frame_info.f,'num_workers',2, 'keep original',false,'width',1200);
    end
end
    outfiles = frame_info.frames;
        videoObj = VideoWriter('CastingDemo.avi');
        set(videoObj,'FrameRate',timing.fps);
        open(videoObj);
        wb = waitbar(0,'Rendering Video');
        for k=1:length(outfiles)
            currFrame = imread(outfiles{k});
            writeVideo(videoObj, currFrame);
            waitbar(k/length(outfiles),wb,'Rendering Frames');
        end
        delete(wb);
        close(videoObj);
        
  cd(previous);
end

function frame_info = frameUpdateFcn(frame_info, tau)
    frame_info.arm_joint.Rotate(1*pi*tau)
    frame_info.world.UpdateVisual();
    frame_info.printmethod = @(dest)frame_print(frame_info.f,'destination',dest,'format','SVG');
%    frame_info.printmethod = @(dest) print(frame_info.f,'-dpng','-r 150','-painters',dest);

end

function frame_info = castingantest_create_elements()
frame_info.ph = caster_startup_debug_display_only;

% Finds Arm joint for fast modification
frame_info.world = frame_info.ph.core.settings.world;

frame_info.ax = frame_info.world.displayAxis;
frame_info.f = get(frame_info.world.displayAxis,'Parent');

set(frame_info.world.displayAxis,'XLim',[-0.5 1],'YLim',[.75, 1.75]);
frame_info.arm_joint = findobj(frame_info.ph.core.settings.CastingRobot.joints,'name','Arm Joint');

if (isempty(frame_info.arm_joint))
    error('Cant find arm joint.');
end
    
end
