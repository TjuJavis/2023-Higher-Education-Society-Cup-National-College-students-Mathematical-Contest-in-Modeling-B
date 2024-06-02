
close all;

% 设置参数
theta = 2*pi/3;
data1 = readtable('附件.xlsx');
rows = 2:252;    
cols = 3:203;   
data2 = data1(rows, cols);
subsetData = table2array(data2);
data = double(subsetData)*(-1);

x = 0:0.02:4;
y = 0:0.02:5;

% 求解某个高度的等高线方程
h = -40; % 假设要求解的高度值为 -40 米

% 绘制等高线图
figure;
contourf(x, y, data, 'LineStyle', 'none', 'levelstep', 3);
title('海底曲面等深线图');
xlabel('由西向东/海里');
ylabel('由南向北/海里');
colorbar;
colormap(jet);
set(gca, 'FontSize', 12);
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1.5);
set(gcf, 'Position', [100 100 800 600]);

% 求解等高线方程
[C, ~] = contour(x, y, data, [h, h], 'LineColor', 'r', 'LineWidth', 2);
clabel(C, h, 'FontSize', 10, 'Color', 'b', 'FontWeight', 'bold');

% 输出等高线方程
eqn = sprintf('海平面高度：%d 米', abs(h));
disp(eqn);

% 定义两个点的坐标
x1 = 1.72;
y1 = 0.36;
x2 = 1.82;
y2 = 1.46;

% 计算指定等高线的周长
[C, ~] = contour(x, y, data, [h, h]);
coords = C(:, 2:end); % 提取坐标点

perimeter = 0;
n = size(coords, 2);
for i = 1:n-1
    dx = coords(1, i+1) - coords(1, i);
    dy = coords(2, i+1) - coords(2, i);
    dist = sqrt(dx^2 + dy^2);
    perimeter = perimeter + dist;
end

% 输出等高线的周长
disp('等高线周长：')
disp(perimeter);

% 计算两个点在指定等高线上的曲线距离
minDist = Inf; % 初始最小距离设置为无穷大
minIdx1 = 0; % 最近点1的索引
minIdx2 = 0; % 最近点2的索引

for i = 1:size(coords, 2)
    dist1 = sqrt((coords(1, i) - x1)^2 + (coords(2, i) - y1)^2);
    dist2 = sqrt((coords(1, i) - x2)^2 + (coords(2, i) - y2)^2);
    
    if dist1 < minDist
        minDist = dist1;
        minIdx1 = i;
    end
    
    if dist2 < minDist
        minDist = dist2;
        minIdx2 = i;
    end
end

distAlongCurve = 0;
if minIdx2 > minIdx1
    for i = minIdx1:minIdx2-1
        dx = coords(1, i+1) - coords(1, i);
        dy = coords(2, i+1) - coords(2, i);
        distAlongCurve = distAlongCurve + sqrt(dx^2 + dy^2);
    end
elseif minIdx2 < minIdx1
    for i = minIdx1-1:-1:minIdx2
        dx = coords(1, i+1) - coords(1, i);
        dy = coords(2, i+1) - coords(2, i);
        distAlongCurve = distAlongCurve + sqrt(dx^2 + dy^2);
    end
end

% 输出两个点在指定等高线上的曲线距离
disp('两个点在等高线上的曲线距离：')
disp(distAlongCurve);

% 找到离点 (x1, y1) 最近的两个坐标点
distances = sqrt((coords(1,:) - x1).^2 + (coords(2,:) - y1).^2);
[~, sortedIndices] = sort(distances);
closestPoint1 = coords(:, sortedIndices(1));
closestPoint2 = coords(:, sortedIndices(2));

% 使用这两个点计算斜率
dy = closestPoint2(2) - closestPoint1(2);
dx = closestPoint2(1) - closestPoint1(1);
slope = dy / dx;

disp(['等高线在点 (' num2str(x1) ',' num2str(y1) ') 处的切线斜率为: ' num2str(slope)]);

xi = 0;
yi = 0;
flag = 0;

% 计算与切线斜率相垂直的点的坐标
for xi = 0.1:0.02:4
    for yi = 0.1:0.02:4
        is = (yi - y1) / (xi - x1) * slope;
        if abs(is+1) < 0.0001
            disp('找到与切线斜率相垂直的点');
            flag = 1; 
            break;
        end
    end
    if flag
        break;
    end
end

disp(xi);
disp(yi);