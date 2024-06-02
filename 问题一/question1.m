%%问题一求解

len=[-800 -600 -400 -200 0 200 400 600 800]; %初始化测线距中心点处距离
theta=2*pi/3; %初始化换能器开角角度
alpha=1.5/180*pi; %初始化坡度
D=70; %初始化中心处水深
n=length(len); %计算测线总数
d=200; %初始化测线间距

Di=D-len*tan(alpha); %计算不同测线下的海水深度

%计算覆盖宽度
W=2*sin(theta)*(D*cos(alpha)-len*sin(alpha))/(cos(theta)+cos(2*alpha));

%计算重叠度
W_up=Di*sin(theta/2)/cos(theta/2-alpha); %定义并计算覆盖宽度左下部分
W_down=Di*sin(theta/2)/cos(theta/2+alpha); %定义并计算覆盖宽度右上部分

W_add=rand(1,n);
eta=rand(1,n-1);
for i=1:n-1
  W_add(i)=W_down(i)+W_up(i+1)+d/cos(alpha);
  eta(i)=(W(i)+W(i+1)-W_add(i))/(d/cos(alpha));
end
disp(['海水深度Di = ', num2str(Di)]);
disp(['覆盖宽度W =: ', num2str(W)]);
disp(['重叠度eta = ', num2str(eta)]);


