% Copyright 2013 X.P. Burgos-Artizzu, P.Perona and Piotr Dollar.  
%  [xpburgos-at-gmail-dot-com]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Simplified BSD License [see bsd.txt]
%
%  Please cite our paper if you use the code:
%  Robust face landmark estimation under occlusion, 
%  X.P. Burgos-Artizzu, P. Perona, P. Dollar (c)
%  ICCV'13, Sydney, Australia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For pre-requisites and compilation, see CONTENTS.m
%
% This code trains and tests RCPR on COFW dataset. 
%  COFW is composed of two files (data/COFW_train.mat, data/COFW_test.mat) 
%  which contain:  
%    -phisTr,phisT - ground truth shapes (train/test)
%    -IsTr,IsT - images (train/test)
%    -bboxesTr, bboxesT - face bounding boxes (train/test)
%  If you change path to folder containing training/testing files, change
%  this variable here:
% RandStream.getGlobalStream.reset();
clear;
COFW_DIR='./data/';
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD COFW dataset
% training/testing images and ground truth
trFile=[COFW_DIR 'COFW_trainc.mat'];
testFile=[COFW_DIR 'COFW_test.mat'];
% Load files
load(trFile,'phisTr','IsTr','bboxesTr','faceTr');bboxesTr=round(bboxesTr);
load(testFile,'phisT','IsT','bboxesT','faceT');bboxesT=round(bboxesT);
nfids=size(phisTr,2)/3;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET UP PARAMETERS
%Choose algorithm to use
% cpr_type=1 (reimplementation of Cao et al.)
% cpr_type=2 RCPR (features+restarts)
% cpr_type=3 RCPR (full)
cpr_type=3;
if(cpr_type==1)
    %Remove occlusion information
    phisTr=phisTr(:,1:nfids*2);phisT=phisT(:,1:nfids*2);
    %Create LFPW model (29 landmarks without visibility)
    model = shapeGt('createModel','lfpw');
    %CPR for face PARAMETERS (Cao et al. CVPR12)
    %(type 2, points relative to closest landmark)
    T=100;K=50;L=20;RT1=5;
    ftrPrm = struct('type',2,'F',400,'nChn',1,'radius',1);
    prm=struct('thrr',[-1 1]/5,'reg',.01);
    occlPrm=struct('nrows',3,'ncols',3,'nzones',1,'Stot',1,'th',.5);
    regPrm = struct('type',1,'K',K,'occlPrm',occlPrm,...
        'loss','L2','R',0,'M',5,'model',model,'prm',prm);
    prunePrm=struct('prune',0,'maxIter',2,'th',0.1,'tIni',10);
elseif(cpr_type==2)
    %Remove occlusion information
    phisTr=phisTr(:,1:nfids*2);phisT=phisT(:,1:nfids*2);
    %Create LFPW model (29 landmarks without visibility)
    model = shapeGt('createModel','lfpw');
    %RCPR(features+restarts) PARAMETERS
    %(type 4, points relative to any 2 landmarks)
    T=100;K=50;L=20;RT1=5;
    ftrPrm = struct('type',4,'F',400,'nChn',1,'radius',1.5);
    prm=struct('thrr',[-1 1]/5,'reg',.01);
    occlPrm=struct('nrows',3,'ncols',3,'nzones',1,'Stot',1,'th',.5);
    regPrm = struct('type',1,'K',K,'occlPrm',occlPrm,...
        'loss','L2','R',0,'M',5,'model',model,'prm',prm);
    %smart restarts are enabled
    prunePrm=struct('prune',1,'maxIter',2,'th',0.1,'tIni',10);
    %remove occlusion information
    phisTr=phisTr(:,1:nfids*2);phisT=phisT(:,1:nfids*2);
    %Create LFPW model (29 landmarks without visibility)
    model = shapeGt('createModel','lfpw');
elseif(cpr_type==3)
    %Create COFW model (29 landmarks including visibility)
    model = shapeGt('createModel','cofw');
    %RCPR (full) PARAMETERS
    %(type 4, points relative to any 2 landmarks)
    T=100;K=15;L=20;RT1=20;
    ftrPrm = struct('type',4,'F',400,'nChn',1,'radius',1.5);
    prm=struct('thrr',[-1 1]/5,'reg',.01);
    %Stot=3 regressors to perform occlusion weighted median
    occlPrm=struct('nrows',3,'ncols',3,'nzones',1,'Stot',4,'th',.5);
    regPrm = struct('type',1,'K',K,'occlPrm',occlPrm,...
        'loss','L2','R',0,'M',5,'model',model,'prm',prm);
    %smart restarts are enabled
    prunePrm=struct('prune',1,'maxIter',1,'th',0.08,'tIni',10);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRAIN
%Initialize randomly L shapes per training image
% IsTrlbp = getlbp(IsTr(num));
% faceTr = getface(IsTrlbp,bboxesTr);
% faceTrlbpHist = getlbpHist(faceTr(num));
load('faceTrlbpHist.mat','faceTrlbpHist');
[pCur,pGt,pGtN,pStar,imgIds,N,N1]=shapeGt('initTr',...
    IsTr,faceTrlbpHist,phisTr,model,[],bboxesTr,L,10);
