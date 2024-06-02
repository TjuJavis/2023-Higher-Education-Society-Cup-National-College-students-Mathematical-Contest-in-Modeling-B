%%W和gamma关系图
D = 120; % 初始化中心处水深
theta = 2 * pi / 3; % 初始化换能器开角角度
alpha=1.5/180*pi;
beta=0:0.001:180/180*pi;
gamma=asin(sin(beta)*sin(alpha));
% 计算覆盖宽度
W = D .* sin(theta/2) ./ cos(theta/2+gamma) + D .* sin(theta/2) ./ cos(theta/2-gamma);
% 绘制图像
figure;
plot(beta*180/pi, W, 'LineWidth', 1.5); % 增加线条宽度
xlabel('\gamma (degrees)', 'FontSize', 10); % 设置横轴标签和字体大小
ylabel('Width', 'FontSize', 10); % 设置纵轴标签和字体大小
title('Width vs. \gamma', 'FontSize', 12); % 设置标题和字体大小
set(gca, 'FontName', 'Arial', 'FontSize', 8); % 设置坐标轴字体样式和大小
grid on; % 显示网格线
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 3.5 2]); 

