% 函数定义部分需要放在脚本末尾
function [metaboliteList, stoichCoeffList] = parseReactionFormula(reactionFormula)
    % 自定义函数: 解析反应式并合并重复代谢物
    components = strsplit(reactionFormula, ' + ');
    metaboliteList = {};
    stoichCoeffList = [];
    for k = 1:length(components)
        % 如果代谢物已经存在，则合并它们的计量系数
        metabolite = components{k};
        idx = find(strcmp(metaboliteList, metabolite), 1);
        if isempty(idx)
            metaboliteList = [metaboliteList; {metabolite}];
            stoichCoeffList = [stoichCoeffList; 1];
        else
            stoichCoeffList(idx) = stoichCoeffList(idx) + 1;
        end
    end
end