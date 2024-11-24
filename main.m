
clear all 
clc
load('3sources.mat');
dataname='3sources';  
    % datasets 'MSRC_v1','100Leaves','3sources','BBC','Reuters','Caltech10120'
%    p          5         9          4         9      7             8
%    a         0.001      0          10        1      0             10
 meanAC=[];
 meanMI=[];
 stdAC=[];
 stdMI=[];     
 p=4;
 alpha=10;
All_result=[];
 for h=1:10
  opts.maxIter=10; 
  opts.p=p;
  opts.alpha=alpha;
  opts.per=0.1;
  [V_final, testlabel, indices,obj] = MGOCS(X,Y,opts);
  V_final(indices,:)=[];              
  [~, label] = max(V_final');
  result =Clustering8Measure(testlabel, label);
 All_result=[All_result; result];
 end
        
mean(All_result,1);
std(All_result,1);