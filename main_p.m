clear all;
global vector_length;
global minimum_eye_opening;
global setup_t;
global hold_t;

vector_length=1600;



clk=[];

for i=1:1600
    if (mod(i,31) ~= 0) 
        clk(i)=0;
    else 
        clk(i)=1;
    end
end
sum_clk=sum(clk);
input_num=randi([0 1], 100, 1);

out_vect=driv_script(input_num);

[data, min_eye300_100, min_eye100_100, min_eye_100_300, setup, hold]=data_recovery(out_vect, clk);
nums_str=[data{:}];

nums_split=[];

for i=1:50
    nums_split(i)=str2num(nums_str(i));
end
nums_split=nums_split';

for i=1:50
    if nums_split(i)~=input_num(i) 
        i
        error='error'
    end
end