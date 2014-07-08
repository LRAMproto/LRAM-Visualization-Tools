function vertices = pkg_vertices(varargin)
% Packages a set of vertices for ease of use
    if ~isempty(varargin)
        vertices.xdata = [];
        vertices.ydata = [];
        vertices.zdata = [];            
    end
    
    if length(varargin) >= 2
        vertices.xdata = varargin{1};
        vertices.ydata = varargin{2};
    end
    
    if length(varargin) >= 3
    % May be defined in future versions of visualizer.
        vertices.zdata = varargin{3};
    else
        vertices.zdata = [];            
    end
    
end
