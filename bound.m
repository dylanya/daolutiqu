function pointA = bound(points,L2)

%寻找边界点,寻找0的坐标
pointA = [];
for k = 1:size(points,1)
    m = uint16(points(k,2));
    n = uint16(points(k,1));
    if (n+1<=size(L2,2) && L2(m,n+1) == 0)  %判断这个点是不是为0，为0就记录坐标点
        pointA=[pointA;m,n+1];
    end
    if ( n-1 > 0 && L2(m,n-1) == 0)
        pointA=[pointA;m,n-1];
    end 
    if (m+1 <=size(L2,1) && L2(m+1,n) == 0)
        pointA=[pointA;m+1,n];
    end
    if (m+1 <=size(L2,1) && n+1 <= size(L2,2) && L2(m+1,n+1) == 0)
        pointA=[pointA;m+1,n+1];
    end
    if (m+1 <=size(L2,1) && n-1 > 0 && L2(m+1,n-1) == 0)
        pointA=[pointA;m+1,n-1];
    end
    if (m-1>0 && L2(m-1,n) == 0)
        pointA=[pointA;m-1,n];
    end
    if (m-1>0 && n+1 <= size(L2,2) && L2(m-1,n+1) == 0)
        pointA=[pointA;m-1,n+1];
    end
    if (m-1>0 && n-1 > 0 && L2(m-1,n-1) == 0)
        pointA=[pointA;m-1,n-1];
    end
end
i = 1;
while (i <= size(pointA,1))
    p = pointA(i,1);
    q = pointA(i,2);
    j = i+1;
    while (j <= size(pointA,1))
        r = pointA(j,1);
        t = pointA(j,2);
        if (p == r && q == t)
            pointA = [pointA(1:j-1,:);pointA(j+1:end,:)];%把相同的坐标点删除，只留一个
            j = j-1;
        end
        j = j+1;
    end
    i = i+1;
end
            
        
        
    
    
end

