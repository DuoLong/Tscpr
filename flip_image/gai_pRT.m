

for i=1:20
    for j=1:507
        len22(j)=length(IsT{j,1}(1,:));
        for k=1:29
            pRT1(j,k,i)=len22(j)-pRT(j,k,i);
        end
        pRT1(j,30:87,i)=pRT(j,30:87,i);
    end
end
            