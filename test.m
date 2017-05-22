x = [];
ybs = 1000;
y = zeros(ybs,1);
n = 50000;
tic
for ii = 1:n
    x = [x;ii];
end
toc
%
tic
yas = ybs;
for ii = 1:n
    if(ii>yas)
        y = [y;zeros(ybs,1)];
        yas = yas + ybs;
    end
    y(ii) = ii;
end
toc
