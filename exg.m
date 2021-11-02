function EXG = exg(image_1,image_2,image_3,L,block)
%计算EXG值
s2 = regionprops(L,image_1,'MeanIntensity');
s3 = regionprops(L,image_2,'MeanIntensity');
s4 = regionprops(L,image_3,'MeanIntensity');
meanRM = [s2(:).MeanIntensity];
meanGM = [s3(:).MeanIntensity];
meanBM = [s4(:).MeanIntensity];
blocks = unique(L);
blocks = blocks(2:end);

EXG = [];
for i = 1:size(blocks,1)
    meanR = meanRM(blocks(i));
    meanG = meanGM(blocks(i));
    meanB = meanBM(blocks(i));
    result = 2 * meanG - meanR - meanB;
    EXG = [EXG,result];
end