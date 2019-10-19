clc
clear

%% 参数
group_size = 1000; % 群体规模
max_iteration = 1000; % 最大进化代数
prob_copulation = 0.88; % 交配概率
prob_mutation = 0.01; % 变异概率

%% 初始化
group = initialize(group_size);
eval = evaluate(group);
[max_eval, index] = max(eval);
best_chromosome = group(index, :);

%% 开始进化
for i = 1 : max_iteration
    group_after_select = selection(group, eval);
    group_after_copulation = crossover(group_after_select, prob_copulation);
    group_after_mutation = mutation(group_after_copulation, prob_mutation);
    eval = evaluate(group_after_mutation);
    [current_max_eval, current_index] = max(eval);
    if current_max_eval > max_eval
        max_eval = current_max_eval;
        best_chromosome = group_after_mutation(current_index, :);
    end
end

disp(max_eval);
disp(best_chromosome);

%% 初始化函数
function group = initialize(group_size)
    group = (rand(group_size, 4) - 0.5) * 10;
end

%% 适应值评价函数
% function eval = evaluate(group)
%     eval = zeros(5, 1);
%     for chromosome = 1:size(group, 1)
%         eval(chromosome) = 1 / (group(chromosome, 1)^2 + group(chromosome, 2)^2 + group(chromosome, 3)^2 + group(chromosome, 4)^2 + 1);
%     end
% end

function EE = evaluate(tt)
    EE = 1 ./ (sum(tt .* tt, 2) + 1);
end

%% 选择算子
function new_group = selection(group, eval)
    new_group = zeros(length(group), 4);
    for i = 1:length(group)
        new_group(i, :) = group(RWS(eval), :);
    end
end

% 轮盘赌
function index = RWS(eval)
    probability = eval / sum(eval);
    selected = rand();
    prob_sum = 0;
    for i = 1:length(eval)
        prob_sum = prob_sum + probability(i);
        if prob_sum >= selected
            index = i;
            return
        end
    end
end

%% 交配算子
function new_group = crossover(group, prob_copulation)
    copu_flag = rand(size(group, 1), 1) < prob_copulation;
    without_copu = group(copu_flag == 0, :);
    with_copu = group(copu_flag == 1, :);
    new_group = [without_copu; copu_executor(with_copu)];
end

function chromosome_after_copu = copu_executor(with_copu)
    copu_turn_num = floor(size(with_copu, 1) / 2);
    for i = 1:copu_turn_num
        copu_position = randi(4);
        with_copu(2 * i - 1: 2 * i, copu_position + 1:end) = with_copu(2 * i:-1:2 * i - 1, copu_position + 1:end);
    end
    chromosome_after_copu = with_copu;
end

%% 变异算子
function group_after_mutation = mutation(group, prob_mutation)
    if_mutation = rand(size(group)) < prob_mutation;
    for i = 1:size(group, 1)
        for j = 1:size(group, 2)
            if if_mutation(i, j)
                group(i, j) = (rand() - 0.5) * 10;
            end
        end
    end
    group_after_mutation = group;
end