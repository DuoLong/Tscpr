function pout = rcprTest1( Is, regModel, p, regPrm, iniData, ...
    verbose, corrindex, prunePrm)
% Apply robust cascaded shape regressor.
%
% USAGE
%  p = rcprTest1( Is, regModel, p, regPrm, bboxes, verbose, prunePrm)
%
% INPUTS
%  Is       - cell(N,1) input images
%  regModel - learned multi stage shape regressor (see rcprTrain)
%  p        - [NxDxRT1] initial shapes
%  regPrm   - struct with regression parameters (see regTrain)
%  iniData  - [Nx2] or [Nx4] bbounding boxes/initial positions
%  verbose  - [1] show progress or not 
%  prunePrm - [REQ] parameters for smart restarts 
%     .prune     - [0] whether to use or not smart restarts
%     .maxIter   - [2] number of iterations
%     .th        - [.15] threshold used for pruning 
%     .tIni      - [10] iteration from which to prune
%
% OUTPUTS
%  p        - [NxD] shape returned by multi stage regressor
%
% EXAMPLE
%
% See also rcprTest, rcprTrain
%
% Copyright 2013 X.P. Burgos-Artizzu, P.Perona and Piotr Dollar.  
%  [xpburgos-at-gmail-dot-com]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Simplified BSD License [see bsd.txt]
%
%  Please cite our paper if you use the code:
%  Robust face landmark estimation under occlusion, 
%  X.P. Burgos-Artizzu, P. Perona, P. Dollar (c)
%  ICCV'13, Sydney, Australia

% Apply each single stage regressor starting from shape p.
model=regModel.model; T=regModel.T; [N,D,RT1]=size(p);
p=reshape(permute(p,[1 3 2]),[N*RT1,D]);
imgIds = repmat(1:N,[1 RT1]); regs = regModel.regs;

%Get prune parameters
maxIter=prunePrm.maxIter;prune=prunePrm.prune;
th=prunePrm.th;tI=prunePrm.tIni;

%Set up data
p_t=zeros(size(p,1),D,T+1);p_t(:,:,1)=p;
if(model.isFace),bbs=iniData(imgIds,:,1);else bbs=[];end
done=0;Ntot=0;k=0;
N1=N;p1=p;imgIds1=imgIds;
%Iterate while not finished
while(~done)
    %Apply cascade
    tStart=clock;
    %If pruning is active, each loop returns the shapes of the examples
    %that passed the smart restart threshold (good) and 
    %those that did not (bad)
    tI=T;
    [good1,bad1,p_t1,p1]=cascadeLoop(Is,model,regModel,regPrm,T,N1,D,RT1,...
        p1,imgIds1,regs,tStart,iniData,bbs,verbose,...
        prune,1,th,tI);
    %Separate into good/bad (smart restarts)
    p_t(:,:,:)=p_t1;
    Ntot=Ntot+length(good1); done=Ntot==N; 
    p1=permute(reshape(p1,[N,RT1,D]),[1 3 2]);
    pgood=p1(good1,:,:);
    if(~done)
        %Keep iterating only on bad
        N1=length(bad1);
        pbad1=p1(bad1,:,:);
        pbad=zeros(N1,D);
%         for i=1:N1
%             pnlbp=pbad1(i,:,1:RT1/2);mdlbp=median(pnlbp,3);
%                %lbp variance=distance from median of all predictions
%             conflbp=shapeGt('dist',model,pnlbp,mdlbp);
%             dislbp(i,:)=mean(conflbp,3);
%             pnpose=pbad1(i,:,RT1/2+1:RT1);mdpose=median(pnpose,3);
%                %pose variance=distance from median of all predictions
%             confpose=shapeGt('dist',model,pnpose,mdpose);
%             dispose(i,:)=mean(confpose,3);
%         end
%         indlbp=find(dislbp<=dispose);
%         indpose=find(dislbp-0.25>dispose);
%         indboth=setdiff(1:N1,union(indlbp,indpose));
        
