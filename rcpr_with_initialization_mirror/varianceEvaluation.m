load('models/0.0672.mat','regModel','regPrm','prunePrm');
load('plbp.mat','plbp')
N2=size(plbp,1);
variance = zeros(N2,10);
for j=1:N2
    for i=1:10
        pnlbp1=plbp(j,:,1:i);mdlbp1=pnlbp1(1,:,1);
           %lbp variance=distance from median of all predictions
        conflbp1=shapeGt('dist',regModel.model,pnlbp1,mdlbp1);
        variance(j,i)=mean(conflbp1,3);
    end
end