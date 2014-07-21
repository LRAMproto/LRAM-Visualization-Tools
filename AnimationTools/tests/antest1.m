function antest1()
handles.fig = figure('Units','Pixels');
handles.ax = axes('Units','Pixels');
fpos = [0 0 800 600];
axwidth = fpos(3)*.95;
apos = [(fpos(3)-axwidth)/2 (fpos(4)-axwidth)/2 axwidth axwidth];
set(handles.fig,...
    'Units','Pixels',...
    'Position',fpos);
set(handles.ax,...
    'XLim',[-10 10],...
    'YLim',[-10 10],...
    'XLimMode','Manual',...
    'YLimMode','Manual',...
    'Units','Pixels',...
    'Position',apos);

handles.A = Link();
set(handles.A,...
    'name','handles.A',...
    'type','Rectangle',...
    'width',1,...
    'height',2,...
    'fillColor',[0.5 0.5 1]);
handles.B = Link();
set(handles.B,...
    'name','B',...
    'type','Rectangle',...
    'width',3,...
    'height',0.5,...
    'fillColor',[0. 0.5 1]);
handles.atb = Joint();
set(handles.atb,...
    'name','handles.A to B',...
    'type','Revolute',...
    'parent','handles.A',...
    'child','B',...
    'origin',[0 0]);

handles.links = [handles.A handles.B];
handles.joints = [handles.atb];

handles.testbot = Robot('TestBot',handles.links,handles.joints);

handles.w = World(handles.ax,handles.testbot);
handles.w.LoadAll();

guidata(handles.fig, handles);

previous = pwd;
filepath = fileparts(mfilename('fullpath'));
cd(filepath);
cd('frames');
cd('antest1');
fprintf('Filepath set to %s\n',pwd);


fprintf('Beginning Rendering\n');


an = Animation('AnTest',pwd, handles.fig);
set(an,'videoFile','AnTest.avi','updateFcn',@frameUpdateFcn);
for i=1:100
    an.RunUpdateFcn();
    an.RenderFrame();
end
fprintf('Rendering finished.\n');
an.OutputToVideo();

cd(previous);
end


function frameUpdateFcn(animation, frameNo)
    handles = guidata(animation.displayFigure);
    handles.atb.Rotate(2*pi*(frameNo-1)/100);
end