%          N2=length(indlbp);
%          k_num = 2;
%         for j=1:N2
%             X = reshape(pbad1(indlbp(j),:,:),D,RT1);
%             [Idx,~] = kmeans(X',k_num);
%             for k=1:k_num
%                 k_sum(k) = size(find(Idx==k),1);
%             end
%             indlbp1 = find(k_sum==max(k_sum));
%             for o =1:size(indlbp1,1)
%                 va_Idx=Idx==indlbp1(o);
%             end
%             pbad(indlbp(j),:) = median(pbad1(indlbp(j),:,va_Idx),3);
%         end
        

         k_num = 2;
        for j=1:N1
            X = reshape(pbad1(j,:,:),D,RT1);
            [Idx,~] = kmeans(X',k_num);
            for k=1:k_num
                k_sum(k) = size(find(Idx==k),1);
            end
            indlbp1 = find(k_sum==max(k_sum));
            for o =1:size(indlbp1,1)
                va_Idx=Idx==indlbp1(o);
            end
            pbad(j,:) = median(pbad1(j,:,va_Idx),3);
        end
              
%         for j=1:N1
%             X = reshape(pbad1(j,:,:),D,RT1);
%             [Idx,C,~] = kmeans(X',2);
%             indlbp1 = Idx==Idx(1);
%             pbad(j,:) = median(pbad1(j,:,indlbp1),3);
%         end

%         N2=length(indlbp);
%         variance1 = zeros(N2,RT1);
%         for j=1:N2
%             for i=1:RT1
%                 pnlbp1=pbad1(indlbp(j),:,1:i);mdlbp1=pnlbp1(1,:,1);
%                    %lbp variance=distance from median of all predictions
%                 conflbp1=shapeGt('dist',regModel.model,pnlbp1,mdlbp1);
%                 variance1(j,i)=mean(conflbp1,3);
%             end
%         end    
%         reliable1 = variance1<0.05;
%         reliable2 = (variance1(:,3:RT1)-variance1(:,2:RT1-1))<0;
%         lbp_reliable(:,1:2) = reliable1(:,1:2);
%         lbp_reliable(:,3:RT1) = reliable1(:,3:RT1)|reliable2;
%         lbp_reliable = lbp_reliable & variance1<0.15;
%          for j=1:N2 
%             pbad(indlbp(j),:)=median(pbad1(indlbp(j),:,lbp_reliable(j,:)),3);
%          end
         
%         N3=length(indpose);
%         variance2 = zeros(N3,RT1);
%         for j=1:N3
%             pnpose=pbad1(indpose(j),:,RT1/2+1:RT1);
%             pnpose(:,:,RT1/2+1:RT1)=pbad1(indpose(j),:,1:RT1/2);
%             for i=1:RT1
%                 pnpose1=pnpose(1,:,1:i);mdpose1=pnpose1(1,:,1);
%                    %lbp variance=distance from median of all predictions
%                 confpose1=shapeGt('dist',regModel.model,pnpose1,mdpose1);
%                 variance2(j,i)=mean(confpose1,3);
%             end
%         end       
%         reliable3 = variance2<0.05;
%         reliable4 = (variance2(:,3:RT1)-variance2(:,2:RT1-1))<0;
%         pose_reliable(:,1:2) = reliable3(:,1:2);
%         pose_reliable(:,3:RT1) = reliable3(:,3:RT1)|reliable4;
%         pose_reliable = pose_reliable & variance2<0.15;
%          for j=1:N3 
%             pbad(indpose(j),:)=median(pbad1(indpose(j),:,pose_reliable(j,:)),3);
%          end

%         pbad(indpose,:)=median(pbad1(indpose,:,RT1/2+1:RT1),3);
%         pbad(indboth,:)=median(pbad1(indboth,:,:),3);
        done=1;
        pout(bad1,:) = pbad;
    end
end
%reconvert p from [N*RT1xD] to [NxDxRT1]
 pout(good1,:) = median(pgood,3);
%p_t=permute(reshape(p_t,[N,RT1,D,T+1]),[1 3 2 4]);
end

%Apply full RCPR cascade with check in between if smart restart is enabled
function [good,bad,p_t,p]=cascadeLoop(Is,model,regModel,regPrm,T,N,D,RT1,p,...
    imgIds,regs,tStart,bboxes,bbs,verbose,prune,t0,th,tI)

p_t=zeros(size(p,1),D,T+1);p_t(:,:,1)=p;
good=1:N;bad=[];
for t=t0:T
    %Compute shape-indexed features
    ftrPos=regs(t).ftrPos;
    if(ftrPos.type>2)
        [ftrs,regPrm.occlD] = shapeGt('ftrsCompDup',model,p,Is,ftrPos,...
            imgIds,regModel.pStar,bboxes,regPrm.occlPrm);
    else
        [ftrs,regPrm.occlD] = shapeGt('ftrsCompIm',model,p,Is,ftrPos,...
            imgIds,regModel.pStar,bboxes,regPrm.occlPrm);
    end
    %Retrieve learnt regressors 
    regt=regs(t).regInfo;
    %Apply regressors
    p1=shapeGt('projectPose',model,p,bbs);
    pDel=regApply(p1,ftrs,regt,regPrm);
    p=shapeGt('compose',model,pDel,p,bbs);
    p=shapeGt('reprojectPose',model,p,bbs);
    p_t(:,:,t+1)=p;
% %     If reached checkpoint, check state of restarts   
    if((prune && T>=tI && t==tI))
       [p_t,p,good,bad]=checkState(p_t,model,imgIds,N,t,th,RT1);
%        if(isempty(good)),return; end
%        Is=Is(good);N=length(good);imgIds=repmat(1:N,[1 RT1]);
%        if(model.isFace),bboxes=bboxes(good,:);bbs=bboxes(imgIds,:);end
    end
    if((t==1 || mod(t,5)==0) && verbose)
        msg=tStatus(tStart,t,T);fprintf(['Applying ' msg]); 
    end
end
end

% function [p_t,p,good,bad,p2]=checkState(p_t,model,imgIds,N,t,th,RT1)
%     %Confidence computation=variance between different restarts
%     %If output has low variance and low distance, continue (good)
%     %ow recurse with new initialization (bad)
%     p=permute(p_t(:,:,t+1),[3 2 1]);conf=zeros(N,RT1);
%     corroccl=zeros(N,RT1);
%     for n=1:N
%         pn=p(:,:,imgIds==n);md=median(pn,3);
%         %variance=distance from median of all predictions
%         conf(n,:)=shapeGt('dist',model,pn,md);
%         poccl = permute(pn(1,model.nfids*2+1:end,:),[2 3 1]);
%         md=median(poccl,2);
%         corroccl1 = sqrt((poccl - repmat(md,[1 RT1])).^2);
%         corroccl(n,:) = mean(corroccl1,1);
%     end
%     dist=mean(conf,2);
%     distoccl = mean(corroccl,2);
%     bad=unique([find(dist>th);find(distoccl>th)]);
%     good=~ismember(1:N,bad);
%     good = find(good==1);
%     p2=p_t(ismember(imgIds,bad),:,t+1);
%     p_t=p_t(ismember(imgIds,good),:,:);p=p_t(:,:,t+1);
%     if(isempty(good)),return; end
% end
function [p_t,p,good,bad]=checkState(p_t,model,imgIds,N,t,th,RT1)
    %Confidence computation=variance between different restarts
    %If output has low variance and low distance, continue (good)
    %ow recurse with new initialization (bad)
    p=permute(p_t(:,:,t+1),[3 2 1]);conf=zeros(N,RT1);
    for n=1:N
        pn=p(:,:,imgIds==n);md=median(pn,3);
        %variance=distance from median of all predictions
        conf(n,:)=shapeGt('dist',model,pn,md);
    end
    dist=mean(conf,2);
    bad=find(dist>th);good=find(dist<=th);
%     p2=p_t(ismember(imgIds,bad),:,t+1);
%     p_t=p_t(ismember(imgIds,good),:,:);
    p=p_t(:,:,t+1);
%     if(isempty(good)),return; end
end

% function [p_t,p,good,bad]=checkState(p_t,model,imgIds,N,t,th,RT1)
%     %Confidence computation=variance between different restarts
%     %If output has low variance and low distance, continue (good)
%     %ow recurse with new initialization (bad)
%     p=permute(p_t(:,:,t+1),[3 2 1]);conf=zeros(N,RT1);
%     for n=1:N
%         pn=p(:,:,imgIds==n);
%         md=median(pn(:,:,:),3);
% %         mdlbp=median(pn(:,:,1:RT1/2),3);
%         %variance=distance from median of all predictions
%         conflbp(n,:)=shapeGt('dist',model,pn(:,:,1:RT1/2),md);
%         
% %         mdpose=median(pn(:,:,RT1/2+1:RT1),3);
%         %variance=distance from median of all predictions
%         confpose(n,:)=shapeGt('dist',model,pn(:,:,RT1/2+1:RT1),md);
%     end
%     dist(:,1)=mean(conflbp,2);
%     dist(:,2)=mean(confpose,2);
%     distdiff=abs(dist(:,1)-dist(:,2));
%     bad=find(distdiff>th*1);good=find(distdiff<=th*1);
% %     p2=p_t(ismember(imgIds,bad),:,t+1);
% %     p_t=p_t(ismember(imgIds,good),:,:);
%     p=p_t(:,:,t+1);
%     if(isempty(good)),return; end
% end

function msg=tStatus(tStart,t,T)
elptime = etime(clock,tStart);
fracDone = max( t/T, .00001 );
esttime = elptime/fracDone - elptime;
if( elptime/fracDone < 600 )
    elptimeS  = num2str(elptime,'%.1f');
    esttimeS  = num2str(esttime,'%.1f');
    timetypeS = 's';
else
    elptimeS  = num2str(elptime/60,'%.1f');
    esttimeS  = num2str(esttime/60,'%.1f');
    timetypeS = 'm';
end
msg = ['  [elapsed=' elptimeS timetypeS ...
    ' / remaining~=' esttimeS timetypeS ']\n' ];
end