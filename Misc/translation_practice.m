function translation_practice()


handles.fig = figure(...
    'Name','Translation Tests',...
    'Units','Pixels',...
    'Position',[0 0 600 600]);
handles.ax = axes(...
    'parent',handles.fig,...
    'Units','Pixels',...
    'XLim',[-10 10],...
    'YLim',[-10 10],...
    'XLimMode','Manual',...
    'YLimMode','Manual',...
    'Position',[50 50 500 500]);
guidata(handles.fig, handles);

theta = pi/3;

disp('Parent:');
% Parent joint, root, attached to world.
Lparent = eye(4,4);
Lparent(1,1) = cos(theta);
Lparent(1,2) = sin(theta);
Lparent(2,1) = -sin(theta);
Lparent(2,2) = cos(theta);

Wparent = Lparent*eye(4,4);

theta = -pi/1.5;

disp('Joint:');
% Main joint, world;
Ljoint = eye(4,4);
Ljoint(1,1) = cos(theta);
Ljoint(1,2) = sin(theta);
Ljoint(2,1) = -sin(theta);
Ljoint(2,2) = cos(theta);

% sets pivot point
Ljoint(4,1)=4;

Wjoint = Ljoint*Wparent;

theta = pi/1.5;

disp('Child:');
% Child joint
Lchild = eye(4,4);

Lchild(1,1) = cos(theta);
Lchild(1,2) = sin(theta);
Lchild(2,1) = -sin(theta);
Lchild(2,2) = cos(theta);

% sets pivot point x position
Lchild(4,1)=4;

Wchild = Lchild* Wjoint;


p1 = [0, 0, 0, 1] * Wparent;
p2 = [4, 0, 0, 1] * Wparent;

line([p1(1),p2(1)],[p1(2),p2(2)],'color','red','linewidth',10);

p1 = [0, 0, 0, 1] * Wjoint;
p2 = [4, 0, 0, 1] * Wjoint;

line([p1(1),p2(1)],[p1(2),p2(2)],'color','blue','linewidth',5);

p1 = [0, 0, 0, 1] * Wchild;
p2 = [4, 0, 0, 1] * Wchild;

line([p1(1),p2(1)],[p1(2),p2(2)],'color','green','linewidth',2.5);



set(handles.fig,'ResizeFcn',@figureResize);    

end

function figureResize(fig, eventdata)
    handles = guidata(fig);
    windowPos = get(handles.fig,'Position');
    set(handles.fig,'Position',[windowPos(1), windowPos(2), windowPos(4), windowPos(4)]);
    windowPos = get(handles.fig,'Position');    
    set(handles.ax,'Position',[50,50,windowPos(4)-100,windowPos(4)-100]);
end

