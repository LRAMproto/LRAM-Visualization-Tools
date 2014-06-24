function testfunction(varargin)
%TESTFUNCTION Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0
    disp('hello');
elseif nargin > 0
    for i=1:length(varargin)
        disp(varargin(i));
    end
end



end

