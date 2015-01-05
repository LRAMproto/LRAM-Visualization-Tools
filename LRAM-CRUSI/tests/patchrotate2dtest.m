function data = patchrotate2dtest()
data.origin = [0 1 0];
data.originRotate = [0 0 0];
data.pivotPoint = [0 5 0];
data.xrotate = 0;
data.yrotate = 0;
data.zrotate = deg2rad(25);
data.hasChanged = true;

sf = .50;
w = 1024*sf;
h = 1024*sf;

fig = figure('position',[0 0 w h]);
ax = axes('parent',fig,...
    'xlim',[-10 10],...
    'ylim',[-10 10],...
    'xlimmode','manual',...
    'ylimmode','manual'...
    );
data.xdata = [-1 1 1 -1]*.5;
data.ydata = [-1 -1 1 1]*5;

origpat = patch('parent',ax,...
    'xdata',data.xdata,...'
    'ydata',data.ydata,...
    'facecolor',[1 0 0]);

pat = patch('parent',ax,...
    'xdata',...
    data.xdata,...
    'ydata',...
    data.ydata...
    );

data = ApplyPatchTForm(pat,data);
data = ApplyPatchTForm(pat,data);
data.zrotate = deg2rad(15);
data.hasChanged = true;
data = ApplyPatchTForm(pat,data);

end

function data = ApplyPatchTForm(pat,data)
if data.hasChanged
    fprintf('... Update...\n');
    points = [];
    
    for k=1:length(data.xdata)
        points = [points; [data.xdata(k),data.ydata(k)]];
    end
    TOriginR = makehgtform('zrotate',data.originRotate(3));
    TOrigin = makehgtform('translate',data.origin);
    R = makehgtform('zrotate',data.zrotate);
    T = makehgtform('translate',data.pivotPoint);
    M = T * R * inv(T) * TOrigin * TOriginR;
    
    newxdata = [];
    newydata = [];
    
    for k=1:size(points,1)
        newPoint = M * [points(k,1:2) 0 1]';
        newPoint = newPoint';
        newxdata = [newxdata, newPoint(1)];
        newydata = [newydata, newPoint(2)];
    end
    
    set(pat,'xdata',newxdata,'ydata',newydata)
    data.hasChanged = false;
else
   fprintf('... Not Updated...\n');
end

end

