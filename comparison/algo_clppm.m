clear; close all;

%% 参数
n = 5;          % 智能体数量
T_total = 100;  % 增加仿真步数以观察收敛性
rng(1);         % 固定随机种子
T = 20;          % 扰动时间

e = 0.5;                
listen_agent = 1;       % 监听目标

load('A.mat');
load('adj.mat');

%% 初始化状态
x = zeros(n,T_total);
x(:,1) = [1; 2; 4; 3; 5]; % 初始状态
x_ave = mean(x(:,1));

z = zeros(1,T_total);
z(1) = x(1,1) - 0.1*rand; % 降低初始噪声

%% 主循环
for t = 1:T_total-1
    % 通信过程
    S = zeros(n,n);
    for i = 1:n
        neighbors = find(adj(i,:));
        for j = neighbors
            if t == 1
                load('noisen.mat');
                S(i,j) = x(i,t) + noise(i,j);
                 noise = zeros(n, n);
            else, if t < T 
                    %noise = zeros(n, n);
                    noise(i,j) = 1000*(rand-0.5);
                    S(i,j) = x(i,t) + noise(i,j);
                  else
                    S(i,j) = x(i,t);
                  end
            end
        end
    end
    
    % 状态更新
    x_new = x(:,t);
    for i = 1:n
        delta = 0;
        neighbors = find(adj(i,:));
        for j = neighbors
            s_ij = S(j,i);
            s_ji = S(i,j);
            delta = delta + e*A(i,j)*(s_ij - s_ji); % 使用alpha权重
        end
        x_new(i) = x_new(i) + delta;
    end
    x(:,t+1) = x_new;
    

    c=0.9;
    % 监听
    sum_z = 0;
    neighbors = find(adj(listen_agent,:));
    for j = neighbors
        term = A(listen_agent,j)*(x(j,t) - x(listen_agent,t));
        sum_z = sum_z + term;
    end
    z(t+1) = z(t) + (x(listen_agent,t+1) - x(listen_agent,t)) - c*sum_z;
end

%% 收敛性分析
figure;
hold on; 
for i = 1:n
    plot(0:T_total-1, x(i, :), 'DisplayName', ['x_' num2str(i)]);
end
%plot(z, 'r--', 'LineWidth', 1) % 监听值
plot(0:T_total-1, z, 'r--', 'LineWidth', 1,'DisplayName', 'Z');
plot([0 T_total-1], [x_ave x_ave], 'k:', 'LineWidth', 1);
% plot(0:T-1, x(1, 1) * ones(1, T),'--','DisplayName', 'x1[0] ');
plot(0:T_total-1, x(1,1)*ones(1,T_total),'-.','LineWidth',1);
xlabel('k');
legend('x_1','x_2','x_3','x_4','x_5','Z','average x[0]')

% 误差分析
final_error = mean(abs(x(:,end) - x_ave));
disp(['最终平均误差: ', num2str(final_error)]);
listen_error = abs(x(1,end) - z(end));
disp(['监听误差: ', num2str(listen_error)]);