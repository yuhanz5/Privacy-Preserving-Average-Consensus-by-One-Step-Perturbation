clear;

%mo 差分噪声
% 初始化邻接矩阵 A
A = 0.25 * [ 
  2 1 0 0 1 ;
  1 2 1 0 0 ;
  0 1 2 0 1 ;
  0 0 0 3 1 ;
  1 0 1 1 1 ;
];

% 节点数量
n = size(A, 1);
% 迭代次数
T = 100;
rng(1);  
% 初始状态 
x = zeros(n, T);   % 初始状态矩阵，每行代表一个节点
x(:, 1) = [1, 2, 3, 4, 5]; % 假设初始状态值

% 噪声变量初始化
v = randn(n, T);  % 标准正态分布随机变量 vi(k)
w = zeros(n, T);  
e = 0.9;          
    

% k = 0 时的噪声
w(:, 1) = v(:, 1);

% 噪声迭代生成
for k = 2:T
    w(:, k) = (e^k) * v(:, k) - (e^(k-1)) * v(:, k-1); 
end

% 初始化监听器 z
z = zeros(1, T);
z(1) = x(1, 1) + w(1, 1);  %z(0) = x^+(0)

% 迭代计算状态，使用状态更新公式
for k = 1:T-1
    % 添加噪声后的新状态 x+(k)
    x_plus = x(:, k) + w(:, k);
    
    % 计算 x_i(k+1) 
    % x_i(k+1) = a_ii * x_i+(k) + ∑ a_ij * x_j+(k)
    for i = 1:n
        % a_ii * x_i^+(k)
        x_sum1 = A(i,i) * x_plus(i);

        % 加权求和部分 ∑ a_ij * x_j^+(k)
        x_sum2 = 0;
        for j = 1:n
            if j ~= i  
                x_sum2 = x_sum2 + A(i,j) * x_plus(j);
            end
        end

        % 状态更新 x_i(k+1) = a_ii * x_i+(k) + ∑ a_ij * x_j+(k)
        x(i, k+1) = x_sum1 + x_sum2;
    end

    % 更新监听器 z[k+1]
    x1_plus_next = x(1, k+1) + w(1, k+1);  % x1^+[k+1]
    x1_plus = x(1, k) + w(1, k);  % x1^+[k]

    % 计算 ∑ a_1j(x_j^+[k] - x1^+[k])
    %A(1, 2) = 0.7;
    sumz = 0;
    for j = 1:n
        if j ~= 1  
            sumz = sumz + A(1, j) * (x_plus(j) - x_plus(1));
        end
    end
    %A(1, 2) = 0.25;
    % 更新监听器 z[k+1] = z[k] + x1^+[k+1] − (x1^+[k] + ε * ∑ a1j * (x_j^+[k] − x1^+[k]))
    z(k+1) = z(k) + x1_plus_next - (x1_plus + e * sumz);
end

% 平均值
average = mean(x(:, 1));

% 绘制节点的状态轨迹
figure;
hold on;
for i = 1:n
    plot(1:T, x(i, :), 'DisplayName', ['x_' num2str(i)]);
end

% plot(1:T, x(1, :), 'DisplayName', 'x_1');
plot(0:T-1, average * ones(1, T), 'k--', 'DisplayName', 'average x[0]');
plot(0:T-1, z, '-.', 'DisplayName', 'Z');
plot(1:T, x(1, 1) * ones(1, T),'--','DisplayName', 'x1[0] ');
xlabel('k');
ylabel(' x_i(k)');
title('mo');
legend show;
hold off;
