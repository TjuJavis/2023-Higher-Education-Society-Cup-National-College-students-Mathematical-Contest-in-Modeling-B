%%问题三求解
theta=2*pi/3; % 初始化换能器开角角度
alpha=1.5/180*pi; % 初始化坡度
D0=110; % 初始化中心处水深
% n=length(len); %计算测线总数
% 初始化海域
width_s=2*1852;
length_s=4*1852;

%% 求do

% 定义方程组 x(1)do X(2)为l1 
F = @(x) [
    (D0-x(2)*tan(alpha))*sin(theta/2)/cos(theta/2+alpha)-x(1);
    -x(2)+x(1)-4*1852/2
    ];

% 使用fsolve函数求解方程组
x0 = [9;3]; % 初始猜测值
options = optimoptions('fsolve', 'Display', 'none'); % 设置显示求解过程
[x, ~, ~] = fsolve(F, x0, options); % 求解方程组
do=x(1);
l1=x(2);


%% 求d1
%eta=0.11;
% 定义方程组 x(1)为d1 X(2)为W2上 X(3)为W2
D1=D0-l1*tan(alpha);
W1=2*D1*sin(theta)*cos(alpha)/(cos(theta)+cos(2*alpha));

F = @(x) [
    -0.1+(W1+x(3)-(do/cos(alpha)+x(2)+x(1)/cos(alpha)))/x(1);
    -x(2)+(D1-x(1)*tan(alpha))*sin(theta/2)/cos(theta/2-alpha);
    -x(3)+2*D1*sin(theta)*cos(alpha)/(cos(theta)+cos(2*alpha))
    ];

% 使用fsolve函数求解方程组
x0 = [9;3;4]; % 初始猜测值
options = optimoptions('fsolve', 'Display', 'none'); % 设置显示求解过程
x = fsolve(F, x0, options); % 求解方程组
exitflag = 0; % 没有退出标识符返回
d1=x(1);
W2_up=x(2);

%% 递推求解d（n）

dn = 40;

L_main = zeros(1,101);
L_plus = zeros(1,101);
n_disp = zeros(1,101);
d_disp = zeros(101,dn);
j = 1;

for eta = 0.1:0.001:0.2 % 遍历eta从0.1~0.2
    d = zeros(1,dn); 
    D = zeros(1,dn);
    W = zeros(1,dn);
    W_up = zeros(1,dn);
    delta_x = zeros(1,dn);
    d(1) = d1;
    d_disp(:,1) = d1;
    D(1) = D1;

  for i=2:dn
    D(i)=D(i-1)-d(i-1)*tan(alpha);
    W(i)=2*D(i)*sin(theta)*cos(alpha)/(cos(theta)+cos(2*alpha));
    W_up(i)=D(i)*sin(theta/2)/cos(theta/2-alpha);
    myfunc=@(x) -eta*x+(D(i)-x*tan(alpha))*sin(theta/2)/cos(theta/2+alpha)...
        -x/cos(alpha)+W_up(i);
     x0 = 10; % 初始猜测值

     options = optimoptions('fsolve', 'Display', 'none'); % 设置不显示求解过程

     x = fsolve(myfunc, x0, options); % 求解方程组，结果存储在变量x中
     exitflag = 0; % 没有退出标识符返回

%     [x, ~, ~] = fsolve(myfunc, x0, options); % 求解方程组
    d(i)=x;
    d_disp(j,i) = d(i);
    n=i+1;
    delta_x(i) = D(i)*tan(theta/2);
    if (sum(d)+do+W_up(i))>length_s
       break
    end
  end
  n_disp(j) = n;
  %计算仅有主测线的测线总长度
  L_main(j) = 2*n;
  % 计算加入转弯后的测线总长度
  L_plus(j) = n*2 - 2*sum(delta_x)/1852+4-(do+W_up(i))/1852;
    j = j + 1;
end
