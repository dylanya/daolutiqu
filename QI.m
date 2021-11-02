rgb=imread('zhengz3a.tif');
if ndims(rgb)==3
    I=rgb2gray(rgb);
else
    I=rgb;
end
% I=histeq(I);
figure('units','normalized','position',[0 0 1 1]);
subplot(2,2,1);imshow(rgb);title('原图');
subplot(2,2,2);imshow(I,[]);title('灰度图像');
% subplot(2,2,3);imshow(I,[]);title('直方图均衡化');
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I),hy,'replicate');
Ix = imfilter(double(I),hx,'replicate');
gradmag = sqrt(Ix.^2+Iy.^2);
%%
g2 = imclose(imopen(gradmag, ones(3,3)), ones(3,3));
L2 = watershed(g2);
L2 = padarray(L2,[1,1],0);
I = padarray(I,[1,1],0);
rgb = padarray(rgb,[1,1],0);
wr2 = L2 == 0;
f2 = I;
f2(wr2) = 255;
% figure('units','normalized','position',[0 0 1 1]);
% subplot(1,2,1);imshow(f2);title('f2');
% subplot(1,2,2);imshow(wr2);title('wr2');

%%
% %将分水岭分割图像叠加到原图
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
It1(wr2)=0;
It2(wr2)=255;
It3(wr2)=0;
I2 = cat(3,It1,It2,It3);
figure
imshow(I2);title('叠加到原图');

%%
% L2 = padarray(L2,[1,1],0);
% I = padarray(I,[1,1],0);
% rgb = padarray(rgb,[1,1],0);
% % 每次合并完之后叠加到原图上输出
% wr2 = L2 == 0;
% f2 = I;
% f2(wr2) = 255;
% %将分水岭分割图像叠加到原图
% It1 = rgb(:,:,1);
% It2 = rgb(:,:,2);
% It3 = rgb(:,:,3);
% It1(wr2)=0;
% It2(wr2)=255;
% It3(wr2)=0;
% I2 = cat(3,It1,It2,It3);
% figure('units','normalized','position',[0 0 1 1]);
% imshow(I2);title('叠加到原图');
%%
%查看每个区域的面积,质心，像素数，周长,最小外接矩形
%最小外接矩形，例如，值为 [5.5 8.5 11 14] 的二维边界框表示外接框左上角 (x,y) 坐标为 (5.5, 8.5)，框的水平宽度为 11 个像素，垂直高度为 14 个像素。
% s = regionprops(L2,'Area','Centroid','ConvexArea','Perimeter','BoundingBox');
% s2 = regionprops(L2,I,'MeanIntensity');

