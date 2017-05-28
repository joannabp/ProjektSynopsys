clear all;
close all;
clc
global vector_length;

vector_length=1600;
input_data = randi([0 1], 100, 1);
%t_clk=randi(64,1,1)+1;
%start=randi(30,1,1);
t_clk=31;
start=31;
clk_in = clk_gen(t_clk,start);
%clk_tst=zeros(1,vector_length);
data_out=zeros(1,vector_length);

%---------------------driver----------------------------------------------%

driv_data = driv_script(input_data);

%---------------------Channel---------------------------------------------%

%channel_data = channel(driv_data,100);
# for i=2:vector_length
	# if(abs(driv_data(i)-driv_data(i-1))>=100)
		# clk_tst(i)=1;
	# end
# end

%---------------------Clock_Recovery--------------------------------------%

clk_out=clock_recovery(clk_in,t_clk);

%---------------------Data_Recovery---------------------------------------%

[data, min_eye300_100, min_eye100_100, min_eye100_300, setup, hold, out] = data_recovery(driv_data, clk_out);

nums_str=[data{:}];
nums_split=[];

for i=1:length(nums_str)
    nums_split(i)=str2num(nums_str(i));
end
nums_split=nums_split';
data_out=driv_script(nums_split);
for i=1:50
    if nums_split(i)~=input_data(i) 
        printf('error w %d',i);
		end
end
%---------------------Dodatki---------------------------------------------%

plot(driv_data);
ylabel("data in");
figure
plot(clk_in);
ylabel('clk in');
figure
plot(1:1600,clk_out*100,1:1600,data_out,1:1600,driv_data);
ylabel('clk out');
figure
plot(data_out);
ylabel('data out');