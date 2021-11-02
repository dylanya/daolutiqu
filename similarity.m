function sim = similarity(mean1,mean2,standardD1,standardD2,area1,area2)
%计算相似性
    sigmap = ((area1-1)*standardD1.^2+(area2-1)*standardD2.^2)/(area1+area2-2);
    if(sigmap == 0 )
        sim  = 0;
    else
        sim = abs(mean1-mean2)/sqrt(sigmap*((1/mean1)+(1/mean2)));
    end
end