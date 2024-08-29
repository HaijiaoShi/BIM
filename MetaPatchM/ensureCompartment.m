function metID = ensureCompartment(metID)
    % 使用正则表达式检查代谢物ID是否以 [x] 形式结尾，其中 x 是任意单个字母
    % 正则表达式解释：'\[' 开始方括号, '[a-zA-Z]' 任意字母, '\]' 结束方括号
    if isempty(regexp(metID, '\[[a-zA-Z]\]$', 'once'))
        metID = [metID '[c]']; % 如果没有，添加默认后缀 [c]
    end
end
