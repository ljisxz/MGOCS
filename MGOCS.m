function [V, testlabel, indices,Obj] = MGOCS(X,Y,opts)
Obj=[];
k = length(unique(Y));  % class number
n = length(Y);  % sample number
view = length(X);   % view number 
per=opts.per; % percentage label information (0-1)
p=opts.p;
alpha=opts.alpha;
maxIter=opts.maxIter; 
[indices,count]=SelLabSam_Semi_2(Y,per);
ind=[1:1:n];
ind(indices)=[];
testlabel=Y(ind);
Y=[Y(indices);testlabel];
 for i=1:view
      temp= X{i};
      X{i}=[temp(indices,:);temp(ind,:)];
 end
 indices=1:count;
 
 
%construct label indicater matrix C
C= zeros(count,k);
for i = 1:count
    C(i,Y(i))=1;
end

[A, ~, L]  = createWs(X,p);
V= rand(n,k);
weight=1/view;
obj=[];
for iter=1:maxIter
V(1:count,:)=C; 
    for j=1:view
     obj(iter,j)=(sum(sum((A{j}-V*V').^2))+alpha*trace(V'*L{j}*V));     
    end
    Obj(iter)=sum(obj(iter,:)*weight);
    SV=zeros(size(n));
    for i=1:view
        SV=SV+A{i}*weight;
    end

    D=diag(sum(SV,1));
    SVV =(2+alpha)*SV*V;
    VVV =  V*V'*V;
    V=(SVV./(VVV+alpha*D*V+eps)).*V;


end
   
   
    
end

 






