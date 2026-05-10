
%% 算法1clppm-d=2  主循环函数
function [x, z] = algorithm_clppm(n, T_total, adj, A, noise)
    e=0.9;
    d=2;listen_agent=1;
    x = zeros(n,d,T_total);      % 状态存储
    x(:,:,1) = [1,2; 2,4; 4,3; 3,2; 5,4]; % 初始状态
    z = zeros(d, T_total); % 监听变量初始化
    %noise = zeros(n, n, d, T);
    z(:,1) = x(1,:,1) - rand; % 初始

   for t = 1:T_total
    % -----当前时刻  exchange information
    S = cell(n,n);
    for i = 1:n
        neighbors = find(adj(i,:));
        for j = neighbors
            if t == 1
                S{i,j} = x(i,:,t) + noise(i,j);
            else,if t <= 20

                noise = zeros(n, n,d,20);
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
        x_new(i,:) = x_new(i,:) + delta; % t 时刻 的
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
end
