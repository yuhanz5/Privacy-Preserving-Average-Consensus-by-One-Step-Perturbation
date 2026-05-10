
%总误差（Total Error）是指在某一时间步下，所有智能体的状态与全局目标（例如全局平均值）之间的误差的总和。
% 通常，这种误差用平方和的方式计算，它表示了系统的整体偏离程度。
clear;

load('algo_our.mat');
% 设置全局平均值为3
x_bar = 3 * ones(T_total, 1);  % 全局平均值为常数 3，x_bar 是长度为 T 的列向量

% 计算全局误差 E(t)，使用总误差（平方和）或平均误差（绝对差）
E_total = zeros(T_total, 1);  % 初始化总误差向量
for t = 1:T_total
    % 计算每个时间步的总误差（平方和）
    E_total(t) = sum((x(:,t) - x_bar(t)).^2);  % 对每个智能体计算误差，进行平方和
end

load('algo_clppm.mat');
x_bar = 3 * ones(T_total, 1);
% 计算全局误差 E(t)，使用总误差（平方和）或平均误差（绝对差）
E_totald = zeros(T_total, 1);  % 初始化总误差向量
for t = 1:T_total
    % 计算每个时间步的总误差（平方和）
    E_totald(t) = sum((x(:,t) - x_bar(t)).^2);  % 对每个智能体计算误差，进行平方和
end

load('algo_mo.mat');
x_bar = 3 * ones(T_total, 1);
% 计算全局误差 E(t)，使用总误差（平方和）或平均误差（绝对差）
E_totalm = zeros(T_total, 1);  % 初始化总误差向量
for t = 1:T_total
    % 计算每个时间步的总误差（平方和）
    E_totalm(t) = sum((x(:,t) - x_bar(t)).^2);  % 对每个智能体计算误差，进行平方和
end


% 绘制clppm误差曲线
figure;
hold on;
plot(0:T_total-1, E_total,'r-', 'LineWidth', 1, 'DisplayName', 'Our algorithm');
 %plot(0:T_total-1, E_totald,'b--', 'LineWidth', 1, 'DisplayName', 'CLPPM algorithm');
 %plot(0:T_total-1, E_totalm,'g--', 'LineWidth', 1, 'DisplayName', ' Manitrara''s algorithm');  %纵坐标太小了看不出来
plot(0:T_total-1, E_totalm,'g--', 'LineWidth', 1, 'DisplayName', ' Mo''s algorithm'); 

% 添加图形标签
xlabel('$k$','Interpreter','latex');
ylabel('$E_t[k]$','Interpreter','latex');
legend;

set(gcf, 'WindowStyle', 'normal'); % 设置图形窗口为普通样式

plot(0:T_total-1, 0*ones(1,T_total),'black:','LineWidth',1);
hold off;


% % 绘制our误差曲线
% figure;
% hold on;
% 
% 
% 
% % 添加图形标签
% xlabel('$t$','Interpreter','latex');
% ylabel('$E_t[t]$','Interpreter','latex');
% set(gcf, 'WindowStyle', 'normal'); % 设置图形窗口为普通样式
% legend;
% hold off;