%%
%创建RAG区域邻接图
[n, e] = imRAG(L2);
% hold on;
% for i=1:size(e, 1) %e有多少行,size是查询长度，size(e, 1)查询e的第一维的长度，第一维是行，第二维是列
% plot(n(e(i,:), 1), n(e(i,:), 2), 'linewidth', 2, 'color', 'red'); %：是取所以数据， (n(e(i,:), 1)得到n的第一列
% end
% plot(n(:,1), n(:,2), 'bo');
%%
%论文上写面积除以4，是它的真实面积，代码里面不用除。
boundary = input('boundary = ');
MEAN = input('MEAN= ');
mark = true;

%修改下面遍历过程，用blocks的方式遍历，而不是遍历所有的L2点
while mark
    if (size(L2,1) ~= size(I,1) || size(L2,2) ~= size(I,2))
        return
    end
    s = regionprops(L2,I,'Area','MeanIntensity','PixelList');
    blocks = unique(L2);
    blocks = blocks(2:end);
    mean = [s(:).MeanIntensity];
    area = [s(:).Area];
    for i = 1:size(blocks,1)
        jump  = false;
        near = getNearBy(blocks(i),e);
        mean1 = mean(blocks(i));
        for j = 1:size(near,2)
            nearA = find(blocks==near(j));
            mean2 = mean(near(j));
            g1 = abs(mean1-mean2);

           if(area(near(j))<= boundary && g1 <= MEAN )
                block = blocks(i);
                points1 = s(block).PixelList;
                points2 = s(blocks(nearA)).PixelList;
                L2 = regionmerging(points1,points2,block,L2);
                [n, e] = imRAG(L2);
                s = regionprops(L2,I,'Area','MeanIntensity','PixelList');
                jump = true;
                break;
            end
            
            if(jump == false && i==size(blocks,1))
                mark=false;
            end
            if(jump==true)
                break;
            end
        end
    end
end

% 每次合并完之后叠加到原图上输出
wr2 = L2 == 0;
f2 = I;
f2(wr2) = 255;
%将分水岭分割图像叠加到原图
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
It1(wr2)=0;
It2(wr2)=255;
It3(wr2)=0;
I2 = cat(3,It1,It2,It3);
figure('units','normalized','position',[0 0 1 1]);
imshow(I2);title('叠加到原图');

%查看合并后区域个数,A1个数要减去1，因为里面有个0
A1 = unique(L2);

% L2 = clearZero(L2);
% % 每次合并完之后叠加到原图上输出
% wr2 = L2 == 0;
% f2 = I;
% f2(wr2) = 255;
% %将分水岭分割图像叠加到原图
% It1 = rgb(:,:,1);
% It2 = rgb(:,:,2);
% It3 = rgb(:,:,3);
% It1(wr2)=0;
% It2(wr2)=255;
% It3(wr2)=0;
% I2 = cat(3,It1,It2,It3);
% figure('units','normalized','position',[0 0 1 1]);
% imshow(I2);title('叠加到原图');

%%
% similarityB = input('similarityB = ');
[n, e] = imRAG(L2);
mark2 = true;
while mark2
    s2 = regionprops(L2,I,'MeanIntensity','PixelList');
    s3 = regionprops(L2,It3,'MeanIntensity');
    blocks = unique(L2);
    blocks = blocks(2:end);
    mean = [s3(:).MeanIntensity];
    for i = 1:size(blocks,1)
        jump  = false;
        near = getNearBy(blocks(i),e);
        mean1 = mean(blocks(i));
        P1 = glcm(I,blocks(i),L2);
            v1 = 0;
            for m = 1:size(P1,1)
                for n = 1:size(P1,2)
                    v1 = v1 + P1(m,n)/(1+(m-n)^2);
                end
            end
        for j = 1:size(near,2)
            nearA = find(blocks==near(j));
            mean2 = mean(near(j));
            P2 = glcm(I,blocks(nearA),L2);
            v2 = 0;
            for m = 1:size(P2,1)
                for n = 1:size(P2,2)
                    v2 = v2 + P2(m,n)/(1+(m-n)^2);
                end
            end
            if(0.867 <= v1 && v1 <= 1 && 0.867 <= v2 && v2 <= 1 && mean1 <= 120 && mean2 <= 120)
                block = blocks(i);
                points1 = s2(block).PixelList;
                points2 = s2(blocks(nearA)).PixelList;
                L2 = regionmerging(points1,points2,block,L2);
                [n, e] = imRAG(L2);
                s2 = regionprops(L2,I,'MeanIntensity','PixelList');
                s3 = regionprops(L2,It3,'MeanIntensity');
                jump = true;
                break;
            end
        end
        if(jump == false && i==size(blocks,1))
                mark2=false;
                
        end
        
        if(jump == true)
           break; 
            
        end
    end
end

%去除小像素
% L2 = clearZero(L2);

% 每次合并完之后叠加到原图上输出
wr2 = L2 == 0;
f2 = I;
f2(wr2) = 255;
% figure('units','normalized','position',[0 0 1 1]);
% subplot(1,2,1);imshow(f2);title('f2');
% subplot(1,2,2);imshow(wr2);title('wr2');
%将分水岭分割图像叠加到原图
It1 = rgb(:,:,1);
It2 = rgb(:,:,2);
It3 = rgb(:,:,3);
It1(wr2)=0;
It2(wr2)=255;
It3(wr2)=0;
I2 = cat(3,It1,It2,It3);
figure('units','normalized','position',[0 0 1 1]);
imshow(I2);title('叠加到原图');

%查看合并后区域个数,A1个数要减去1，因为里面有个0
A2 = unique(L2);