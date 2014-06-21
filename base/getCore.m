function vcore = getCore()
    results = findall(0,'Name','lram viscore');
    if numel(results) <= 0
        error('viscore uninitialized. Please run viscore.');
    else
        fig = results(1);
        vcore = get(fig,'UserData');
    end    
end

