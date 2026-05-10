clear; close all;

%% 参数
n = 5;          % 智能体数量
d = 2;          % 状态维度
T_total = 200;   % 总仿真步数
rng(7);         % 固定随机种子
T = 20;          % 扰动时间


% 监听参数设置
e = 0.9;                % 监听系数
listen_agent = 1;        % 监听目标


load('A.mat');
load('adj.mat');

% %% 生成连通无向图（环形拓扑）
% adj = circshift(eye(n),1) + circshift(eye(n),-1);
% adj = double(adj > 0);
% 
% % 生成双随机矩阵权重
% alpha = zeros(n,n);
% adj_degrees = sum(adj,2);
% for i = 1:n
%     neighbors = find(adj(i,:));
%     alpha(i,neighbors) = 1./adj_degrees(i);
% end
% % Sinkhorn平衡
% for iter = 1:100
%     alpha = alpha ./ sum(alpha,2); 
%     alpha = alpha ./ sum(alpha,1); 
% end
% % 转换为矩阵权重
% A = cell(n,n);
% for i = 1:n
%     for j = 1:n
%         A{i,j} = alpha(i,j)*eye(d);
%     end
% end

% Tij_matrix = randi([3,5],n,n); % 各边扰动时间
% T = max(Tij_matrix(:));        % 最大扰动时间步

%% 初始化状态
% x_ave = repmat([3,3], n, 1);   % 目标平均值
x = zeros(n,d,T_total);      % 状态存储
x(:,:,1) = [1,2; 2,4; 4,3; 3,2; 5,4]; % 初始状态

x_ave = mean(x(:,:,1));

z = zeros(d, T_total); % 监听变量初始化
% noise = zeros(n, n, d, T);
z(:,1) = x(1,:,1) - rand; % 初始


%% 主循环
tic;
for t = 1:T_total
    % -----当前时刻  exchange information
    S = cell(n,n);
    for i = 1:n
        neighbors = find(adj(i,:));
        for j = neighbors
            
            if t == 1
                load('noise11.mat');
                S{i,j} = x(i,:,t) + noise(i,j);
            else,if t <= T && t~=1
                %load('noise1.mat');
                 noise(i,j,:,t) = (rand(1,d)-0.5); % 噪声
                S{i,j} = x(i,:,t) + noise(i,j);   % 扰动 i-->j
                else
                S{i,j} = x(i,:,t);           % 无噪声信息
                end
            end
        end
    end
    
    % --------- 状态更新
    x_new = x(:,:,t);
    for i = 1:n
        delta = zeros(1,d);     %储存每次迭代
        neighbors = find(adj(i,:));
        for j = neighbors
            % 使用 邻居 通信信息
            s_ij = S{j,i};  % sij： i收到的邻居j的信息
            s_ji = S{i,j};  %i -->j
            
            delta = delta + (A{i,j} * (s_ij - s_ji)')';
        end
        x_new(i,:) = x_new(i,:) + e*delta; % t 时刻 的
    end
        x(:,:,t+1) = x_new;
    
        % --------- 监听计算

        sum_z = zeros(d,1);
        neighbors = find(adj(listen_agent,:)); % 获取监听目标的邻居
        for j = neighbors 
           % 矩阵权重 A{listen_agent,j}是d×d矩阵
           % ∑ A_1j(x_j^+[k] - x1^+[k])
            term = (A{listen_agent, j}) * (x(j,:,t) - x(listen_agent,:,t))';
            sum_z = sum_z + term;
        
        end
        
        % 监听更新公式
        z(:,t+1) = z(:,t) + x(listen_agent,:,t+1)' - x(listen_agent,:,t)' - e * sum_z;
     
end
liserror = x(1,:,200)-z(:,200);
disp('listen error:');
disp(liserror);
averror = x(1,:,200)-x_ave;
disp('average error:');
disp(averror);
toc;
%% 可视化
figure;

% ========== 维度1对比 ==========
subplot(2,1,1); 
hold on; grid on;
colors = lines(n); % 生成n种颜色的矩阵
for i = 1:n
    dim1 = squeeze(x(i,1,:)); % 提取第i个智能体的维度1
    plot(0:T_total, dim1, 'LineWidth', 1, 'Color', colors(i,:));
end


%yline(3, 'k--', 'LineWidth', 1); % 标注目标值3


% 绘制维度1监听值
 plot(0:T_total, z(1,:), 'r--', 'LineWidth', 1,...
    'DisplayName','Z');

 % 1节点1维初始值
plot(0:T_total-1, x(1,1,1)*ones(1,T_total),'-.','LineWidth',1);
% 标注理论平均值
plot(0:T_total-1,x_ave(1,1)*ones(1,T_total), 'k-', 'LineWidth', 1,...
    'DisplayName','Average Value');

title('Dimension 1 ');
ylabel('$x_{i1}(t)$',Interpreter='latex');
xlabel('t');

% ========== 维度2对比 ========== 
subplot(2,1,2);
hold on; grid on;
colors = lines(n); % 生成n种颜色的矩阵
for i = 1:n
    dim1 = squeeze(x(i,2,:)); % 提取第i个智能体的维度1
    plot(0:T_total, dim1, 'LineWidth', 1, 'Color', colors(i,:));
end

% 绘制维度2监听值
plot(0:T_total, z(2,:),'r--','LineWidth',1);
% 1节点 2维初始值
plot(0:T_total-1, x(1,2,1)*ones(1,T_total),'-.','LineWidth',1);

% 标注理论平均值
plot(0:T_total-1,x_ave(1,2)*ones(1,T_total), 'k-', 'LineWidth', 1,...
    'DisplayName','Average Value');

title('Dimension 2 ');
ylabel('$x_{i2}(t)$',Interpreter='latex');
xlabel('t');

