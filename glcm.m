function P = glcm(img, block, L2)
img = histeq(img);
gray_leave = 256 ;%灰度级数
gray_leave_com = 16 ;%压缩后灰度级数
dx = 1 ; dy = 1 ;%搜寻灰度步进长度
[L,W] = size(img);%图片的尺寸，L长 ，W宽
%--------------------------------------------------------------------------
%2.为了减少计算量，对原始图像灰度级压缩，将img量化成16级
%--------------------------------------------------------------------------

for i = 1 : L
    for j = 1 : W
        for n = 1 : gray_leave_com
            if (n-1)*(gray_leave/gray_leave_com) <= img(i ,j)  &&  img(i ,j)<= (n-1)*(gray_leave/gray_leave_com )+(gray_leave/gray_leave_com )-1
                img(i ,j) = n-1;
             
            end
        end
    end
end

%--------------------------------------------------------------------------
%3.计算四个共生矩阵P,取距离为1，角度分别为0,45,90,135
%--------------------------------------------------------------------------
P = zeros(gray_leave_com,gray_leave_com,4);

for m = 1 : gray_leave_com
    for n  = 1 : gray_leave_com
        for i = 1 : L
            for j = 1 : W     
                if (j<W && img(i , j) == m-1 && img(i ,j+dy) ==n-1 && L2(i,j) == block && L2(i ,j+dy) == block) %角度为0
                    P(m , n , 1) = P(m, n ,1) + 1 ;
                end
%                 if (i<L && j<W && img(i , j) == m-1 && img(i +dx ,j+dy) ==n-1) %角度为45
%                     P(m , n , 2) = P(m, n ,2) + 1;
%                 end
%                 if (i<L && img(i , j) == m-1 && img(i +dx ,j) ==n-1) %角度为90
%                     P(m , n , 3) = P(m, n ,3) + 1;
%                 end
%                 if ( j>1 && i<L && img(i , j) == m-1 && img(i +dx ,j - dy ) ==n-1) %角度为135
%                     P(m , n , 4) = P(m, n ,4) + 1;
%                 end
            end
        end
    end
end
%%---------------------------------------------------------
% 对共生矩阵归一化
%%---------------------------------------------------------
for n=1:4
    P(:,:,n)=P(:,:,n)/sum(sum(P(:,:,n)));
end
