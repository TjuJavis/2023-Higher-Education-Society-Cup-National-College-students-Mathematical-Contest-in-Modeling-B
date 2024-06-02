data1 = readtable('附件.xlsx');
rows = 2:252;    
cols = 3:203;   
data2 = data1(rows, cols);
subsetData = table2array(data2);
data = double(subsetData)*(-1);
x = 0:0.02:4;
y = 0:0.02:5;
figure;
contourf(x,y,data, 'LineStyle', 'none','levelstep',20);%以20m为步长
title('海底曲面等深线图');
xlabel('由西向东/海里');
ylabel('由南向北/海里');
colorbar;
colormap(jet);  % 使用jet颜色映射
set(gca, 'FontSize', 12);
set(findall(gca, 'Type', 'Line'), 'LineWidth', 1.5);
set(gcf, 'Position', [100 100 800 600]);

