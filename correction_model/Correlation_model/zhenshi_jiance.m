% for i=1:20
%     pCur0(:,:,i)=phisT;
% end

%求真实值与检测值的差值
for i=1:507
    for j=1:87
        for k=1:20
            zhenjian(i,j,k)=pCur0(i,j,k)-pCur(i,j,k);
        end
    end
end
for i=1:507
    for k=1:20
    for j=1:29
        
            zhenjianJL(i,j,k)=sqrt(zhenjian(i,j,k)*zhenjian(i,j,k)+zhenjian(i,j+29,k)*zhenjian(i,j+29,k));
        end
    end
end

for i=1:507
        for k=1:20
            sum(i,k)=0;
            avg(i,k)=0;
            for j=1:29
            sum(i,k)=sum(i,k)+zhenjianJL(i,j,k);
            end
        avg(i,k)=sum(i,k)/29;
    end
end