%%
%合并非道路
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
            if ((v1 < 0.867 || v1 > 1) && (v2 < 0.867 || v2 > 1) || (mean1 < 70 || mean1 > 120) && (mean2 < 70 || mean2 > 120))
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
A3 = unique(L2);

%%
% similarityB = input('similarityB = ');
[n, e] = imRAG(L2);
mark2 = true;
while mark2
    s2 = regionprops(L2,I,'MeanIntensity','PixelList');
    blocks = unique(L2);
    blocks = blocks(2:end);
    mean = [s2(:).MeanIntensity];
    for i = 1:size(blocks,1)
        jump  = false;
        near = getNearBy(blocks(i),e);
        mean1 = mean(blocks(i));
%         P1 = glcm(I,blocks(i),L2);
%             v1 = 0;
%             for m = 1:size(P1,1)
%                 for n = 1:size(P1,2)
%                     v1 = v1 + P1(m,n)/(1+(m-n)^2);
%                 end
%             end
        for j = 1:size(near,2)
            nearA = find(blocks==near(j));
            mean2 = mean(near(j));
%             P2 = glcm(I,blocks(nearA),L2);
%             v2 = 0;
%             for m = 1:size(P2,1)
%                 for n = 1:size(P2,2)
%                     v2 = v2 + P2(m,n)/(1+(m-n)^2);
%                 end
%             end
            if (mean1 < 80 && mean2 < 80)
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
A4 = unique(L2);

