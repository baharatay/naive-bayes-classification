[winedata]=xlsread('Wine.xls','Data');
[r,c]=size(winedata);
 
for j=1:13
    incr(j)=(max(winedata(:,j))-min(winedata(:,j)))/4;
end
 
% for i=1:13
% x=winedata(:,i);
% histogram(x,4);
% figure(i);
% end


for j=1:13
    for i=1:r
        a=min(winedata(:,j));
        for k=1:4
            if  a<=winedata(i,j) && winedata(i,j)<a+incr(j)
            new(i,j)=k;
            a=a+incr(j);
            else 
            a=a+incr(j);  
            end
        end
    end
end
 

%%Train and Test Data Partitioning
rIndex=randperm(r);
sizeTrain=ceil(r*0.8);
sizeTest=r-sizeTrain;
ctr=0;
cte=0;
for i=1:r
    if i<=sizeTrain
        ctr=ctr+1;
        train(ctr,:)=new(rIndex(i),:);
    else
        cte=cte+1;
        test(cte,:)=new(rIndex(i),:);
    end
end
 
k=1;
for i=1:ctr
    if rIndex(i)<=60
        new1(k,:)=train(i,:);
        k=k+1;
    end
end
 
l=1;
for i=1:ctr
    if rIndex(i)>60
        new2(l,:)=train(i,:);
        l=l+1;
    end
end
 
[m,n]=size(new1);
[p,q]=size(new2);

for i=1:cte
    prob(i,1,1)=m/sizeTrain;
    for j=1:13
        prob(i,1,1)=prob(i,1,1)*(sum(new1(:,j)==test(i,j))/m);
    end
end
 
for i=1:cte
    prob(i,1,2)=p/sizeTrain;
    for j=1:13
        prob(i,1,2)=prob(i,1,2)*(sum(new2(:,j)==test(i,j))/p);
    end
end
 
for i=1:cte
    if prob(i,1,1)>=prob(i,1,2)
        pred(i,1)=1;
    else
        pred(i,1)=2;
    end
end
 
for i=105:130
    if rIndex(i)<=60
        actual(i-104,1)=1;
    else
        actual(i-104,1)=2;
    end
end
 
for i=1:cte
    if actual(i,1)==pred(i,1)
        result(i,1)=1;
    else
        result(i,1)=0;
    end
end
 
error= sum(result(:,1)==0)/cte;