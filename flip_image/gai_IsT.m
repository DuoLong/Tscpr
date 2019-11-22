len=length(IsT);
IsT1=cell(507,1);
for i=1:len
    len1(i)=length(IsT{i,1}(1,:));
   % len2(i)=floor(len1(i)/2);
    for j=1:len1(i)
        p=len1(i)-j+1;
        IsT1{i,1}(:,j)=IsT{i,1}(:,p);
      
    end
end