%function [samp1,samp2]=kmeans(samp); % 作为调用函数时去掉注释符
 clear all;
close all;
clc;


samp=[11.1506    6.7222    2.3139    5.9018   11.0827    5.7459   13.2174   13.8243    4.8005    0.9370   12.3576];  %样本集
[l0 l]=size(samp);
 
%利用均值把样本分为两类，再将每类的均值作为聚类中心
th0=mean(samp);
n1=0;n2=0;
c1=0.0;
c1=double(c1);
c2=c1;
for i=1:l
    if samp(i)<th0
        c1=c1+samp(i);n1=n1+1;
    else
        c2=c2+samp(i);n2=n2+1;
    end
end
c1=c1/n1;c2=c2/n2; %初始聚类中心
 
t=0;
cl1=c1;cl2=c2;
c11=c1;c22=c2; %聚类中心
while t==0
    samp1=zeros(1,l);
    samp2=samp1;
    n1=1;n2=1;
    for i=1:l
        if abs(samp(i)-c11)<abs(samp(i)-c22)
            samp1(n1)=samp(i);
            cl1=cl1+samp(i);n1=n1+1;
            c11=cl1/n1;
        else
            samp2(n2)=samp(i);
            cl2=cl2+samp(i);n2=n2+1;
            c22=cl2/n2;
        end
    end
    if c11==c1 && c22==c2
        t=1;
    end
    cl1=c11;cl2=c22;
    c1=c11;c2=c22;
end  %samp1,samp2为聚类的结果。
