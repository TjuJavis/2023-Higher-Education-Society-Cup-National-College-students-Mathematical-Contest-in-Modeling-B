%% 问题二求解
close all;
len1=0:0.3:2.1; %初始化测线距中心点处距离
len=len1'*1852;

n=length(len); %计算测线总数
theta=2*pi/3; %初始化换能器开角角度
alpha=1.5/180*pi; %初始化坡度
beta1=0:45:315; %测线方向夹角
beta=beta1/180*pi;
D=120; %初始化中心处水深

%% 计算覆盖宽度
W=2.*sin(theta).*sqrt(1-sin(beta).^2.*sin(alpha).^2).*(D+len.*cos(beta).*tan(alpha))./....
  (cos(theta)+1-2.*sin(alpha).^2.*sin(beta).^2);
W=W';

%% 可视化
[len2D, beta2D] = meshgrid(len1, beta1); % 创建 len 和 beta 的二维版本
surf(len2D, beta2D, W); % 绘制三维图形
colormap jet; % 改变颜色映射
colorbar;% 添加颜色条
shading interp; % 改变表面的着色方式
xlabel('距中心点距离 len (海里)');
ylabel('测线方向夹角 \beta (度)');
zlabel('覆盖宽度 W (米)');
title('覆盖宽度W和L、\beta关系可视化');