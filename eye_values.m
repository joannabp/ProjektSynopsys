function [min_eye300_100, min_eye100_100, min_eye100_300, eyeO1, eyeO2, eyeO3]=eye_values(input_vector, rising_edge_detector);

vector_length=length(input_vector);
j=1;
e=[];
for k=1:vector_length 
    if rising_edge_detector(k)==1
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
