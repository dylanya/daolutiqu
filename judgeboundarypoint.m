function judge = judgeboundarypoint(m, n, boundary, L2)
    count = 0;
    if (n+1<=size(L2,2) && L2(m,n+1) == 0)
        for i = 1: size(boundary, 1)
            if(boundary(i,1) == m && boundary(i,2) == n+1)
                count= count+1;
                break
            end
            
        end
    end
    if ( n-1 > 0 && L2(m,n-1) == 0)
        for i = 1:size(boundary, 1)
            if(boundary(i,1) == m && boundary(i,2) == n-1)
                count= count+1;
                break
            end
            
        end
    end 
    if (m+1 <=size(L2,1) && L2(m+1,n) == 0 )
        for i = 1:size(boundary, 1)
            if(boundary(i,1) == m+1 && boundary(i,2) == n)
                count= count+1;
                break
            end
            
        end
    end
    if (m-1>0 && L2(m-1,n) == 0)
        for i =1: size(boundary, 1)
            if(boundary(i,1) == m-1 && boundary(i,2) == n)
                count= count+1;
                break
            end
            
        end
    end
    
    if( count > 1 )
        judge = false;
    else
        judge = true;
    end
        
end