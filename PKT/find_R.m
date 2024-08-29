function [res] = find_fanying(temdata)

flag1=strfind(temdata,'<=>');
flag2=strfind(temdata,'->');

if isempty(flag1)
    zuo=temdata(1:flag2-1);
    zuo_wei=strfind(zuo,'+');
    zuo_shu=length(strfind(zuo,'+'))+1;
    for i=1:zuo_shu
        if i==1
            left_flag=0;
        else
            left_flag=zuo_wei(i-1);
        end
        if i==zuo_shu
            right_flag=length(zuo);
        else
            right_flag=zuo_wei(i)-1;
        end
        temdata2=zuo(left_flag+1:right_flag);
        for k=1:length(temdata2)
            if temdata2(1)==' '
                temdata2(1)=[];
            end
            if temdata2(end)==' '
                temdata2(end)=[];
            end
        end
        res{1,i}=temdata2;
    end
end


if isempty(flag2)
    zuo=temdata(1:flag1-1);
    zuo_wei=strfind(zuo,'+');
    zuo_shu=length(strfind(zuo,'+'))+1;
    for i=1:zuo_shu
        if i==1
            left_flag=0;
        else
            left_flag=zuo_wei(i-1);
        end
        if i==zuo_shu
            right_flag=length(zuo);
        else
            right_flag=zuo_wei(i)-1;
        end
        temdata2=zuo(left_flag+1:right_flag);
        for k=1:length(temdata2)
            if temdata2(1)==' '
                temdata2(1)=[];
            end
            if temdata2(end)==' '
                temdata2(end)=[];
            end
        end
        res{1,i}=temdata2;
    end
end


end