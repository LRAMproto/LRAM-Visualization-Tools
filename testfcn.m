function testfcn(varargin)
% Tests output of a function
fprintf('testfcn passes the following arguments:\n\n');
for i=1:length(varargin)
    disp(varargin(i));
end

end