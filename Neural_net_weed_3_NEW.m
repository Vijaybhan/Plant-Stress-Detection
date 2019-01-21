clc;
clear all;
filename = 'dataset_unnormalize.csv';
A = xlsread(filename);
totaldata=zeros(1512,8);
j=1;
for i=1:2:3023
    %if~(isnan(A(i,1))|| A(i,1)==0 ||isinf(A(i,1)))
        totaldata(j,:)=A(i,:);
       j=j+1;
end
    

for i=1:6
%totaldata(:,i)=(totaldata(:,i)-min(totaldata(:,i)))/(max(totaldata(:,i))-min(totaldata(:,i)));
totaldata(:,i)=totaldata(:,i)/255;
end

for i=1:6
totaldata(:,i)=(totaldata(:,i)-mean(totaldata(:,i)))/std(totaldata(:,i));
end

 augm=zeros(1172,8);
 testset1=zeros(304,7);
% augm=ones(105,6);
% %%%%%%CLASS1%%%%%%%
r=randperm(846);
for i=1:676
    
    augm(i,:)=totaldata(r(i),:);
    
end
for i=1:170
    
   testset1(i,:)=totaldata(r(i+676),1:7);

end
% 
% %%%%%%CLASS2%%%%%%%
  r=randperm(660)+846;
for i=1:496
    augm(i+676,:)=totaldata(r(i),:);
    
end
for i=1:134
    
   testset1(i+170,:)=totaldata(r(i+496),1:7);
  
    
end
% % %%%%%%CLASS3%%%%%%%
%  r=randperm(170)+455;
% for i=1:128
%     augm(i+342,:)=totaldata(r(i),:);
%     
% end
% for i=1:42
%     
%    testset1(i+113,:)=totaldata(r(i+128),1:9);
%   
%     
% end

% 
w1=rand(7,14);
w2=rand(14,20);
w3=rand(20,2);
w1_1=rand(7,14);
w2_2=rand(14,20);
w3_3=rand(20,2);
w1_1=w1;
w_2=w2;
w_3=w3;
a1=zeros(14,1);
a2=zeros(20,1);
a3=zeros(2,1);
t1=[1;0];
t2=[0;1];
%t3=[0;0;1];
flag=1;
e=[0;0];
th=0.1;
cre=0;
eta=0.01;
f1=zeros(20,20);
f2=zeros(14,14);
no_of_epoch=150;
m=100;
l_count=0;
x=zeros(1,no_of_epoch);
y=zeros(1,no_of_epoch);
Error=zeros(1,no_of_epoch);
cre1=0;
% 
for epoch=1:no_of_epoch
for j2=1:m    
    d=randperm(1172);
for i=1:1172
    a1=logsig(w1'*augm(d(i),[1 2 3 4 5 6 7 ])');
    a2=logsig(w2'*a1);
    a3=logsig(w3'*a2);
         if(augm(d(i),[8])==1)
          e=t1-a3;
          cre=(e'*e)/2;
         end
         if(augm(d(i),[8])==2)
             e=t2-a3;
              cre=(e'*e)/2;
         end
%          if(augm(d(i),[10])==3)
%              e=t3-a3;
%               cre=(e'*e)/2;
%          end

            
            s3 =  -2*(1-a3).*a3.*e;
            w3 = w3-(eta*s3*a2')';
            for j=1:20
                f1(j,j) = a2(j)*(1-a2(j));
            end
            s2 = f1*w3*s3;
            w2 = w2-(eta*s2*a1')';
            for j=1:14
                f2(j,j) = a1(j)*(1-a1(j));
            end
            s1 = f2*w2*s2;
            w1 = w1-(eta*s1*augm(d(i),[1 2 3 4 5 6 7 ]))';
            
end

cre1=cre1+cre;

end



x(1,epoch)=epoch;
y(1,epoch)=cre1/m;

Error(epoch)=cre1/m;
if(epoch>1 )
    if(Error(epoch)>Error(epoch-1))
    l_count=l_count+1;
    end
    
end
if(l_count==5)
    eta=eta/10;
end

if(epoch>1)
   if( Error(epoch)<Error(epoch-1))
   l_count=0; 
   w1_1=w1;
   w_2=w2;
   w_3=w3;
    end
else
    
   w1_1=w1;
   w_2=w2;
   w_3=w3;
   
end


cre1=0;


epoch
end


 plot(x,y)
% 
%  
% w1;
% w2;
count=0;
for k=1:304
    a1 = logsig( w1_1'*testset1(k,:)' );
        a2 = logsig( w2_2'*a1 );
        a3 = logsig( w3_3'*a2 );
    class=find(a3 == max(a3(:)));
    if (k<171 && class==1)
        
        count=count+1;
    end
    if (170<k && k<305 && class==2)
        
        count=count+1;
    end
%     if (113<k&&k<156 && class==3)
%         
%         count=count+1;
%     end
end
acc=(count/304)*100
