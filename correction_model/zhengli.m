%���ڵ�Ŀ����סС��10�飬ɾ�����10�飬���ɾ�ֵ
prt=pRT;
for i=1:507
    for j=1:29   %����ÿһ�����������
        
        for k=1:19
            t=1;
            for kk=k+1:20
                if (zhenjianJL1(i,j,k)>zhenjianJL1(i,j,kk))
                    ppzhen=zhenjianJL1(i,j,kk);
                    zhenjianJL1(i,j,kk)=zhenjianJL1(i,j,k);
                    zhenjianJL1(i,j,k)=ppzhen;
                    ppzhen1=prt(i,j,kk);
                    prt(i,j,kk)=prt(i,j,k);
                    prt(i,j,k)=ppzhen1;
                    ppzhen2=prt(i,j+29,kk);
                    prt(i,j+29,kk)=prt(i,j+29,k);
                    prt(i,j+29,k)=ppzhen2;
                    ppzhen3=prt(i,j+58,kk);
                    prt(i,j+58,kk)=prt(i,j+58,k);
                    prt(i,j+58,k)=ppzhen3;
                end
            end
        end
    end
end

