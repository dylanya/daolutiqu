function L2 = regionmerging(points1,points2,block,L2)
% 合并去除边界
pointA1 = bound(points1,L2);
pointA2 = bound(points2,L2);
boundy = adjacency(pointA1,pointA2,L2);
% boundy
% block
% L2(uint16(points2(1,2)),uint16(points2(1,1)))
for i = 1:size(points2,1)
    m = uint16(points2(i,2));
    n = uint16(points2(i,1));
    L2(m,n) = block;
    
end
for j = 1:size(boundy,1)
    p = uint16(boundy(j,1));
    q = uint16(boundy(j,2));
    L2(p,q) = block;
end

end
