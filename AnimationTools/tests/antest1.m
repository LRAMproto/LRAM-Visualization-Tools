function antest1;
    f = figure;
    ax = axes;
    previous = pwd;
    filepath = fileparts(mfilename('fullpath'));
    cd(filepath);
    cd('frames');
    cd('antest1');
    fprintf('Filepath set to %s\n',pwd);
    fprintf('Beginning Rendering\n');

    an = Animation('AnTest',pwd, f);
    for i=1:20
        an.RunUpdateFcn();
        an.RenderFrame();
    end   
    fprintf('Rendering finished.\n');
    %an.OutputToVideo();
    
    cd(previous);
end