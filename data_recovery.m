function [out_data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold, eyeO1, eyeO2, eyeO3]=data_recovery(input_vector, clk);

global min_eye_opening;
global setup_t;
global hold_t;
global unres_val;
vector_length=length(input_vector);
%-------rising edge detection ------%
thresh=0.5;
ind= clk>thresh; %-----------rising edge vector
ind=[0 diff(ind)>0]>0;

t=1:length(clk);
j=1;
c=[];
% ------------------- check setup time ------------% 

s=1;
prev_val=input_vector(1);
setup(1)=1;
for i=2:vector_length
    c=(input_vector(i)-prev_val);
    if (c<abs(1e-5))
        setup(s)=setup(s)+1;
    else 
        setup(s)=1;
    end
    if(ind(i)==1)
        s=s+1;
        setup(s)=1;
    end
    prev_val=input_vector(i);
end
% ------------------- check hold time ------------% ---- 

h=1;
prev_val=input_vector(1);
hold(1)=1;
for i=2:vector_length
    c=(input_vector(i)-prev_val);
    if(ind(i)==1)
        h=h+1;
        hold(h)=1;
        prev_val=input_vector(i);
    end
    if (c<abs(1e-5))
        
        hold(h)=hold(h)+1;
    end
end
prev_val=0;
k=1;
%-------------------- compare level ----------------%
for i=1:vector_length 
    if ind(i)==1
        %---------- sample 200 ---------------%
            if(setup(j)<setup_t | hold(j)<hold_t)
               c(k:k+1)=unres;
            elseif(input_vector(i)>200+min_eye_opening/2)
                c(k:k+1)=1;
            elseif(input_vector(i)>200-min_eye_opening/2) 
                 c(k:k+1)=unres;
            elseif(input_vector(i)>min_eye_opening/2)
                c(k)=1;
                c(k+1)=0;
            elseif(input_vector(i)>-min_eye_opening/2)
                 c(k:k+1)=unres;
            elseif(input_vector(i)>-200+min_eye_opening/2) 
                c(k)=0;
                c(k+1)=1;
            elseif(input_vector(i)>-200-min_eye_opening/2)
                  c(k:k+1)=unres;
            else 
               c(k:k+1)=0;
            end   
            prev_val=c(j);
             j=j+1;  
             k=k+2;
    end
    if(strcmp(unres_val, 'prev'))
        unres=prev_val;
    else
         unres=unres_val;
    end
end 


out_data=c;

j=1;
e=[];
for k=1:vector_length 
    if ind(k)==1
        e(j)=input_vector(k);
        j=j+1;
    end
end 


j=j-1;
c=1;
eye=zeros(j-1, 3);
for k=1:j-2
    eye(k,:)=e(c:c+2);
    c=c+1;
end

c=1;
a=1;
b=1;
eyeO1=[];
eyeO2=[];
eyeO3=[];

%----------------save eye opening values -----------%
for k=1:j-2
    
    if(eye(k,2)>=-300 && eye(k,2)<=-100)
        eyeO1(a)=eye(k,2);
        a=a+1;
    elseif (eye(k,2)>=-100 && eye(k,2)<=100)
        eyeO2(b)=eye(k,2);
        eye(k,2);
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
