function [res] =findC_shumu(temdata)

flag1=strfind(temdata,'C');
flag2=strfind(temdata,'H');
flag3=strfind(temdata,'O');
flag4=strfind(temdata,'CH');
if isempty([flag2,flag3])
    res=0;
else if isempty(flag2)
        res=1;
else if isempty(flag4)
        res=temdata(flag1+1:flag2-1);
        res=str2num(res);
else
    res=1;
end
end
end
if strcmp(temdata,'O2')
    res=0;
end
if strcmp(temdata,'CNS')
    res=1;
end
end