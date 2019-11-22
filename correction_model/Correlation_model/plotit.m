plot(avg1(:,13),avg(:,13),'r.');
grid on
xlabel("Mirror error em");
ylabel("Alignment error  qea");
title("Correlation Coefficient is 0.8949")
for i=1:20
    sum(i)=0;
    sum1(i)=0;
    for j=1:507
        sum(i)=sum(i)+avg(j,i);
        sum1(i)=sum1(i)+avg1(j,i);
    end
end
for i=1:20
    p(i)= myPearson(avg1(:,i),avg(:,i))
end