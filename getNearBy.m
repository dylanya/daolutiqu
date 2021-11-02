function  a = getNearBy(order, e)
%查询相邻区域
    a = [];
    f = 1;
    for i = 1:size(e,1)
        if e(i,1) == order
            a(f) = e(i,2);
            f=f+1;
        end
    end
    
    for i = 1:size(e,1)
        if e(i,2) == order
            a(f) = e(i,1);
            f=f+1;
        end
    end
end