% 确保代谢物具有空间定位标志的函数
function metID = ensureCompartment2(metID)
    % 如果是 _c 或 _e，转换为 [c] 或 [e]
    if contains(metID, '_c')
        metID = regexprep(metID, '_c$', '[c]');
    elseif contains(metID, '_e')
        metID = regexprep(metID, '_e$', '[e]');
    else
        % 如果是其他任何 _x 后缀，转换为 [c]
        metID = regexprep(metID, '(_[a-zA-Z])$', '[c]');
    end
end
