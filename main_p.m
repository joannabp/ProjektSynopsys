clear all;
global vector_length;
global minimum_eye_opening;
global setup_t;
global hold_t;

vector_length=1600;



clk=[];
clk_s=0;
for i=1:1600
    if (mod(i,16) == 0) 
        clk_s=~clk_s;
    %else 
        
    end
    clk(i)=clk_s;
end
sum_clk=sum(clk);

input_num=randi([0 1], 100, 1);

out_vect=driv_script(input_num);

%clk=pll2(out_vect);
[data, min_eye300_100, min_eye100_100, min_eye_100_300, setup, hold]=data_recovery(out_vect, clk);
nums_str=[data{:}];

nums_split=[];

for i=1:50
    nums_split(i)=str2num(nums_str(i));
end
nums_split=nums_split';
c=1;
for i=1:50
    if nums_split(i)~=input_num(i) 
        i;
        error='error';
        c=c+1;
    end
    
end