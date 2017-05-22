%% Speed test
b = bus();
a = class1(b);
%
pause(1);
tic
for ii = 1:100000
    a.getData();
end
toc
%
tic
for ii = 1:100000
    a.getProperty();
end
toc