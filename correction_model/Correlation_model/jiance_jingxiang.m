

%求检测值与镜像值的差值
for i=1:26900
    for j=1:87
        for k=1:20
            zhenjian1(i,j,k)=pCur(i,j,k)-pCur1(i,j,k);
        end
    end
end
for i=1:507
    for k=1:20
    for j=1:29
        
            zhenjianJL1(i,j,k)=sqrt(zhenjian1(i,j,k)*zhenjian1(i,j,k)+zhenjian1(i,j+29,k)*zhenjian1(i,j+29,k));
        end
    end
end

for i=1:507
        for k=1:20
            sum1(i,k)=0;
            avg1(i,k)=0;
            for j=1:29
            sum1(i,k)=sum1(i,k)+zhenjianJL1(i,j,k);
            end
        avg1(i,k)=sum1(i,k)/29;
    end
end
