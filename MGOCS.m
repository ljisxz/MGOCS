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
ind=1:n;
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

opts.p=p;
[A, ~, L]  = createWs(X,opts);
weight=1/view;
S=zeros(n);
for i=1:view
    S=S+A{i}*weight;
end
%S=   (S + S') / 2;  
D=diag(sum(S,2));

Suu=S(count+1:n,count+1:n);
Sul=S(count+1:n ,1:count);
Duu=D(count+1:n,count+1:n);
Dul=D(count+1:n ,1:count);
V= rand(n-count,k);
%V= rand(n,k);
obj=[];
for iter=1:maxIter
    for j=1:view
     obj(iter,j)=(sum(sum((A{j}-[C;V]*[C;V]').^2))+alpha*trace([C;V]'*L{j}*[C;V]));     
    end
    Obj(iter)=sum(obj(iter,:)*weight);
    F1= (2+alpha)*Suu*V+(2+alpha)*Sul*C;
    F2=2*V*C'*C+2*V*V'*V+alpha*Duu*V+alpha*Dul*C+eps; 
    V=V.*(F1./F2) ;

end
   
   
    
end

 







