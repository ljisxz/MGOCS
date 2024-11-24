function [revS, Dv, L] = createWs(X,p)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

view = length(X);
revS = cell(1,view);
Dv = cell(1,view);
L = cell(1,view);

for i=1:view
      options = [];
      options.Metric = 'Cosine';%  'Cosine' 'Euclidean';% 'Euclidean';'Cosine'
      options.NeighborMode = 'KNN';
      options.k = p;
      options.WeightMode ='Binary';%Cosine'; % 'HeatKernel''Binary''Cosine'
      options.t =1;%  sqrt(sigma/2);%0.7;%
      W = constructW(X{i},options);
%       W=mapminmax(W, 0, 1);
      
    %  W=mapminmax(W, 0, 1);
%        [A,~]= corr(X{i}','Type','Pearson');
%       % A=mapminmax(A, 0, 1);
% % % %       
%            W=A;
      %.....................
%       dist = EuDist2(X{i});
%        D = dist.^2;
%       sigma = mean(mean(dist));
%       sigma=sqrt(2);
%        sigma=2;
%       A = exp(D/(-sigma.^2));
% %      revS{i}=A;
% %       .......................
%      W=A;


      revS{i} = (W + W') / 2;    
      Dv{i} = diag(sum(revS{i},1));
      L{i} = Dv{i} - revS{i};
    
end

function D = EuDist2(fea_a,fea_b,bSqrt)
%EUDIST2 Efficiently Compute the Euclidean Distance Matrix by Exploring the

if ~exist('bSqrt','var')
    bSqrt = 1;
end

if (~exist('fea_b','var')) || isempty(fea_b)
    aa = sum(fea_a.*fea_a,2);
    ab = fea_a*fea_a';
    
    if issparse(aa)
        aa = full(aa);
    end
    
    D = bsxfun(@plus,aa,aa') - 2*ab;
    D(D<0) = 0;
    if bSqrt
        D = sqrt(D);
    end
    D = max(D,D');
else
    aa = sum(fea_a.*fea_a,2);
    bb = sum(fea_b.*fea_b,2);
    ab = fea_a*fea_b';

    if issparse(aa)
        aa = full(aa);
        bb = full(bb);
    end

    D = bsxfun(@plus,aa,bb') - 2*ab;
    D(D<0) = 0;
    if bSqrt
        D = sqrt(D);
    end
end






