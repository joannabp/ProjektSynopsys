clear all;
close all;
clc
global vector_length;

vector_length=1600;
input_data = randi([0 1], 100, 1);
t_clk=randi(64,1,1)+1;
start=randi(30,1,1);

clk = clk_gen(t_clk,start);
start=30;

%---------------------driver----------------------------------------------%

driv_data = driv_script(input_data);

%---------------------Channel---------------------------------------------%

chanel_data = driv_data;
szum=szum(driv_data,0.5);

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk,t_clk);

%---------------------Data_Recovery---------------------------------------%

[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold, out] = data_recovery(driv_data, clk_out);

nums_str=[data{:}];
nums_split=[];

for i=1:length(nums_str)
    nums_split(i)=str2num(nums_str(i));
end
nums_split=nums_split';

for i=1:50
    if nums_split(i)~=input_data(i) 
        printf('error w %d',i);
		end
end
%---------------------Dodatki---------------------------------------------%

plot(driv_data);
ylabel("data in");
figure
plot(clk(1:66));
ylabel('clk wzor');
figure
plot(clk_out(1:66));
ylabel('clk out');