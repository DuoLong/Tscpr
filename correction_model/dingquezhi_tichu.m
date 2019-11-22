% a=[1 2 3
%    5 9 6 
%    3 2 9
%    1 2 3;
%    4 2 9];
% 
% [hang,lie]=find(a<5);
% [hang1,lie1]=find(a>=5);
% 
% median(a,2);
% clear all;
% load 'pRT.mat'
% load 'zhenjianJL1.mat'

%8->0.0637;9->0.0636;10->0.0635
%4->0.779;
load 'D:\文件\大改+20维+4-11\逻辑代码\定阙值+剔除异常数据+填补中间值\data\COFW_test.mat'
load 'D:\文件\大改+20维+4-11\逻辑代码\定阙值+剔除异常数据+填补中间值\models\rcpr_COFW.mat'
aa=zhenjianJL1;
aaa=pRT1;
[hang,lie,three]=find(aa<=5);
for i=1:256025
    liee(i)=mod(lie(i),29);
    threee(i)=floor(lie(i)/29)+1;
    if(liee(i)==0)
        liee(i)=29;
        threee(i)=floor(lie(i)/29);
    end
end
[hang1,lie1,three1]=find(aa>4.1);

for i=1:507
    for j=1:87
        for k=1:20
            aab(i,j,k)=5000;
        end
    end
end
   
liee=liee';
threee=threee';

         %第一步寻找到所有剩余中值
for i=1:256025
    ab(hang(i),liee(i),threee(i))=aa(hang(i),liee(i),threee(i));
    aab(hang(i),liee(i),threee(i))=aaa(hang(i),liee(i),threee(i));
    aab(hang(i),liee(i)+29,threee(i))=aaa(hang(i),liee(i)+29,threee(i));
    aab(hang(i),liee(i)+58,threee(i))=aaa(hang(i),liee(i)+58,threee(i));
end

for i=1:507
    for j=1:87
         t=0;
        for k=1:20  
              if(aab(i,j,k)~=5000)
                   t=t+1;
                  pp(i,j,t)=aab(i,j,k);
               end
        end
        %中值
        if t~=0
        zhong(i,j)=median(pp(i,j,1:t));
        end
        if t==0
            zhong(i,j)=median(aaa(i,j,1:20));
        end  
        %均值
    %    jun(i,j)=sum(pp(i,j,1:t))/t;
    end
        end

% for i=1:507
%     for j=1:87
%          t=0;
%         for k=1:20  
%               if(aab(i,j,k)~=5000)
%                    t=t+1;
%                   pp(i,j,t)=aab(i,j,k);
%                end
%         end
%         %中值
%         zhong(i,j)=zhong(i,j)
%         %均值
%         jun(i,j)=sum(pp(i,j,1:t))/t;
%     end
% end
        
        
for i=1:507
    for j=1:87
        for k=1:20
            if aab(i,j,k)==5000
                aab(i,j,k)=zhong(i,j);  %取中值
%                 aab(i,j,k)=jun(i,j);
            end                
        end
    end
end
result_zhong=aab;

ppp=0;
for i=1:507
    for j=1:87
        for k=1:20
            if result_zhong(i,j,k)==5000
                ppp=ppp+1;
            end                
        end
    end
end