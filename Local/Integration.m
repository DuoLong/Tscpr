% 
% loss = shapapeGt('dist',regModel.model,pappap,paphisT);
% fpaprintf('--------------DONE\n');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% DISpapLAY Standard histogram of errors
% figure(1),clf,
% mu1=mean(loss(loss<0.1));muAll=mean(loss);

% load 'pap1.mat'
% load 'pap2.mat'
% load 'pap3.mat'
% load 'pap4.mat'
% 
% pappap(:,[23 24 25 26 27 28 29 52 53 54 55 56 57 58 81 82 83 84 85 86 87])=pap4;
% pappap(:,[1 3 5 6 9 11 13 14 17 30 32 34 35 38 40 42 43 46 59 61 63 64 67 69 71 72 75])=pap1;
% pappap(:,[2 4 7 8 10 12 15 16 18 31 33 36 37 39 41 44 45 47 60 62 65 66 68 70 73 74 76])=pap2;
% pappap(:,[19 20 21 22 48 49 50 51 77 78 79 80])=pap3;
load 'pap1.mat'
load 'pap2.mat'
load 'pap3.mat'
load 'pap4.mat'

pap(:,[23 24 25 26 27 28 29 52 53 54 55 56 57 58 81 82 83 84 85 86 87])=pap4;
pap(:,[1 3 5 6 9 11 13 14 17 30 32 34 35 38 40 42 43 46 59 61 63 64 67 69 71 72 75])=pap1;
pap(:,[2 4 7 8 10 12 15 16 18 31 33 36 37 39 41 44 45 47 60 62 65 66 68 70 73 74 76])=pap2;
pap(:,[19 20 21 22 48 49 50 51 77 78 79 80])=pap3;