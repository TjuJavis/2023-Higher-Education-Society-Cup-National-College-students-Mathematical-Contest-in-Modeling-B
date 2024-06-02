data = readtable('附件.xlsx');
rows = 2:252;    
cols = 3:203;   
subsetData = data(rows, cols);
subsetData = table2array(subsetData);
subsetData = double(subsetData).*(-1);

% 构建网格
x = 0:0.02:4;
y = 0:0.02:5;
[X, Y] = ndgrid(x, y); % 将 X 和 Y 转换为 ndgrid 格式
[Xq, Yq] = ndgrid(0:0.02:4, 0:0.02:5);
subsetData=subsetData';
% 构建差值函数
F = griddedInterpolant(X, Y, subsetData, 'spline');
% 进行二维差值拟合
Vq = F(Xq, Yq);
% 绘制网格图
figure;
mesh(Xq, Yq, Vq);
xlabel('由西向东/海里', 'FontSize', 12); 
ylabel('由南向北/海里', 'FontSize', 12); 
zlabel('海水深度', 'FontSize', 12); 
title('海底曲面三维模拟', 'FontSize', 14); 
view(45, 30); % 设置视角
xticks(0:0.2:4); 
yticks(0:0.2:5); 
zticks(0:20:200); 
colormap(gca, 'winter');
colorbar; 