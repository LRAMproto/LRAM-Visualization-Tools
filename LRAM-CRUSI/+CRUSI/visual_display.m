% CRUSI.visual_display()
% * Visual part of the display. Updates the display based upon what has
%   been loaded into the program.
function visual_display(plugin)
fig = init(plugin);

end

% Initializes the visual display.
function fig = init(plugin)

fig = figure();
GenHandles(fig, plugin);
if has_two_monitors()
    maximize_second_monitor(fig);
end
set(plugin, 'postUpdateFcn',@display);

end

% Updates the visual display.
function display(core, eventdata, plugin)
disp('display update called');
core.settings.robot.UpdateVisual();
end

% Generates handles for the figure on startup.
function GenHandles(fig, plugin)
h.w = 800;
h.h = 500;
h.ax_height_pct = .90;
h.ar = h.w/h.h;

set(fig, ...
...%    'menubar','none',...
    'name','Visual Display',...
    'position',[50 50 h.w h.h],...
    'color',[0.35 0.35 0.5],...
    'resizefcn', @reshape);

h.ax = axes('parent',fig);

set(h.ax,...
    'xlim',[-.5 3.5]*.95,...
    'ylim',[0 4]*.95,...
    'visible','off',...
    'xlimmode','manual',...
    'ylimmode','manual');

plugin.core.settings.robot.LoadToAxis(h.ax);

guidata(fig, h);
end

% Changes how the visual display looks when it is resized.

function reshape(fig, eventdata)
h = guidata(fig);
if ~isempty(h)
    % One has to check that this is empty because it runs on
    % initialization.
    wPosition = get(fig, 'position');
    h.w = wPosition(3);
    h.h = wPosition(4);
    h.ar = h.w/h.h;
    
    if h.ar > 1
        axdims = [h.h *     h.ax_height_pct, h.h *     h.ax_height_pct];
        position = [(h.w - axdims(1))/2, (h.h - axdims(2))/2, axdims];
        
    else
        axdims = [h.w *     h.ax_height_pct, h.w *     h.ax_height_pct];
        position = [(h.w - axdims(1))/2, (h.h - axdims(2))/2, axdims];
    end
    
    set(h.ax,...
        'units','pixels',...
        'position', position);
end

end