load('mean_initialTr20_2.mat','initialTr');
load('errorindextr20.mat','Tr_erindex');
initialTr(Tr_erindex,:) = pCur(Tr_erindex,:);
% seedt = randperm(20);
% load('0.0663seed.mat','seedt');
% for se=1:L/2
% pCur(1345*(L/2+se-1)+1:1345*(L/2+se),1:58)= initialTr(1345*(seedt(se)-1)+1:1345*seedt(se),1:58);
% end
pCur(:,1:58)= initialTr(:,1:58);
initData=struct('pCur',pCur,'pGt',pGt,'pGtN',pGtN,'pStar',pStar,...
    'imgIds',imgIds,'N',N,'N1',N1);
%Create training structure
trPrm=struct('model',model,'pStar',[],'posInit',bboxesTr,...
    'T',T,'L',L,'regPrm',regPrm,'ftrPrm',ftrPrm,...
    'pad',10,'verbose',1,'initData',initData);
%Train model
[regModel,~] = rcprTrain(IsTr,phisTr,trPrm);
regModel.faceTrlbpHist = faceTrlbpHist;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TEST
%Initialize randomly using RT1 shapes drawn from training
t=clock;
% IsTlbp = getlbp(IsT);
% faceT = getface(IsT,bboxesT);
% faceTlbpHist = getlbpHist(faceT);
load('faceTlbpHist.mat','faceTlbpHist');
[p, corrindexT]=shapeGt('initTest',faceTrlbpHist,faceTlbpHist,bboxesT,model,pStar,pGtN,RT1);
load('mean_initialT20_2.mat','initialT');
load('errorindext20.mat','T_erindex');
for i=1:RT1
initialT(T_erindex(:,i),:,i)=p(T_erindex(:,i),:,i);
end
% p(:,1:58,RT1/2+1:RT1)= initialT(:,1:58,seedt(1:RT1/2));
p(:,1:58,:)= initialT(:,1:58,:);
%Create test struct
testPrm = struct('RT1',RT1,'pInit',bboxesT,...
    'regPrm',regPrm,'initData',p,'prunePrm',prunePrm,...
    'verbose',1);
%Test
p = rcprTest(IsT,regModel,corrindexT,testPrm);t=etime(clock,t);
%Round up the pixel positions
p(:,1:nfids*2)=round(p(:,1:nfids*2));
% If rcpr_type=3, use threshold computed during training to 
% binarize occlusion
if(cpr_type==3)
    occl=p(:,(nfids*2)+1:end);
    %Compute occlusion precisions and recall
occll = occl;
 th=-2:.01:2;
 pre2=zeros(length(th),1);
 recall2=zeros(length(th),1);
 for i=1:length(th)
     occll(occl>=th(i))=1;occll(occl<th(i))=0;
     p(:,(nfids*2)+1:end)=occll;
     realOccl = phisT(:,nfids*2+1:end);
     testOccl = p(:,nfids*2+1:end);
     realind = find(realOccl==1);
     testind = find(testOccl==1);
     pre2(i) = length(find(realOccl(testind)==1))/numel(testind);
     recall2(i) = length(find(realOccl(testind)==1))/numel(realind);
 end
 save 210 pre2 recall2;
    
    occl(occl>=regModel.th)=1;occl(occl<regModel.th)=0;
    p(:,(nfids*2)+1:end)=occl;
end
%Compute loss
loss = shapeGt('dist',regModel.model,p,phisT);
fprintf('--------------DONE\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DISPLAY Standard histogram of errors
figure(1),clf,
mu1=mean(loss(loss<0.1));muAll=mean(loss);
fail=100*length(find(loss>0.1))/length(loss);
bins=log10(min(loss)):0.1:log10(max(loss));ftsz=20;
[n,b]=hist(log10(loss),bins); n=n./sum(n);
semilogx(10.^b,n,'b','LineWidth',3);
hold on,plot(zeros(10,1)+2.5,linspace(0,max(n),10),'--k');
ticks=[0 linspace(min(loss),max(loss)/4,5) ...
    linspace((max(loss)/3),max(loss),3)];
ticks=round(ticks*100)/100;
set(gca,'XTick',ticks,'FontSize',ftsz);
xlabel('error','FontSize',ftsz);ylabel('probability','FontSize',ftsz),
title(['Mean error=' num2str(muAll,'%0.2f') '   ' ...
    'Mean error (<0.1)=' num2str(mu1,'%0.2f') '   ' ...
    'Failure rate (%)=' num2str(fail,'%0.2f')],'FontSize',ftsz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VISUALIZE Example results on a test image
figure(3),clf,
nimage=12;
%Ground-truth
subplot(1,2,1),
shapeGt('draw',model,IsT{nimage},phisT(nimage,:),{'lw',20});
title('Ground Truth');
%Prediction
subplot(1,2,2),shapeGt('draw',model,IsT{nimage},p(nimage,:),...
    {'lw',20});
title('Prediction');