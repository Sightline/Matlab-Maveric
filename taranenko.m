%%
A = [0 0 0 0 0 1;
    0 0 0 0 1 0;
    0 0 0 1 0 0;
    1 1 1 1 1 1;
    5 4 3 2 1 0;
    20 12 6 2 0 0];
B1 = [0 0 0;30 0 0;0 0 0;4 40 20;-20 10 5;0 0 0];
alp = A\B1;
tau = 0:0.01:1;k = 1;
for tau = 0:0.01:1
    x(k) = alp(1,1)*tau^5 + alp(2,1)*tau^4 + alp(3,1)*tau^3 ...
        + alp(4,1)*tau^2 + alp(5,1)*tau + alp(6,1);
    xd(k) = 5*alp(1,1)*tau^4 + 4*alp(2,1)*tau^3 + 3*alp(3,1)*tau^2 ...
        + 2*alp(4,1)*tau + alp(5,1);
    xdd(k) = 20*alp(1,1)*tau^3 + 12*alp(2,1)*tau^2 + 6*alp(3,1)*tau ...
        + 2*alp(4,1);
    y(k) = alp(1,2)*tau^5 + alp(2,2)*tau^4 + alp(3,2)*tau^3 ...
        + alp(4,2)*tau^2 + alp(5,2)*tau + alp(6,2);
    yd(k) = 5*alp(1,2)*tau^4 + 4*alp(2,2)*tau^3 + 3*alp(3,2)*tau^2 ...
        + 2*alp(4,2)*tau + alp(5,2);
    ydd(k) = 20*alp(1,2)*tau^3 + 12*alp(2,2)*tau^2 + 6*alp(3,2)*tau ...
        + 2*alp(4,2);
    z(k) = alp(1,3)*tau^5 + alp(2,3)*tau^4 + alp(3,3)*tau^3 ...
        + alp(4,3)*tau^2 + alp(5,3)*tau + alp(6,3);
    zd(k) = 5*alp(1,3)*tau^4 + 4*alp(2,3)*tau^3 + 3*alp(3,3)*tau^2 ...
        + 2*alp(4,3)*tau + alp(5,3);
    zdd(k) = 20*alp(1,3)*tau^3 + 12*alp(2,3)*tau^2 + 6*alp(3,3)*tau ...
        + 2*alp(4,3);
    k = k+1;
end
k = k-1;
B2 = [4 40 20;-20 10 5;0 0 0;-20 100 100;30 0 0;0 0 0];
alp = A\B2;
for tau = 0:0.01:1
    x(k) = alp(1,1)*tau^5 + alp(2,1)*tau^4 + alp(3,1)*tau^3 ...
        + alp(4,1)*tau^2 + alp(5,1)*tau + alp(6,1);
    xd(k) = 5*alp(1,1)*tau^4 + 4*alp(2,1)*tau^3 + 3*alp(3,1)*tau^2 ...
        + 2*alp(4,1)*tau + alp(5,1);
    xdd(k) = 20*alp(1,1)*tau^3 + 12*alp(2,1)*tau^2 + 6*alp(3,1)*tau ...
        + 2*alp(4,1);
    y(k) = alp(1,2)*tau^5 + alp(2,2)*tau^4 + alp(3,2)*tau^3 ...
        + alp(4,2)*tau^2 + alp(5,2)*tau + alp(6,2);
    yd(k) = 5*alp(1,2)*tau^4 + 4*alp(2,2)*tau^3 + 3*alp(3,2)*tau^2 ...
        + 2*alp(4,2)*tau + alp(5,2);
    ydd(k) = 20*alp(1,2)*tau^3 + 12*alp(2,2)*tau^2 + 6*alp(3,2)*tau ...
        + 2*alp(4,2);
    z(k) = alp(1,3)*tau^5 + alp(2,3)*tau^4 + alp(3,3)*tau^3 ...
        + alp(4,3)*tau^2 + alp(5,3)*tau + alp(6,3);
    zd(k) = 5*alp(1,3)*tau^4 + 4*alp(2,3)*tau^3 + 3*alp(3,3)*tau^2 ...
        + 2*alp(4,3)*tau + alp(5,3);
    zdd(k) = 20*alp(1,3)*tau^3 + 12*alp(2,3)*tau^2 + 6*alp(3,3)*tau ...
        + 2*alp(4,3);
    k = k+1;
end
figure(1);
plot3(y,x,z); grid; xlabel('east');ylabel('north');zlabel('altitude');
figure(2);
plot(x);hold on;
plot(y,'r');
plot(z,'g'); hold off;
grid; 
figure(3);
plot(xd);hold on;
plot(yd,'r');
plot(zd,'g'); hold off;
grid; 
figure(4);
plot(xdd);hold on;
plot(ydd,'r');
plot(zdd,'g'); hold off;
grid; 
% figure(3);
% psi = atan2(yd,xd);
% plot(psi);