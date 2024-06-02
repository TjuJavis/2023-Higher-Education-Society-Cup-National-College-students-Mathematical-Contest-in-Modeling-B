%% SA 模拟退火
tic
clear; clc
close all;
%% 参数初始化
T0 = 100; % 初始温度
T = T0; % 迭代中温度会发生改变，第一次迭代时温度就是T0
maxgen = 200; % 最大迭代次数
Lk = 100; % 每个温度下的迭代次数
alfa = 0.95; % 温度衰减系数
x_lb = repmat(20,1,50); % x的下界
x_ub = repmat(200,1,50); % x的上界
Dmax=40;
k=0.5;
alpha=0.5/180*pi;
theta=120*pi/180;
%% 随机生成一个初始解
% 生成随机数的个数
num_of_random_numbers = randi([1, 50]);
% 生成随机数
x0 = linspace(200, 20, num_of_random_numbers); % 生成一个从200递减到20的数组
step = rand(1, num_of_random_numbers-1) * 10; % 生成一个随机步长数组
x0(2:end) = x0(2:end) + step; % 将步长添加到x0中
x0 = sort(x0, 'descend'); % 对x0进行降序排序
% x0 = 20 + (200 - 20) * rand(1, num_of_random_numbers);
narvs = length(x0); % 变量x个数
y0 = Obj_fun1(x0); % 计算当前解的函数值
%% 定义一些保存中间过程的量，方便输出结果和画图
max_y = y0; % 初始化找到的最佳的解对应的函数值为y0
MAXY = zeros(maxgen,1); % 记录每一次外层循环结束后找到的max_y (方便画图）
%% 模拟退火过程
for iter = 1 : maxgen % 外循环, 我这里采用的是指定最大迭代次数
 for i = 1 : Lk % 内循环，在每个温度下开始迭代
   y = randn(1,narvs); % 生成1行narvs列的N(0,1)随机数
   z = y / sqrt(sum(y.^2)); % 根据新解的产生规则计算z
   x_new1 = x0 + z*T; % 根据新解的产生规则计算x_new的值
   x_new=sort(x_new1,'descend');
    % 如果这个新解的位置超出了定义域，就对其进行调整
    for j = 1: narvs
        if x_new(j) < x_lb(j)
           r = rand(1);
           x_new(j) = r*x_lb(j)+(1-r)*x0(j);
        elseif x_new(j) > x_ub(j)
           r = rand(1);
           x_new(j) = r*x_ub(j)+(1-r)*x0(j);
        end
     end
 x1 = x_new; % 将调整后的x_new赋值给新解x1
 y1 = Obj_fun1(x1); % 计算新解的函数值
 if y1 > y0 % 如果新解函数值大于当前解的函数值
    x0 = x1; % 更新当前解为新解
    y0 = y1;
 else
    p = exp(-(y0 - y1)/T); % 根据Metropolis准则计算一个概率
 if rand(1) < p % 生成一个随机数和这个概率比较，如果该随机数小于这个概率
    x0 = x1; % 更新当前解为新解
    y0 = y1;
 end
 end
% 判断是否要更新找到的最佳的解
 if y0 > max_y % 如果当前解更好，则对其进行更新
     max_y = y0; % 更新最大的y
     best_x = x0; % 更新找到的最好的x
 end
end
MAXY(iter) = max_y; % 保存本轮外循环结束后找到的最大的y
T = alfa*T; % 温度下降
end
%% 画出每次迭代后找到的最大y的图形
figure
plot(1:maxgen,MAXY,'b-');
xlabel('迭代次数');
ylabel('y的值');
toc
function opp = Obj_fun1(x)
       narvs = length(x);
       Dmax=40;
       k=0.5;
       alpha=0.5/180*pi;
       eta=zeros(1,narvs);
      for i=1:(narvs-1)
         eta=1-x(i+1)/2/(Dmax-x(i)*tan(alpha))*tan(alpha/2); 
         
      end
     opp=k*(1-sum(eta))+(1-k)*2*sum(x);
end
