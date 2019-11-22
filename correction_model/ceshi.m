for i=1:5
for j=1:5
for k=1:5
   A(i,j,k)=rand(1);
end
end
end

[hang,lie,three]=find(A>0.5);
for i=1:51
    if(lie(i)/)
[aa,bb]=ind2sub(5,find(lie>0.5))
median(A,2)