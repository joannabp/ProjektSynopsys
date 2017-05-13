function [data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold]=data_recovery(input_vector, clk);
global vector_length;
%global minimum_eye_opening;
%global setup_t;
%global hold_t;

%-------rising edge detection ------%
%clk=[0 0 1 1 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 1 0 0 0 1];

thresh=0.5
ind= clk>thresh; %-----------rising edge vector
%ind=[0 diff(ind)>0]>0;

t=1:length(clk);

%--------------
%s1=randi(300,1, 50);
%s2=(-1)*randi(300,1, 50);
%s=horzcat(s1,s2);
out=[];
j=1;


c200=[];
c0=[];
cm200=[];

for i=1:vector_length 
    if ind(i)==1
        c200(j)=input_vector(i)>200;
        c0(j)=input_vector(i)>0;
        cm200(j)=input_vector(i)<-200;
             j=j+1;  
    end

end 
j=j-1;
for i=1:j
        if c200(i)==1
            out(i)=3;
        elseif c0(i)==1
            out(i)=2;
        elseif cm200(i)==0
            out(i)=1;
        else 
            out(i)=0;
        end
end

out_data=cellstr(dec2bin(out,2))';
m=1;
e=[];
for k=1:vector_length 
    if ind(k)==1
    e(m)=input_vector(k);
    m=m+1;
    end
end 
m=m-1;
c=1;
eye=zeros(m-1, 3);
for k=1:m-2
    eye(k,:)=e(c:c+2);
    c=c+1;
end

c=1;
a=1;
b=1;
eyeO1=[];
eyeO2=[];
eyeO3=[];
%%eye01=zeros(1);

for k=1:m-2
    
    if(eye(k,2)>=-300 && eye(k,2)<=-100)
        eyeO1(a)=eye(k,2);
        a=a+1;
    elseif (eye(k,2)>=-100 && eye(k,2)<=100)
        eyeO2(b)=eye(k,2);
        eye(k,2)
        b=b+1;
    end
    %else if
    if (eye(k,2)>=100 && eye(k,2)<=300)
        eyeO3(c)=eye(k,2);
        c=c+1;
    end
        
        
end

eyeO1_sort=sort(eyeO1);
eyeO2_sort=sort(eyeO2);
eyeO3_sort=sort(eyeO3);

min_eye300_100=max(diff(eyeO1_sort));
min_eye100_100=max(diff(eyeO2_sort));
min_eye100_300=max(diff(eyeO3_sort));
data=out_data;
setup=1;
hold=1;
% 3 cykle zegara zestawiæ ze sob¹ 
% t is here that we introduce SETUP and HOLD time. Setup time is defined as the minimum amount of time before the clock's active edge that the data must be stable for it to be latched correctly. Any violation may cause incorrect data to be captured, which is known as setup violation.
% 
% Hold time is defined as the minimum amount of time after the clock's active edge during which data must be stable. Violation in this case may cause incorrect data to be latched, which is known as a hold violation. Note that setup and hold time is measured with respect to the active clock edge only.