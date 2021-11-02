function result = adjacency(pointA1,pointA2, L2)

%寻找相同边界

boundy = [];
for i = 1:size(pointA1,1)
    m = pointA1(i,1);
    n = pointA1(i,2);
    for j = 1:size(pointA2,1)
        p = pointA2(j,1);
        q = pointA2(j,2);
        if (p == m  && q == n)
            boundy = [boundy;m,n];%如果有相同的坐标点，保留这个坐标点，就是他们相同的边界
            break
        end
    end
end
result = [];
for i = 1: size(boundy,1)
    m = uint16(boundy(i,1));
    n= uint16(boundy(i,2));
    if(judgeboundarypoint(m, n, boundy, L2) == false)
        result = [result; boundy(i,1), boundy(i,2)];
    end
end

end