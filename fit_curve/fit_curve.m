clc;
clear;

%% prepare data
% use fifth-order polynomial to generates fake
% observation data
x = -5:0.1:5;
x = x.';
y = 1 * x.^4 + 7 * x.^3 + 9 * x.^2 + 1 * x + 1 + 50 * randn(size(x));
% visualization
figure(1);
plot(x, y, 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'cyan');
hold on;

%% least-square method
% generate a linear equations system and find it least-square solution
Mx = [x.^4, x.^3, x.^2, x, ones(length(x), 1)];
param = Mx \ y;
% visualization
ls4 = param(1); ls3 = param(2); ls2 = param(3); ls1 = param(4); ls0 = param(5); 
lsfit = ls4 * x.^4 + ls3 * x.^3 + ls2 * x.^2 + ls1 * x + ls0;
figure(1);
plot(x, lsfit, '--magenta', 'LineWidth', 2);

%% optimization method
% configure options and optimize loss function
fun = @(param)sseval(param, x, y);
param0 = rand(5, 1);
options = optimset('Display', 'iter');
solution = fminsearch(fun, param0, options);
% visualization
figure(1);
p4 = solution(1); p3 = solution(2); p2 = solution(3); p1 = solution(4); p0 = solution(5);
yfit = p4 * x.^4 + p3 * x.^3 + p2 * x.^2 + p1 * x + p0;
plot(x, yfit, ':', 'LineWidth', 2, 'Color', '#0072BD');

% definition of loss function
function sse = sseval(param, x, y)
    p4 = param(1);
    p3 = param(2);
    p2 = param(3);
    p1 = param(4);
    p0 = param(5);
    sse = sum((y - p4 * x.^4 - p3 * x.^3 - p2 * x.^2 - p1 * x - p0).^2);
end