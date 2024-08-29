initCobraToolbox(false) %初始化模型
changeCobraSolver('gurobi','all') %修改求解器
model=readCbModel('p-thermo.xml')
save("p-thermo.mat","model")