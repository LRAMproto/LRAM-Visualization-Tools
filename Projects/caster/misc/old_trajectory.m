% This function takes in a time span, initial velocity and position and
% outputs the x and y positions across the time span as an animated plot. 

function [positions velocities] = old_trajectory(t,Vo,Ro,Xo,Yo)
 
% Variables
g   = 9.81;      % m/s^2
dt  = t(2)-t(1);

% Kinematic equations

x   = Xo + Ro(1) + Vo(1) .* t;              % The initial position
y   = Yo + Ro(2) + Vo(2) .* t - 0.5 * g * t.^2;

Vx  = zeros(1,length(t)) + Vo(1);
Vy  = Vo(2) - g * t;

positions = [x;
             y];

velocities = [Vx; 
              Vy];

% Print results

% fprintf('Initial horizontal velocity is:   %.2f [m/s]\n',Vx(1))
% fprintf('Initial vertical velocity is:     %.2f [m/s]\n\n',Vy(1))
% fprintf(2,'Delta T is %.3f seconds\n\n',dt)

% Print the velocity data 

% fprintf('Vx:\n')
% fprintf('%.2f\t',velocities(1,:));          % For length(t) < 50
% fprintf('\n\n')
% fprintf('Vy:\n')
% fprintf('%.2f\t',velocities(2,:));
% fprintf('\n\n')

% fprintf('Vx\n')
% disp(velocities(1,:));                    % for length(t) > 50
% fprintf('Vy\n')
% disp(velocities(2,:));


% Plot data
% plot(1,1)
% hold on
% axis([0 3.03 0 2.18])
% for i=1:length(t)
%   plot(x(i),y(i),'*r');
%   hold on;
%   grid on
%   pause(0.01);                  % decrease for length(t) > 200
% end
% 
% title('X vs Y')
% xlabel('Horizontal [meters]')
% ylabel('vertical [meters]')

end

