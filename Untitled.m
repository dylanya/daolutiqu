% L = padarray(L,[1,1],0);
% f_ori = padarray(f_ori,[1,1],0);
% I=rgb2gray(f_ori);
% [n, e] = imRAG(L);
% s = regionprops(L,I,'Area','MeanIntensity','PixelList');
% s2 = regionprops(L,image_1,'MeanIntensity');
% s3 = regionprops(L,image_2,'MeanIntensity');
% s4 = regionprops(L,image_3,'MeanIntensity');
% mean = [s(:).MeanIntensity];
% area = [s(:).Area];
% meanR = [s2(:).MeanIntensity];
% meanG = [s3(:).MeanIntensity];
% meanB = [s4(:).MeanIntensity];
% meanR1 = meanR(blocks(i));
% meanG1 = meanG(blocks(i));
% meanB1 = meanB(blocks(i));
% EXG = 2 * meanG1 - meanR1 - meanB1;
% NGBDI = (meanG1 - meanB1)/(meanG1 + meanB1);
% P1 = glcm(I,blocks(i),L);
% v1 = 0;
% for m = 1:size(P1,1)
%     for n = 1:size(P1,2)
%         v1 = v1 + P1(m,n)/(1+(m-n)^2);
%     end
% end
% mean1 = mean(blocks(i));
% area1 = area(blocks(i));
% mean2 = mean(blocks(j));
% area2 = area(blocks(j));
% SVD = (mean1 - mean2)^2 * (area1 * area2) ./ (area1 + area2);
%%
I=rgb2gray(f_ori);
[n, e] = imRAG(L);
mark2 = true;
while mark2
    s = regionprops(L,I,'MeanIntensity','PixelList');
    blocks = unique(L);
    blocks = blocks(2:end);
    mean = [s(:).MeanIntensity];
    EXG = exg(image_1,image_2,image_3,L);
    for i = 1:size(blocks,1)
        jump  = false;
        near = getNearBy(blocks(i),e);
        mean1 = mean(blocks(i));
        EXG1 = EXG(blocks(i));
        P1 = glcm(I,blocks(i),L);
            v1 = 0;
            for m = 1:size(P1,1)
                for n = 1:size(P1,2)
                    v1 = v1 + P1(m,n)/(1+(m-n)^2);
                end
            end
        for j = 1:size(near,2)
            nearA = find(blocks==near(j));
            mean2 = mean(near(j));
            EXG2 = EXG(near(j));
            P2 = glcm(I,blocks(nearA),L);
            v2 = 0;
            for m = 1:size(P2,1)
                for n = 1:size(P2,2)
                    v2 = v2 + P2(m,n)/(1+(m-n)^2);
                end
            end
            v = abs(v1 - v2);
            if(v <=0.15 && EXG1 <= 6 && EXG2 <=6)
                block = blocks(i);
                points1 = s(block).PixelList;
                points2 = s(blocks(nearA)).PixelList;
                L = regionmerging(points1,points2,block,L);
                [n, e] = imRAG(L);
                s = regionprops(L,I,'MeanIntensity','PixelList');
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
T = find(L==0);image = f_ori; 
image_1=image(:,:,1);image_2=image(:,:,2);image_3=image(:,:,3);
image_1(T)=0;image_2(T)=255;image_3(T)=0;
image(:,:,1)=image_1;image(:,:,2)=image_2;image(:,:,3)=image_3;
figure, imshow(image);
%%