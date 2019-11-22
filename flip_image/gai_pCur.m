for i=1:26900
    k=mod(i,1345);
    if(k==0)
        k=1345;
    end
    len11(i)=length(IsTr{k,1}(1,:));
end

for i=1:26900
    for j=1:29
        pCur1(i,j)=len11(i)-pCur(i,j);
    end
     pCur1(i,30:87)=pCur(i,30:87);
end